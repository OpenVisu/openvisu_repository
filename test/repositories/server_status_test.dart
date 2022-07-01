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
  group('ServerStatusRepository', () {
    late ServerStatusRepository serverStatusRepository;

    const String server1 = 'http://localhost/';

    setUp(() async {
      serverStatusRepository = ServerStatusRepository();
    });

    test('test credentials.all()', () async {
      final ServerStatus serverStatus1 =
          await serverStatusRepository.get(server1);
      expect(serverStatus1.isConnected, true);
      expect(serverStatus1.isOk, true);
      expect(serverStatus1.isUnknown, false);
      expect(serverStatus1.requiresSetup, false);
    });
  });
}
