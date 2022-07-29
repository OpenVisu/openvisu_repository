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

import 'primary_key.dart';
import 'page_content.dart';

class IframePage extends PageContent<IframePage> {
  static const collection = 'iframe-page';

  final String src;

  const IframePage(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.src,
  );

  IframePage.fromJson(Map<String, dynamic> data)
      : src = data['src'] ?? '',
        super.fromJson(data);

  IframePage.createDefault()
      : src = '',
        super.createDefault();

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'src': src,
      };

  IframePage copyWith({
    final String? src,
  }) =>
      IframePage(
        id as PageContentPk<IframePage>,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        src ?? this.src,
      );

  @override
  List<Object> get props => super.props
    ..addAll([
      src,
    ]);
}
