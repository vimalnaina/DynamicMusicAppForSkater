import 'package:flutter/foundation.dart';

class SongListResponse {
  int? code;
  String? msg;
  SongListData? data;

  SongListResponse({this.code, this.msg, this.data});

  SongListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data =
        json['data'] != null ? new SongListData.fromJson(json['data']) : null;
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

class SongListData {
  int? songlistId;
  List<SongList>? songList;
  String? userId;
  String? listName;
  String? description;
  String? createTime;

  SongListData({
    this.songlistId,
    this.songList,
    this.userId,
    this.listName,
    this.description,
    this.createTime,
  });

  SongListData.fromJson(Map<String, dynamic> json) {
    if (json['songList'] != null) {
      songList = <SongList>[];
      json['songList'].forEach((v) {
        songList!.add(new SongList.fromJson(v));
      });
    }
    userId = json['userId'] is String
        ? BigInt.parse(json['userId']).toString()
        : (BigInt.from(json['userId'])).toString();
    songlistId = json['songlistId'];
    listName = json['listName'];
    description = json['description'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songList != null) {
      data['songList'] = this.songList!.map((v) => v.toJson()).toList();
    }
    data['userId'] = this.userId;
    data['songlistId'] = this.songlistId;
    data['listName'] = this.listName;
    data['description'] = this.description;
    data['createTime'] = this.createTime;
    return data;
  }
}

class SongList {
  String? name;
  String? singer;
  int? duration;
  int? difficultyLevel;
  String? songId;
  String? createId;
  String? createTime;
  String? imageId;
  String? songUrl;
  Uint8List? image;
  Uint8List? song;
  String? userId;
  String? userName;

  SongList(
      {this.name,
      this.singer,
      this.duration,
      this.difficultyLevel,
      this.songId,
      this.createId,
      this.createTime,
      this.songUrl,
      this.image,
      this.song,
      this.userId,
      this.userName,
      this.imageId});

  SongList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    singer = json['singer'];
    duration = json['duration'];
    difficultyLevel = json['difficultyLevel'];
    songId = json['songId'] is String
        ? BigInt.parse(json['songId']).toString()
        : (BigInt.from(json['songId'])).toString();
    createId = json['createId'];
    createTime = json['createTime'];
    imageId = json['imageId'] is String
        ? BigInt.parse(json['imageId']).toString()
        : (BigInt.from(json['imageId']) + BigInt.one).toString();
    songUrl = json['songUrl'];
    image = json['image'];
    userId = json['userId'];
    userName = json['userName'];
    song = json['song'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['singer'] = this.singer;
    data['duration'] = this.duration;
    data['difficultyLevel'] = this.difficultyLevel;
    data['songId'] = this.songId;
    data['createId'] = this.createId;
    data['createTime'] = this.createTime;
    data['imageId'] = this.imageId;
    data['songUrl'] = this.songUrl;
    data['image'] = this.image;
    data['song'] = this.song;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    return data;
  }
}
