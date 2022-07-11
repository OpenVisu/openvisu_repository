// Copyright (C) 2022 Robin Jespersen
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import 'package:openvisu_repository/openvisu_repository.dart';

class TimeSeriesCache {
  static const int maxCacheItems = 1000;
  Map<StepSize, Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> cache = {};

  void set(
    final Pk<TimeSerial> timeSerialId,
    final List<TimeSeriesEntry<double?>> measurements,
    final StepSize stepSize,
  ) {
    if (!cache.containsKey(stepSize)) {
      cache[stepSize] = {};
    }
    if (!cache[stepSize]!.containsKey(timeSerialId)) {
      cache[stepSize]![timeSerialId] = [];
    }
    for (TimeSeriesEntry<double?> m in measurements) {
      if (cache[stepSize]![timeSerialId]!
          .where((e) => e.time == m.time)
          .isEmpty) {
        cache[stepSize]![timeSerialId]!.add(m);
      }

      if (cache[stepSize]![timeSerialId]!
          .where((e) => e.time == m.time)
          .isNotEmpty) {
        final e =
            cache[stepSize]![timeSerialId]!.firstWhere((e) => e.time == m.time);
        if (e != m) {
          if (m.value != null && e.value == null) {
            // happens cause of the way "keep last" works in the influxdb
            cache[stepSize]![timeSerialId]!.remove(e);
            cache[stepSize]![timeSerialId]!.add(m);
          } else {
            throw AssertionError('no value should be added twice to the cache');
        }
      }
    }
    cache[stepSize]![timeSerialId]!.sort((a, b) => a.time.compareTo(b.time));
    _cleanUp(
      timeSerialId,
      stepSize,
      measurements[measurements.length ~/ 2].time,
    );
  }

  _cleanUp(
    final Pk<TimeSerial> timeSerialId,
    final StepSize stepSize,
    final DateTime center,
  ) {
    if (cache[stepSize]![timeSerialId]!.length <= maxCacheItems) {
      return;
    }

    final c =
        cache[stepSize]![timeSerialId]!.indexWhere((e) => e.time == center);
    final int t = cache[stepSize]![timeSerialId]!.length;
    if (c + maxCacheItems ~/ 2 < t) {
      cache[stepSize]![timeSerialId]!.removeRange(c + maxCacheItems ~/ 2, t);
    }
    if (c - maxCacheItems ~/ 2 > 0) {
      cache[stepSize]![timeSerialId]!.removeRange(0, c - maxCacheItems ~/ 2);
    }
  }

  setMultiple(
    final Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> measurements,
    final StepSize stepSize,
  ) {
    measurements.forEach((timeSerialId, values) {
      set(timeSerialId, values, stepSize);
    });
  }

  /// returns true if the data exists in the correct resolution for
  /// the full timeframe
  bool exists(
    final Pk<TimeSerial> timeSerialId,
    final DateTime start,
    final DateTime stop,
  ) {
    final StepSize stepSize = StepSize.fromStartStop(start, stop);
    if (!cache.containsKey(stepSize)) {
      return false;
    }
    if (!cache[stepSize]!.containsKey(timeSerialId)) {
      return false;
    }
    if (cache[stepSize]![timeSerialId]!.length < 2) {
      return false;
    }
    if (start.isBefore(cache[stepSize]![timeSerialId]!.first.time)) {
      return false;
    }
    if (stop.isAfter(cache[stepSize]![timeSerialId]!.last.time)) {
      return false;
    }
    return true;
  }

  bool existsMultiple(
    final List<Pk<TimeSerial>> timeSerialIds,
    final DateTime start,
    final DateTime stop,
  ) {
    for (final Pk<TimeSerial> timeSerialId in timeSerialIds) {
      if (!exists(timeSerialId, start, stop)) {
        return false;
      }
    }
    return true;
  }

  List<TimeSeriesEntry<double?>> get(
    final Pk<TimeSerial> timeSerialId,
    final DateTime start,
    final DateTime stop,
    final StepSize stepSize,
  ) {
    if (!cache.containsKey(stepSize)) {
      return [];
    }
    if (!cache[stepSize]!.containsKey(timeSerialId)) {
      return [];
    }
    return cache[stepSize]![timeSerialId]!
        .where((e) => !(e.time.isBefore(start) || e.time.isAfter(stop)))
        .toList();
  }

  Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> getMultiple(
    final List<Pk<TimeSerial>> timeSerialIds,
    final DateTime start,
    final DateTime stop,
    final StepSize stepSize,
  ) {
    return {
      for (var timeSerialId in timeSerialIds)
        timeSerialId: get(timeSerialId, start, stop, stepSize),
    };
  }

  void delete(
    final Pk<TimeSerial> timeSerialId,
  ) {
    for (final StepSize stepSize in cache.keys) {
      if (cache[stepSize]!.containsKey(timeSerialId)) {
        cache[stepSize]!.remove(timeSerialId);
      }
    }
  }

  /// test if the timestap is contained in the cache
  bool containsTime(final StepSize stepSize, final DateTime dateTime) {
    if (!cache.containsKey(stepSize)) {
      return false;
    }
    if (cache[stepSize]!.isEmpty) {
      return false;
    }
    final list = cache[stepSize]![cache[stepSize]!.keys.first]!;
    if (list.isEmpty) {
      return false;
    }
    if (dateTime.isBefore(list.first.time)) {
      return false;
    }
    if (dateTime.isAfter(list.last.time)) {
      return false;
    }
    return true;
  }

  /// test if between the two timestamps is a gap that was never loaded
  bool hasGap(
    final StepSize stepSize,
    final DateTime start,
    final DateTime stop,
  ) {
    final list = cache[stepSize]![cache[stepSize]!.keys.first]!;
    final int expect =
        stop.difference(start).inMilliseconds ~/ stepSize.delta.inMilliseconds +
            1;
    final int found = list
        .where((e) => !(e.time.isBefore(start) || e.time.isAfter(stop)))
        .length;

    return expect != found;
  }

  GapStartStop getGapStartStop(
    final StepSize stepSize,
    final DateTime start,
    final DateTime stop,
  ) {
    final list = cache[stepSize]![cache[stepSize]!.keys.first]!;
    var t = start;
    for (TimeSeriesEntry tse in list) {
      if (tse.time.isAtSameMomentAs(t)) {
        t = t.add(stepSize.delta);
        continue;
      }
      if (!tse.time.isBefore(stop)) {
        throw ArgumentError('no gap found');
      }
      if (tse.time.isAfter(t)) {
        return GapStartStop(
          t.subtract(stepSize.delta),
          tse.time.subtract(stepSize.delta),
        );
      }
    }
    throw ArgumentError('no gap found');
  }

  void clear() {
    cache.clear();
  }
}

class GapStartStop {
  final DateTime start;
  final DateTime stop;

  GapStartStop(this.start, this.stop);
}
