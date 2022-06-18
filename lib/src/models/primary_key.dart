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
import 'page_content.dart';

class Pk<M extends Model<M>> {
  final dynamic id;

  Pk(this.id) {
    if (id == null) {
      return;
    }
    if (id is int) {
      return;
    }
    if (id is String) {
      return;
    }
    throw UnimplementedError('Invalid id type ${id.runtimeType}');
  }

  const Pk.newModel() : id = 0;

  const Pk.empty() : id = null;

  factory Pk.fromJson(dynamic value) {
    if (value == null) {
      return Pk<M>.empty();
    }
    if (value == 0) {
      return Pk<M>.newModel();
    }
    if (int.tryParse('$value') != null) {
      return Pk<M>(int.tryParse('$value'));
    }
    return Pk<M>(value);
  }

  bool get isEmpty => id == null;

  bool get isNotEmpty => id != null;

  bool get isNew => id is int && id == 0;

  @override
  int get hashCode {
    if (id == null) {
      return null.hashCode;
    }
    if (id is int) {
      return (id as int).hashCode;
    }
    if (id is String) {
      return (id as String).hashCode;
    }
    throw UnimplementedError('Unknown ModelKey type ${id.runtimeType}');
  }

  @override
  bool operator ==(other) {
    if (other is! Pk<M>) {
      return false;
    }
    return id == other.id;
  }

  toJson() {
    if (id is int) {
      return (id as int);
    }
    return id;
  }

  @override
  String toString() {
    return id.toString();
  }

  Pk<R> cast<R extends Model<R>>() {
    return Pk<R>(id);
  }
}

class PageContentPk<M extends PageContent<M>> extends Pk<M> {
  PageContentPk(id) : super(id);

  PageContentPk.newModel() : super.newModel();
  const PageContentPk.empty() : super.empty();
}
