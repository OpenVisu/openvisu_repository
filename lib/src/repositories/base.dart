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

import 'package:openvisu_repository/openvisu_repository.dart';

abstract class BaseRepository {
  final AuthenticationRepository authenticationRepository;

  Uri indexUrl();

  Uri createUrl();

  Uri viewUrl(final Pk modelKey);

  Uri updateUrl(final Pk modelKey);

  Uri deleteUrl(final Pk modelKey);

  Uri sortUrl() {
    throw UnimplementedError('Sorting is not supported.');
  }

  Uri swapUrl() {
    throw UnimplementedError('Swapping is not supported.');
  }

  Model create(final Map<String, dynamic> data);

  Model createDefault();

  BaseRepository({
    required this.authenticationRepository,
  });
}
