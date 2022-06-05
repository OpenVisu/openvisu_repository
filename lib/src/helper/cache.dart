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

import 'package:openvisu_repository/openvisu_repository.dart';

abstract class Cache<T extends Model<T>> {
  final Map<Pk<T>, T> _itemCache = {};
  final Map<String, List<T>> _listCache = {};

  cacheClear() {
    itemCacheClear();
    listCacheClear();
  }

  itemCacheClear() {
    _itemCache.removeWhere((key, value) => true);
  }

  listCacheClear() {
    _listCache.removeWhere((key, value) => true);
  }

  bool itemCacheContains(final Pk<T> id) {
    return _itemCache.containsKey(id);
  }

  bool listCacheContains(final String query) {
    return _listCache.containsKey(query);
  }

  T? getItemCache(final Pk<T> id) {
    if (itemCacheContains(id)) {
      return _itemCache[id];
    }
    return null;
  }

  List<T>? getListCache(final String query) {
    if (listCacheContains(query)) {
      return _listCache[query]!;
    }
    return null;
  }

  T setItemCache(final T model) {
    _itemCache[model.id] = model;
    return model;
  }

  List<T> setListCache(final String query, final List<T> models) {
    _listCache[query] = models;
    return models;
  }

  removeItemCache(final Pk<T> id) {
    _itemCache.remove(id);
    for (final String query in _listCache.keys) {
      _listCache[query]!.removeWhere((element) => element.id == id);
    }
  }

  removeListCache(final String query) {
    _listCache.remove(query);
  }
}
