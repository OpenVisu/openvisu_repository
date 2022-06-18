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
import 'permission.dart';
import 'primary_key.dart';
import 'user.dart';

class Me extends Model<Me> {
  final String? status;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? timezone;
  final String? locale;
  final String? avatar;
  final String? company;
  final String? title;
  final List<String> roles;
  final List<Permission> permissions;

  const Me(
    Pk<Me> id,
    this.status,
    this.firstName,
    this.lastName,
    this.email,
    this.timezone,
    this.locale,
    this.avatar,
    this.company,
    this.title,
    this.roles,
    this.permissions,
  ) : super(
          id,
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  Me.fromJson(Map<String, dynamic> data)
      : status = data['status'],
        firstName = data['first_name'],
        lastName = data['last_name'],
        email = data['email'],
        timezone = data['timezone'],
        locale = data['locale'],
        avatar = data['avatar'],
        company = data['company'],
        title = data['title'],
        roles = data['roles'].cast<String>(),
        permissions =
            (data['permissions'] as List).map((e) => Permission(e)).toList(),
        super.fromJson(data);

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'timezone': timezone,
        'locale': locale,
        'avatar': avatar,
        'company': company,
        'title': title,
        'roles': roles,
        'permissions': (permissions.map((e) => e.name)).toList(),
      };

  bool isGuest() {
    return roles.length == 1 && roles.first == 'public';
  }

  @override
  Map<String, dynamic> toMap() {
    throw UnimplementedError('not supposed to be used');
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      if (status != null) status!,
      if (firstName != null) firstName!,
      if (lastName != null) lastName!,
      if (email != null) email!,
      if (timezone != null) timezone!,
      if (locale != null) locale!,
      if (avatar != null) avatar!,
      if (company != null) company!,
      if (title != null) title!,
      roles,
      permissions,
    ]);
}
