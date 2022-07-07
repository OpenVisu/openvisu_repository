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
import 'package:openvisu_repository/src/helper/step_size.dart';

class TimeSeriesCache {
  Map<StepSize, Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> cache = {};

  void set(
    final Pk<TimeSerial> timeSerialId,
    final List<TimeSeriesEntry<double?>> measurements,
  ) {
    if (measurements.length < 2) {
      throw const FormatException('measurement list is to short');
    }
    final StepSize stepSize = StepSize.fromDelta(
        measurements[1].time.difference(measurements[0].time));

    if (!cache.containsKey(stepSize)) {
      cache[stepSize] = {};
    }
    if (!cache[stepSize]!.containsKey(timeSerialId)) {
      cache[stepSize]![timeSerialId] = [];
    }
    cache[stepSize]![timeSerialId]!.addAll(measurements);
    cache[stepSize]![timeSerialId]!.sort((a, b) => a.time.compareTo(b.time));
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
  ) {
    final StepSize stepSize = StepSize.fromStartStop(start, stop);
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
  ) {
    return {
      for (var timeSerialId in timeSerialIds)
        timeSerialId: get(timeSerialId, start, stop),
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
}
