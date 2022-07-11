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

import 'package:flutter_test/flutter_test.dart';
import 'package:openvisu_repository/openvisu_repository.dart';

class MockTimeSeriesLoader extends TimeSeriesLoader {
  @override
  Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> doLoad(
    final Pk<ChartPage> chartPageId,
    final List<Pk<TimeSerial>> timeSerialIds,
    final DateTime start,
    final DateTime stop,
    final StepSize stepSize,
  ) async {
    return {};
  }
}

void main() {
  group('TimeSeriesLoader', () {
    final Pk<ChartPage> chartPageId = Pk<ChartPage>(1);
    final Pk<TimeSerial> timeSerialId1 = Pk<TimeSerial>(1);
    late final List<Pk<TimeSerial>> timeSerialIds = [timeSerialId1];

    late final TimeSeriesLoader timeSeriesLoader = MockTimeSeriesLoader();

    late DateTime now;
    late DateTime before20minutes;

    void _fillFromTo(
      final Pk<TimeSerial> timeSerialId,
      final DateTime start,
      final DateTime stop,
      final StepSize stepSize,
    ) {
      var t = start;
      while (!t.isAfter(stop)) {
        timeSeriesLoader.cache.set(
          timeSerialId,
          [
            TimeSeriesEntry.fromDataType(
                    DataType.Double, t, t.millisecondsSinceEpoch)
                as TimeSeriesEntry<double?>
          ],
          stepSize,
        );
        t = t.add(stepSize.delta);
      }
    }

    setUpAll(() {
      now = DateTime.now();
      before20minutes = now.subtract(const Duration(minutes: 20));

      var oss = timeSeriesLoader.optimizeStartStop(before20minutes, now);
      now = oss.stop;
      before20minutes = oss.start;
    });

    test('test load() sync', () {
      final StepSize stepSize = StepSize.fromDelta(const Duration(minutes: 1));

      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r1 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
        stepSize,
      );
      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r2 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
        stepSize,
      );
      expect(r1 == r2, true);

      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r3 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        now.subtract(const Duration(minutes: 16)),
        now,
        stepSize,
      );
      expect(r1 == r3, true);
      expect(timeSeriesLoader.futures.length, 1);

      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r4 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        now.subtract(const Duration(minutes: 10)),
        now,
        stepSize,
      );
      expect(r1 == r4, false);

      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r5 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        now.subtract(const Duration(minutes: 11)),
        now,
        stepSize,
      );
      expect(r4 == r5, false);

      expect(timeSeriesLoader.futures.length, 2);
    });

    test('test load() async', () async {
      final StepSize stepSize = StepSize.fromDelta(const Duration(minutes: 1));
      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r1 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
        stepSize,
      );
      await r1;
      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r2 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
        stepSize,
      );
      expect(r1 == r2, false);
    });

    test('test optimizeStartStop() align times to stepSize', () {
      timeSeriesLoader.cache.clear();

      var start = DateTime(2022, 7, 7, 18, 00, 4);
      var stop = DateTime(2022, 7, 7, 18, 10, 9);

      var stepSize = StepSize.fromStartStop(start, stop);
      expect(stepSize.delta, const Duration(seconds: 10));

      var oss = timeSeriesLoader.optimizeStartStop(start, stop);
      expect(oss.start, DateTime(2022, 7, 7, 18, 00));
      expect(oss.stop, DateTime(2022, 7, 7, 18, 10));

      start = DateTime(2022, 7, 7, 18, 03, 12);
      stop = DateTime(2022, 7, 7, 19, 01, 59);

      stepSize = StepSize.fromStartStop(start, stop);
      expect(stepSize.delta, const Duration(minutes: 1));

      oss = timeSeriesLoader.optimizeStartStop(start, stop);
      expect(oss.start, DateTime(2022, 7, 7, 18, 03));
      expect(oss.stop, DateTime(2022, 7, 7, 19, 01));
    });

    test('test optimizeStartStop() width', () {
      // TODO
    });

    test('test optimizeStartStop() left overlap with cache', () {
      var stepSize = StepSize.fromDelta(const Duration(minutes: 1));
      _fillFromTo(timeSerialId1, now.subtract(const Duration(minutes: 40)),
          now.subtract(const Duration(minutes: 20)), stepSize);

      var data = timeSeriesLoader.cache.get(
        timeSerialId1,
        now.subtract(const Duration(hours: 1)),
        now,
        stepSize,
      );
      expect(data.length, 21);
      expect(data.first.time, now.subtract(const Duration(minutes: 40)));
      expect(data.last.time, now.subtract(const Duration(minutes: 20)));

      // query with overlap of one minute and 30 seconds on the left
      var start = data.first.time.subtract(const Duration(minutes: 50));
      var stop = data.first.time.add(const Duration(minutes: 1, seconds: 30));
      stepSize = StepSize.fromStartStop(start, stop);

      var oss = timeSeriesLoader.optimizeStartStop(start, stop);
      expect(
        oss.start,
        data.first.time
            .subtract(stepSize.recomendedQueryWidth() + stepSize.delta),
      );
      expect(oss.stop, data.first.time.subtract(stepSize.delta));
    });

    test('test optimizeStartStop() right overlap with cache', () {
      var stepSize = StepSize.fromDelta(const Duration(minutes: 1));
      _fillFromTo(timeSerialId1, now.subtract(const Duration(minutes: 40)),
          now.subtract(const Duration(minutes: 20)), stepSize);

      var data = timeSeriesLoader.cache.get(
        timeSerialId1,
        now.subtract(const Duration(hours: 1)),
        now,
        stepSize,
      );
      expect(data.length, 21);
      expect(data.first.time, now.subtract(const Duration(minutes: 40)));
      expect(data.last.time, now.subtract(const Duration(minutes: 20)));

      // query with overlap of one minute and 30 seconds on the right
      var start = data.last.time.subtract(
        const Duration(minutes: 1, seconds: 30),
      );
      var stop = data.last.time.add(const Duration(minutes: 52));

      var oss = timeSeriesLoader.optimizeStartStop(start, stop);
      expect(oss.start, data.last.time);
      expect(oss.stop, data.last.time.add(stepSize.recomendedQueryWidth()));
    });

    test('test optimizeStartStop() fill gap', () {
      timeSeriesLoader.cache.clear();

      var stepSize = StepSize.fromDelta(const Duration(minutes: 1));

      _fillFromTo(timeSerialId1, now.subtract(const Duration(minutes: 40)),
          now.subtract(const Duration(minutes: 20)), stepSize);
      expect(
        timeSeriesLoader.cache.hasGap(
          stepSize,
          now.subtract(const Duration(minutes: 40)),
          now.subtract(const Duration(minutes: 20)),
        ),
        false,
      );

      _fillFromTo(timeSerialId1, now.subtract(const Duration(minutes: 10)), now,
          stepSize);

      var start = now.subtract(const Duration(minutes: 30));
      var stop = now.subtract(const Duration(minutes: 5));

      expect(timeSeriesLoader.cache.hasGap(stepSize, start, stop), true);
      var oss = timeSeriesLoader.optimizeStartStop(start, stop);
      expect(oss.start, now.subtract(const Duration(minutes: 20)));
      expect(oss.stop, now.subtract(const Duration(minutes: 11)));
    });
  });
}
