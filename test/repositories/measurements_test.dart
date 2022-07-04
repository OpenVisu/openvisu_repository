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
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MeasurementsRepository', () {
    late final DateTime now;
    late final List<TimeSeriesEntry<double?>> measurements;

    final Pk<TimeSerial> timeSerialId = Pk<TimeSerial>(1);

    MeasurementsRepository measurementsRepository = MeasurementsRepository(
      timeSeriesEntryRepository: TimeSeriesEntryRepository(),
    );

    setUpAll(() {
      now = DateTime.now();

      measurements = List.generate(
        20,
        (i) => TimeSeriesEntry.fromDataType(
          DataType.Double,
          now.subtract(Duration(minutes: 20 - i)),
          i * 2,
        ) as TimeSeriesEntry<double?>,
      );
    });

    test('test empty', () {
      expect(
        measurementsRepository.getCached(
            timeSerialId, now.subtract(const Duration(hours: 1)), now),
        [],
      );
    });

    test('test getCached()', () {
      measurementsRepository.cache(timeSerialId, measurements);

      expect(
        measurementsRepository.getCached(
            timeSerialId, now.subtract(const Duration(hours: 1)), now),
        measurements,
      );

      List<TimeSeriesEntry<double?>> measurementsHalf =
          measurements.getRange(10, 20).toList();

      List<TimeSeriesEntry<double?>> measurementsHalfFromCache =
          measurementsRepository.getCached(
              timeSerialId, now.subtract(const Duration(minutes: 10)), now);

      expect(
        measurementsHalf,
        measurementsHalfFromCache,
      );
    });

    test('test hasCachedDataForTimeSerial()', () {
      expect(
        measurementsRepository.hasCachedDataForTimeSerial(
          timeSerialId,
          measurements.first.time,
          measurements.last.time,
        ),
        true,
      );

      expect(
        measurementsRepository.hasCachedDataForTimeSerial(
          timeSerialId,
          measurements[5].time,
          measurements[10].time,
        ),
        true,
      );

      expect(
        measurementsRepository.hasCachedDataForTimeSerial(
          timeSerialId,
          measurements[5].time.subtract(const Duration(seconds: 5)),
          measurements[10].time,
        ),
        true,
      );

      expect(
        measurementsRepository.hasCachedDataForTimeSerial(
          timeSerialId,
          measurements.first.time.subtract(const Duration(seconds: 5)),
          measurements[10].time,
        ),
        false,
      );

      expect(
        measurementsRepository.hasCachedDataForTimeSerial(
          timeSerialId,
          measurements.first.time,
          measurements.last.time.add(const Duration(seconds: 5)),
        ),
        false,
      );
    });

    test('test requiresLoadForTimeSerial()', () {
      expect(
        measurementsRepository.requiresLoadForTimeSerial(
          timeSerialId,
          measurements.first.time,
          measurements.last.time,
        ),
        false,
      );

      expect(
        measurementsRepository.requiresLoadForTimeSerial(
          timeSerialId,
          measurements.first.time,
          measurements[1].time,
        ),
        true,
      );

      expect(
        measurementsRepository.requiresLoadForTimeSerial(
          timeSerialId,
          measurements.first.time,
          measurements.last.time.add(const Duration(seconds: 5)),
        ),
        true,
      );
    });
  });
}
