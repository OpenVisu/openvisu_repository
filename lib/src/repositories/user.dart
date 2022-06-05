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

import 'package:http/http.dart';
import 'package:openvisu_repository/openvisu_repository.dart';

class UserRepository extends CrudRepository<User> {
  UserRepository({required super.authenticationRepository});

  @override
  Uri indexUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/user-administration/index',
    );
  }

  @override
  Uri createUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/user-administration/create',
    );
  }

  @override
  Uri viewUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/user-administration/view?id=$modelKey',
    );
  }

  @override
  Uri updateUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/user-administration/update?id=$modelKey',
    );
  }

  @override
  Uri deleteUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/user-administration/delete?id=$modelKey',
    );
  }

  @override
  User create(Map<String, dynamic>? data) {
    return User.fromJson(data!);
  }

  @override
  User createDefault() {
    return User.createDefault();
  }

  // additional calls that are not CRUD go here

  Future<User> getMe() async {
    final Uri getMe = Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/me/view',
    );
    Response response = await httpGet(getMe);
    return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }

  Future<User> updateMe(User user) async {
    final Uri updateMe = Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/me/update',
    );
    Response response = await httpPost(updateMe, user.toMap());
    return User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  }
}
