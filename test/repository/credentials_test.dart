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
  group('CredentialsRepository', () {
    late CredentialsRepository credentialsRepository;
    const Credentials credentialsA = Credentials(
      username: 'admin',
      password: 'password',
      endpoint: 'https://demo.openvisu.org',
    );
    const Credentials credentialsB = Credentials(
      username: 'user',
      password: 'password',
      endpoint: 'https://demo.openvisu.org',
    );

    setUp(() async {
      credentialsRepository = CredentialsRepository();
      await credentialsRepository.ready;
    });

    test('test credentials.all()', () async {
      final List<Credentials> credentialList =
          await credentialsRepository.all();
      expect(credentialList, []);
    });

    test('test credentials.add()', () async {
      final List<Credentials> credentialList =
          await credentialsRepository.all();
      expect(credentialList.length, 0);
      await credentialsRepository.add(credentialsA);
      expect(credentialList.length, 1);
    });

    test('test credentials.delete()', () async {
      final List<Credentials> credentialList =
          await credentialsRepository.all();
      expect(credentialList.length, 1);
      await credentialsRepository.delete(credentialsA);
      expect(credentialList.length, 0);
    });

    test('test credentials.add() dedublicate', () async {
      final List<Credentials> credentialList =
          await credentialsRepository.all();
      expect(credentialList.length, 0);
      await credentialsRepository.add(credentialsA);
      await credentialsRepository.add(credentialsA);

      // just cleaning up
      expect(credentialList.length, 1);
      await credentialsRepository.delete(credentialsA);
      expect(credentialList.length, 0);
    });
    test('test credentials.deleteAll()', () async {
      final List<Credentials> credentialList =
          await credentialsRepository.all();
      expect(credentialList.length, 0);
      await credentialsRepository.add(credentialsA);
      await credentialsRepository.add(credentialsB);
      expect(credentialList.length, 2);
      await credentialsRepository.deleteAll();
      expect(credentialList.length, 0);
    });
  });
}
