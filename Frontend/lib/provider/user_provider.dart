import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:skating_app/model/songlist/create_songlist_request.dart';
import 'package:skating_app/resources/string_manager.dart';
import 'package:skating_app/utils/api_config.dart';
import 'package:skating_app/utils/constants.dart';
import 'package:skating_app/utils/network_utils.dart';

class UserProvider with ChangeNotifier {
  Future<Map<String, dynamic>> getAllSkaters(
      {required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.getAllSkaters);
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("songListByLevel==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }
}
