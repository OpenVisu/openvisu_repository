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

import 'primary_key.dart';
import 'user.dart';

import 'model.dart';

enum RightType { none, mine, all }

enum ActionType { create, read, update, delete }

class Permission extends Model<Permission> {
  final String name;

  Permission(
    this.name,
  ) : super(
          Pk<Permission>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  Permission.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        super(
          Pk<Permission>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  Permission.create(final ActionType actionType, final RightType rightType,
      final String subject)
      : name = generateName(actionType, rightType, subject),
        super(
          Pk<Permission>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  static String generateName(
      ActionType actionType, RightType rightType, String subject) {
    String action = '';
    switch (actionType) {
      case ActionType.create:
        action = 'create';
        break;
      case ActionType.read:
        action = 'view';
        break;
      case ActionType.update:
        action = 'update';
        break;
      case ActionType.delete:
        action = 'delete';
        break;
    }

    String right = '';
    switch (rightType) {
      case RightType.mine:
        right = 'own';
        break;
      case RightType.all:
        right = 'all';
        break;
      case RightType.none:
        throw UnsupportedError('input not valid');
    }

    return '$action:$right:$subject';
  }

  @override
  Map<String, String> toMap() => {
        'name': name,
      };

  ActionType? get actionType {
    if (name.split(':').length != 3) return null;
    final List<String> l = name.split(':');
    switch (l[0]) {
      case 'create':
        return ActionType.create;
      case 'view':
        return ActionType.read;
      case 'update':
        return ActionType.update;
      case 'delete':
        return ActionType.delete;
    }
    return null;
  }

  RightType? get rightType {
    if (name.split(':').length != 3) return RightType.none;
    final List<String> l = name.split(':');
    switch (l[1]) {
      case 'own':
        return RightType.mine;
      case 'all':
        return RightType.all;
    }
    return RightType.none;
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
      case ActionType.read:
        return this.actionType == ActionType.read &&
                rightType == RightType.all ||
            (owner && rightType == RightType.mine);
      case ActionType.update:
        return this.actionType == ActionType.update &&
                rightType == RightType.all ||
            (owner && rightType == RightType.mine);
      case ActionType.delete:
        return this.actionType == ActionType.delete &&
                rightType == RightType.all ||
            (owner && rightType == RightType.mine);
    }
  }

  static String stringFromRightType(final RightType rightType) {
    return rightType.toString().split('.').last;
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      name,
    ]);
}
