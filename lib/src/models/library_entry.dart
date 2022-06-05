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

class LibraryEntry extends Model<LibraryEntry> {
  static const collection = 'library-entry';

  final Uint8List binaryFile;
  final String? fileName;
  final String? name;
  final int? sort;
  final bool hasPdf;
  final String? pdfHash;

  String? get documentUrl => hasPdf
      ? '${AuthenticationRepository.serverUrl}/api/library_manager/library-entry/view-file?id=$id&attribute=file&time=$pdfHash'
      : null;

  const LibraryEntry(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.sort,
    this.binaryFile,
    this.fileName,
    this.hasPdf,
    this.pdfHash,
  );

  LibraryEntry.createDefault()
      : name = '',
        sort = 0,
        binaryFile = Uint8List(0),
        fileName = '',
        hasPdf = false,
        pdfHash = null,
        super(
          Pk<LibraryEntry>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  LibraryEntry.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        sort = data['sort'] is int ? data['sort'] : int.parse(data['sort']),
        // required to parse response after upload TODO fix in backend
        binaryFile = Uint8List(0),
        fileName = '',
        hasPdf = data['hasPdf'],
        pdfHash = data['pdfHash'],
        super(
          Pk<LibraryEntry>(data['id'] as int),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          0,
          0,
        );

  @override
  Map<String, dynamic> toMap() => {
        if (name != null) 'name': name,
        if (sort != null) 'sort': sort,
      };

  LibraryEntry.patch(
    final Pk<LibraryEntry> id, {
    this.name,
    this.sort,
    final Uint8List? binaryFile,
    this.fileName,
  })  : assert(!id.isNew),
        hasPdf = false,
        pdfHash = null,
        binaryFile = binaryFile ?? Uint8List(0),
        super(
          id,
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  LibraryEntry copyWith({
    final int? documentId,
    final Uint8List? document,
    final String? name,
    final int? sort,
    final Uint8List? binaryFile,
    final String? fileName,
  }) =>
      LibraryEntry(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        name ?? this.name,
        sort ?? this.sort,
        binaryFile ?? this.binaryFile,
        fileName ?? this.fileName,
        hasPdf,
        pdfHash,
      );

  @override
  int getSort() {
    return sort!;
  }

  @override
  bool get requiresMultipartRequest => binaryFile.isNotEmpty;

  @override
  List<MultipartFile> getMultipartFiles() {
    return [
      if (binaryFile.isNotEmpty)
        MultipartFile.fromBytes(
          'LibraryEntry[file]',
          binaryFile,
          filename: '$fileName',
        )
    ];
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      if (name != null) name!,
      if (sort != null) sort!,
      binaryFile,
      if (fileName != null) fileName!,
      hasPdf,
      if (pdfHash != null) pdfHash!,
    ]);
}
