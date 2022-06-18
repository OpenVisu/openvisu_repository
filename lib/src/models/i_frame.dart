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

class IFrame extends Model<IFrame> {
  static const collection = 'i-frame';

  final String name;
  final String url;
  final int sort;

  const IFrame(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.sort,
    this.url,
  );

  @override
  IFrame.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        sort = data['sort'],
        url = data['url'],
        super.fromJson(data);

  @override
  IFrame.createDefault()
      : name = '',
        url = '',
        sort = 0,
        super.createDefault();

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'name': name,
        'url': url,
        'sort': sort,
      };

  IFrame copyWith({final String? name, final String? url}) => IFrame(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        name ?? this.name,
        sort,
        url ?? this.url,
      );

  @override
  int getSort() {
    return sort;
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      name,
      sort,
      url,
    ]);
}
