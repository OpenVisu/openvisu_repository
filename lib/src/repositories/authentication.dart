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
import 'dart:io';

import 'package:logging/logging.dart';

import '../models/token.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:universal_html/html.dart' as html;

class AuthenticationRepository {
  static final log = Logger('repository/AuthenticationRepository');

  /// if it is running in the browser, use the current url as api server
  /// This is replaced at the moment of login
  static String serverUrl = getDefaultServerUrl();

  static String getDefaultServerUrl() {
    return kIsWeb
        ? Uri.parse(html.window.location.href).toString()
        : 'http://localhost/';
  }

  final storage = LocalStorage('authentication_repository');
  late final Future<bool> ready = storage.ready;

  final CredentialsRepository credentialsRepository;
  static Me? me;
  static Token? token;

  final Duration httpTimeOut;

  AuthenticationRepository({
    required this.credentialsRepository,
    this.httpTimeOut = const Duration(seconds: 10),
  });

  Future<void> authenticate({
    required final Credentials credentials,
    required final bool saveLogin,
  }) async {
    serverUrl = credentials.endpoint;

    if (credentials.username != null && credentials.password != null) {
      final response = await http.post(
        Uri.parse('${credentials.endpoint}/api/auth/login'),
        body: {"login": credentials.username, "password": credentials.password},
      ).timeout(httpTimeOut);

      if (response.statusCode != HttpStatus.ok) {
        log.severe('Failed to login: ${response.body}');
        throw HttpException('Failed to login as ${credentials.username} '
            'HttpStatus: ${response.statusCode}.');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      me = Me.fromJson(data);
      token = Token.fromJson(data['token']);
    } else {
      // this is the guest login
      final response = await http
          .get(
            Uri.parse(
              '${AuthenticationRepository.serverUrl}/api/me/view',
            ),
          )
          .timeout(httpTimeOut);
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException('Failed to login as Guest '
            'HttpStatus: ${response.statusCode}.');
      }

      final Map<String, dynamic> data = json.decode(response.body);
      me = Me.fromJson(data);
      token = Token.guest();
    }

    await persistServerUrl(serverUrl);
    await persistToken(token!);
    await persistMe(me!);

    if (saveLogin) {
      credentialsRepository.add(credentials);
    }
  }

  bool hasOpenSession() {
    return token != null;
  }

  Future<void> doLogout() async {
    if (hasOpenSession() && !isGuest()) {
      try {
        final response = await http.post(
          Uri.parse('${AuthenticationRepository.serverUrl}/api/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $tokenString',
          },
        ).timeout(httpTimeOut);
        if (response.statusCode != HttpStatus.ok) {
          log.severe('Failed to logout from server at: $serverUrl. '
              'Status Code: ${response.statusCode}');
        }
      } catch (e) {
        log.severe('Failed to logout from server at: $serverUrl.');
        log.severe('${e.runtimeType.toString()}: ${e.toString()}');
      }
    }

    AuthenticationRepository.serverUrl = getDefaultServerUrl();

    await ready;
    await storage.deleteItem('token');
    await storage.deleteItem('me');

    token = null;
    me = null;
  }

  Future<void> persistMe(final Me me) async {
    await ready;
    storage.setItem('me', me.toJson());
  }

  Future<void> persistToken(final Token token) async {
    await ready;
    await storage.setItem('token', token.toJson());
  }

  Future<void> persistServerUrl(final String? url) async {
    await ready;
    await storage.setItem('serverUrl', url);
  }

  Future<bool> hasToken() async {
    await ready;

    if (token == null) {
      final Map<String, dynamic>? tokenJson = storage.getItem('token');
      if (tokenJson != null) {
        token = Token.fromJson(tokenJson);
        serverUrl = await storage.getItem('serverUrl');
      }
      if (token != null) {
        // TODO make token refresh
        if (token!.isValid()) {
          me = Me.fromJson(await storage.getItem('me'));
          // TODO load me from url iff not set
        }
      } else {
        await doLogout();
      }
    }

    return token != null;
  }

  Future<String?> getTokenString() async {
    if (await hasToken()) {
      return token!.token;
    }
    return null;
  }

  static get tokenString => token?.token;

  Me getMe() {
    return me!;
  }

  List<String> getRoles() {
    return me!.roles;
  }

  List<Permission> _getPermissionsForSubject(final String subject) {
    List<Permission> fp = me!.permissions
        .where((permission) => permission.subject == subject)
        .toList();
    return fp;
  }

  bool isAdmin() {
    for (String role in getRoles()) {
      if (role == 'administrator') return true;
    }
    return false;
  }

  bool isGuest() {
    return token != null && token!.isGuest();
  }

  bool can({
    required final ActionType action,
    required final String subject,
    final Pk<User>? ownerId,
  }) {
    if (isAdmin()) {
      return true;
    }

    final List<Permission> permissions = _getPermissionsForSubject(subject);

    if (permissions.isEmpty) {
      return false;
    }

    for (final Permission permission in permissions) {
      if (permission.can(subject, action, ownerId == (me!.id as Pk<User>))) {
        return true;
      }
    }
    return false;
  }
}
