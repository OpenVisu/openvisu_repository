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

import '../enums/chart_type.dart';
import 'page_content.dart';
import 'primary_key.dart';
import 'time_serial.dart';
import 'user.dart';

class ChartPage extends PageContent<ChartPage> {
  static const collection = 'chart-page';

  final ChartType chartType;
  final Duration interval;
  final List<TimeSerial> timeSerials;

  const ChartPage(
    super.id,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
    this.chartType,
    this.interval,
    this.timeSerials,
  );

  @override
  ChartPage.fromJson(Map<String, dynamic> data)
      : chartType = ChartType.fromString(data['chart_type']),
        interval = Duration(seconds: data['interval']),
        timeSerials =
            data.containsKey('timeSerials') && data['timeSerials'] != null
                ? (data['timeSerials'] as List)
                    .map((e) => TimeSerial.fromJson(e))
                    .toList()
                : [],
        super(
          PageContentPk<ChartPage>(data['id'] as int),
          Pk<User>(data['created_by'] as int),
          Pk<User>(data['updated_by'] as int),
          data['created_at'],
          data['updated_at'],
        );

  @override
  ChartPage.createDefault()
      : chartType = ChartType.line,
        interval = const Duration(hours: 1),
        timeSerials = const [],
        super(
          PageContentPk<ChartPage>.newModel(),
          const Pk<User>.empty(),
          const Pk<User>.empty(),
          0,
          0,
        );

  @override
  Map<String, dynamic> toMap() => {
        if (!isNew) 'id': id,
        'chart_type': chartType.toString(),
        'interval': interval.inSeconds,
      };

  ChartPage copyWith({
    final ChartType? chartType,
    final Duration? interval,
    final List<TimeSerial>? timeSerials,
  }) =>
      ChartPage(
        id as PageContentPk<ChartPage>,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
        chartType ?? this.chartType,
        interval ?? this.interval,
        timeSerials ?? this.timeSerials,
      );

  @override
  Future<void> beforeDelete() async {
    // TODO empty timeSerial caches
  }

  bool isLive() => chartType.isLive();

  @override
  List<Object> get props => [
        chartType,
        interval,
        timeSerials,
      ];
}
