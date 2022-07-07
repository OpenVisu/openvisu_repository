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
import 'package:openvisu_repository/src/helper/time_series_loader.dart';

class MockTimeSeriesLoader extends TimeSeriesLoader {
  @override
  Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> doLoad(
    final Pk<ChartPage> chartPageId,
    final List<Pk<TimeSerial>> timeSerialIds,
    final DateTime start,
    final DateTime stop,
  ) async {
    return {};
  }
}

void main() {
  group('TimeSeriesLoader', () {
    final Pk<ChartPage> chartPageId = Pk<ChartPage>(1);
    final List<Pk<TimeSerial>> timeSerialIds = [Pk<TimeSerial>(1)];

    late final TimeSeriesLoader timeSeriesLoader = MockTimeSeriesLoader();

    late final DateTime now;
    late final DateTime before20minutes;

    setUpAll(() {
      now = DateTime.now();
      before20minutes = now.subtract(const Duration(minutes: 20));
    });

    test('test load() sync', () {
      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r1 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
      );
      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r2 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
      );
      expect(r1 == r2, true);

      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r3 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        now.subtract(const Duration(minutes: 15)),
        now,
      );
      expect(r1 == r3, true);
      expect(timeSeriesLoader.futures.length, 1);

      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r4 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        now.subtract(const Duration(minutes: 10)),
        now,
      );
      expect(r1 == r4, false);

      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r5 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        now.subtract(const Duration(minutes: 11)),
        now,
      );
      expect(r4 == r5, false);

      expect(timeSeriesLoader.futures.length, 2);
    });

    test('test load() async', () async {
      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r1 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
      );
      await r1;
      Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> r2 =
          timeSeriesLoader.load(
        chartPageId,
        timeSerialIds,
        before20minutes,
        now,
      );
      expect(r1 == r2, false);
    });
  });
}
