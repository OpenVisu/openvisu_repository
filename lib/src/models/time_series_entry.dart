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

import 'package:equatable/equatable.dart';
import 'package:openvisu_repository/src/enums/data_type.dart';

class TimeSeriesEntry<T> extends Equatable {
  final DateTime time;
  final T value;

  const TimeSeriesEntry._(
    this.time,
    this.value,
  );

  static TimeSeriesEntry fromJson(
      DataType dataType, Map<String, dynamic> data) {
    final DateTime time =
        DateTime.fromMillisecondsSinceEpoch(data['timestamp'] * 1000);

    return fromDataType(dataType, time, data['value']);
  }

  static TimeSeriesEntry fromDataType(
    final DataType dataType,
    final DateTime time,
    final dynamic value,
  ) {
    switch (dataType) {
      case DataType.String:
        return TimeSeriesEntry<String?>._(time, (value as String?));
      case DataType.Boolean:
        return TimeSeriesEntry<bool>._(
            time, int.tryParse('$value') == 1 ? true : false);
      case DataType.Double:
        return TimeSeriesEntry<double?>._(
          time,
          double.tryParse('$value'),
        );
      default:
        return TimeSeriesEntry._(time, value);
    }
  }

  @override
  List<Object> get props => [
        time,
        if (value != null) value!,
      ];
}
