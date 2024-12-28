import 'package:flutter/material.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';

class SonglistScreenProvider extends ChangeNotifier {
  SongListData? _data;

  SongListData? get data => _data;

  void setData(SongListData? songListData) {
    _data = songListData;
    notifyListeners();
  }
}