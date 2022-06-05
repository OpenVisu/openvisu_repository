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

import 'package:openvisu_repository/openvisu_repository.dart';

class PageRepository extends CrudRepository<Page> {
  PageRepository({required super.authenticationRepository});

  @override
  Uri indexUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/page/index?sort=sort',
    );
  }

  @override
  Uri createUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/page/create',
    );
  }

  @override
  Uri viewUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/page/view?id=$modelKey',
    );
  }

  @override
  Uri updateUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/page/update?id=$modelKey',
    );
  }

  @override
  Uri deleteUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/page/delete?id=$modelKey',
    );
  }

  @override
  Uri sortUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/page/sort',
    );
  }

  @override
  Uri swapUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/page/swap',
    );
  }

  @override
  Page create(Map<String, dynamic>? data) {
    return Page.fromJson(data!);
  }

  @override
  Page createDefault() {
    return Page.createDefault();
  }
}
