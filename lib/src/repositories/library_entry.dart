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

class LibraryEntryRepository extends CrudRepository<LibraryEntry> {
  LibraryEntryRepository({required super.authenticationRepository});

  @override
  Uri indexUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/library_manager/library-entry/index?sort=sort',
    );
  }

  @override
  Uri createUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/library_manager/library-entry/create',
    );
  }

  @override
  Uri viewUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/library_manager/library-entry/view?id=$modelKey',
    );
  }

  @override
  Uri updateUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/library_manager/library-entry/update?id=$modelKey',
    );
  }

  @override
  Uri deleteUrl(final Pk modelKey) {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/library_manager/library-entry/delete?id=$modelKey',
    );
  }

  @override
  Uri sortUrl() {
    return Uri.parse(
      '${AuthenticationRepository.serverUrl}/api/library_manager/library-entry/sort',
    );
  }

  @override
  Uri swapUrl() {
    throw UnimplementedError('Swapping is not supported.');
  }

  @override
  Model create(Map<String, dynamic>? data) {
    return LibraryEntry.fromJson(data!);
  }

  @override
  Model createDefault() {
    return LibraryEntry.createDefault();
  }
}
