import 'package:skating_app/model/songlist/competition_response.dart';

class CreateCompetitionRequest {
  String? userId;
  String? description;
  String? listName;
  List<SongUserPairCreation> songUserPairs;

  CreateCompetitionRequest({
    this.userId,
    this.description,
    this.listName,
    required this.songUserPairs,
  });

  factory CreateCompetitionRequest.fromJson(Map<String, dynamic> json) {
    return CreateCompetitionRequest(
        userId: json['userId'],
        description: json['description'],
        listName: json['listName'],
        songUserPairs: json['songUserPairs'].cast<SongUserPair>());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['description'] = description;
    data['listName'] = listName;
    data['songUserPairs'] = songUserPairs;
    return data;
  }
}

class SongUserPairCreation {
  String? songId;
  String? userId;
  String? userName;

  SongUserPairCreation({this.songId, this.userId, this.userName});

  SongUserPairCreation.fromJson(Map<String, dynamic> json) {
    songId = json['songId'];
    userId = json['userId'];
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
