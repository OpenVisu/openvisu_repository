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

import 'package:localstorage/localstorage.dart';
import 'package:openvisu_repository/openvisu_repository.dart';

class CredentialsRepository {
  final Credentials demoAdminCredentials = const Credentials(
    username: 'admin',
    password: 'password',
    endpoint: 'https://demo.openvisu.org',
  );

  final bool demoMode;

  CredentialsRepository({this.demoMode = false}) {
    ready = storage.ready;
    _load();
  }

  Future<bool>? ready;
  List<Credentials>? _credentialsList;

  final storage = LocalStorage('credentials_repository');

  _load() async {
    _credentialsList = await all();
  }

  Future<List<Credentials>> all() async {
    await ready;
    if (_credentialsList == null) {
      List<dynamic>? t = await storage.getItem('credentials');
      if (t != null) {
        _credentialsList = t.map((e) => Credentials.fromJson(e)).toList();
      } else {
        _credentialsList = [if (demoMode) demoAdminCredentials];
      }
    }
    return _credentialsList!;
  }

  Future add(Credentials credentials) async {
    _credentialsList = await all();
    if (_credentialsList!.contains(credentials)) {
      return;
    }
    _credentialsList!.add(credentials);
    await storage.setItem(
      'credentials',
      _credentialsList!.map((e) => e.toJson()).toList(),
    );
  }

  Future delete(Credentials credentials) async {
    _credentialsList = await all();
    _credentialsList!.remove(credentials);
    await storage.setItem(
      'credentials',
      _credentialsList!.map((e) => e.toJson()).toList(),
    );
  }

  Future deleteAll() async {
    _credentialsList = await all();
    _credentialsList!.removeWhere((_) => true);
    await storage.setItem(
      'credentials',
      _credentialsList!.map((e) => e.toJson()).toList(),
    );
  }
}
