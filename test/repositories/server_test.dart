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
  group('ServerRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();
    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final ServerRepository serverRepository = ServerRepository(
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
      final List<Server> list = await serverRepository.all(null);
      expect(list.isNotEmpty, true);
    });

    late Pk<Server> id;
    test('test create()', () async {
      final length = (await serverRepository.all(null)).length;
      Server server = Server.createDefault().copyWith(
        name: 'test server',
        description: 'test description',
        url: 'opc.tcp://opcua-fake:4842/',
        rootNode: 'ns=2;i=1',
      );
      server = await serverRepository.add(server);
      id = server.id;
      expect(server.name, 'test server');
      expect(server.description, 'test description');
      final newLength = (await serverRepository.all(null)).length;
      expect(newLength, length + 1);
    });

    test('test update()', () async {
      Server server = await serverRepository.get(id);
      expect(server.name, 'test server');
      server = await serverRepository.update(server.copyWith(name: 'new name'));
      expect(server.name, 'new name');
      expect(server.description, 'test description');
    });

    test('test delete()', () async {
      final length = (await serverRepository.all(null)).length;
      await serverRepository.delete(id);
      final newLength = (await serverRepository.all(null)).length;
      expect(newLength, length - 1);
    });
  });
}
