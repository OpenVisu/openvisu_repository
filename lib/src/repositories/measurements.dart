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

/// Repository to handle the data needed by the ViewWindowOnMeasurementsCubit
/// currently the values need to be sideloaded
class MeasurementsRepository {
  final TimeSeriesEntryRepository timeSeriesEntryRepository;

  final Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> _cache = {};

  MeasurementsRepository({required this.timeSeriesEntryRepository});

  void cache(
    Pk<TimeSerial> timeSerialId,
    List<TimeSeriesEntry<double?>> measurements,
  ) {
    _cache[timeSerialId] = measurements;
  }

  List<TimeSeriesEntry<double?>> getCached(
    Pk<TimeSerial> timeSerialId,
    final DateTime start,
    final DateTime stop,
  ) {
    if (_cache.containsKey(timeSerialId)) {
      return _cache[timeSerialId]!
          .where((e) => !(e.time.isBefore(start) || e.time.isAfter(stop)))
          .toList();
    }
    return [];
  }

  Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> getMultipleCached(
    List<Pk<TimeSerial>> timeSerialIds,
    final DateTime start,
    final DateTime stop,
  ) {
    return {
      for (Pk<TimeSerial> id in timeSerialIds)
        id: _cache[id]!
            .where((e) => !(e.time.isBefore(start) || e.time.isAfter(stop)))
            .toList(),
    };
  }

  void sideload(final Pk<TimeSerial> id, List<dynamic> data) {
    final List<TimeSeriesEntry<double?>> measurements = data
        .map((e) => TimeSeriesEntry.fromJson(DataType.Double, e)
            as TimeSeriesEntry<double?>)
        .toList();

    cache(id, measurements);
    timeSeriesEntryRepository.cacheLast(
      id,
      measurements.last,
    ); // TODO test if last is always the newest
  }
}
