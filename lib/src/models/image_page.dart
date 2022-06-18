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

import 'package:openvisu_repository/openvisu_repository.dart';

import 'page_content.dart';
import 'package:http/http.dart';

class ImagePage extends PageContent<ImagePage> {
  static const collection = 'image-page';

  final bool hasImage;
  final String? imageHash;
  final Uint8List? binaryImage;
  final String? imageFileName;

  String? get imageUrl => hasImage
      ? '${AuthenticationRepository.serverUrl}/api/dashboard/image-page/view-file?id=$id&attribute=image&hash=$imageHash'
      : null;

  const ImagePage(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.hasImage,
    this.binaryImage,
    this.imageHash,
    this.imageFileName,
  );

  @override
  ImagePage.fromJson(Map<String, dynamic> data)
      : hasImage = data['hasImage'],
        imageHash = data['imageHash'],
        binaryImage = null,
        imageFileName = null,
        super.fromJson(data);

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'hasImage': hasImage,
        'imageHash': imageHash,
      };

  /// Used to update values without having the complete model
  ImagePage.patch(
    final PageContentPk<ImagePage> id, {
    final int? imageId,
    this.binaryImage,
  })  : assert(!id.isNew),
        hasImage = false,
        imageHash = null,
        imageFileName = null,
        super(
          id,
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  ImagePage copyWith({
    final int? imageId,
    final String? imageUrl,
    final Uint8List? binaryImage,
    final String? imageFileName,
  }) =>
      ImagePage(
        id as PageContentPk<ImagePage>,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        hasImage,
        binaryImage ?? this.binaryImage,
        imageHash,
        imageFileName ?? this.imageFileName,
      );

  @override
  bool get requiresMultipartRequest => binaryImage != null;

  @override
  List<MultipartFile> getMultipartFiles() {
    return [
      if (binaryImage != null)
        MultipartFile.fromBytes(
          'ImagePage[image]',
          binaryImage!,
          filename: imageFileName!,
        )
    ];
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      hasImage,
      if (binaryImage != null) binaryImage!,
      if (imageHash != null) imageHash!,
      if (imageFileName != null) imageFileName!,
    ]);
}
