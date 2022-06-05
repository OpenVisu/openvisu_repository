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

import 'dart:async';
import 'dart:convert';

import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart';

class ServerStatusRepository {
  static final log = Logger('repository/ServerStatusRepository');

  static final Map<String, ServerStatus> serverStatusList = {};
  static const Duration cacheTime = Duration(seconds: 55);

  final Duration httpTimeOut;

  ServerStatusRepository(this.httpTimeOut);

  Future<ServerStatus> get(
    final String serverUrl, {
    final forceUpdate = false,
  }) async {
    if (!serverStatusList.keys.contains(serverUrl) || forceUpdate) {
      serverStatusList[serverUrl] = await load(
        serverUrl,
        serverStatusList[serverUrl],
      );
    }
    // if last test is to old, lod data
    else if (!forceUpdate &&
        serverStatusList[serverUrl]!
            .createdAt
            .isBefore(DateTime.now().subtract(cacheTime))) {
      serverStatusList[serverUrl] = await load(
        serverUrl,
        serverStatusList[serverUrl],
      );
    }

    return serverStatusList[serverUrl]!;
  }

  Future<ServerStatus> load(
    final String serverUrl,
    final ServerStatus? serverStatus,
  ) async {
    final Uri pingUri = Uri.parse(
      '$serverUrl/api/status/ping',
    );
    try {
      final http.Response response =
          await http.get(pingUri).timeout(httpTimeOut);
      if (response.statusCode == HttpStatus.ok) {
        return ServerStatus.fromJson(
          json.decode(response.body),
        );
      } else {
        log.warning(response.statusCode);
        if (serverStatus != null) {
          return serverStatus.lostConnection();
        }
        return ServerStatus.unknown();
      }
    } catch (e) {
      log.warning(e);
      if (serverStatus != null) {
        return serverStatus.lostConnection();
      }
      return ServerStatus.unknown();
    }
  }
}
