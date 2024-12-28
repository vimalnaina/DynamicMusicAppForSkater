import 'package:skating_app/model/songlist/songlist_response.dart';

class BoardSlotResponse {
  final int code;
  final List<BoardSlotData>? data;
  final String? msg;

  BoardSlotResponse({
    required this.code,
    this.data,
    this.msg,
  });

  factory BoardSlotResponse.fromJson(Map<String, dynamic> json) {
    return BoardSlotResponse(
      code: json['code'],
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => BoardSlotData.fromJson(item))
          .toList(),
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'data': data?.map((item) => item.toJson()).toList(),
      'msg': msg,
    };
  }
}

class BoardSlotData {
  final String date;
  final DateTime endTime;
  final SongListVO songListVO;
  final DateTime startTime;
  final int userId;
  final String userName;

  BoardSlotData({
    required this.date,
    required this.endTime,
    required this.songListVO,
    required this.startTime,
    required this.userId,
    required this.userName,
  });

  factory BoardSlotData.fromJson(Map<String, dynamic> json) {
    return BoardSlotData(
      date: json['date'],
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
      songListVO: SongListVO.fromJson(json['songListVO']),
      userId: json['userId'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'endTime': endTime.millisecondsSinceEpoch,
      'songListVO': songListVO.toJson(),
      'startTime': startTime.millisecondsSinceEpoch,
      'userId': userId,
      'userName': userName,
    };
  }
}

class SongListVO {
  final String createTime;
  final String description;
  final String listName;
  final List<SongList> songList;
  final int songlistId;
  final String userId;

  SongListVO({
    required this.createTime,
    required this.description,
    required this.listName,
    required this.songList,
    required this.songlistId,
    required this.userId,
  });

  factory SongListVO.fromJson(Map<String, dynamic> json) {
    return SongListVO(
      createTime: json['createTime'],
      description: json['description'],
      listName: json['listName'],
      songList: (json['songList'] as List<dynamic>)
          .map((item) => SongList.fromJson(item))
          .toList(),
      songlistId: json['songlistId'],
      userId: json['userId'] is String
          ? BigInt.parse(json['userId']).toString()
          : (BigInt.from(json['userId'])).toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime,
      'description': description,
      'listName': listName,
      'songList': songList.map((item) => item.toJson()).toList(),
      'songlistId': songlistId,
      'userId': userId,
    };
  }
}
