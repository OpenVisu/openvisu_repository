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
  group('PageRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();
    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final PageRepository repository = PageRepository(
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
      final List<Page> list = await repository.all(null);
      expect(list.isNotEmpty, true);
    });

    late Pk<Page> id;
    test('test create()', () async {
      final int length = (await repository.all(null)).length;
      Page page = Page.createDefault().copyWith(
        name: 'Test Page',
        dashboardId: Pk<Dashboard>(1),
        pageType: PageType.chart,
      );
      page = await repository.add(page);
      id = page.id;
      expect(page.name, 'Test Page');
      expect(page.dashboardId, Pk<Dashboard>(1));
      expect(page.pageType, PageType.chart);
      final int newLength = (await repository.all(null)).length;
      expect(newLength, length + 1);
    });

    test('test swap()', () async {
      List<Page> list = await repository.all(null);
      expect(list[0].name, 'Page 1');
      expect(list[1].name, 'Page 2');

      await repository.swap(list[0], list[1]);

      list = await repository.all(null);
      expect(list[0].name, 'Page 2');
      expect(list[1].name, 'Page 1');
    });

    test('test update()', () async {
      Page page = await repository.get(id);
      expect(page.name, 'Test Page');
      page = await repository.update(page.copyWith(
        name: 'Test Page Updated',
      ));
      expect(page.name, 'Test Page Updated');
    });

    test('test delete()', () async {
      final int length = (await repository.all(null)).length;
      await repository.delete(id);
      final int newLength = (await repository.all(null)).length;
      expect(newLength, length - 1);
    });
  });
}
