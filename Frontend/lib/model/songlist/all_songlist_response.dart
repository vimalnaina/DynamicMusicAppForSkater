import 'package:skating_app/model/songlist/songlist_response.dart';

class AllSongListResponse {
  int? code;
  String? msg;
  List<SongListData>? data;

  AllSongListResponse({this.code, this.msg, this.data});

  AllSongListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <SongListData>[];
      json['data'].forEach((v) {
        data!.add(new SongListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}