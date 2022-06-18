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

import 'permission.dart';
import 'primary_key.dart';
import 'user.dart';

import 'model.dart';

class Role extends Model<Role> {
  static const collection = 'role';

  final String name;
  final String description;
  final List<Permission> permissions;

  const Role(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.description,
    this.permissions,
  );

  Role.guest()
      : name = 'public',
        description = '',
        permissions = [],
        super(
          Pk<Role>('public'),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        ); //  TODO load guest permissions somewhere

  Role.createDefault()
      : name = '',
        description = '',
        permissions = [],
        super.createDefault();

  Role.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        description = data['description'],
        permissions = data.containsKey('permissions')
            ? (data['permissions'] as List)
                .map((e) => Permission.fromJson(e))
                .toList()
            : [],
        super.fromJson(data);

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'permissions': permissions.map((Permission e) => e.name).toList(),
      };

  Role copyWith({
    final String? description,
    final List<Permission>? permissions,
    final String? name, // NOTE name is only considered if new
  }) =>
      Role(
        isNew ? const Pk<Role>.newModel() : Pk<Role>(1),
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        name != null && isNew ? name : this.name,
        description ?? this.description,
        permissions ?? this.permissions,
      );

  @override
  List<Object> get props => super.props
    ..addAll([
      name,
      description,
      permissions,
    ]);
}
