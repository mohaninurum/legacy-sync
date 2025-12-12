import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:legacy_sync/config/network/api_host.dart';
import 'package:legacy_sync/config/network/app_exceptions.dart';
import 'package:legacy_sync/config/network/base_api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart';

typedef ResultFuture<T> = Future<Either<AppException, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef DataMap = Map<String, dynamic>;

class NetworkApiService implements BaseApiServices {
  final dio.Dio _dio = dio.Dio();

  Map<String, String> _buildHeaders([String? overrideToken]) {
    final tokenToUse = overrideToken ?? ApiURL.authToken;
    return {'Content-Type': 'application/json; charset=UTF-8', if (tokenToUse.isNotEmpty) 'Authorization': 'Bearer $tokenToUse'};
  }

  Either<AppException, T> _parseHttpResponse<T>(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody = response.body;
    print("statusCode: $statusCode responseData:$responseBody");

    switch (statusCode) {
      case 200:
      case 201:
        return Right(jsonDecode(responseBody));
      case 400:
        final msg = jsonDecode(responseBody)["message"] ?? "Bad request";
        return Left(BadRequestException(msg, 400));
      case 401:
        final msg = jsonDecode(responseBody)["message"] ?? "Unauthorized";
        return Left(UnauthorisedException(msg, 401));
      case 403:
        final msg = jsonDecode(responseBody)["message"] ?? "Unauthorized";
        return Left(UnauthorisedException(msg, 403));
      case 404:
        final msg = jsonDecode(responseBody)["message"] ?? "Not found";
        return Left(NotFoundException(msg, 404));
      case 500:
        final msg = jsonDecode(responseBody)["message"] ?? "Server error";
        return Left(InternalServerException(msg, 500));
      default:
        return const Left(FetchDataException("Unexpected server error"));
    }

  }

  Either<AppException, T> _parseDioResponse<T>(dio.Response response) {
    final statusCode = response.statusCode ?? 0;
    final responseData = response.data;
    print("statusCode: $statusCode responseData:$responseData");

    switch (statusCode) {
      case 200:
      case 201:
        return Right(jsonDecode(responseData));
      case 400:
        final msg = jsonDecode(responseData)["message"] ?? "Bad request";
        return Left(BadRequestException(msg, 400));
      case 401:
        final msg = jsonDecode(responseData)["message"] ?? "Unauthorized";
        return Left(UnauthorisedException(msg, 401));
      case 403:
        final msg = jsonDecode(responseData)["message"] ?? "Unauthorized";
        return Left(UnauthorisedException(msg, 403));
      case 404:
        final msg = jsonDecode(responseData)["message"] ?? "Not found";
        return Left(NotFoundException(msg, 404));
      case 500:
        final msg = jsonDecode(responseData)["message"] ?? "Server error";
        return Left(InternalServerException(msg, 500));
      default:
        return const Left(FetchDataException("Unexpected server error"));
    }

  }

  Future<Either<AppException, T>> _safeRequest<T>(Future<http.Response> Function() call, {required String method, required String url, Map<String, String>? headers, Map<String, dynamic>? body, Map<String, dynamic>? queryParams}) async {
    try {
      if (kDebugMode) {
        printCurlRequest(url: url, method: method, headers: headers, queryParams: queryParams, body: body);
      }
      final response = await call().timeout(const Duration(seconds: 60));
      return _parseHttpResponse<T>(response);
    } on SocketException {
      return const Left(NoInternetException('No internet'));
    } on TimeoutException {
      return const Left(FetchDataException('Request timed out'));
    }
  }

  @override
  ResultFuture getGetApiResponse(String url) {
    final headers = _buildHeaders();
    return _safeRequest(() => http.get(Uri.parse(url), headers: headers), method: 'GET', url: url, headers: headers);
  }

  @override
  ResultFuture getPostApiResponse(String url, Map<String, dynamic> dic) {
    final headers = _buildHeaders();
    return _safeRequest(() => http.post(Uri.parse(url), headers: headers, body: jsonEncode(dic)), method: 'POST', url: url, headers: headers, body: dic);
  }

  @override
  ResultFuture getPutApiResponse(String url, Map<String, dynamic> dic) {
    final headers = _buildHeaders();
    return _safeRequest(() => http.put(Uri.parse(url), headers: headers, body: jsonEncode(dic)), method: 'PUT', url: url, headers: headers, body: dic);
  }

  @override
  ResultFuture patchApiResponse(String url, Map<String, dynamic> dic) {
    final headers = _buildHeaders();
    return _safeRequest(() => http.patch(Uri.parse(url), headers: headers, body: jsonEncode(dic)), method: 'PATCH', url: url, headers: headers, body: dic);
  }

