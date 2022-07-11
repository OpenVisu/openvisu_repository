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

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:openvisu_repository/openvisu_repository.dart';

class TimeSeriesLoader {
  final TimeSeriesCache cache = TimeSeriesCache();

  // map of active futures
  // the key contains the parameters of the query
  @visibleForTesting
  final Map<Query, Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>>>
      futures = {};

  // if there is a future matching the query, it is returned
  // otherwise a new query is started and its future returned
  Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> load(
    final Pk<ChartPage> chartPageId,
    final List<Pk<TimeSerial>> timeSerialIds,
    DateTime start,
    DateTime stop,
  ) {
    final StepSize stepSize = StepSize.fromStartStop(start, stop);

    OptimizedStartStop oss = optimizeStartStop(start, stop);
    start = oss.start;
    stop = oss.stop;

    Iterable<Query> queries =
        futures.keys.where(_covers(chartPageId, start, stop));
    if (queries.isNotEmpty) {
      return futures[queries.first]!;
    }

    final Query query = Query(chartPageId, start, stop);

    // ignore all running queries that are covered by the new one
    for (Query q in [...futures.keys]) {
      if (_covers(q.chartPageId, q.start, q.stop)(query)) {
        futures[q]!.ignore();
        futures.remove(q);
      }
    }

    futures[query] = doLoad(chartPageId, timeSerialIds, start, stop) //
        .then(_cleanUp(query, stepSize));

    return futures[query]!;
  }

  // if a future completes, it is removed from the list of active futures
  FutureOr<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> Function(
    Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>,
  ) _cleanUp(
    final Query query,
    final StepSize stepSize,
  ) {
    return (Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> value) {
      cache.setMultiple(value, stepSize);
      futures.remove(query);
      return value;
    };
  }

  // align the time with the stepSize
  DateTime _round(final DateTime time, StepSize stepSize) {
    return DateTime.fromMillisecondsSinceEpoch(
      (time.millisecondsSinceEpoch ~/ stepSize.delta.inMilliseconds) *
          stepSize.delta.inMilliseconds,
    );
  }

  @visibleForTesting
  OptimizedStartStop optimizeStartStop(
    DateTime start,
    DateTime stop,
  ) {
    final StepSize stepSize = StepSize.fromStartStop(start, stop);
    start = _round(start, stepSize);
    stop = _round(stop, stepSize);

    // if nothing in cache, return
    if (!cache.cache.containsKey(stepSize)) {
      return OptimizedStartStop(start, stop);
    }
    if (cache.cache[stepSize]!.isEmpty) {
      return OptimizedStartStop(start, stop);
    }
    final List<TimeSeriesEntry<double?>> list =
        cache.cache[stepSize]![cache.cache[stepSize]!.keys.first]!;
    if (list.isEmpty) {
      return OptimizedStartStop(start, stop);
    }

    // TODO double width

    // test for overlaps
    final Duration delta = stop.difference(start);
    final bool containsStop = cache.containsTime(stepSize, stop);
    final bool containsStart = cache.containsTime(stepSize, start);
    if (containsStart && containsStop) {
      if (cache.hasGap(stepSize, start, stop)) {
        final GapStartStop gss = cache.getGapStartStop(stepSize, start, stop);
        return OptimizedStartStop(gss.start, gss.stop);
      }
      throw ArgumentError('query is covered by cache');
    }
    if (containsStop) {
      stop = list.first.time.subtract(
        stepSize.delta,
      ); // stop time is not included in query result
      start = stop.subtract(delta);
    }
    if (containsStart) {
      start = list.last.time; // start time is not included in query result
      stop = start.add(delta);
    }
    return OptimizedStartStop(start, stop);
  }

  // returns a function that returns true, if an exising query covers
  // the new query
  bool Function(Query q) _covers(
    final Pk<ChartPage> chartPageId,
    final DateTime start,
    final DateTime stop,
  ) {
    return (Query q) {
      if (q.chartPageId != chartPageId) {
        return false;
      }
      if (q.stepSize != StepSize.fromStartStop(start, stop)) {
        return false;
      }
      if (start.isBefore(q.start)) {
        return false;
      }
      if (stop.isAfter(q.stop)) {
        return false;
      }
      return true;
    };
  }

  @visibleForTesting
  Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> doLoad(
    final Pk<ChartPage> chartPageId,
    final List<Pk<TimeSerial>> timeSerialIds,
    final DateTime start,
    final DateTime stop,
  ) async {
    Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> t =
        await InfluxdbRepository.get(chartPageId, start, stop);
    return {
      for (MapEntry<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> e
          in t.entries)
        e.key: e.value,
    };
  }
}

@visibleForTesting
class Query extends Equatable {
  final Pk<ChartPage> chartPageId;
  final DateTime start;
  final DateTime stop;
  final StepSize stepSize;

  Query(
    this.chartPageId,
    this.start,
    this.stop,
  ) : stepSize = StepSize.fromStartStop(start, stop);

  @override
  List<Object?> get props => [chartPageId, start, stop, stepSize];
}

@visibleForTesting
class OptimizedStartStop {
  final DateTime start;
  final DateTime stop;

  OptimizedStartStop(this.start, this.stop);
}
