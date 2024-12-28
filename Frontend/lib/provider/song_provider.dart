import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:skating_app/model/songlist/create_competition_request.dart';
import 'package:skating_app/model/songlist/create_songlist_request.dart';
import 'package:skating_app/model/songlist/favourite_songlist_response.dart';
import 'package:skating_app/resources/string_manager.dart';
import 'package:skating_app/utils/api_config.dart';
import 'package:skating_app/utils/constants.dart';
import 'package:skating_app/utils/network_utils.dart';

class SongProvider with ChangeNotifier {
  Future<Map<String, dynamic>> songList({required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.songList);
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("songList==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> uploadSong({
    required BuildContext context,
    required Uint8List musicData,
    required Uint8List imageData,
    required int difficultyLevel,
    required String singer,
    required String songName,
  }) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.uploadSong);
      final response = await callApi(
        method: Constants.METHOD_POST,
        uri: uri,
        bodyParams: {
          'difficultyLevel': difficultyLevel.toString(),
          'singer': singer,
          'songName': songName,
        },
        files: {
          'musicData': musicData,
          'imageData': imageData,
        },
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("uploadSong==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> getAllSongLists(
      {required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.getAllSongLists);
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

  Future<Map<String, dynamic>> getAllRaceLists(
      {required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.getAllRaceLists);
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

  Future<Map<String, dynamic>> getSongListDataById(
      {required int id, required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(
          ApiConfig.baseUrl, ApiConfig.getSongListById + id.toString());
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("getSongListDataById==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> songListByLevel(
      {required String level, required BuildContext context}) async {
    var result;

    try {
      final uri =
          Uri.https(ApiConfig.baseUrl, ApiConfig.getSongsByLevel + level);
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

  Future<Map<String, dynamic>> createSongList(
      {required CreateSongListRequest requestModel,
      required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.createSongList);
      final response = await callApi(
        method: Constants.METHOD_POST,
        uri: uri,
        bodyParams: requestModel.toJson(),
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("createSongList==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> createRaceList(
      {required CreateCompetitionRequest requestModel,
      required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.createRaceList);
      final response = await callApi(
        method: Constants.METHOD_POST,
        uri: uri,
        bodyParams: requestModel.toJson(),
      );
      result = handleResponse(response!, context);
    } catch (e) {
      print("createSongList==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<dynamic> getSong(
      {required String songId, required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.getSong + "$songId");
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      print("length==${response!.contentLength}");
      result = handleGetImageResponse(response!);
    } catch (e) {
      print("getSong==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<dynamic> getImage(
      {required String imageId, required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.getImage + imageId);

      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );

      result = handleGetImageResponse(response!);
    } catch (e) {
      print("getImage==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  handleGetImageResponse(Response response) {
    var result;
    if (response.statusCode == 200) {
      result = response.bodyBytes;
    }
    return result;
  }

  Future<dynamic> getUserAnnouncement(
      {required String id, required BuildContext context}) async {
    var result;

    try {
      final uri =
          Uri.https(ApiConfig.baseUrl, ApiConfig.userAnnouncement + "$id");
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      print("length==${response!.contentLength}");
      result = handleGetImageResponse(response!);
    } catch (e) {
      print("getSong==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<dynamic> getSongAnnouncement(
      {required String id, required BuildContext context}) async {
    var result;

    try {
      final uri =
          Uri.https(ApiConfig.baseUrl, ApiConfig.songAnnouncement + "$id");
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      print("length==${response!.contentLength}");
      result = handleGetImageResponse(response!);
    } catch (e) {
      print("getSong==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> addRecommend({
    required BuildContext context,
    required String id,
  }) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.addRecommend + id);
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> retriveHistory({
    required BuildContext context,
  }) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, ApiConfig.retriveHistory);
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );
      result = handleResponse(response!, context);
    } catch (e) {
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': ""
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> getFavouriteSongList(
      {required BuildContext context}) async {
    var result;

    try {
      final uri = Uri.https(ApiConfig.baseUrl, '/recommend/favourite');
      final response = await callApi(
        method: Constants.METHOD_GET,
        uri: uri,
      );

      result = handleResponse(response!, context);

      if (!result['status']) {
        result['data'] = null;
      }
    } catch (e) {
      print("getFavouriteSongList==exception==$e");
      result = {
        'status': false,
        'error': StringManager.somethingWentWrong,
        'data': null,
      };
    }
    return result;
  }
}