  @override
  ResultFuture pathResponse(String url, Map<String, dynamic> dic) => patchApiResponse(url, dic);

  @override
  ResultFuture deleteResponse(String url, Map<String, dynamic> dic) => patchApiResponse(url, dic);

  @override
  ResultFuture getDeleteApiResponse(String url, Map<String, dynamic> dic) {
    final headers = _buildHeaders();
    return _safeRequest(() => http.delete(Uri.parse(url), headers: headers, body: jsonEncode(dic)), method: 'DELETE', url: url, headers: headers, body: dic);
  }

  @override
  ResultFuture getPostDownloadZip(String url, Map<String, dynamic> dic) {
    final headers = _buildHeaders();
    return _safeRequest(() => http.post(Uri.parse(url), headers: headers, body: jsonEncode(dic)), method: 'POST', url: url, headers: headers, body: dic);
  }

  @override
  ResultFuture getPostUploadMultiPartApiResponse(String url, Map<String, String> fields, dynamic fileBytes, String fileName, String key, String method) async {


    try {
      final request = http.MultipartRequest(method.isEmpty ? 'POST' : method, Uri.parse(url));
      request.fields.addAll(fields);
      if (fileBytes != null && fileBytes.isNotEmpty) {
        request.files.add(http.MultipartFile.fromBytes(key, fileBytes, filename: fileName));
      }
      final headers = _buildHeaders();
      request.headers.addAll(headers);
      if (kDebugMode) {
        printCurlRequest(url: url, method: method, headers: headers, body: fields);
      }


      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      return _parseHttpResponse(response);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  @override
  ResultFuture getPostMultiFileUpload(String url, Map<String, String> fields, List<PlatformFile> files, String key, String method) async {
    try {
      final request = http.MultipartRequest(method.isEmpty ? 'POST' : method, Uri.parse(url));
      request.fields.addAll(fields);
      request.headers.addAll(_buildHeaders());

      for (final file in files) {
        final bytes = await getFileBytes(file.path!);
        if (bytes.isNotEmpty) {
          request.files.add(http.MultipartFile.fromBytes(key, bytes, filename: file.name, contentType: getContentType(file.name)));
        }
      }

      if (kDebugMode) {
        printCurlRequest(url: url, method: method, headers: _buildHeaders(), body: fields);
      }

      final response = await http.Response.fromStream(await request.send());
      return _parseHttpResponse(response);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  @override
  ResultFuture multiFileUpload(String url, Map<String, String> fields, List<PlatformFile> files, String key, String method, Function(double progress)? onUploadProgress) async {
    try {
      final formData = dio.FormData();

      for (final file in files) {
        final bytes = await getFileBytes(file.path!);
        formData.files.add(MapEntry(key, dio.MultipartFile.fromBytes(bytes, filename: file.name, contentType: getContentType(file.name))));
      }

      formData.fields.addAll(fields.entries.map((e) => MapEntry(e.key, e.value)));

      final headers = _buildHeaders();

      if (kDebugMode) {
        printCurlRequest(url: url, method: method, headers: headers, body: fields);
      }

      final response = await _dio.request(
        url,
        data: formData,
        options: dio.Options(method: method.isEmpty ? 'POST' : method, headers: headers),
        onSendProgress: (sent, total) {
          if (onUploadProgress != null && total > 0) {
            onUploadProgress((sent / total) * 100);
          }
        },
      );

      return _parseDioResponse(response);
    } catch (e) {
      return Left(AppException(e.toString()));
    }
  }

  Future<List<int>> getFileBytes(String path) async {
    return File(path).readAsBytes();
  }

  MediaType getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'mp4':
        return MediaType('video', 'mp4');
      case 'webm':
        return MediaType('video', 'webm');
      case 'avi':
        return MediaType('video', 'avi');
      default:
        throw Exception('Unsupported file type: $extension');
    }
  }

  static void printCurlRequest({required String url, required String method, Map<String, String>? headers, Map<String, dynamic>? queryParams, dynamic body}) {
    if (queryParams != null && queryParams.isNotEmpty) {
      url += '?${Uri(queryParameters: queryParams).query}';
    }

    String curlCommand = "curl -X $method '$url'";

    headers?.forEach((key, value) {
      curlCommand += " -H '$key: $value'";
    });

    if (body != null) {
      final bodyString = (body is String) ? body : jsonEncode(body);
      curlCommand += " -d '$bodyString'";
    }

    print("cURL Command:\n$curlCommand\n");
  }
}