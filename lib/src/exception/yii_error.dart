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

class BackendErrorInformation {}

class YiiExceptionInformation extends BackendErrorInformation {
  final String name;
  final String message;
  final int code;
  final String type;
  final String? file;
  final int? line;

  YiiExceptionInformation(
      this.name, this.message, this.code, this.type, this.file, this.line);

  YiiExceptionInformation.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        message = data['message'],
        code = data['code'],
        type = data['type'],
        file = data.containsKey('file') ? data['file'] : null,
        line = data.containsKey('line') ? data['line'] : null;

  @override
  String toString() {
    return 'YiiError ('
        '$name, '
        '$message, '
        '$code, '
        '$type, '
        '$file, '
        '$line, '
        ')';
  }
}

class YiiErrorInformation extends BackendErrorInformation {
  final int code;
  final String message;

  YiiErrorInformation.fromJson(Map<String, dynamic> data)
      : code = data['error']!['code']!,
        message = data['error']!['message']!;

  YiiErrorInformation.wasDeleted()
      : code = 404,
        message = 'The Item was deleted';
}

/// handles validation errors of models
class YiiUnprocessableEntityInformation extends BackendErrorInformation {
  Map<String, List<String>> errors = {};

  YiiUnprocessableEntityInformation.fromJson(List<dynamic> data) {
    for (Map<String, dynamic> entry in data) {
      if (!errors.containsKey(entry['field'])) {
        errors[entry['field']!] = <String>[];
      }
      errors[entry['field']!]!.add(entry['message']!);
    }
  }

  /// returns the errors reported by the server for that specific field
  String? getField(String field) {
    if (errors.containsKey(field)) {
      return errors[field]!.join(',');
    }
    return null;
  }
}

/// handles validation errors of models
class HtmlError extends BackendErrorInformation {
  final String html;

  HtmlError(this.html);
}

class SocketError extends BackendErrorInformation {
  final String message;

  SocketError(this.message);
}
