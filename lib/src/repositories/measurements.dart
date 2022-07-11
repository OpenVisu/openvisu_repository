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

/// Repository keeps a global timeSeriesCache
class MeasurementsRepository {
  final TimeSeriesEntryRepository timeSeriesEntryRepository;
  final TimeSeriesCache timeSeriesCache = TimeSeriesCache();

  MeasurementsRepository({required this.timeSeriesEntryRepository});

  void sideload(final Pk<TimeSerial> id, List<dynamic> data) {
    final List<TimeSeriesEntry<double?>> measurements = data
        .map((e) => TimeSeriesEntry.fromJson(DataType.Double, e)
            as TimeSeriesEntry<double?>)
        .toList();

    if (measurements.length >= 2) {
      final stepSize = StepSize.fromDelta(
          measurements[1].time.difference(measurements[0].time));
      timeSeriesCache.set(id, measurements, stepSize);
      timeSeriesEntryRepository.cacheLast(
        id,
        measurements.last,
      ); // TODO test if last is always the newest
    } else {
      throw ArgumentError('measurements list too short');
    }
  }
}
