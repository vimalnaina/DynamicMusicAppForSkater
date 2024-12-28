import 'dart:convert';

class SongDataSocketResponse {
  final int id;
  final int chunkIndex;
  final int totalChunks;
  final List<int> data;
  final int type;

  SongDataSocketResponse({
    required this.id,
    required this.chunkIndex,
    required this.totalChunks,
    required this.data,
    required this.type,
  });

  // Factory method to create a `SongDataSocketResponse` from a map
  factory SongDataSocketResponse.fromMap(Map<String, dynamic> map) {
    return SongDataSocketResponse(
      id: map['id'],
      chunkIndex: map['chunkIndex'],
      totalChunks: map['totalChunks'],
      data: map['data'] is String
          ? base64Decode(map['data']) // Decode base64 if `data` is a string
          : List<int>.from(map['data']), // Otherwise, treat it as List<int>
      type: map['type'],
    );
  }

  // Method to convert a `SongDataSocketResponse` instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chunkIndex': chunkIndex,
      'totalChunks': totalChunks,
      'data': base64Encode(data), // Encode as base64 string for JSON
      'type': type,
    };
  }
}