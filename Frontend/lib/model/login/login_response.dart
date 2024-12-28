class LoginResponse {
  int? code;
  String? msg;
  UserData? data;

  LoginResponse({this.code, this.msg, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
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

class UserData {
  String? id;
  String? userName;
  String? token;
  int? type;
  String? audio;

  UserData({this.id, this.userName, this.token, this.type, this.audio});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'] is String
        ? BigInt.parse(json['id']).toString()
        : (BigInt.from(json['id'])).toString();
    audio = json['audio'] is String
        ? BigInt.parse(json['audio']).toString()
        : (BigInt.from(json['audio'])).toString();
    userName = json['userName'];
    token = json['token'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['token'] = this.token;
    data['type'] = this.type;
    data['audio'] = this.audio;
    return data;
  }
}
