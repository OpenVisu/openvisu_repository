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

class ProjectRepository extends CrudRepository<Project> {
  ProjectRepository({required super.authenticationRepository});

  @override
  Uri indexUrl() {
    throw UnimplementedError();
  }

  @override
  Uri createUrl() {
    throw UnimplementedError();
  }

  @override
  Uri viewUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/project/view?id=1',
    );
  }

  @override
  Uri updateUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/project/update?id=1',
    );
  }

  @override
  Uri deleteUrl(final Pk modelKey) {
    throw UnimplementedError;
  }

  @override
  Project create(Map<String, dynamic>? data) {
    return Project.fromJson(data!);
  }

  @override
  Project createDefault() {
    throw UnimplementedError;
  }
}
