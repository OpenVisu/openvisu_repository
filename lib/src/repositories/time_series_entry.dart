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

/// this repository stores the last value of each timeSerial
/// currently the values need to be sideloaded
class TimeSeriesEntryRepository {
  final Map<Pk<TimeSerial>, TimeSeriesEntry<double?>> _cacheLast = {};

  cacheLast(final Pk<TimeSerial> id, final TimeSeriesEntry<double?> tse) {
    if (!_cacheLast.containsKey(id)) {
      _cacheLast[id] = tse;
    } else if (_cacheLast[id]!.time.isBefore(tse.time)) {
      _cacheLast[id] = tse;
    }
  }

  TimeSeriesEntry<double?>? getLast(final Pk<TimeSerial> id) {
    if (_cacheLast.containsKey(id)) {
      return _cacheLast[id];
    }
    return null;
  }

  void sideloadMultiple(final Pk<TimeSerial> id, final List<dynamic> data) {
    for (Map<String, dynamic> d in data) {
      sideloadOne(id, d);
    }
  }

  void sideloadOne(final Pk<TimeSerial> id, final Map<String, dynamic> data) {
    cacheLast(
      id,
      TimeSeriesEntry.fromJson(DataType.Double, data)
          as TimeSeriesEntry<double?>,
    );
  }
}
