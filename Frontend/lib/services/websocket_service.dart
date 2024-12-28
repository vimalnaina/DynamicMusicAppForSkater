import 'package:audioplayers/audioplayers.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/constants.dart';
import 'package:web_socket_client/web_socket_client.dart';
import 'dart:typed_data';
import 'dart:convert';

class WebSocketService extends ChangeNotifier {
  WebSocket? socket;
  BuildContext? context;
  static WebSocketService? _webSocketService;

  WebSocketService(this.context);

  static WebSocketService getInstance(BuildContext context) {
    _webSocketService ??= WebSocketService(context);
    return _webSocketService!;
  }

  connect() async {
    socket = WebSocket(
      Uri.parse(Constants.socket_url),
      timeout: const Duration(seconds: 120),
      headers: {"token": Constants.token},
    );

    socket?.connection.listen((state) {
      if (state is Connecting)
        print("socket: connecting...");
      else if (state is Connected)
        print("socket: connected.");
      else if (state is Reconnecting)
        print("socket: connecting...");
      else if (state is Reconnected)
        print("socket: re-connected.");
      else if (state is Disconnecting)
        print("socket: disconnecting...");
      else if (state is Disconnected) print("socket: disconnected.");
    });

    socket?.messages.listen((event) async {
      if (AppUtils.isValidJson(event)) {
        Map<String, dynamic> message = jsonDecode(event);
        _extractSongData(message);
      }
    });
  }

  close() {
    if (socket == null) return;
    socket?.close();
  }

  Map<String, List<Uint8List?>> chunkMap = {};
  Map<String, int> expectedChunksMap = {};
  Map<int, List<Uint8List>> globalDataByType = {};

  _extractSongData(Map<String, dynamic> data) {
    // A map to keep track of chunks for each message
    String id = (BigInt.from(data['id']) + BigInt.one).toString();
    int type = data['type'];
    int chunkIndex = data['chunkIndex'];
    int totalChunks = data['totalChunks'];
    String base64Data = data['data'];
    Uint8List chunkData = base64Decode(base64Data);

    print("chunk id: ${id}");
    print("type: ${type}");
    print("totalChunks: ${totalChunks}");

    // Initialize chunk storage if it's a new message
    if (!chunkMap.containsKey(id)) {
      chunkMap[id] = List<Uint8List?>.filled(totalChunks, null);
      expectedChunksMap[id] = totalChunks;
    }

    // Store the chunk data at the correct index
    chunkMap[id]![chunkIndex] = chunkData;

    // Check if all chunks have been received
    if (chunkMap[id]!.every((element) => element != null)) {
      // All chunks received for this id
      Uint8List fullData = _assembleChunks(id);

      // Call the processing function based on type
      _processDataByType(type, fullData, id);

      // Clean up
      chunkMap.remove(id);
      expectedChunksMap.remove(id);
    }
  }

  Uint8List _assembleChunks(String id) {
    List<Uint8List?> chunks = chunkMap[id]!;
    BytesBuilder bytesBuilder = BytesBuilder();

    for (Uint8List? chunk in chunks) {
      if (chunk != null) {
        bytesBuilder.add(chunk);
      }
    }

    return bytesBuilder.toBytes();
  }

  void _processDataByType(int type, Uint8List fullData, String id) async {
    switch (type) {
      case 1:
        print("UserAnnouncement from websocket");
        FBroadcast.instance().broadcast("UserAnnouncement", value: {"data": fullData, "id": id});
        break;
      case 2:
        print("SongAnnouncement from websocket");
        FBroadcast.instance().broadcast("SongAnnouncement", value: {"data": fullData, "id": id});
        break;
      case 3:
        FBroadcast.instance().broadcast("MusicData", value: {"data": fullData, "id": id});
        break;
      default:
      // print("Unknown type: $type");
    }
  }
}
