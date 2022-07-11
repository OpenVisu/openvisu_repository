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

void main() {
  group('TimeSeriesCache', () {
    final TimeSeriesCache timeSeriesCache = TimeSeriesCache();
    final Pk<TimeSerial> tiemSerialId1 = Pk<TimeSerial>(1);

    late final DateTime now;
    late final DateTime before20minutes;
    late final DateTime before40minutes;
    late final List<TimeSeriesEntry<double?>> measurements20minutes;
    late final List<TimeSeriesEntry<double?>> measurements20minutesDifferent;
    final List<TimeSeriesEntry<double?>> measurements20inBetween = [];

    setUpAll(() {
      now = DateTime.now();
      before20minutes = now.subtract(const Duration(minutes: 20));
      before40minutes = now.subtract(const Duration(minutes: 40));

      measurements20minutes = List.generate(
        21,
        (i) => TimeSeriesEntry.fromDataType(
          DataType.Double,
          now.subtract(Duration(minutes: 20 - i)),
          now.subtract(Duration(minutes: 20 - i)).second,
        ) as TimeSeriesEntry<double?>,
      );
      measurements20minutesDifferent = List.generate(
        21,
        (i) => TimeSeriesEntry.fromDataType(
          DataType.Double,
          now.subtract(Duration(minutes: 40 - i)),
          now.subtract(Duration(minutes: 40 - i)).second,
        ) as TimeSeriesEntry<double?>,
      );

      expect(
        measurements20minutesDifferent.last,
        measurements20minutes.first,
      );
      expect(measurements20minutesDifferent.first.time,
          now.subtract(const Duration(minutes: 40)));
      expect(measurements20minutesDifferent.last.time,
          now.subtract(const Duration(minutes: 20)));
      expect(measurements20minutes.first.time,
          now.subtract(const Duration(minutes: 20)));
      expect(measurements20minutes.last.time, now);

      measurements20inBetween.addAll(
        measurements20minutesDifferent.getRange(10, 21),
      );
      measurements20inBetween.addAll(
        measurements20minutes.getRange(0, 10),
      );
      expect(measurements20inBetween.first, measurements20minutesDifferent[10]);
      expect(measurements20inBetween.last, measurements20minutes[9]);
    });

    test('test set()', () {
      final StepSize stepSize = StepSize.fromDelta(const Duration(minutes: 1));
      expect(
        timeSeriesCache.exists(tiemSerialId1, before20minutes, now),
        false,
      );

      timeSeriesCache.set(tiemSerialId1, measurements20minutes, stepSize);

      expect(timeSeriesCache.exists(tiemSerialId1, before20minutes, now), true);
      expect(
        timeSeriesCache.existsMultiple([tiemSerialId1], before20minutes, now),
        true,
      );
    });

    test('test set() dedublication', () {
      final StepSize stepSize = StepSize.fromDelta(const Duration(minutes: 1));
      expect(
        timeSeriesCache.get(tiemSerialId1, before40minutes, now).length,
        21,
      );

      timeSeriesCache.set(tiemSerialId1, measurements20minutes, stepSize);

      expect(
        timeSeriesCache.get(tiemSerialId1, before40minutes, now).length,
        21,
      );

      timeSeriesCache.set(
          tiemSerialId1, measurements20minutesDifferent, stepSize);

      expect(
        timeSeriesCache.get(tiemSerialId1, before40minutes, now).length,
        41,
      );

      timeSeriesCache.set(tiemSerialId1, measurements20inBetween, stepSize);

      expect(
        timeSeriesCache.get(tiemSerialId1, before40minutes, now).length,
        41,
      );
    });

    test('test get()', () {
      expect(
        timeSeriesCache.exists(tiemSerialId1, before20minutes, now),
        true,
      );

      List<TimeSeriesEntry<double?>> list = timeSeriesCache.get(
        tiemSerialId1,
        before20minutes,
        now,
      );
      expect(list.length, measurements20minutes.length);

      Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> map =
          timeSeriesCache.getMultiple(
        [tiemSerialId1],
        before20minutes,
        now,
      );
      expect(map[tiemSerialId1]!.length, measurements20minutes.length);
    });

    test('test delete()', () {
      expect(
        timeSeriesCache.exists(tiemSerialId1, before20minutes, now),
        true,
      );

      timeSeriesCache.delete(tiemSerialId1);

      expect(
        timeSeriesCache.exists(tiemSerialId1, before20minutes, now),
        false,
      );
    });

    test('test exists()', () {
      final StepSize stepSize = StepSize.fromDelta(const Duration(minutes: 1));

      expect(
        timeSeriesCache.exists(
          tiemSerialId1,
          now.subtract(const Duration(hours: 1)),
          now,
        ),
        false,
      );

      timeSeriesCache.set(tiemSerialId1, measurements20minutes, stepSize);

      expect(timeSeriesCache.exists(tiemSerialId1, before20minutes, now), true);

      expect(
        timeSeriesCache.exists(
          tiemSerialId1,
          now.subtract(const Duration(minutes: 16)),
          now,
        ),
        true,
      );

      expect(
        timeSeriesCache.exists(
          tiemSerialId1,
          now.subtract(const Duration(minutes: 21)),
          now,
        ),
        false,
      );

      // for 10 minutes a resolution of 10 seconds is expected, thus exists is false
      expect(
        timeSeriesCache.exists(
          tiemSerialId1,
          now.subtract(const Duration(minutes: 10)),
          now,
        ),
        false,
      );
    });
  });
}
