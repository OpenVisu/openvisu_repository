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
  group('IFrameRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();
    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final IFrameRepository repository = IFrameRepository(
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
      final List<IFrame> list = await repository.all(null);
      expect(list.length, 0);
    });

    late Pk<IFrame> id;
    test('test create()', () async {
      IFrame iframe = IFrame.createDefault().copyWith(
        name: 'Test IFrame',
        url: 'http://example.com/',
      );
      iframe = await repository.add(iframe);
      id = iframe.id;
      expect(iframe.name, 'Test IFrame');
      expect(iframe.url, 'http://example.com/');
      final List<IFrame> list = await repository.all(null);
      expect(list.length, 1);
    });

    test('test update()', () async {
      IFrame iframe = await repository.get(id);
      expect(iframe.name, 'Test IFrame');
      iframe = await repository.update(iframe.copyWith(
        name: 'Test IFrame2',
        url: 'https://example.com/',
      ));
      expect(iframe.name, 'Test IFrame2');
      expect(iframe.url, 'https://example.com/');
    });

    test('test delete()', () async {
      List<IFrame> list = await repository.all(null);
      expect(list.length, 1);
      await repository.delete(id);
      list = await repository.all(null);
      expect(list.length, 0);
    });
  });
}
