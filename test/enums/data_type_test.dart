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

import 'dart:math';

import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test toString and fromString methods', () {
    for (final DataType original in DataType.values) {
      DataType recreated = DataType.fromString(original.toString());
      expect(original, recreated);
    }

    expect(DataType.fromString('not existing'), DataType.none);
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

  test('Test validate method', () {
    // Boolean
    expect(DataType.Boolean.validate('-1'), 'Invalid Boolean');
    expect(DataType.Boolean.validate('2'), 'Invalid Boolean');
    expect(DataType.Boolean.validate('0'), null);
    expect(DataType.Boolean.validate('1'), null);

    // Float
    expect(DataType.Float.validate('test'), 'Invalid Float');
    expect(DataType.Float.validate('true'), 'Invalid Float');
    expect(DataType.Float.validate('${3.4028236e+38}'), 'Too big for Float');
    expect(DataType.Float.validate('0'), null);
    expect(DataType.Float.validate('1'), null);
    expect(DataType.Float.validate('1.0'), null);

    // Double
    expect(DataType.Double.validate('test'), 'Invalid Double');
    expect(DataType.Double.validate('true'), 'Invalid Double');
    expect(
      DataType.Double.validate('${double.maxFinite}0'),
      'Too big for Double',
    );
    expect(DataType.Double.validate('0'), null);
    expect(DataType.Double.validate('1'), null);
    expect(DataType.Double.validate('1.0'), null);

    // Int16
    expect(DataType.Int16.validate('test'), 'Invalid Int16');
    expect(DataType.Int16.validate('true'), 'Invalid Int16');
    expect(
      DataType.Int16.validate(pow(2, 15).toString()),
      'Too big for Int16',
    );
    expect(
      DataType.Int16.validate((-pow(2, 15) - 1).toString()),
      'Too small for Int16',
    );
    expect(DataType.Int16.validate('0'), null);
    expect(DataType.Int16.validate('1'), null);
    expect(DataType.Int16.validate('-1'), null);

    // Int32
    expect(DataType.Int32.validate('test'), 'Invalid Int32');
    expect(DataType.Int32.validate('true'), 'Invalid Int32');
    expect(
      DataType.Int32.validate(pow(2, 31).toString()),
      'Too big for Int32',
    );
    expect(
      DataType.Int32.validate((-pow(2, 31) - 1).toString()),
      'Too small for Int32',
    );
    expect(DataType.Int32.validate('0'), null);
    expect(DataType.Int32.validate('1'), null);
    expect(DataType.Int32.validate('-1'), null);

    // Int64
    expect(DataType.Int64.validate('test'), 'Invalid Int64');
    expect(DataType.Int64.validate('true'), 'Invalid Int64');
    expect(DataType.Int64.validate('${pow(2, 63)}0'), 'Invalid Int64');
    expect(DataType.Int64.validate('-${pow(2, 63)}0'), 'Invalid Int64');
    expect(DataType.Int64.validate('0'), null);
    expect(DataType.Int64.validate('1'), null);
    expect(DataType.Int64.validate('-1'), null);

    // UInt16
    expect(DataType.UInt16.validate('test'), 'Invalid UInt16');
    expect(DataType.UInt16.validate('true'), 'Invalid UInt16');
    expect(
      DataType.UInt16.validate(pow(2, 16).toString()),
      'Too big for UInt16',
    );
    expect(
      DataType.UInt16.validate('-1'),
      'Too small for UInt16',
    );
    expect(DataType.UInt16.validate('0'), null);
    expect(DataType.UInt16.validate('1'), null);

    // UInt32
    expect(DataType.UInt32.validate('test'), 'Invalid UInt32');
    expect(DataType.UInt32.validate('true'), 'Invalid UInt32');
    expect(
      DataType.UInt32.validate(pow(2, 32).toString()),
      'Too big for UInt32',
    );
    expect(
      DataType.UInt32.validate('-1'),
      'Too small for UInt32',
    );
    expect(DataType.UInt32.validate('0'), null);
    expect(DataType.UInt32.validate('1'), null);

    // UInt64
    expect(DataType.UInt64.validate('test'), 'Invalid UInt64');
    expect(DataType.UInt64.validate('true'), 'Invalid UInt64');
    expect(
      DataType.UInt64.validate('-1'),
      'Too small for UInt64',
    );
    expect(DataType.UInt64.validate('0'), null);
    expect(DataType.UInt64.validate('1'), null);

    // String
    expect(DataType.String.validate('test string'), null);
    expect(
      DataType.String.validate(List.generate(256, (_) => '-').join()),
      'String max length is 255',
    );

    // unsuppoerted datatypes
    for (final DataType dt in DataType.values) {
      if (!dt.isTrackable()) {
        expect(
          dt.validate(''),
          (String v) => v.startsWith('Unsupported DataType:'),
        );
      }
    }
  });

  test('Test cast method', () {
    // Boolean
    expect(() => DataType.Boolean.cast('-1'), throwsA(isA<FormatException>()));
    expect(() => DataType.Boolean.cast('2'), throwsA(isA<FormatException>()));
    expect(DataType.Boolean.cast('0'), false);
    expect(DataType.Boolean.cast('1'), true);

    // Float
    expect(() => DataType.Float.cast('test'), throwsA(isA<FormatException>()));
    expect(() => DataType.Float.cast('true'), throwsA(isA<FormatException>()));
    expect(
      () => DataType.Float.cast('${3.4028236e+38}'),
      throwsA(isA<FormatException>()),
    );
    expect(DataType.Float.cast('0'), 0);
    expect(DataType.Float.cast('1'), 1);
    expect(DataType.Float.cast('1.0'), 1);

    // Double
    expect(DataType.Double.cast('0'), 0);
    expect(DataType.Double.cast('1'), 1);
    expect(DataType.Double.cast('1.1'), 1.1);

    // Int16
    expect(DataType.Int16.cast('0'), 0);
    expect(DataType.Int16.cast('-1'), -1);
    expect(DataType.Int16.cast('1'), 1);

    // Int32
    expect(DataType.Int32.cast('0'), 0);
    expect(DataType.Int32.cast('-1'), -1);
    expect(DataType.Int32.cast('1'), 1);

    // Int64
    expect(DataType.Int64.cast('0'), 0);
    expect(DataType.Int64.cast('-1'), -1);
    expect(DataType.Int64.cast('1'), 1);

    // UInt16
    expect(DataType.UInt16.cast('0'), 0);
    expect(DataType.UInt16.cast('1'), 1);

    // UInt32
    expect(DataType.UInt32.cast('0'), 0);
    expect(DataType.UInt32.cast('1'), 1);

    // UInt64
    expect(DataType.UInt64.cast('0'), 0);
    expect(DataType.UInt64.cast('1'), 1);

    // String
    expect(DataType.String.cast('0'), '0');
    expect(DataType.String.cast('1'), '1');
    expect(DataType.String.cast('test'), 'test');

    // unsuppoerted datatypes
    for (final DataType dt in DataType.values) {
      if (!dt.isTrackable()) {
        expect(
          () => dt.cast(''),
          throwsA(
            predicate(
              (x) =>
                  x is FormatException &&
                  x.message.startsWith('Unsupported DataType: '),
            ),
          ),
        );
      }
    }
  });
}
