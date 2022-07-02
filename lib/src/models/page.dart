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

import 'package:openvisu_repository/src/enums/page_type.dart';

import 'chart_page.dart';
import 'dashboard.dart';
import 'iframe_page.dart';
import 'image_page.dart';
import 'none_page.dart';
import 'page_content.dart';
import 'primary_key.dart';
import 'user.dart';
import 'single_value.dart';
import 'text_page.dart';

import 'model.dart';

class Page extends Model<Page> {
  static const collection = 'page';

  final String? name;
  final int? sort;
  final Pk<Dashboard>? dashboardId;
  final PageType pageType;
  final PageContentPk childId;
  final PageContent child;

  const Page(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.name,
    this.sort,
    this.dashboardId,
    this.pageType,
    this.childId,
    this.child,
  );

  static PageContent parseChild(Map<String, dynamic> data) {
    if (!data.containsKey('child')) return NonePage.createDefault();
    PageType pageType = PageType.fromString(data['child_type']);
    if (data['child'] == null) {
      return NonePage.createDefault();
    }
    switch (pageType) {
      case PageType.text:
        return TextPage.fromJson(data['child']);
      case PageType.iframe:
        return IframePage.fromJson(data['child']);
      case PageType.image:
        return ImagePage.fromJson(data['child']);
      case PageType.chart:
        return ChartPage.fromJson(data['child']);
      case PageType.singleValue:
        return SingleValuePage.fromJson(data['child']);
      case PageType.none:
        return NonePage.createDefault();
    }
  }

  @override
  Page.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        sort = data['sort'],
        dashboardId = Pk<Dashboard>(data['dashboard_id']),
        pageType = PageType.fromString(data['child_type']),
        childId = getChildModelKey(data['child_type'], data['child_id']),
        child = parseChild(data),
        super.fromJson(data);

  Page.createDefault()
      : name = '',
        sort = 0,
        dashboardId = const Pk<Dashboard>.newModel(),
        pageType = PageType.none,
        childId = const PageContentPk<NonePage>.empty(),
        child = NonePage.createDefault(),
        super.createDefault();

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        if (name != null) 'name': name,
        if (sort != null) 'sort': sort,
        if (dashboardId != null) 'dashboard_id': dashboardId,
        'child_type': pageType.toString(),
        if (childId.isNotEmpty) 'child_id': childId,
      };

  Page copyWith({
    final String? name,
    final Pk<Dashboard>? dashboardId,
    final PageType? pageType,
    final PageContentPk? childId,
  }) =>
      Page(
        id,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        name ?? this.name,
        sort,
        dashboardId ?? this.dashboardId,
        pageType ?? this.pageType,
        childId ?? this.childId,
        child,
      );

  Page.patch(
    Pk<Page> id, {
    this.name,
    this.dashboardId,
    required this.pageType,
    required this.childId,
    this.sort,
  })  : assert(!id.isNew),
        child = NonePage.createDefault(),
        super(
          id,
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  int getSort() {
    return sort!;
  }

  String get type {
    return pageType.toString();
  }

  static PageContentPk getChildModelKey(final String? s, final int childId) {
    switch (s) {
      case 'text_page':
        return PageContentPk<TextPage>(childId);
      case 'iframe_page':
        return PageContentPk<IframePage>(childId);
      case 'image_page':
        return PageContentPk<ImagePage>(childId);
      case 'chart_page':
        return PageContentPk<ChartPage>(childId);
      case 'single_value_page':
        return PageContentPk<SingleValuePage>(childId);
      default:
        throw UnsupportedError('unknown chart type $s');
    }
  }

  @override
  List<Object> get props => super.props
    ..addAll([
      if (name != null) name!,
      if (sort != null) sort!,
      if (dashboardId != null) dashboardId!,
      pageType,
      childId,
      child,
    ]);
}
