import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starter/core/helpers/log_helper.dart';
import 'package:starter/models/errors_model.dart';
import 'package:starter/utils/app_constants.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetxService {
  final String? appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;
  final int timeoutInSeconds = 30;

  String? token;
  late Map<String, String> _mainHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    AppConstants.appApiKey: AppConstants.appApiValue,
    AppConstants.zoneId: '',
    AppConstants.localizationKey: AppConstants.languages[0].languageCode!,
    'Authorization': 'Bearer $token',
    AppConstants.guestId: '',
  };

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    printLog('Token: $token');

    updateHeader(
      token: token,
    );
  }

  void updateHeader({
    String? token,
    String? zoneIDs,
    String? languageCode,
    String? guestID,
  }) {
    _mainHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      AppConstants.zoneId: zoneIDs ?? '',
      AppConstants.appApiKey: AppConstants.appApiValue,
      AppConstants.localizationKey:
          languageCode ?? AppConstants.languages[0].languageCode!,
      'Authorization': 'Bearer $token',
      AppConstants.guestId: guestID ?? "",
    };
  }

  Response handleResponse(http.Response response, String? uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      printLog(e.toString());
    }
    Response response0 = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (response0.statusCode != 200 &&
        response0.body != null &&
        response0.body is! String) {
      if (response0.body.toString().startsWith('{response_code:')) {
        ErrorsModel errorResponse = ErrorsModel.fromJson(response0.body);
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: errorResponse.responseCode);
      } else if (response0.body.toString().startsWith('{message')) {
        response0 = Response(
            statusCode: response0.statusCode,
            body: response0.body,
            statusText: response0.body['message']);
      }
    } else if (response0.statusCode != 200 && response0.body == null) {
      response0 = Response(statusCode: 0, statusText: noInternetMessage);
    }
    log('====> API Response: [${response0.statusCode}] $uri\n${response0.body}');
    return response0;
  }

  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    String url = appBaseUrl! + uri;
    try {
      printLog('====> API Call: $url\nHeader: $_mainHeaders');
      http.Response response = await http
          .get(
            Uri.parse(url),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(
    String? uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    String url = appBaseUrl! + uri!;

    printLog('====> API Call: $url\nHeader: $_mainHeaders');
    printLog('====> body : ${jsonEncode(body)}');

    http.Response response = await http
        .post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers ?? _mainHeaders,
        )
        .timeout(Duration(seconds: timeoutInSeconds));
    try {
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartDataConversation(
      String? uri, Map<String, String> body, List<MultipartBody>? multipartBody,
      {Map<String, String>? headers, List<PlatformFile>? otherFile}) async {
    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(appBaseUrl! + uri!));
    request.headers.addAll(headers ?? _mainHeaders);

    if (otherFile != null) {
      if (otherFile.isNotEmpty) {
        for (PlatformFile platformFile in otherFile) {
          request.files.add(http.MultipartFile(
              'files[${otherFile.indexOf(platformFile)}]',
              platformFile.readStream!,
              platformFile.size,
              filename: basename(platformFile.name)));
        }
      }
    }
    if (multipartBody != null) {
      for (MultipartBody multipart in multipartBody) {
        Uint8List list = await multipart.file.readAsBytes();
        request.files.add(http.MultipartFile(
          multipart.key!,
          multipart.file.readAsBytes().asStream(),
          list.length,
          filename: '${DateTime.now().toString()}.png',
        ));
      }
    }
    request.fields.addAll(body);
    http.Response response =
        await http.Response.fromStream(await request.send());
    return handleResponse(response, uri);
  }

  Future<Response> postMultipartData(
    String? uri,
    Map<String, String> body,
    List<MultipartBody>? multipartBody, {
    Map<String, String>? headers,
  }) async {
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(appBaseUrl! + uri!));
      request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody!) {
        if (kIsWeb) {
          Uint8List list = await multipart.file.readAsBytes();
          http.MultipartFile part = http.MultipartFile(
            multipart.key!,
            multipart.file.readAsBytes().asStream(),
            list.length,
            filename: basename(multipart.file.path),
            contentType: MediaType('images', 'jpg'),
          );
          request.files.add(part);
        } else {
          File file = File(multipart.file.path);
          request.files.add(http.MultipartFile(
            multipart.key!,
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split('/').last,
          ));
        }
      }
      request.fields.addAll(body);
      http.Response response =
          await http.Response.fromStream(await request.send());
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String? uri, dynamic body,
      {Map<String, String>? headers}) async {
    printLog('====> body : ${body.toString()}');
    try {
      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl! + uri!),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String? uri,
      {Map<String, String>? headers}) async {
    try {
      String url = appBaseUrl! + uri!;

      printLog('====> API Call: $url\nHeader: $_mainHeaders');
      http.Response response = await http
          .delete(
            Uri.parse(url),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
}

class MultipartBody {
  String? key;
  XFile file;

  MultipartBody(this.key, this.file);
}
