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

import 'package:equatable/equatable.dart';

import '../enums/filter_type.dart';

class Filter extends Equatable {
  final String key;
  final FilterType operator;
  final String value;

  const Filter({
    required this.key,
    required this.operator,
    required this.value,
  });

  // https://www.yiiframework.com/doc/guide/2.0/en/rest-filtering-collections#filter-control-keywords
  String toUrl() {
    switch (operator) {
      case FilterType.EQ:
        return 'filter[$key]=$value';
      case FilterType.IN:
        return value.split(',').map((e) => 'filter[$key][in][]=$e').join('&');
      case FilterType.NIN:
        return value.split(',').map((e) => 'filter[$key][nin][]=$e').join('&');
      case FilterType.LIKE:
        return 'filter[$key][like]=$value';
      case FilterType.AND:
      case FilterType.OR:
      case FilterType.NOT:
      case FilterType.LT:
      case FilterType.GT:
      case FilterType.LTE:
      case FilterType.GTE:
      case FilterType.NEQ:
        throw UnimplementedError('FilterType not yet implemented.');
    }
  }

  @override
  List<Object> get props => [
        key,
        operator,
        value,
      ];
}
