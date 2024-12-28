import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skating_app/resources/string_manager.dart';
import 'package:skating_app/utils/api_config.dart';
import 'package:skating_app/utils/constants.dart';
import 'package:skating_app/utils/network_utils.dart';

class AuthProvider with ChangeNotifier {
  Future<Map<String, dynamic>> login(
      {required String userName,
      required String password,
      required BuildContext context}) async {
    var result;

    try {
      final Map<String, dynamic> bodyParams = {
        'userName': userName,
        'password': password,
      };

      print("login==bodyParams==$bodyParams");

      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.login);
      final response = await callApi(
        method: Constants.METHOD_POST,
        uri: uri,
        bodyParams: bodyParams,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("login==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> signUp(
      {required String userName,
        required String password,
        required int type,
        required BuildContext context}) async {
    var result;

    try {
      final Map<String, dynamic> bodyParams = {
        'userName': userName,
        'password': password,
        'type': type,
      };

      print("signUp==bodyParams==$bodyParams");

      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.save);
      final response = await callApi(
        method: Constants.METHOD_POST,
        uri: uri,
        bodyParams: bodyParams,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("signUp==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }
}
