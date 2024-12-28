import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skating_app/model/appointment/add_appointment_request.dart';
import 'package:skating_app/resources/string_manager.dart';
import 'package:skating_app/utils/api_config.dart';
import 'package:skating_app/utils/constants.dart';
import 'package:skating_app/utils/network_utils.dart';

class AppointmentProvider with ChangeNotifier {
  Future<Map<String, dynamic>> getBoardSlots(
      {required String date, required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.getBoardSlots + date);
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("getBoardSlots==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> getAvailableSlots(
      {required String date, required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.getSlots + date);
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("getAvailableSlots==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> bookAppointment({
    required AddAppointmentRequest request,
    required BuildContext context,
  }) async {
    var result;

    try {
      final Map<String, dynamic> bodyParams = request.toJson();

      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.bookAppointment);
      final response = await callApi(
        method: Constants.METHOD_POST,
        uri: uri,
        bodyParams: bodyParams,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("bookAppointment==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }
}
