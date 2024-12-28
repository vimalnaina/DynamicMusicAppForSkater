import 'package:flutter/material.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/utils/app_utils.dart';

class MusicPlayerProvider extends ChangeNotifier {
  bool _isOpenMusicPlayer = false;
  bool _isSongChange = false;
  bool _isSongListChange = false;
  SongList? _currentSong;
  SongList? _currentUserAnnouncement;
  SongList? _currentSongAnnouncement;
  String? _musicType;
  List<SongList> _currentSongList = [];
  ValueNotifier<int> sliderValueNotifier = ValueNotifier(0);
  bool _isCompetition = false;

  bool _isPlaying = false;
  bool _isLoading = true;
  int _duration = 0;
  int _position = 0;

  bool _isUserAnnouncement = false;
  bool _isSongAnnouncement = false;

  bool get isOpenMusicPlayer => _isOpenMusicPlayer;

  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get isCompetition => _isCompetition;

  int get duration => _duration;

  int get position => _position;

  bool get isSongChange => _isSongChange;

  bool get isSongListChange => _isSongListChange;

  bool get isUserAnnouncement => _isUserAnnouncement;

  bool get isSongAnnouncement => _isSongAnnouncement;

  SongList? get currentSong => _currentSong;

  SongList? get currentUserAnnouncement => _currentUserAnnouncement;

  SongList? get currentSongAnnouncement => _currentSongAnnouncement;

  String? get musicType => _musicType;

  List<SongList> get currentSongList => _currentSongList;

  void changeSongList(List<SongList> newSongList) {
    print("called changeSongList == ");
    _isOpenMusicPlayer = true;
    _currentSongList = newSongList;
    _isSongListChange = true;
    // _isUserAnnouncement = true;
    // _isSongAnnouncement = true;
    // _isSongChange = false;
    // _currentSong = newSongList.first;
    // _isPlaying = false;
    // _isLoading = true;
    notifyListeners();
  }

  void changeSong(SongList newSong) {
    if (!_isOpenMusicPlayer) {
      _isOpenMusicPlayer = true;
    }
    _currentSong = newSong;
    _isSongChange = false;
    _isPlaying = false;
    _isLoading = true;

    if (isCompetition) {
      _isUserAnnouncement = true;
      _isSongAnnouncement = false;
    } else {
      _isUserAnnouncement = false;
      _isSongAnnouncement = true;
    }
    notifyListeners();
  }

  // void changeUserAnnouncement(SongList newSong) {
  //   _currentUserAnnouncement = newSong;
  //   notifyListeners();
  // }
  //
  // void changeSongAnnouncement(SongList newSong) {
  //   _currentSongAnnouncement = newSong;
  //   notifyListeners();
  // }

  void changeToNextSong() {
    _currentSong = AppUtils.nextElement(_currentSongList, _currentSong);
    if (_currentSong == null) {
      reset();
      return;
    }
    _isSongChange = false;
    _isPlaying = false;
    _isLoading = true;

    if (isCompetition) {
      _isUserAnnouncement = true;
      _isSongAnnouncement = false;
    } else {
      _isUserAnnouncement = false;
      _isSongAnnouncement = true;
    }
    notifyListeners();
  }

  void changeToPreviousSong() {
    _currentSong = AppUtils.previousElement(_currentSongList, _currentSong);
    if (_currentSong == null) {
      reset();
      return;
    }
    _isSongChange = false;
    _isPlaying = false;
    _isLoading = true;

    if (isCompetition) {
      _isUserAnnouncement = true;
      _isSongAnnouncement = false;
    } else {
      _isUserAnnouncement = false;
      _isSongAnnouncement = true;
    }
    notifyListeners();
  }

  // void resetChangeSongFlag() {
  //   _isSongChange = false;
  //   _isPlaying = false;
  //   _isLoading = true;
  //   notifyListeners();
  // }

  // void resetChangeSongListFlag() {
  //   _isSongListChange = false;
  //   _isPlaying = false;
  //   _isLoading = true;
  //   notifyListeners();
  // }

  void resetUserAnnouncementFlag() {
    _isUserAnnouncement = false;
    _isSongAnnouncement = true;
    _isPlaying = false;
    _isLoading = true;
    notifyListeners();
  }

  void reset() {
    _isUserAnnouncement = false;
    _isSongAnnouncement = false;
    _isPlaying = false;
    _isLoading = false;
    _isSongChange = false;
    _isOpenMusicPlayer = false;
    _isSongListChange = false;
    _currentUserAnnouncement = null;
    _currentSongAnnouncement = null;
    _currentSong = null;
    _currentSongList = [];
    _duration = 0;
    _position = 0;
    _isCompetition = false;
    notifyListeners();
  }

  void resetSongAnnouncementFlag() {
    _isSongAnnouncement = false;
    _isSongChange = true;
    _isPlaying = false;
    _isLoading = true;
    notifyListeners();
  }

  void openMusicPlayerFlag() {
    _isOpenMusicPlayer = true;
    _isPlaying = false;
    notifyListeners();
  }

  void setCurrentSong(SongList song) {
    _currentSong = song;
    _isPlaying = true;
    _isLoading = true;
    notifyListeners();
  }

  void setCurrentSongAnnouncement(SongList song) {
    _currentSongAnnouncement = song;
    _isPlaying = true;
    _isLoading = true;
    notifyListeners();
  }

  void setCurrentUserAnnouncement(SongList song) {
    _currentUserAnnouncement = song;
    _isPlaying = true;
    _isLoading = true;
    notifyListeners();
  }

  void setIsPlaying(bool isPlay) {
    if (isPlay) {
      _isLoading = !isPlay;
    }
    _isPlaying = isPlay;
    notifyListeners();
  }

  void setIsLoading(bool isLoad) {
    _isLoading = isLoad;
    notifyListeners();
  }

  void setDuration(int sec) {
    _duration = sec;
    notifyListeners();
  }

  void setPosition(int sec) {
    _position = sec;
    sliderValueNotifier.value = _position;
  }

  void setIsCompetition() {
    _isCompetition = true;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    reset();
  }
}
