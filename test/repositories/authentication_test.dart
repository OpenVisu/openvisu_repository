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

import 'dart:io';

import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationRepository', () {
    late AuthenticationRepository authenticationRepository;
    late CredentialsRepository credentialsRepository;

    const Credentials credentialsAdmin = Credentials(
      username: 'admin',
      password: 'password',
      endpoint: 'http://localhost/',
    );

    const Credentials credentialsWrong = Credentials(
      username: '1234',
      password: '56789',
      endpoint: 'http://localhost/',
    );
    const Credentials credentialsGuest = Credentials(
      username: null,
      password: null,
      endpoint: 'http://localhost/',
    );

    setUp(() {
      credentialsRepository = CredentialsRepository();
      authenticationRepository = AuthenticationRepository(
        credentialsRepository: credentialsRepository,
        httpTimeOut: const Duration(seconds: 10),
      );
    });

    test('test authentication.authenticate().', () async {
      expect(authenticationRepository.hasOpenSession(), false);

      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );

      expect(authenticationRepository.hasOpenSession(), true);
    });

    test('test authentication.doLogout().', () async {
      expect(authenticationRepository.hasOpenSession(), true);

      await authenticationRepository.doLogout();

      expect(authenticationRepository.hasOpenSession(), false);
    });

    test('test authenticate() fail', () async {
      expect(authenticationRepository.hasOpenSession(), false);

      expect(
        () async => await authenticationRepository.authenticate(
          credentials: credentialsWrong,
          saveLogin: false,
        ),
        throwsA(
          isA<HttpException>().having(
              (s) => s.message, 'message', startsWith('Failed to login as ')),
        ),
      );

      expect(authenticationRepository.hasOpenSession(), false);
    });

    test('test authenticate() guest', () async {
      expect(authenticationRepository.hasOpenSession(), false);

      await authenticationRepository.authenticate(
        credentials: credentialsGuest,
        saveLogin: false,
      );

      expect(authenticationRepository.hasOpenSession(), true);
      expect(authenticationRepository.isGuest(), true);
    });

    test('test can()', () async {
      expect(authenticationRepository.hasOpenSession(), true);
      expect(authenticationRepository.isGuest(), true);

      bool can = authenticationRepository.can(
        action: ActionType.view,
        subject: Dashboard.collection,
      );

      expect(can, false);

      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );
      can = authenticationRepository.can(
        action: ActionType.view,
        subject: Dashboard.collection,
      );

      expect(can, true);
    });

    test('test authentication.isAdmin().', () async {
      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );

      expect(authenticationRepository.isAdmin(), true);
    });

    test('test authentication.isAdmin().', () async {
      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );

      expect(
        authenticationRepository.can(
          action: ActionType.create,
          subject: 'test',
        ),
        true,
      );
    });

    test('test authentication.getMe().', () async {
      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );

      final Me me = authenticationRepository.getMe();
      expect(me.email, 'admin@example.com');
    });

    test('test authentication.getRoles().', () async {
      await authenticationRepository.authenticate(
        credentials: credentialsAdmin,
        saveLogin: false,
      );

      final List<String> roles = authenticationRepository.getRoles();
      expect(roles.length, 1);
      expect(roles.first, 'administrator');
    });
  });
}
