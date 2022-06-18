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
import 'user.dart';

class Setting extends Model<Setting> {
  final String key;
  final String value;

  const Setting(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.key,
    this.value,
  );

  Setting.createDefault()
      : key = '',
        value = '',
        super.createDefault();

  Setting.fromJson(Map<String, dynamic> data)
      : key = data['key'],
        value = '${data['value']}',
        super.fromJson(data);

  @override
  Map<String, dynamic> toMap() {
    return {
      if (!isNew) 'id': id,
      'key': key,
      'value': value,
    };
  }

  Setting copyWith({
    final String? key,
    final String? value,
  }) =>
      Setting(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        key ?? this.key,
        value ?? this.value,
      );

  @override
  List<Object> get props => super.props
    ..addAll([
      key,
      value,
    ]);
}
