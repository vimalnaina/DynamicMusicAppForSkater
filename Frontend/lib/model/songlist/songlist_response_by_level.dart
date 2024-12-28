import 'package:flutter/foundation.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';

class SongListResponseByLevel {
  int? code;
  String? message;
  List<SongList>? data;

  SongListResponseByLevel({this.code, this.message, this.data});

  SongListResponseByLevel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['msg']; // Corrected the field name to match the JSON
    if (json['data'] != null) {
      data = <SongList>[];
      json['data'].forEach((v) {
        data!.add(SongList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['msg'] = this.message; // Corrected the field name to match the JSON
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
