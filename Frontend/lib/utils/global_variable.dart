import 'dart:typed_data';

import 'package:skating_app/model/songlist/songlist_response.dart';

class GlobalVariable {
  bool isNextMusicClick = false;
  bool isPreviousMusicClick = false;
  bool isSongChange = false;
  bool isSongListChange = false;
  SongList? currentSong;
  String? musicType;
  List<SongList> currentSongList = [];
}
