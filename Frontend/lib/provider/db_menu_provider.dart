import 'dart:html';

import 'package:flutter/material.dart';
import 'package:skating_app/model/songlist/competition_response.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/music_player_provider.dart';

class DBMenuProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _showSongListFromHome = false;
  bool _showCompetitionFromHome = false;
  SongListData? _songListArgs;
  CompetitionData? _competitionArgs;
  final MusicPlayerProvider musicPlayerProvider;
  bool _isReload = false;

  DBMenuProvider(this.musicPlayerProvider);

  int get selectedIndex => _selectedIndex;

  bool get showSongListFromHome => _showSongListFromHome;

  bool get showCompetitionFromHome => _showCompetitionFromHome;
  bool get isReload => _isReload;

  SongListData? get songListArgs => _songListArgs;

  CompetitionData? get competitionArgs => _competitionArgs;

  void selectMenu(int index) {
    musicPlayerProvider.reset();
    _selectedIndex = index;
    _showSongListFromHome = false;
    _showCompetitionFromHome = false;
    _songListArgs = null;
    _competitionArgs = null;
    _isReload = true;
    updateUrl(null);
    notifyListeners();
  }

  void resetReload() {
    _isReload = false;
    notifyListeners();
  }

  void toggleSongListAndHome({SongListData? args}) {
    musicPlayerProvider.reset();
    _showSongListFromHome = !_showSongListFromHome;
    _songListArgs = args;
    updateUrl(args?.songlistId);
    notifyListeners();
  }

  void updateUrl(int? id) {
    String route;
    switch (_selectedIndex) {
      case 0:
        route = '/board';
        break;
      case 1:
        route = showSongListFromHome
            ? '/home/songList'
            : '/home';
        break;
      // case 2:
      //   route = '/history';
      //   break;
      case 2:
        route = '/calendar';
        break;
      case 3:
        route = '/settings';
        break;
      default:
        route = '/board';
    }
    // Use `pushState` to update the URL without using Navigator
    Uri newUri = Uri.parse(route);
    window.history.pushState(null, '', newUri.toString());
  }
}
