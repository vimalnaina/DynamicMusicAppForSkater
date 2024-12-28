import 'dart:html';

import 'package:flutter/material.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/music_player_provider.dart';

class DBMenuProviderCoach extends ChangeNotifier {
  int _selectedIndex = 0;
  bool _showNewScreen = false;
  bool _showThirdScreen = false;
  bool _showCompetitionFromHome = false;
  SongListData? _songListArgs;
  bool _isReload = false;

  int get selectedIndex => _selectedIndex;

  bool get showNewScreen => _showNewScreen;

  bool get showThirdScreen => _showThirdScreen;

  bool get showCompetitionFromHome => _showCompetitionFromHome;

  SongListData? get songListArgs => _songListArgs;

  bool get isReload => _isReload;

  final MusicPlayerProvider musicPlayerProvider;

  DBMenuProviderCoach(this.musicPlayerProvider);

  void selectMenu(int index) {
    musicPlayerProvider.reset();
    _selectedIndex = index;
    _showNewScreen = false; // Resetting screens when switching menus
    _showThirdScreen = false;
    _showCompetitionFromHome = false;
    _isReload = true;
    updateUrl(null);
    notifyListeners();
  }

  void resetReload() {
    _isReload = false;
    notifyListeners();
  }

  void toggleCompetitionAndHome({SongListData? args}) {
    musicPlayerProvider.reset();
    _showCompetitionFromHome = !_showCompetitionFromHome;
    _songListArgs = args;
    updateUrl(args?.songlistId);
    notifyListeners();
  }

  void updateUrl(int? id) {
    String route;
    switch (_selectedIndex) {
      case 0:
        route = '/songs';
        break;
      case 1:
        route = showCompetitionFromHome
            ? '/competition/songList'
            : '/competition';
        break;
      case 2:
        route = '/settings';
        break;
      default:
        route = '/songs';
    }
    // Update the browser's URL without navigation
    Uri newUri = Uri.parse(route);
    window.history.pushState(null, '', newUri.toString());
  }
}
