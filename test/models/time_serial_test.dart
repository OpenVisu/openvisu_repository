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
  test('TimeSerial identity check', () {
    final ts1 = TimeSerial(
      Pk<TimeSerial>(1),
      Pk<User>(2),
      Pk<User>(3),
      4,
      5,
      Pk<ChartPage>(6),
      Pk<Server>(7),
      Pk<Node>(8),
      '9',
      '10',
      11,
      12,
      AggregationFunctionType.mean,
      '14',
      15,
      16,
      false,
      const [],
    );

    final ts2 = TimeSerial(
      Pk<TimeSerial>(1),
      Pk<User>(2),
      Pk<User>(3),
      4,
      5,
      Pk<ChartPage>(6),
      Pk<Server>(7),
      Pk<Node>(8),
      '9',
      '10',
      11,
      12,
      AggregationFunctionType.mean,
      '14',
      15,
      16,
      false,
      const [],
    );

    final ts3 = TimeSerial(
      Pk<TimeSerial>(1),
      Pk<User>(2),
      Pk<User>(3),
      4,
      5,
      Pk<ChartPage>(6),
      Pk<Server>(7),
      Pk<Node>(8),
      '9',
      'different value',
      11,
      12,
      AggregationFunctionType.mean,
      '14',
      15,
      16,
      false,
      const [],
    );

    expect(ts1, ts2);
    expect(ts2 != ts3, true);
    expect(ts1 != ts3, true);
    expect(ts3, ts3);
  });

  test('TimeSerial recreate test', () {
    final TimeSerial ts1 = TimeSerial.createDefault().copyWith(
      chartPageId: Pk<ChartPage>(1),
      serverId: Pk<Server>(1),
      nodeId: Pk<Node>(13),
      name: 'TimeSerial',
    );

    expect(ts1.id, const Pk<TimeSerial>.newModel());

    final TimeSerial ts2 = TimeSerial.fromJson(ts1.toMap());

    expect(ts2, ts1);
  });
}
