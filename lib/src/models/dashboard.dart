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

class Dashboard extends Model<Dashboard> {
  static const collection = 'dashboard';

  final String name;
  final int sort;

  const Dashboard(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.sort,
  );

  @override
  Dashboard.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        sort = data['sort'],
        super(
          Pk<Dashboard>(data['id'] as int),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          data['created_at'],
          data['updated_at'],
        );

  @override
  Dashboard.createDefault()
      : name = '',
        sort = 0,
        super(
          Pk<Dashboard>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'name': name,
        'sort': sort,
      };

  Dashboard copyWith({final String? name, final String? description}) =>
      Dashboard(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        name ?? this.name,
        sort,
      );

  @override
  int getSort() {
    return sort;
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      name,
      sort,
    ]);
}
