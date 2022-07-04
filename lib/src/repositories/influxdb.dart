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

import 'dart:convert';

import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html;

class InfluxdbRepository {
  static final log = Logger('repository/InfluxdbRepository');

  static Future<Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>> get(
    final Pk<ChartPage> chartPageId,
    final DateTime? from,
    DateTime? to,
  ) async {
    if (from == null && to == null) {
      to = DateTime.now();
    }

    String url = "${AuthenticationRepository.serverUrl}/api/"
        "dashboard/chart-page/time-serial-data?id=$chartPageId";
    if (to != null) {
      final int toSeconds = (to.millisecondsSinceEpoch / 1000).round();
      url += "&to=$toSeconds";
    }
    if (from != null) {
      final int fromSeconds = (from.millisecondsSinceEpoch / 1000).round();
      url += "&from=$fromSeconds";
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != html.HttpStatus.ok) {
      // TODO handle error
      log.severe('could not load data');
      return <Pk<TimeSerial>, List<TimeSeriesEntry<double?>>>{};
    }

    Map<Pk<TimeSerial>, List<TimeSeriesEntry<double?>>> result = {};
    dynamic jsonDecoded = json.decode(response.body);
    if (jsonDecoded is List<dynamic>) {
      return result;
    }
    (jsonDecoded as Map<dynamic, dynamic>).forEach((key, value) {
      final Pk<TimeSerial> id = Pk<TimeSerial>(int.parse(key));

      final List<TimeSeriesEntry<double?>> measurements =
          (value as List<dynamic>).map((i) {
        TimeSeriesEntry<double?> timeSeriesEntry = TimeSeriesEntry.fromDataType(
          DataType.Double, // TODO return data type from server
          DateTime.fromMillisecondsSinceEpoch(i['timestamp'] * 1000),
          i['value'],
        ) as TimeSeriesEntry<double?>;
        return timeSeriesEntry;
      }).toList();
      result[id] = measurements;
    });
    return result;
  }

  static Future<TimeSeriesEntry> last(
    final AuthenticationRepository authenticationRepository,
    final Node node,
  ) async {
    final String url = "${AuthenticationRepository.serverUrl}/api/"
        "server_manager/influx/last?id=${node.id}";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (!authenticationRepository.isGuest())
        'Authorization':
            'Bearer ${await authenticationRepository.getTokenString()}',
    });

    if (response.statusCode != html.HttpStatus.ok) {
      log.severe('Influxdb.last() failed');
      log.severe(response.statusCode);
      log.severe(response.body);
      return TimeSeriesEntry.fromDataType(node.datatype, DateTime.now(), null);
    }
    return TimeSeriesEntry.fromJson(node.datatype, json.decode(response.body));
  }
}
