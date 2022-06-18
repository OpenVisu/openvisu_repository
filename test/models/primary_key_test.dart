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
  test('ModelKey identity check', () {
    final nullKey1 = Pk<Dashboard>(null);
    const nullKey2 = Pk<Dashboard>.empty();
    expect(nullKey1 == nullKey2, true);

    final stringKey0 = Pk<Dashboard>('0');
    final intKey0 = Pk<Dashboard>(0);
    expect(stringKey0 != intKey0, true);
    expect(stringKey0 != nullKey2, true);

    final stringKey1 = Pk<Dashboard>('1');
    final intKey1 = Pk<Dashboard>(1);
    expect(stringKey1 != intKey1, true);

    expect(
      Pk<Dashboard>.fromJson('1'),
      Pk<Dashboard>(1),
    );
    expect(
      Pk<Dashboard>.fromJson('test'),
      Pk<Dashboard>('test'),
    );

    expect(
      Pk<Dashboard>.fromJson(null),
      const Pk<Dashboard>.empty(),
    );

    expect(
      Pk<Dashboard>.fromJson(0),
      const Pk<Dashboard>.newModel(),
    );

    expect(Pk<Dashboard>.fromJson(null) is Pk<Dashboard>, true);
    expect(Pk<Dashboard>.fromJson(null) is Pk<Page>, false);
    expect(Pk<Page>.fromJson(null) is Pk<Dashboard>, false);
    expect(Pk<Page>.fromJson(null) is Pk<Page>, true);
    expect(Pk<Dashboard>.fromJson(null) != Pk<Page>.fromJson(null), true);
  });
}
