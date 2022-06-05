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

import 'package:equatable/equatable.dart';

class Credentials extends Equatable {
  final String? username;
  final String? password;
  final String endpoint;

  const Credentials({
    required this.username,
    required this.password,
    required this.endpoint,
  });

  Credentials.fromJson(Map<String, dynamic> data)
      : username = data['username'],
        password = data['password'],
        endpoint = data['endpoint'];

  Map<String, String?> toJson() => {
        'username': username,
        'password': password,
        'endpoint': endpoint,
      };

  @override
  String toString() => 'Credentials { '
      'username: $username, '
      'password: $password, '
      'endpoint: $endpoint, '
      '}';

  @override
  List<Object> get props => [
        if (username != null) username!,
        if (password != null) password!,
        endpoint,
      ];
}
