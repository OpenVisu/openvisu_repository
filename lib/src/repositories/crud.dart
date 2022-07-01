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
import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:openvisu_repository/src/helper/cache.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:openvisu_repository/openvisu_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logging/logging.dart';

import 'base.dart';

abstract class CrudRepository<T extends Model<T>> extends BaseRepository
    with Cache<T> {
  static final log = Logger('repository/CrudRepository');

  CrudRepository({required super.authenticationRepository});

  Future<T> get(Pk<T> id) async {
    try {
      final http.Response response = await httpGet(viewUrl(id));
      return setItemCache(
          create(json.decode(utf8.decode(response.bodyBytes))) as T);
    } catch (e) {
      removeItemCache(id);
      rethrow;
    }
  }

  Future<List<T>> all(List<Filter>? filterList) async {
    String url = indexUrl().toString();
    if (filterList != null) {
      if (!url.contains('?')) {
        url = '$url?';
      } else if (!url.endsWith('&')) {
        url += '&';
      }
      url += filterList.map((e) => e.toUrl()).join('&');
    }
    try {
      final response = await httpGet(Uri.parse(url));
      final List<T> models =
          ((json.decode(utf8.decode(response.bodyBytes))) as List)
              .map((i) => (create(i)) as T)
              .toList();
      return setListCache(filterList.toString(), models);
    } catch (e) {
      removeListCache(filterList.toString());
      rethrow;
    }
  }

  // TODO test pagination
  Future<List<T>> paginated({
    List<Filter> filter = const [],
    pageCount = 0,
    pageSize = -1,
  }) async {
    String url = indexUrl().toString();
    if (!url.contains('?')) {
      url = '$url?';
    }
    url = addFilterToUrl(url, filter: filter);
    url = addPaginationToUrl(url, pageCount: pageCount, pageSize: pageSize);
    final Response response = await httpGet(Uri.parse(url));
    return (json.decode(utf8.decode(response.bodyBytes)) as List)
        .map((json) => (create(json)) as T)
        .toList();
  }

  String addFilterToUrl(String url, {List<Filter> filter = const []}) {
    for (var element in filter) {
      url += '&filter[${element.key}]=${element.value}';
    }
    return url;
  }

  String addPaginationToUrl(
    String url, {
    int pageCount = 0,
    int pageSize = -1,
  }) {
    url += '&pageCount=$pageCount';
    url += '&pageSize=$pageSize';
    return url;
  }

  Future<Map<String, String>> headers() async {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (!authenticationRepository.isGuest())
        'Authorization':
            'Bearer ${await authenticationRepository.getTokenString()}',
    };
  }

  Future<T> add(final T model) async {
    late final String jsonResult;
    if (model.requiresMultipartRequest) {
      final http.MultipartRequest request = http.MultipartRequest(
        'POST',
        createUrl(),
      );
      request.headers['Authorization'] =
          'Bearer ${await authenticationRepository.getTokenString()}';

      for (http.MultipartFile multipartFile in model.getMultipartFiles()) {
        request.files.add(multipartFile);
      }
      final Map<String, dynamic> tmpMap = model.toMap();
      for (final String key in tmpMap.keys) {
        request.fields[key] = '${tmpMap[key]}';
      }

      final http.StreamedResponse response =
          await _catchStreamedResponseErrors(await request.send());
      jsonResult = utf8.decode(await response.stream.toBytes());
    } // TODO merge with next else block
    else {
      final Response response = await httpPost(
        createUrl(),
        model.toMap(), // TODO update all bodies to this pattern
      );
      jsonResult = utf8.decode(response.bodyBytes);
    }
    return setItemCache(create(json.decode(jsonResult)) as T);
  }

  Future<T> update(final T model) async {
    late final String jsonResult;
    if (model.requiresMultipartRequest) {
      final http.MultipartRequest request = http.MultipartRequest(
        'POST',
        updateUrl(model.id),
      );
      request.headers['Authorization'] =
          'Bearer ${await authenticationRepository.getTokenString()}'; // TODO load regular headers?

      for (http.MultipartFile multipartFile in model.getMultipartFiles()) {
        request.files.add(multipartFile);
      }
      final Map<String, dynamic> tmpMap = model.toMap();
      for (final String key in tmpMap.keys) {
        request.fields[key] = '${tmpMap[key]}';
      }

      http.StreamedResponse response =
          await _catchStreamedResponseErrors(await request.send());
      jsonResult = utf8.decode(await response.stream.toBytes());
    } // TODO merge with next else block
    else {
      final http.Response response = await httpPatch(
        updateUrl(model.id),
        model.toMap(),
      );
      jsonResult = utf8.decode(response.bodyBytes);
    }
    return setItemCache(create(json.decode(jsonResult)) as T);
  }

  Future<void> delete(final Pk<T> id) async {
    await httpDelete(deleteUrl(id));
    removeItemCache(id);
  }

  Future<bool> swap(final T x, final T y) async {
    log.info('Swapping $T (${x.id}, ${y.id})');
    final Response response = await httpPost(
      swapUrl(),
      {'id1': '${x.id}', 'id2': '${y.id}'},
    );
    return response.statusCode == HttpStatus.ok;
  }

  Future<bool> sort(final List<Pk<T>> sortedPks) async {
    final Response response = await httpPost(sortUrl(), {'order': sortedPks});
    return response.statusCode == HttpStatus.ok;
  }

  // if a model was loaded via another repository, it can be injected into the
  // cache of another using tis method
  void cache(final T model) {
    setItemCache(model);
  }

  /// http helper methods
  Future<http.Response> httpGet(final Uri uri) async {
    Response response = await SentryHttpClient().get(
      uri,
      headers: await headers(),
    );
    return await _catchResponseErrors(response);
  }

  Future<http.Response> httpPost(final Uri uri, jsonData) async {
    Response response = await SentryHttpClient().post(
      uri,
      body: json.encode(jsonData),
      headers: await headers(),
    );
    return await _catchResponseErrors(response);
  }

  Future<http.Response> httpPatch(final Uri uri, jsonData) async {
    Response response = await SentryHttpClient().patch(
      uri,
      body: json.encode(jsonData),
      headers: await headers(),
      encoding: Encoding.getByName("utf-8"),
    );
    return await _catchResponseErrors(response);
  }

  Future<http.Response> httpDelete(final Uri uri) async {
    Response response = await SentryHttpClient().delete(
      uri,
      headers: await headers(),
    );
    return await _catchResponseErrors(response);
  }

  Future<http.StreamedResponse> _catchStreamedResponseErrors(
      final StreamedResponse streamedResponse) async {
    await _handleError(
        streamedResponse.statusCode, streamedResponse.request!.url.toString(),
        stream: streamedResponse.stream);
    return streamedResponse;
  }

  /// only return good responses, all others end in throws
  Future<http.Response> _catchResponseErrors(final Response response) async {
    await _handleError(response.statusCode, response.request!.url.toString(),
        body: response.bodyBytes);
    return response;
  }

  Future<bool> _handleError(
    final int statusCode,
    final String url, {
    final Uint8List? body,
    final ByteStream? stream,
  }) async {
    assert(stream != null || body != null);

    switch (statusCode) {
      // TODO role returns 200 others 201, y?
      case HttpStatus.created:
      case HttpStatus.ok:
      case HttpStatus.noContent:
        return true;
    }

    late final String content;
    if (stream != null) {
      content = utf8.decode(await stream.toBytes());
    }
    if (body != null) {
      content = utf8.decode(body);
    }

    switch (statusCode) {
      case HttpStatus.unauthorized:
        throw UnauthorizedRequest();
      case HttpStatus.forbidden:
        throw ForbiddenRequest(url);
      case HttpStatus.notFound:
        log.severe(url);
        log.severe('HttpStatus.notFound: $content');
        throw BackendError(
          YiiExceptionInformation.fromJson(json.decode(content)),
        );
      case HttpStatus.unprocessableEntity:
        throw BackendError(
          YiiUnprocessableEntityInformation.fromJson(json.decode(content)),
        );
      case HttpStatus.requestEntityTooLarge:
        throw BackendError(
          YiiErrorInformation.fromJson(json.decode(content)),
        );
      case HttpStatus.internalServerError:
        log.severe('HttpStatus.internalServerError');
        log.severe(content);
        throw BackendError(
          YiiExceptionInformation.fromJson(json.decode(content)),
        );
      case HttpStatus.gatewayTimeout:
        throw BackendError(HtmlError(content));
      default:
        log.severe('unkown server state $statusCode, throw default: $content');
        throw BackendError(
          YiiExceptionInformation.fromJson(json.decode(content)),
        );
    }
  }
}
