import 'package:flutter/foundation.dart';

class AllSkatersResponse {
  int? code;
  String? msg;
  List<SkaterData>? data;

  AllSkatersResponse({this.code, this.msg, this.data});

  AllSkatersResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <SkaterData>[];
      json['data'].forEach((v) {
        data!.add(SkaterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SkaterData {
  String? id;
  String? userName;
  String? password;
  int? audio;
  int? type;

  SkaterData({this.id, this.userName, this.password, this.audio, this.type});

  SkaterData.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String
        ? BigInt.parse(json['id']).toString()
        : (BigInt.from(json['id'])).toString();
    userName = json['userName'];
    password = json['password'];
    audio = json['audio'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['password'] = this.password;
    data['audio'] = this.audio;
    data['type'] = this.type;
    return data;
  }
}
