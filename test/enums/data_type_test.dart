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
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test toString and fromString methods', () {
    for (final DataType original in DataType.values) {
      DataType recreated = DataType.fromString(original.toString());
      expect(original, recreated);
    }
  });

  test('Test isNumeric method', () {
    for (final DataType dt in DataType.values) {
      final bool r = dt.isNumeric();
      switch (dt) {
        case DataType.Boolean:
        case DataType.Float:
        case DataType.Double:
        case DataType.Int16:
        case DataType.Int32:
        case DataType.Int64:
        case DataType.UInt16:
        case DataType.UInt32:
        case DataType.UInt64:
          expect(r, true);
          break;
        default:
          expect(r, false);
      }
    }
  });

  test('Test isTrackable method', () {
    for (final DataType dt in DataType.values) {
      final bool r = dt.isTrackable();
      switch (dt) {
        case DataType.Boolean:
        case DataType.Float:
        case DataType.Double:
        case DataType.String:
        case DataType.Int16:
        case DataType.Int32:
        case DataType.Int64:
        case DataType.UInt16:
        case DataType.UInt32:
        case DataType.UInt64:
          expect(r, true);
          break;
        default:
          expect(r, false);
      }
    }
  });
  test('Test isEditable method', () {
    for (final DataType dt in DataType.values) {
      final bool r = dt.isEditable();
      switch (dt) {
        case DataType.Boolean:
        case DataType.Float:
        case DataType.Double:
        case DataType.String:
        case DataType.Int16:
        case DataType.Int32:
        case DataType.Int64:
        case DataType.UInt16:
        case DataType.UInt32:
        case DataType.UInt64:
          expect(r, true);
          break;
        default:
          expect(r, false);
      }
    }
  });
}
