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

import 'page_content.dart';
import 'primary_key.dart';
import 'user.dart';

class TextPage extends PageContent<TextPage> {
  static const collection = 'text-page';

  final String content;

  const TextPage(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.content,
  );

  TextPage.createDefault()
      : content = '',
        super.createDefault();

  TextPage.fromJson(Map<String, dynamic> data)
      : content = data['content'],
        super.fromJson(data);

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'content': content,
      };

  TextPage copyWith({
    final String? content,
  }) =>
      TextPage(
        id as PageContentPk<TextPage>,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        content ?? this.content,
      );

  @override
  List<Object> get props => super.props
    ..addAll([
      content,
    ]);
}
