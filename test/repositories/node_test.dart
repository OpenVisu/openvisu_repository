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
  group('DashboardRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();

    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final NodeRepository repository = NodeRepository(
      authenticationRepository: authenticationRepository,
    );

    const Credentials credentialsAdmin = Credentials(
      username: 'admin',
      password: 'password',
      endpoint: 'http://localhost/',
    );

    setUp(() async {
      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );
    });

    tearDown(() async {
      await authenticationRepository.doLogout();
    });

    test('test all()', () async {
      final List<Node> list = await repository.all(null);
      expect(list.length, 20);
      expect(list[0].id, Pk<Node>(15));
      expect(list[10].id, Pk<Node>(17));
    });

    test('test paginated()', () async {
      List<Node> list = await repository.paginated(
        pageCount: 0,
        pageSize: 10,
      );
      expect(list.length, 10);
      expect(list[0].id, Pk<Node>(15));

      list = await repository.paginated(
        pageCount: 1,
        pageSize: 10,
      );
      expect(list[0].id, Pk<Node>(17));
    });

    test('test paginated() with filter', () async {
      List<Node> list = await repository.paginated(
          pageCount: 0,
          pageSize: 10,
          filter: [
            const Filter(key: 'tracked', operator: FilterType.EQ, value: '1')
          ]);
      expect(list.length, 4);
    });

    test('test paginated() with display_name filter', () async {
      List<Node> list =
          await repository.paginated(pageCount: 0, pageSize: 10, filter: [
        const Filter(
          key: 'display_name',
          operator: FilterType.LIKE,
          value: 'varint32',
        )
      ]);
      expect(list.length, 1);
    });

    test('test paginated() with identifier filter', () async {
      List<Node> list =
          await repository.paginated(pageCount: 0, pageSize: 10, filter: [
        const Filter(
          key: 'identifier',
          operator: FilterType.LIKE,
          value: 'ns=2;i=17',
        )
      ]);
      expect(list.length, 1);
    });
  });
}
