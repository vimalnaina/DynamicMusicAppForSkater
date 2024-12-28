class CreateSongListRequest {
  String? userId;
  String? description;
  String? listName;
  List<String>? songIds;

  CreateSongListRequest(
      {this.userId, this.description, this.listName, this.songIds});

  CreateSongListRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    description = json['description'];
    listName = json['listName'];
    songIds = json['songIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['description'] = this.description;
    data['listName'] = this.listName;
    data['songIds'] = this.songIds;
    return data;
  }
}
