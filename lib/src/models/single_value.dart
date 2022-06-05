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

import 'dart:convert';
import 'dart:core';

import 'node.dart';
import 'page_content.dart';
import 'primary_key.dart';
import 'server.dart';
import 'user.dart';

class SingleValuePage extends PageContent<SingleValuePage> {
  static const collection = 'single-value-page';

  final Pk<Server> serverId;
  final Pk<Node> nodeId;
  final String unit;
  final int resolution;
  final double factor;
  final Node? node;
  final String styleType;
  final Map<String, dynamic> styleConfiguration;

  const SingleValuePage(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.serverId,
    this.nodeId,
    this.unit,
    this.resolution,
    this.factor,
    this.node,
    this.styleType,
    this.styleConfiguration,
  ) : super();

  SingleValuePage.createDefault()
      : serverId = Pk<Server>.newModel(),
        nodeId = Pk<Node>.newModel(),
        unit = '',
        resolution = 2,
        factor = 1,
        node = null,
        styleType = '',
        styleConfiguration = {},
        super(
          PageContentPk<SingleValuePage>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  SingleValuePage.fromJson(Map<String, dynamic> data)
      : serverId = Pk<Server>(data['server_id']),
        nodeId = Pk<Node>(data['node_id']),
        unit = data['unit'],
        resolution = data['resolution'],
        factor = double.parse('${data['factor']}'),
        node = data.containsKey('node') && data['node'] != null
            ? Node.fromJson(data['node'])
            : null,
        styleType = data['style_type'],
        styleConfiguration = jsonDecode(data['style_configuration']),
        super(
          PageContentPk<SingleValuePage>(data['id'] as int),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          data['created_at'],
          data['updated_at'],
        );

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        if (serverId.isNotEmpty) 'server_id': serverId,
        if (nodeId.isNotEmpty) 'node_id': nodeId,
        'unit': unit,
        'resolution': resolution,
        'factor': factor.toStringAsFixed(2),
        'style_type': styleType,
        'style_configuration': jsonEncode(styleConfiguration),
      };

  SingleValuePage copyWith({
    final Pk<Server>? serverId,
    final Pk<Node>? nodeId,
    final unit,
    final resolution,
    final factor,
    final node,
    final styleType,
    final styleConfiguration,
  }) {
    return SingleValuePage(
      id as PageContentPk<SingleValuePage>,
      createdBy,
      updatedBy,
      createdAt,
      updatedAt,
      serverId ?? this.serverId,
      nodeId ?? this.nodeId,
      unit ?? this.unit,
      resolution ?? this.resolution,
      factor ?? this.factor,
      node ?? this.node,
      styleType ?? this.styleType,
      styleConfiguration ?? this.styleConfiguration,
    );
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      serverId,
      nodeId,
      unit,
      resolution,
      factor,
      if (node != null) node!,
      styleType,
      styleConfiguration,
    ]);
}
