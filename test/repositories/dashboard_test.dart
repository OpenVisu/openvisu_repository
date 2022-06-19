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

    final DashboardRepository dashboardRepository = DashboardRepository(
      authenticationRepository: authenticationRepository,
    );

    const Credentials credentialsAdmin = Credentials(
      username: 'admin',
      password: 'password',
      endpoint: 'http://localhost/',
    );

    final Pk<Dashboard> id1 = Pk<Dashboard>(1);

    setUp(() async {
      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );
    });

    tearDown(() async {
      await authenticationRepository.doLogout();
    });

    test('test dashboardRepository.all().', () async {
      final List<Dashboard> list = await dashboardRepository.all(null);
      expect(list.length, 1);
      expect(list.first.name, 'Dashboard 1');
      expect(list.first.id, id1);
    });

    test('test dashboardRepository.get().', () async {
      final Dashboard dashboard1 = await dashboardRepository.get(id1);
      expect(dashboard1.name, 'Dashboard 1');
      expect(dashboard1.id, id1);
    });

    test('test dashboardRepository.add().', () async {
      final Dashboard newDashboard = Dashboard.createDefault().copyWith(
        name: 'Dashboard 2',
      );
      final Dashboard createdDashboard =
          await dashboardRepository.add(newDashboard);
      expect(createdDashboard.name, 'Dashboard 2');
    });

    test('test dashboardRepository.delete().', () async {
      List<Dashboard> list = await dashboardRepository.all(null);
      expect(list.length, 2);
      expect(list.first.id == id1, true);
      expect(list.last.id != id1, true);
      await dashboardRepository.delete(list.last.id);
      list = await dashboardRepository.all(null);
      expect(list.length, 1);
      expect(list.first.id == id1, true);
    });
  });
}
