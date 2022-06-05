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
  test('Dashboard identity check', () {
    final page0 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 4, 5, '6', 1);
    final page1 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 4, 5, '6', 1);

    expect(page0 == page0, true);
    expect(page0 == page1, true);
    expect(page1 == page1, true);

    //final page2 = Dashboard(2, 2, 3, 4, 5, '6', null);
    final page3 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(3), Pk<User>(3), 4, 5, '6', 1);
    final page4 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(4), 4, 5, '6', 1);
    final page5 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 5, 5, '6', 1);
    final page6 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 4, 6, '6', 1);
    final page7 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 4, 5, '7', 1);
    final page8 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 4, 5, '6', 1);

    expect(page0 == page3, false);
    expect(page0 == page4, false);
    expect(page0 == page5, false);
    expect(page0 == page6, false);
    expect(page0 == page7, false);
    expect(page0 == page8, true);

    final page9 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 4, 5, '6', 5);
    final page10 =
        Dashboard(Pk<Dashboard>(1), Pk<User>(2), Pk<User>(3), 4, 5, '6', 5);
    expect(page9 == page10, true);
  });
}
