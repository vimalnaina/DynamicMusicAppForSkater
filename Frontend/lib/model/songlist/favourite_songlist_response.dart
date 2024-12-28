import 'package:skating_app/model/songlist/songlist_response.dart';

class FavouriteSongListResponse {
  int? code;
  List<FavouriteSong>? data;
  String? msg;

  FavouriteSongListResponse({this.code, this.data, this.msg});

  FavouriteSongListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <FavouriteSong>[];
      json['data'].forEach((v) {
        data!.add(FavouriteSong.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FavouriteSong {
  int? count;
  SongList? song;

  FavouriteSong({this.count, this.song});

  FavouriteSong.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    song = json['song'] != null ? SongList.fromJson(json['song']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (song != null) {
      data['song'] = song!.toJson();
    }
    return data;
  }
}
