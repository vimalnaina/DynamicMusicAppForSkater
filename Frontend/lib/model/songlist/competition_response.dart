import 'package:flutter/foundation.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';

class CompetitionResponse {
  int? code;
  String? msg;
  CompetitionData? data;

  CompetitionResponse({this.code, this.msg, this.data});

  CompetitionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null
        ? new CompetitionData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CompetitionData {
  int? songlistId;
  List<SongUserPair>? songUserPairs;
  String? userId;
  String? listName;
  String? description;
  String? createTime;

  CompetitionData({
    this.songlistId,
    this.songUserPairs,
    this.userId,
    this.listName,
    this.description,
    this.createTime,
  });

  CompetitionData.fromJson(Map<String, dynamic> json) {
    if (json['songUserPairs'] != null) {
      songUserPairs = <SongUserPair>[];
      json['songUserPairs'].forEach((v) {
        songUserPairs!.add(new SongUserPair.fromJson(v));
      });
    }
    userId = json['userId'] is String
        ? BigInt.parse(json['userId']).toString()
        : (BigInt.from(json['userId']) + BigInt.one).toString();
    songlistId = json['songlistId'];
    listName = json['listName'];
    description = json['description'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songUserPairs != null) {
      data['songUserPairs'] =
          this.songUserPairs!.map((v) => v.toJson()).toList();
    }
    data['userId'] = this.userId;
    data['songlistId'] = this.songlistId;
    data['listName'] = this.listName;
    data['description'] = this.description;
    data['createTime'] = this.createTime;
    return data;
  }
}

class SongUserPair {
  String? songId;
  String? userId;
  String? userName;

  SongUserPair({this.songId, this.userId, this.userName});

  SongUserPair.fromJson(Map<String, dynamic> json) {
    songId = json['songId'] is String
        ? BigInt.parse(json['songId']).toString()
        : (BigInt.from(json['songId'])).toString();

    userId = json['userId'] is String
        ? BigInt.parse(json['userId']).toString()
        : (BigInt.from(json['userId'])).toString();
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['songId'] = songId;
    data['userId'] = userId;
    data['userName'] = userName;
    return data;
  }
}
