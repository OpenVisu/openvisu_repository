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

import 'dart:core';
import 'dart:typed_data';

import 'primary_key.dart';
import 'user.dart';
import '../repositories/authentication.dart';
import 'package:http/http.dart';

import 'model.dart';

class Project extends Model<Project> {
  static const collection = 'project';

  final String name;
  final Uint8List? logoFile;
  final String? logoFileName;
  final String imprint;
  final bool hasLogoFile;
  final String? logoFileHash;

  String? get logoUrl => hasLogoFile
      ? '${AuthenticationRepository.serverUrl}/api/project/view-file?id=$id&attribute=logo#$logoFileHash'
      : null;

  const Project(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.logoFile,
    this.imprint,
    this.hasLogoFile,
    this.logoFileHash,
    this.logoFileName,
  );

  @override
  Project.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        imprint = data['imprint'],
        logoFile = null,
        hasLogoFile = data['hasLogoFile'],
        logoFileHash = data['logoFileHash'],
        logoFileName = null,
        super(
          Pk<Project>(data['id'] as int),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          data['created_at'],
          data['updated_at'],
        );

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'imprint': imprint,
      };

  Project copyWith({
    final String? name,
    final String? imprint,
    final Uint8List? logoFile,
    final String? logoFileName,
  }) =>
      Project(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        name ?? this.name,
        logoFile ?? this.logoFile,
        imprint ?? this.imprint,
        hasLogoFile,
        logoFileHash,
        logoFileName ?? this.logoFileName,
      );

  @override
  bool get requiresMultipartRequest => logoFile != null;

  @override
  List<MultipartFile> getMultipartFiles() {
    return [
      if (logoFile != null)
        MultipartFile.fromBytes(
          'Project[logo]',
          logoFile!,
          filename: logoFileName!,
        )
    ];
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      name,
      if (logoFile != null) logoFile!,
      imprint,
      hasLogoFile,
      if (logoFileHash != null) logoFileHash!,
      if (logoFileName != null) logoFileName!,
    ]);
}
