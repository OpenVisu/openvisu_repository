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

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:crypto/crypto.dart';

void main() {
  group('LibraryEntryRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();
    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final LibraryEntryRepository repository = LibraryEntryRepository(
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
      final List<LibraryEntry> list = await repository.all(null);
      expect(list.length, 0);
    });

    late Pk<LibraryEntry> id;
    test('test create()', () async {
      final File testFile = File('./test/data/files/test.pdf');
      expect(await testFile.length(), 8865);

      LibraryEntry libraryEntry = LibraryEntry.createDefault().copyWith(
        name: 'Test Library Entry',
        binaryFile: testFile.readAsBytesSync(),
        fileName: 'test-file-name.pdf',
      );

      libraryEntry = await repository.add(libraryEntry);

      id = libraryEntry.id;
      expect(libraryEntry.name, 'Test Library Entry');
      expect(libraryEntry.sort, int.tryParse(libraryEntry.id.toString()));
      expect(libraryEntry.hasPdf, true);
      expect(
        libraryEntry.pdfHash,
        sha1.convert(testFile.readAsBytesSync()).toString(),
      );
      expect(
        libraryEntry.documentUrl,
        'http://localhost//api/library_manager/library-entry/view-file?id=${libraryEntry.id.toString()}&attribute=file&hash=af1d0071b69890fafd1ba850cc2a81605f7f8cf3',
      );

      final List<LibraryEntry> list = await repository.all(null);
      expect(list.length, 1);
    });

    test('test patch()', () async {
      final LibraryEntry libraryEntry = await repository
          .update(LibraryEntry.patch(id, name: 'Test Library Entry 2'));
      expect(libraryEntry.name, 'Test Library Entry 2');
      expect(libraryEntry.pdfHash, 'af1d0071b69890fafd1ba850cc2a81605f7f8cf3');
    });

    test('test document url', () async {
      final LibraryEntry libraryEntry = await repository.get(id);
      final response = await get(
        Uri.parse(libraryEntry.documentUrl!),
      );
      expect(response.statusCode, HttpStatus.ok);
      expect(response.contentLength, 8865);

      expect(
        sha1.convert(response.bodyBytes).toString(),
        libraryEntry.pdfHash,
      );
    });

    test('test delete()', () async {
      List<LibraryEntry> list = await repository.all(null);
      expect(list.length, 1);
      await repository.delete(id);
      list = await repository.all(null);
      expect(list.length, 0);
    });
  });
}
