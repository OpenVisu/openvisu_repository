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
  group('TimeSerialRepository', () {
    final CredentialsRepository credentialsRepository = CredentialsRepository();
    final AuthenticationRepository authenticationRepository =
        AuthenticationRepository(
      credentialsRepository: credentialsRepository,
      httpTimeOut: const Duration(seconds: 10),
    );

    final TimeSerialRepository repository = TimeSerialRepository(
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
      final List<TimeSerial> list = await repository.all(null);
      expect(list.isNotEmpty, true);
    });

    late Pk<TimeSerial> id;

    test('test create()', () async {
      final length = (await repository.all(null)).length;
      TimeSerial timeSerial = TimeSerial.createDefault().copyWith(
        chartPageId: Pk<ChartPage>(1),
        serverId: Pk<Server>(1),
        nodeId: Pk<Node>(13),
        name: 'TimeSerial',
      );
      timeSerial = await repository.add(timeSerial);
      id = timeSerial.id;
      expect(timeSerial.name, 'TimeSerial');
      expect(timeSerial.unit, '');

      final newLength = (await repository.all(null)).length;
      expect(newLength, length + 1);
    });

    test('test update()', () async {
      TimeSerial timeSerial = await repository.get(id);
      expect(timeSerial.aggregationFunction, AggregationFunctionType.mean);
      timeSerial = await repository.update(timeSerial.copyWith(
        aggregationFunction: AggregationFunctionType.max,
      ));
      expect(timeSerial.aggregationFunction, AggregationFunctionType.max);
    });

    test('test delete()', () async {
      final length = (await repository.all(null)).length;
      await repository.delete(id);
      final newLength = (await repository.all(null)).length;
      expect(newLength, length - 1);
    });
  });
}
