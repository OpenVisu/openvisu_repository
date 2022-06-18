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

import '../enums/data_type.dart';
import 'model.dart';
import 'primary_key.dart';
import 'server.dart';
import 'time_series_entry.dart';
import 'user.dart';

class Node extends Model<Node> {
  static const collection = 'node';

  final Pk<Server> serverId;
  final String serverName;
  final String nodeId;
  final String displayName;
  final bool tracked;
  final String path; // read only
  final bool readable;
  final bool writable;
  final DataType datatype;
  final TimeSeriesEntry? timeSeriesEntry;
  final String? changeValue;
  final int? changeErrorAt;
  final String? changeError;

  const Node(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.serverId,
    this.serverName,
    this.nodeId,
    this.displayName,
    this.tracked,
    this.path,
    this.readable,
    this.writable,
    this.datatype,
    this.timeSeriesEntry,
    this.changeValue,
    this.changeErrorAt,
    this.changeError,
  );

  Node.fromJson(Map<String, dynamic> data)
      : serverId = Pk<Server>(data['server_id']),
        serverName = data['server_name'],
        nodeId = data['identifier'],
        displayName = data['display_name'],
        tracked = data['tracked'] == 1,
        path = data['path'],
        readable = data['readable'] == 1,
        writable = data['writable'] == 1,
        datatype = DataType.fromString(data['data_type']),
        timeSeriesEntry = data.containsKey('lastValue')
            ? TimeSeriesEntry.fromJson(
                DataType.fromString(data['data_type']), data['lastValue'])
            : null,
        changeValue = data['change_value'],
        changeErrorAt = data['change_error_at'],
        changeError = data['change_error'],
        super.fromJson(data);

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'server_id': serverId,
        'node_id': nodeId,
        'display_name': displayName,
        'tracked': tracked ? 1 : 0,
        'change_value': changeValue,
        if (changeValue != null) ...{
          'change_error_at': null,
          'change_error': changeError
        }
      };

  Node copyWith({
    final int? endpointId,
    final Pk<Server>? serverId,
    final String? nodeId,
    final String? displayName,
    final bool? tracked,
    final bool? readable,
    final bool? writable,
    final DataType? dataType,
    final String? changeValue,
  }) =>
      Node(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        serverId ?? this.serverId,
        serverName,
        nodeId ?? this.nodeId,
        displayName ?? this.displayName,
        tracked ?? this.tracked,
        path,
        readable ?? this.readable,
        writable ?? this.writable,
        dataType ?? datatype,
        timeSeriesEntry,
        changeValue ?? this.changeValue,
        changeErrorAt,
        changeError,
      );

  T getLastValue<T>() {
    return timeSeriesEntry?.value as T;
  }

  bool isChangingValue() => (changeValue != null && !hasChangingError());

  bool hasChangingError() => changeError != null;

  T getLastOptimisticValue<T>() {
    if (isChangingValue()) {
      return datatype.cast(changeValue) as T;
    }
    dynamic t = timeSeriesEntry?.value;
    if (t is int && T == double) {
      return t.toDouble() as T;
    }
    if (t is bool && T == double) {
      return (t == true ? 1.0 : 0.0) as T;
    }
    return t as T;
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      serverId,
      serverName,
      nodeId,
      displayName,
      tracked,
      path,
      readable,
      writable,
      datatype,
      if (timeSeriesEntry != null) timeSeriesEntry!,
      if (changeValue != null) changeValue!,
      if (changeErrorAt != null) changeErrorAt!,
      if (changeError != null) changeError!,
    ]);
}
