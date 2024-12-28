import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

class AudioProcessor {
  static Future<Duration> getAudioDuration(Uint8List audioData) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_audioDurationWorker, receivePort.sendPort);

    final sendPort = await receivePort.first as SendPort;
    final response = ReceivePort();

    sendPort.send([response.sendPort, audioData]);
    final result = await response.first as Duration;

    return result;
  }

  static void _audioDurationWorker(SendPort mainSendPort) async {
    final port = ReceivePort();
    mainSendPort.send(port.sendPort);

    await for (final message in port) {
      final sendPort = message[0] as SendPort;
      final audioData = message[1] as Uint8List;

      // Compute duration in the isolate
      final player = AudioPlayer();
      await player.setSourceBytes(audioData);
      final duration = await player.getDuration();
      await player.dispose();

      sendPort.send(duration);
    }
  }
}
