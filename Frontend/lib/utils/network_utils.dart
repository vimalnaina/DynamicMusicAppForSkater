import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:skating_app/resources/string_manager.dart';
import 'package:skating_app/ui/screens/authentication/login/login_screen.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/constants.dart';
import 'package:skating_app/utils/preference_manager.dart';

Future<http.Response?> callApi({
  required String method,
  required Uri uri,
  Map<String, String>? headers,
  Map<String, dynamic>? bodyParams,
  Map<String, Uint8List>? files, // Add files parameter for multipart data
  BuildContext? context,
}) async {
  String authToken =
      await PreferenceManager.getString(PreferenceManager.AUTH_TOKEN);

  Map<String, String> header = {
    // "Accept": "application/json",
    // "Access-Control-Allow-Origin": "*",
    "Content-Type": "application/json"
  };
  if (authToken.isNotEmpty) {
    header.addAll({"token": authToken});
  }
  if (headers != null) {
    header.addAll(headers);
  }
  print("url: ${uri.toString()}");
  print("header: $header");
  print("body: $bodyParams");
  if (await AppUtils.checkNetworkConnection()) {
    if (files != null && method == Constants.METHOD_POST) {
      // Handle multipart form data request
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(header);

      // Add body parameters as fields
      if (bodyParams != null) {
        bodyParams.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }
      // Add files to the request
      files.forEach((key, fileData) {
        request.files.add(http.MultipartFile.fromBytes(
          key,
          fileData,
          filename: "$key.jpg", // Use appropriate extension based on file type
        ));
      });
      // Send multipart request and convert to http.Response
      final streamedResponse = await request.send().timeout(
            Duration(seconds: Constants.TIMEOUT_SEC),
            onTimeout: () => http.StreamedResponse(Stream.empty(), 408),
          );
      return await http.Response.fromStream(streamedResponse);
    } else if (method == Constants.METHOD_GET) {
      return await http.Client().get(uri, headers: header).timeout(
        Duration(seconds: Constants.TIMEOUT_SEC),
        onTimeout: () {
          return http.Response('', 408);
        },
      );
    } else if (method == Constants.METHOD_POST) {
      if (bodyParams == null) {
        return await http.Client().post(uri, headers: header).timeout(
          Duration(seconds: Constants.TIMEOUT_SEC),
          onTimeout: () {
            return http.Response('', 408);
          },
        );
      } else {
        return await http.Client()
            .post(uri, headers: header, body: json.encode(bodyParams))
            .timeout(
          Duration(seconds: Constants.TIMEOUT_SEC),
          onTimeout: () {
            return http.Response('', 408);
          },
        );
      }
    } else if (method == Constants.METHOD_DELETE) {
      return await http.Client()
          .delete(uri, headers: header, body: json.encode(bodyParams))
          .timeout(
        Duration(seconds: Constants.TIMEOUT_SEC),
        onTimeout: () {
          return http.Response('', 408);
        },
      );
    } else if (method == Constants.METHOD_PATCH) {
      return await http.Client()
          .patch(uri, headers: header, body: json.encode(bodyParams))
          .timeout(
        Duration(seconds: Constants.TIMEOUT_SEC),
        onTimeout: () {
          return http.Response('', 408);
        },
      );
    } else if (method == Constants.METHOD_PUT) {
      return await http.Client()
          .put(uri, headers: header, body: json.encode(bodyParams))
          .timeout(
        Duration(seconds: Constants.TIMEOUT_SEC),
        onTimeout: () {
          return http.Response('', 408);
        },
      );
    }
  } else {
    return http.Response('', 409);
  }
  return null;
}

handleResponse(http.Response response, BuildContext context) {
  var result;
  print('response status is ${response.statusCode}');
  if (response.statusCode == 200) {
    print('responseData is ${response.body}');
    final Map<String, dynamic> responseData = json.decode(response.body);
    result = {
      'status': true,
      'message': responseData["message"],
      'data': responseData,
    };
  } else if (response.statusCode == 201) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    print('responseData is $responseData');
    result = {
      'status': true,
      'message': responseData["message"],
      'data': responseData,
    };
  } else if (response.statusCode == 400) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    print('responseData is $responseData');
    result = {
      'status': false,
      'error': responseData["message"],
    };
  } else if (response.statusCode == 401 || response.statusCode == 403) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    print('responseData is $responseData');
    result = {
      'status': false,
      'error': responseData["message"],
    };
    PreferenceManager.clearAllPrefs();
    Future(() {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    });
  } else if (response.statusCode == 408) {
    result = {
      'status': false,
      'error': StringManager.requestTimeOut,
    };
  } else if (response.statusCode == 409) {
    result = {
      'status': false,
      'error': StringManager.noInternetConnection,
    };
  } else {
    result = {
      'status': false,
      'error': StringManager.somethingWentWrong,
    };
  }
  return result;
}
