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

enum PageType {
  none,
  text,
  iframe,
  image,
  chart,
  singleValue,
}

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
    if (!data.containsKey('child')) return const NonePage.createDefault();
    PageType pageType = chartTypeFromString(data['child_type']);
    if (data['child'] == null) {
      return const NonePage.createDefault();
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
        return const NonePage.createDefault();
    }
  }

  @override
  Page.fromJson(Map<String, dynamic> data)
      : name = data['name'],
        sort = data['sort'],
        dashboardId = Pk<Dashboard>(data['dashboard_id']),
        pageType = chartTypeFromString(data['child_type']),
        childId = getChildModelKey(data['child_type'], data['child_id']),
        child = parseChild(data),
        super(
          Pk<Page>(data['id']),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          data['created_at'],
          data['updated_at'],
        );

  Page.createDefault()
      : name = '',
        sort = 0,
        dashboardId = Pk<Dashboard>.newModel(),
        pageType = PageType.none,
        childId = const PageContentPk<NonePage>.empty(),
        child = const NonePage.createDefault(),
        super(
          Pk<Page>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        if (name != null) 'name': name,
        if (sort != null) 'sort': sort,
        if (dashboardId != null) 'dashboard_id': dashboardId,
        'child_type': _stringFromChartType(pageType),
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
        child = const NonePage.createDefault(),
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
    return _stringFromChartType(pageType);
  }

  static PageType chartTypeFromString(final String? s) {
    switch (s) {
      case 'text_page':
        return PageType.text;
      case 'iframe_page':
        return PageType.iframe;
      case 'image_page':
        return PageType.image;
      case 'chart_page':
        return PageType.chart;
      case 'single_value_page':
        return PageType.singleValue;
      default:
        return PageType.none;
    }
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

  static String _stringFromChartType(final PageType chartType) {
    switch (chartType) {
      case PageType.text:
        return 'text_page';
      case PageType.iframe:
        return 'iframe_page';
      case PageType.image:
        return 'image_page';
      case PageType.chart:
        return 'chart_page';
      case PageType.singleValue:
        return 'single_value_page';
      case PageType.none:
        return 'null';
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
