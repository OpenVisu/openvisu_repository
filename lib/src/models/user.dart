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

class User extends Model<User> {
  final String username;
  final String email;
  final String? unconfirmedEmail;
  final String? registrationIp;
  final int? confirmedAt;
  final int? lastLoginAt;
  final String? lastLoginIp;
  final String? firstName;
  final String? lastName;
  final String? timezone;
  final String? locale;
  final String? company;
  final String? title;

  final String? password;
  final List<String> roles;

  const User(
    final Pk<User> id,
    final int createdAt,
    final int updatedAt,
    this.username,
    this.email,
    this.unconfirmedEmail,
    this.registrationIp,
    this.confirmedAt,
    this.lastLoginAt,
    this.lastLoginIp,
    this.firstName,
    this.lastName,
    this.timezone,
    this.locale,
    this.company,
    this.title,
    this.password,
    this.roles,
  ) : super(
          id,
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          createdAt,
          updatedAt,
        );

  User.createDefault()
      : username = '',
        email = '',
        unconfirmedEmail = null,
        registrationIp = null,
        confirmedAt = null,
        lastLoginAt = null,
        lastLoginIp = null,
        firstName = null,
        lastName = null,
        timezone = null,
        locale = null,
        company = null,
        title = null,
        password = null,
        roles = [],
        super(
          Pk<User>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  User.fromJson(Map<String, dynamic> data)
      : username = data['username'],
        email = data['email'],
        unconfirmedEmail = data['unconfirmed_email'],
        registrationIp = data['registration_ip'],
        confirmedAt = data['confirmed_at'],
        lastLoginAt = data['last_login_at'],
        lastLoginIp = data['last_login_ip'],
        firstName = data['first_name'],
        lastName = data['last_name'],
        timezone = data['timezone'],
        locale = data['locale'],
        company = data['company'],
        title = data['title'],
        password = null,
        roles = (data['roles'] as List).map((e) => e as String).toList(),
        super(
          Pk<User>(data['id'] as int),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      if (!isNew) 'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'timezone': timezone,
      'locale': locale,
      'company': company,
      'title': title,
      if (password != null) 'password': password,
      'roles': roles,
    };
  }

  User copyWith({
    final String? email,
    final String? firstName,
    final String? lastName,
    final String? username,
    final String? timezone,
    final String? locale,
    final String? company,
    final String? title,
    final String? password,
    final List<String>? roles,
  }) {
    return User(
      id,
      createdAt,
      updatedAt,
      username ?? this.username,
      email ?? this.email,
      unconfirmedEmail,
      registrationIp,
      confirmedAt,
      lastLoginAt,
      lastLoginIp,
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      timezone ?? this.timezone,
      locale ?? this.locale,
      company ?? this.company,
      title ?? this.title,
      password ?? this.password,
      roles ?? this.roles,
    );
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      username,
      email,
      if (unconfirmedEmail != null) unconfirmedEmail!,
      if (registrationIp != null) registrationIp!,
      if (confirmedAt != null) confirmedAt!,
      if (lastLoginAt != null) lastLoginAt!,
      if (lastLoginIp != null) lastLoginIp!,
      if (firstName != null) firstName!,
      if (lastName != null) lastName!,
      if (timezone != null) timezone!,
      if (locale != null) locale!,
      if (company != null) company!,
      if (title != null) title!,
      if (password != null) password!,
      roles,
    ]);
}
