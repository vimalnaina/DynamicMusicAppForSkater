import 'package:skating_app/model/songlist/competition_response.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';

class AllCompetitionResponse {
  int? code;
  String? msg;
  List<CompetitionData>? data;

  AllCompetitionResponse({this.code, this.msg, this.data});

  AllCompetitionResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CompetitionData>[];
      json['data'].forEach((v) {
        data!.add(new CompetitionData.fromJson(v));
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
