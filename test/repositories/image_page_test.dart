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

import 'package:crypto/crypto.dart';
import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImagePageRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();
    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final PageRepository pageRepository = PageRepository(
      authenticationRepository: authenticationRepository,
    );

    final ImagePageRepository repository = ImagePageRepository(
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
      final List<ImagePage> list = await repository.all(null);
      expect(list.isEmpty, true);
    });

    late Pk<Page> id;
    late Pk<ImagePage> childId;
    test('test create()', () async {
      final length = (await repository.all(null)).length;
      Page page = Page.createDefault().copyWith(
        name: 'ImagePage',
        dashboardId: Pk<Dashboard>(1),
        pageType: PageType.image,
      );
      page = await pageRepository.add(page);
      id = page.id;
      childId = page.childId as Pk<ImagePage>;
      expect(page.pageType, PageType.image);
      expect(page.childId, isNotNull);

      final newLength = (await repository.all(null)).length;
      expect(newLength, length + 1);

      final ImagePage imagePage = await repository.get(
        page.childId as Pk<ImagePage>,
      );

      expect(imagePage, isNotNull);
      //TOODO y not? expect(page.child as ChartPage, chartPage);
    });

    test('test update()', () async {
      final File testFile = File('./test/data/files/openvisu_logo.png');
      expect(await testFile.length(), 13659);

      ImagePage imagePage = await repository.get(childId);
      expect(imagePage.hasImage, false);
      expect(imagePage.imageHash, null);
      expect(imagePage.isNew, false);

      imagePage = imagePage.copyWith(
        binaryImage: testFile.readAsBytesSync(),
        imageFileName: 'test-image-file-name.png',
      );
      imagePage = await repository.update(imagePage);

      expect(imagePage.hasImage, true);
      expect(
        imagePage.imageHash,
        sha1.convert(testFile.readAsBytesSync()).toString(),
      );
      expect(imagePage.imageFileName, null);
      expect(
        imagePage.imageUrl,
        'http://localhost//api/dashboard/image-page/view-file?id=${imagePage.id}&attribute=image&hash=9b013271bbecafb442053578ded3cdbadd3c0a83',
      );
    });

    test('test delete()', () async {
      final pageListLength = (await pageRepository.all(null)).length;
      final imagePageListLength = (await repository.all(null)).length;
      await pageRepository.delete(id);
      final newPageListLength = (await pageRepository.all(null)).length;
      final newImagePageListLength = (await repository.all(null)).length;
      expect(newPageListLength, pageListLength - 1);
      expect(newImagePageListLength, imagePageListLength - 1);
    });
  });
}
