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

enum ActionType {
  create,
  view,
  update,
  delete;

  static ActionType? fromString(final String s) {
    switch (s) {
      case 'create':
        return ActionType.create;
      case 'view':
        return ActionType.view;
      case 'update':
        return ActionType.update;
      case 'delete':
        return ActionType.delete;
    }
    return null;
  }

  @override
  String toString() {
    return name;
  }
}
