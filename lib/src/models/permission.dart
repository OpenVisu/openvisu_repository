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

class Permission extends Model<Permission> {
  final String name;

  Permission(
    this.name,
  ) : super.createDefault();

  @override
  Permission.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        super.fromJson(data);

  Permission.create(
    final ActionType actionType,
    final RightType rightType,
    final String subject,
  )   : name = generateName(actionType, rightType, subject),
        super.createDefault();

  static String generateName(
    ActionType actionType,
    RightType rightType,
    String subject,
  ) {
    String action = actionType.toString();

    if (rightType == RightType.none) {
      throw UnsupportedError('input not valid');
    }
    String right = rightType.toString();

    return '$action:$right:$subject';
  }

  @override
  Map<String, String> toMap() => {
        'name': name,
      };

  ActionType? get actionType {
    if (name.split(':').length != 3) return null;
    final List<String> l = name.split(':');
    return ActionType.fromString(l[0]);
  }

  RightType? get rightType {
    if (name.split(':').length != 3) return RightType.none;
    final List<String> l = name.split(':');
    return RightType.fromString(l[1]);
  }

  String? get subject {
    if (name.split(':').length != 3) return null;
    final List<String> l = name.split(':');
    return l[2];
  }

  bool can(
      final String subject, final ActionType actionType, final bool owner) {
    if (this.subject != subject) return false;
    switch (actionType) {
      case ActionType.create:
        return this.actionType == ActionType.create;
      case ActionType.view:
        return this.actionType == ActionType.view &&
                rightType == RightType.all ||
            (owner && rightType == RightType.own);
      case ActionType.update:
        return this.actionType == ActionType.update &&
                rightType == RightType.all ||
            (owner && rightType == RightType.own);
      case ActionType.delete:
        return this.actionType == ActionType.delete &&
                rightType == RightType.all ||
            (owner && rightType == RightType.own);
    }
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      name,
    ]);
}
