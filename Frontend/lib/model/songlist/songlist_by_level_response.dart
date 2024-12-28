import 'package:skating_app/model/songlist/songlist_response.dart';

class SongListByLevelResponse {
  int? code;
  String? msg;
  List<SongList>? data;

  SongListByLevelResponse({this.code, this.msg, this.data});

  SongListByLevelResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <SongList>[];
      json['data'].forEach((v) {
        data!.add(new SongList.fromJson(v));
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
