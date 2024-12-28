class AvailableSlotsResponse {
  final int code;
  final String? msg;
  final List<SlotData>? data;

  AvailableSlotsResponse({
    required this.code,
    this.msg,
    this.data,
  });

  factory AvailableSlotsResponse.fromJson(Map<String, dynamic> json) {
    return AvailableSlotsResponse(
      code: json['code'],
      msg: json['msg'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SlotData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class SlotData {
  final DateTime startTime;
  final DateTime endTime;
  final bool available;

  SlotData({
    required this.startTime,
    required this.endTime,
    required this.available,
  });

  factory SlotData.fromJson(Map<String, dynamic> json) {
    return SlotData(
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'available': available,
    };
  }
}
