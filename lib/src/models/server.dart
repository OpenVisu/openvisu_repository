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

import 'model.dart';
import 'primary_key.dart';
import 'user.dart';
import 'package:flutter/material.dart';

class Server extends Model<Server> {
  static const collection = 'server';

  final String name;
  final String url;
  final String description;
  final int checkedOn; // readonly
  final bool scanRequired;
  final int modifiedOn; // readonly
  final bool hasConnectionError;
  final String? connectionError;
  final String rootNode;

  const Server(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.url,
    this.description,
    this.checkedOn,
    this.scanRequired,
    this.modifiedOn,
    this.hasConnectionError,
    this.connectionError,
    this.rootNode,
  );

  Server.createDefault()
      : name = '',
        url = '',
        description = '',
        checkedOn = 0,
        scanRequired = false,
        modifiedOn = 0,
        hasConnectionError = false,
        connectionError = null,
        rootNode = '',
        super(
          Pk<Server>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  Server.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        url = data['url'],
        description = data['description'],
        checkedOn = data['checked_at'] ?? 0, // TODO set 0 as default in db
        scanRequired = data['scan_required'] == 1,
        modifiedOn = data['updated_at'],
        hasConnectionError = data['has_connection_error'] == 1,
        connectionError = data['connection_error'],
        rootNode = data['root_node'] ?? '',
        super(
          Pk<Server>(data['id'] as int),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          data['created_at'],
          data['updated_at'],
        );

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'name': name,
        'url': url,
        'description': description,
        'scan_required': scanRequired ? 1 : 0,
        'root_node': rootNode,
      };

  Server copyWith({
    final String? name,
    final String? url,
    final String? description,
    final int? sort,
    final bool? scanRequired,
    final String? rootNode,
  }) =>
      Server(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        name ?? this.name,
        url ?? this.url,
        description ?? this.description,
        checkedOn,
        scanRequired ?? this.scanRequired,
        modifiedOn,
        hasConnectionError,
        connectionError,
        rootNode ?? this.rootNode,
      );

  bool isConnected() {
    return getStatusColor() == Colors.green;
  }

  Color getStatusColor() {
    if (hasConnectionError) return Colors.red;

    DateTime nowTime = DateTime.now().toUtc();

    DateTime checkedOnTime = DateTime.fromMillisecondsSinceEpoch(
      checkedOn * 1000,
      isUtc: true,
    );
    DateTime modifiedOnTime = DateTime.fromMillisecondsSinceEpoch(
      modifiedOn * 1000,
      isUtc: true,
    );

    // unknown state
    if (checkedOnTime.isBefore(modifiedOnTime)) {
      if (nowTime.difference(checkedOnTime).inMinutes > 5) return Colors.red;
      return Colors.blue;
    }

    int differenceInMinutes = nowTime.difference(checkedOnTime).inMinutes;
    if (differenceInMinutes > 5) return Colors.red;
    if (differenceInMinutes > 2) return Colors.orange;
    return Colors.green;
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      name,
      url,
      description,
      checkedOn,
      scanRequired,
      modifiedOn,
      hasConnectionError,
      if (connectionError != null) connectionError!,
      rootNode,
    ]);
}
