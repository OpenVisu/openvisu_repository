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

class Token {
  final int? userId;
  final int? expiresAt;
  final String? token;

  Token(
    this.userId,
    this.expiresAt,
    this.token,
  );

  Token.fromJson(Map<String, dynamic> data)
      : userId = data['user_id'],
        expiresAt = data['expires_at'],
        token = data['token'];

  Token.guest()
      : userId = -1,
        expiresAt = -1,
        token = 'guest';

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'expires_at': expiresAt,
        'token': token,
      };

  bool isGuest() {
    return token == 'guest';
  }

  bool isValid() {
    if (isGuest()) return true;
    if (expiresAt! > (DateTime.now().millisecondsSinceEpoch / 1000).round()) {
      return true;
    }
    return false;
  }
}
