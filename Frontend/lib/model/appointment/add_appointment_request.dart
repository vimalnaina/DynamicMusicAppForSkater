class AddAppointmentRequest {
  final String date;
  final int startTime;
  final int endTime;
  final BigInt userId;
  final int songlistId;

  AddAppointmentRequest({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.userId,
    required this.songlistId,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'userId': userId.toString(),
      'songlistId': songlistId.toString(),
    };
  }

  factory AddAppointmentRequest.fromJson(Map<String, dynamic> json) {
    return AddAppointmentRequest(
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      userId: BigInt.parse(json['userId']),
      songlistId: int.parse(json['songlistId']),
    );
  }
}
