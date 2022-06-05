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

import 'dart:core';

import 'package:openvisu_repository/src/enums/aggregation_function_type.dart';
import '../enums/data_type.dart';
import 'chart_page.dart';
import 'model.dart';
import 'node.dart';
import 'primary_key.dart';
import 'server.dart';
import 'time_series_entry.dart';
import 'user.dart';

class TimeSerial extends Model<TimeSerial> {
  static const collection = 'time-serial';

  final Pk<ChartPage> chartPageId;
  final Pk<Server> serverId;
  final Pk<Node> nodeId;
  final String name;
  final String colorHex;
  final double minValue;
  final double maxValue;
  final AggregationFunctionType aggregationFunction;
  final String unit;
  final int resolution;
  final double factor;
  final bool alert;
  final List<TimeSeriesEntry<double?>> measurements;

  const TimeSerial(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.chartPageId,
    this.serverId,
    this.nodeId,
    this.name,
    this.colorHex,
    this.minValue,
    this.maxValue,
    this.aggregationFunction,
    this.unit,
    this.resolution,
    this.factor,
    this.alert,
    this.measurements,
  );

  TimeSerial.createDefault()
      : chartPageId = Pk<ChartPage>.newModel(),
        serverId = const Pk<Server>.empty(),
        nodeId = const Pk<Node>.empty(),
        name = '',
        colorHex = '#0000FF',
        minValue = 0,
        maxValue = 1,
        aggregationFunction = AggregationFunctionType.mean,
        unit = '',
        resolution = 2,
        factor = 1,
        alert = false,
        measurements = [],
        super(
          Pk<TimeSerial>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  TimeSerial.fromJson(Map<String, dynamic> data)
      : chartPageId = Pk<ChartPage>(data['chart_page_id'] as int),
        serverId = Pk<Server>(data['server_id'] as int),
        nodeId = Pk<Node>(data['node_id'] as int),
        name = data['name'],
        colorHex = data['color'] as String,
        minValue = double.parse('${data['min_value']}'),
        maxValue = double.parse('${data['max_value']}'),
        aggregationFunction =
            AggregationFunctionType.fromString(data['aggregation_function']),
        unit = data['unit'],
        resolution = data['resolution'],
        factor = double.parse('${data['factor']}'),
        alert = (data['alert'] as int) == 1,
        measurements = data.containsKey('measurements')
            ? (data['measurements'] as List)
                .map((e) => TimeSeriesEntry.fromJson(DataType.Double, e)
                    as TimeSeriesEntry<double?>)
                .toList()
            : [],
        super(
          Pk<TimeSerial>(data['id'] as int),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          data['created_at'],
          data['updated_at'],
        );

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        if (chartPageId.isNotEmpty) 'chart_page_id': chartPageId,
        if (serverId.isNotEmpty) 'server_id': serverId,
        if (nodeId.isNotEmpty) 'node_id': nodeId,
        'name': name,
        'color': colorHex,
        'min_value': minValue,
        'max_value': maxValue,
        'aggregation_function': aggregationFunction.toString(),
        'unit': unit,
        'resolution': resolution,
        'factor': factor,
        'alert': alert,
      };

  TimeSerial copyWith({
    final Pk<ChartPage>? chartPageId,
    final Pk<Server>? serverId,
    final Pk<Node>? nodeId,
    final String? name,
    final String? colorHex,
    final double? minValue,
    final double? maxValue,
    final AggregationFunctionType? aggregationFunction,
    final String? unit,
    final int? resolution,
    final double? factor,
    final bool? alert,
    final List<TimeSeriesEntry<double>>? measurements,
  }) =>
      TimeSerial(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        chartPageId ?? this.chartPageId,
        serverId ?? this.serverId,
        nodeId ?? this.nodeId,
        name ?? this.name,
        colorHex ?? this.colorHex,
        minValue ?? this.minValue,
        maxValue ?? this.maxValue,
        aggregationFunction ?? this.aggregationFunction,
        unit ?? this.unit,
        resolution ?? this.resolution,
        factor ?? this.factor,
        alert ?? this.alert,
        measurements ?? this.measurements,
      );

  @override
  List<Object> get props => super.props
    ..addAll([
      chartPageId,
      serverId,
      nodeId,
      name,
      colorHex,
      minValue,
      maxValue,
      aggregationFunction,
      unit,
      resolution,
      factor,
      alert,
      measurements,
    ]);
}
