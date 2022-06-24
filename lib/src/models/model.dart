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

import 'package:equatable/equatable.dart';

import 'primary_key.dart';
import 'user.dart';
import 'package:http/http.dart';

abstract class Model<M extends Model<M>> extends Equatable {
  final Pk<M> id;
  final Pk<User> createdBy;
  final Pk<User> updatedBy;
  final int createdAt;
  final int updatedAt;

  const Model(
    this.id,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  );

  Model.createDefault()
      : id = Pk<M>.newModel(),
        createdBy = const Pk<User>.empty(),
        updatedBy = const Pk<User>.empty(),
        createdAt = 0,
        updatedAt = 0;

  Model.fromJson(Map<String, dynamic> data)
      : id = !data.containsKey('id')
            ? Pk<M>.newModel()
            : Pk<M>.fromJson(data['id']),
        createdBy = Pk<User>.fromJson(data['created_by']),
        updatedBy = Pk<User>.fromJson(data['updated_by']),
        createdAt = data['created_at'] ?? 0,
        updatedAt = data['updated_at'] ?? 0;

  Map<String, dynamic> toMap();

  int getSort() {
    throw UnimplementedError('This model $this is not sortable.');
  }

  bool get isNew => id.isNew;

  bool get requiresMultipartRequest => false;

  Pk<User> get currentOwner => updatedBy.isNotEmpty ? updatedBy : createdBy;

  List<MultipartFile> getMultipartFiles() => [];

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
      ];
}
