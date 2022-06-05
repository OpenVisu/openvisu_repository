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

class ServerStatus {
  static const _statusOkay = 'ok';
  static const _statusRequiresSetup = 'admin not setup';
  static const _statusUnknown = 'unknown';

  final DateTime createdAt;
  final DateTime? lastConnected;
  final String status;
  final Project project;
  final System system;

  ServerStatus._({
    this.lastConnected,
    required this.status,
    required this.project,
    required this.system,
  }) : createdAt = DateTime.now();

  ServerStatus.fromJson(Map<String, dynamic> data)
      : createdAt = DateTime.now(),
        lastConnected = DateTime.now(),
        status = data['status'],
        project = Project.fromJson(data['project']),
        system = System.fromJson(data['system']);

  ServerStatus.unknown()
      : createdAt = DateTime.now(),
        lastConnected = null,
        status = ServerStatus._statusUnknown,
        project = Project.unknown(),
        system = System.unknown();

  ServerStatus lostConnection() {
    return ServerStatus._(
      lastConnected: lastConnected,
      status: status,
      project: project,
      system: system,
    );
  }

  /// returns true if there was never any connection to that server
  bool get isUnknown => status == ServerStatus._statusUnknown;

  /// returns true if server is known to require setup
  bool get requiresSetup => status == ServerStatus._statusRequiresSetup;

  /// returns true if server is known to be configured correctly
  bool get isOk => status == ServerStatus._statusOkay;

  /// returns true if the last connection to the server was successful
  bool get isConnected =>
      lastConnected != null && !lastConnected!.isBefore(createdAt);
}

class Project {
  final String name;
  final String? image;
  final String imprint;

  Project.fromJson(Map<String, dynamic> data)
      : name = data['name'] ?? '',
        image = data['image'],
        imprint = data['imprint'] ?? '';

  Project.unknown()
      : name = 'Unknown',
        image = null,
        imprint = '';
}

class System {
  final String version;

  System.fromJson(Map<String, dynamic> data) : version = data['version'];

  System.unknown() : version = '-.-.-';
}
