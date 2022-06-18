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
  group('ChartPageRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();
    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final PageRepository pageRepository = PageRepository(
      authenticationRepository: authenticationRepository,
    );
    final ChartPageRepository repository = ChartPageRepository(
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
      final List<ChartPage> list = await repository.all(null);
      expect(list.length, 0);
    });

    late Pk<Page> id;
    late Pk<ChartPage> childId;

    test('test create()', () async {
      Page page = Page.createDefault().copyWith(
        name: 'ChartPage',
        dashboardId: Pk<Dashboard>(1),
        pageType: PageType.chart,
      );
      page = await pageRepository.add(page);
      id = page.id;
      childId = page.childId as Pk<ChartPage>;
      expect(page.pageType, PageType.chart);
      expect(page.childId, isNotNull);

      final List<ChartPage> list = await repository.all(null);
      expect(list.length, 1);

      final ChartPage chartPage = await repository.get(
        page.childId as Pk<ChartPage>,
      );

      expect(chartPage, isNotNull);
      //TOODO y not? expect(page.child as ChartPage, chartPage);
    });

    test('test update()', () async {
      ChartPage chartPage = await repository.get(childId);
      expect(chartPage.chartType, ChartType.line);
      chartPage = await repository.update(chartPage.copyWith(
        chartType: ChartType.area,
      ));
      expect(chartPage.chartType, ChartType.area);
    });

    test('test delete()', () async {
      List<Page> pageList = await pageRepository.all(null);
      List<ChartPage> chartPageList = await repository.all(null);
      expect(pageList.length, 2);
      expect(chartPageList.length, 1);
      await pageRepository.delete(id);
      pageList = await pageRepository.all(null);
      chartPageList = await repository.all(null);
      expect(pageList.length, 1);
      expect(chartPageList.length, 0);
    });
  });
}
