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

class TestModel extends Model<TestModel> {
  const TestModel(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      if (!isNew) 'id': id.toJson(),
    };
  }

  @override
  TestModel.fromJson(Map<String, dynamic> data)
      : super(
          !data.containsKey('id')
              ? const Pk<TestModel>.newModel()
              : Pk<TestModel>.fromJson(data['id']),
          Pk<User>.fromJson(data['created_by']),
          Pk<User>.fromJson(data['updated_by']),
          data['created_at'] ?? 0,
          data['updated_at'] ?? 0,
        );
}

void main() {
  test('Model recreate test', () {
    const TestModel m1 = TestModel(
      Pk<TestModel>.newModel(),
      Pk<User>.empty(),
      Pk<User>.empty(),
      0,
      0,
    );

    final TestModel m2 = TestModel.fromJson(m1.toMap());

    expect(m1, m2);

    TestModel m3 = TestModel(
      Pk<TestModel>(1),
      const Pk<User>.empty(),
      const Pk<User>.empty(),
      0,
      0,
    );

    final TestModel m4 = TestModel.fromJson(m3.toMap());

    expect(m3, m4);
  });
}
