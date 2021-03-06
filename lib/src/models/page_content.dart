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

import 'model.dart';
import 'user.dart';
import 'primary_key.dart';

abstract class PageContent<M extends PageContent<M>> extends Model<M> {
  const PageContent(
    PageContentPk<M> id,
    Pk<User> createdBy,
    Pk<User> updatedBy,
    int createdAt,
    int updatedAt,
  ) : super(
          id,
          createdBy,
          updatedBy,
          createdAt,
          updatedAt,
        );

  PageContent.createDefault()
      : super(
          PageContentPk<M>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  PageContent.fromJson(Map<String, dynamic> data)
      : super(
          !data.containsKey('id')
              ? PageContentPk<M>.newModel()
              : PageContentPk<M>.fromJson(data['id']),
          Pk<User>.fromJson(data['created_by']),
          Pk<User>.fromJson(data['updated_by']),
          data['created_at'] ?? 0,
          data['updated_at'] ?? 0,
        );
}
