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

import 'dart:math';

import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openvisu_repository/src/helper/cache.dart';

class TestCache extends Cache<Dashboard> {}

void main() {
  group('Cache<T extends Model<T>>', () {
    final TestCache testCache = TestCache();
    final Pk<Dashboard> id1 = Pk<Dashboard>(1);
    final Pk<Dashboard> id2 = Pk<Dashboard>(2);
    final Dashboard dashboard1 =
        Dashboard(id1, Pk<User>(0), Pk<User>(0), 0, 0, 'Dashboard 1', 0);
    final Dashboard dashboard2 =
        Dashboard(id2, Pk<User>(0), Pk<User>(0), 0, 0, 'Dashboard 2', 0);

    const String query1 = 'query1';
    const String query2 = 'query2';
    final List<Dashboard> list1 = [dashboard1];
    final List<Dashboard> list2 = [dashboard2];

    setUp(() async {});

    test('test setItemCache()', () async {
      expect(testCache.getItemCache(id1), null);
      testCache.setItemCache(dashboard1);
      expect(testCache.getItemCache(id1), dashboard1);
      expect(testCache.getItemCache(id2), null);
    });

    test('test removeItemCache()', () async {
      expect(testCache.getItemCache(id1), dashboard1);
      testCache.removeItemCache(dashboard1.id);
      expect(testCache.getItemCache(id1), null);
    });

    test('test itemCacheClear()', () async {
      testCache.setItemCache(dashboard1);
      testCache.setItemCache(dashboard2);
      expect(testCache.getItemCache(id1), dashboard1);
      expect(testCache.getItemCache(id2), dashboard2);
      testCache.itemCacheClear();
      expect(testCache.getItemCache(id1), null);
      expect(testCache.getItemCache(id2), null);
    });

    test('test setListCache()', () async {
      expect(testCache.getListCache(query1), null);
      testCache.setListCache(query1, list1);
      expect(testCache.getListCache(query1), list1);
      expect(testCache.getListCache(query2), null);
    });

    test('test removeListCache()', () async {
      expect(testCache.getListCache(query1), list1);
      testCache.removeListCache(query1);
      expect(testCache.getListCache(query1), null);
    });

    test('test listCacheClear()', () async {
      testCache.setListCache(query1, list1);
      testCache.setListCache(query2, list2);
      expect(testCache.getListCache(query1), list1);
      expect(testCache.getListCache(query2), list2);
      testCache.listCacheClear();
      expect(testCache.getListCache(query1), null);
      expect(testCache.getListCache(query2), null);
    });

    test('test cacheClear()', () async {
      testCache.setItemCache(dashboard1);
      testCache.setListCache(query1, list1);
      expect(testCache.getItemCache(id1), dashboard1);
      expect(testCache.getListCache(query1), list1);
      testCache.cacheClear();
      expect(testCache.getItemCache(id1), null);
      expect(testCache.getListCache(query1), null);
    });
  });
}
