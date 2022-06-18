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
  group('SingleValuePageRepository', () {
    late CredentialsRepository credentialsRepository;
    late AuthenticationRepository authenticationRepository;
    late SingleValuePageRepository singleValuePageRepository;

    const Credentials credentials = Credentials(
      username: 'admin',
      password: 'password',
      endpoint: 'http://localhost/',
    );

    setUp(() async {
      credentialsRepository = CredentialsRepository();
      authenticationRepository = AuthenticationRepository(
        credentialsRepository: credentialsRepository,
        httpTimeOut: const Duration(seconds: 10),
      );
      singleValuePageRepository = SingleValuePageRepository(
        authenticationRepository: authenticationRepository,
      );
    });

    test('test all() unauthenticated', () async {
      expect(
        () async => await singleValuePageRepository.all(null),
        throwsA(isA<ForbiddenRequest>()),
      );
    });

    test('test all() authenticated', () async {
      await authenticationRepository.authenticate(
        credentials: credentials,
        saveLogin: false,
      );

      List<SingleValuePage> list = await singleValuePageRepository.all(null);
      expect(list.isNotEmpty, true);
    });
  });
}
