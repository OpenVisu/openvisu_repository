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

class ChartPageRepository extends CrudRepository<ChartPage> {
  ChartPageRepository({required super.authenticationRepository});

  @override
  Uri indexUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/chart-page/index',
    );
  }

  @override
  Uri createUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/chart-page/create',
    );
  }

  @override
  Uri viewUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/chart-page/view?id=$modelKey',
    );
  }

  @override
  Uri updateUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/chart-page/update?id=$modelKey',
    );
  }

  @override
  Uri deleteUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/dashboard/chart-page/delete?id=$modelKey',
    );
  }

  @override
  ChartPage create(Map<String, dynamic>? data) {
    return ChartPage.fromJson(data!);
  }

  @override
  ChartPage createDefault() {
    return ChartPage.createDefault();
  }
}
