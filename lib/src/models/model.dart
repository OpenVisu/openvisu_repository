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

  Map<String, dynamic> toMap();

  int getSort() {
    throw UnimplementedError('This model $this is not sortable.');
  }

  bool get isNew => id.isNew;

  bool get requiresMultipartRequest => false;

  Pk<User> get currentOwner => updatedBy.isNotEmpty ? updatedBy : createdBy;

  List<MultipartFile> getMultipartFiles() => [];

  /// do stuff that needs to be done before this entry is deleted
  Future<void> beforeDelete() async {}

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
