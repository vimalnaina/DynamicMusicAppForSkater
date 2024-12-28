import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/login/login_response.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/music_player_provider.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/utils/debouncer.dart';
import 'package:skating_app/utils/local_database.dart';
import 'package:skating_app/utils/preference_manager.dart';

class MusicPlayerWidget extends StatefulWidget {
  const MusicPlayerWidget({super.key});

  @override
  State<MusicPlayerWidget> createState() => _MusicPlayerWidgetState();
}

class _MusicPlayerWidgetState extends State<MusicPlayerWidget> {
  late AudioPlayer _audioPlayer;
  late MusicPlayerProvider musicPlayerProvider;
  late SongProvider songProvider;
  late LocalDatabase db;
  final Debouncer _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    db = LocalDatabase();

    _audioPlayer.onPositionChanged.listen((Duration p) {
      musicPlayerProvider.setPosition(p.inSeconds);
    });

    _audioPlayer.onPlayerComplete.listen((event) async {
      print("onPlayerComplete==");
      if (musicPlayerProvider.isUserAnnouncement) {
        print("onPlayerComplete==1");
        musicPlayerProvider.resetUserAnnouncementFlag();
      } else if (musicPlayerProvider.isSongAnnouncement) {
        print("onPlayerComplete==2");
        musicPlayerProvider.resetSongAnnouncementFlag();
      } else if (musicPlayerProvider.isSongChange) {
        print("onPlayerComplete==3");
        musicPlayerProvider.changeToNextSong();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      musicPlayerProvider =
          Provider.of<MusicPlayerProvider>(context, listen: false);
      songProvider = Provider.of<SongProvider>(context, listen: false);
      musicPlayerProvider.addListener(_listenerCallback);
    });

    FBroadcast.instance().register("UserAnnouncement", (value, callback) {
      print("called from websocket UserAnnouncement");
      musicPlayerProvider
          .setCurrentUserAnnouncement(SongList(song: value["data"]));
      _playMusic();
    }, context: this);

    FBroadcast.instance().register("SongAnnouncement", (value, callback) async {
      print(
          "called from websocket SongAnnouncement ${value.toString().length}");
      // await db.insertSong(SongList(song: value));
      musicPlayerProvider
          .setCurrentSongAnnouncement(SongList(song: value["data"]));
      _playMusic();
    }, context: this);

    FBroadcast.instance().register("MusicData", (value, callback) {
      // print("called from websocket MusicData");
      // _playMusic(data: value);
    }, context: this);
  }

  void _listenerCallback() {
    if (musicPlayerProvider.isSongChange &&
        musicPlayerProvider.isLoading &&
        !musicPlayerProvider.isPlaying) {
      _debouncer.run(() {
        getSong(musicPlayerProvider.currentSong);
      });
    }

    if (musicPlayerProvider.isUserAnnouncement &&
        musicPlayerProvider.isLoading &&
        !musicPlayerProvider.isPlaying) {
      _debouncer.run(() {
        getUserAnnouncement();
      });
    }

    if (musicPlayerProvider.isSongAnnouncement &&
        musicPlayerProvider.isLoading &&
        !musicPlayerProvider.isPlaying) {
      _debouncer.run(() {
        getSongAnnouncement(musicPlayerProvider.currentSong);
      });
    }
  }

  getUserAnnouncement() async {
    String uId =
        UserData.fromJson(await PreferenceManager.getUserData()).id ?? "";
    await songProvider.getUserAnnouncement(id: uId, context: context);
  }

  getSongAnnouncement(SongList? songData) async {
    print("called getSongAnnouncement");
    if (songData != null) {
      // var song = await db.getAnnouncementsBySongId(songData.songId ?? "");
      // if (song != null) {
      //   songData = song;
      //   musicPlayerProvider.setCurrentSongAnnouncement(songData);
      //   _playMusic();
      // } else {
      await songProvider.getSongAnnouncement(
          id: songData.songId ?? "", context: context);
      //   }
    }
  }

  getSong(SongList? songData) async {
    print("called getSong");
    if (songData != null) {
      var song = await db.getSongById(songData.songId ?? "");

      if (song != null) {
        print("called getSong #1 === length ${song.toString().length}");
        songData = song;
      } else {
        print("called getSong #2");
        String id = songData.songId ?? "";
        var response = await songProvider.getSong(songId: id, context: context);
        songData.song = response;
        await db.insertSong(songData);
      }
      musicPlayerProvider.setCurrentSong(songData);
      _playMusic();
      addRecommend(songData.songId);
    }
  }

  addRecommend(String? id) {
    if (id != null) {
      songProvider.addRecommend(id: id, context: context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("called dispose method ==== ");
    musicPlayerProvider.removeListener(_listenerCallback);
    FBroadcast.instance().unregister(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stopMusic();
    });
  }

  SongList? currentMusic;

  Future<void> _playMusic() async {
    print("called _playMusic");
    try {
      if (musicPlayerProvider.isUserAnnouncement) {
        if (musicPlayerProvider.currentUserAnnouncement != null) {
          if (musicPlayerProvider.currentUserAnnouncement!.song != null) {
            await _audioPlayer.setSourceBytes(
                musicPlayerProvider.currentUserAnnouncement!.song!);
            Duration duration = await _audioPlayer.getDuration() ?? Duration();
            musicPlayerProvider.setDuration(duration.inSeconds);
            await _audioPlayer.resume();

            musicPlayerProvider.setIsPlaying(true);
          }
        } else {
          print("currentUserAnnouncement is null");
        }
      } else if (musicPlayerProvider.isSongAnnouncement) {
        if (musicPlayerProvider.currentSongAnnouncement != null) {
          if (musicPlayerProvider.currentSongAnnouncement!.song != null) {
            await _audioPlayer.setSourceBytes(
                musicPlayerProvider.currentSongAnnouncement!.song!);
            Duration duration = await _audioPlayer.getDuration() ?? Duration();
            musicPlayerProvider.setDuration(duration.inSeconds);
            await _audioPlayer.resume();

            musicPlayerProvider.setIsPlaying(true);
          }
        } else {
          print("currentSongAnnouncement is null");
        }
      } else {
        if (musicPlayerProvider.currentSong != null) {
          if (musicPlayerProvider.currentSong!.song != null) {
            await _audioPlayer
                .setSourceBytes(musicPlayerProvider.currentSong!.song!);
            Duration duration = await _audioPlayer.getDuration() ?? Duration();
            musicPlayerProvider.setDuration(duration.inSeconds);
            await _audioPlayer.resume();

            musicPlayerProvider.setIsPlaying(true);
          }
        } else {
          print("current song is null");
        }
      }
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _pauseMusic() async {
    await _audioPlayer.pause();
    musicPlayerProvider.setIsPlaying(false);
  }

  Future<void> _stopMusic() async {
    await _audioPlayer.stop();
    musicPlayerProvider.setIsPlaying(false);
  }

  String _formatDuration(int duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final minutes =
        twoDigits(Duration(seconds: duration).inMinutes.remainder(60));
    final seconds =
        twoDigits(Duration(seconds: duration).inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Future<Uint8List> getImage(String id) async {
    print("id----$id");
    var img = await db.getImageById(id);
    if (img != null) {
      return img["image"];
    } else {
      final response =
          await songProvider.getImage(imageId: id, context: context);
      await db.insertImage({"imageId": id, "image": response});
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 2.sp, right: 2.sp, bottom: 2.sp),
      decoration: BoxDecoration(
        color: ColorManager.colorAccent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<MusicPlayerProvider>(
              builder: (context, musicPlayerProvider, child) {
            return Row(
              children: [
                ValueListenableBuilder<int>(
                    valueListenable: musicPlayerProvider.sliderValueNotifier,
                    builder: (context, value, child) {
                      return Text(
                        _formatDuration(value),
                        style: getMediumStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s14,
                        ),
                      );
                    }),
                ValueListenableBuilder<int>(
                  valueListenable: musicPlayerProvider.sliderValueNotifier,
                  builder: (context, value, child) {
                    return Expanded(
                      child: Slider(
                        value: musicPlayerProvider.duration > 0
                            ? value.toDouble()
                            : 0.0,
                        min: 0,
                        max: musicPlayerProvider.duration.toDouble() > 0
                            ? musicPlayerProvider.duration.toDouble()
                            : 1.0, // Avoid error
                        onChanged: (double value) async {
                          final position = Duration(seconds: value.toInt());
                          await _audioPlayer.seek(position);
                          if (!musicPlayerProvider.isPlaying) {
                            await _audioPlayer
                                .resume(); // Continue playing after seeking
                          }
                          musicPlayerProvider.setPosition(position.inSeconds);
                          // setState(() {
                          //   _position = position.inSeconds; // Update current position
                          // });
                        },
                      ),
                    );
                  },
                ),
                Text(
                  _formatDuration(musicPlayerProvider.duration),
                  style: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s14,
                  ),
                ),
              ],
            );
          }),
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Consumer<MusicPlayerProvider>(
                      builder: (context, musicPlayerProvider, child) {
                        if (musicPlayerProvider.isLoading) {
                          return Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2.sp),
                                child: Container(
                                  width: 12.sp,
                                  height: 12.sp,
                                  padding: EdgeInsets.all(2.sp),
                                  decoration: BoxDecoration(
                                    color: ColorManager.grey,
                                    borderRadius: BorderRadius.circular(2.sp),
                                  ),
                                  child: CircularProgressIndicator(
                                      color: ColorManager.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Loading...",
                                      style: getBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        if (musicPlayerProvider.isUserAnnouncement) {
                          return Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2.sp),
                                child: Container(
                                  width: 12.sp,
                                  height: 12.sp,
                                  padding: EdgeInsets.all(1.sp),
                                  decoration: BoxDecoration(
                                    color: ColorManager.grey,
                                    borderRadius: BorderRadius.circular(2.sp),
                                  ),
                                  child: Icon(Icons.person_2_outlined),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "User Announcement...",
                                      style: getBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        if (musicPlayerProvider.isSongAnnouncement) {
                          return Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2.sp),
                                child: Container(
                                  width: 12.sp,
                                  height: 12.sp,
                                  padding: EdgeInsets.all(1.sp),
                                  decoration: BoxDecoration(
                                    color: ColorManager.grey,
                                    borderRadius: BorderRadius.circular(2.sp),
                                  ),
                                  child: Icon(Icons.music_note_outlined),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Song Announcement...",
                                      style: getBoldStyle(
                                        color: ColorManager.white,
                                        fontSize: FontSize.s15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        if (musicPlayerProvider.currentSong == null) {
                          return const SizedBox();
                        }
                        return Row(
                          children: [
                            FutureBuilder<Uint8List>(
                              future: getImage(
                                  musicPlayerProvider.currentSong!.imageId ??
                                      ""),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    width: 12.sp,
                                    height: 12.sp,
                                    padding: EdgeInsets.all(2.sp),
                                    child: CircularProgressIndicator(
                                      color: ColorManager.white,
                                    ),
                                  ); // Loading indicator
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error: ${snapshot.error}'); // Error message
                                } else if (snapshot.hasData) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(2.sp),
                                    child: Image.memory(
                                      snapshot.data!,
                                      width: 12.sp,
                                      height: 12.sp,
                                      errorBuilder: (context, url, error) =>
                                          Container(
                                        width: 12.sp,
                                        height: 12.sp,
                                        decoration: BoxDecoration(
                                          color: ColorManager.grey,
                                          borderRadius:
                                              BorderRadius.circular(2.sp),
                                        ),
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                } else {
                                  return Text('No image data found');
                                }
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.sp),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    musicPlayerProvider.currentSong!.name ??
                                        "-",
                                    style: getBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s15,
                                    ),
                                  ),
                                  Text(
                                    musicPlayerProvider.currentSong!.singer ??
                                        "-",
                                    style: getRegularStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        color: Colors.white,
                      ),
                      iconSize: 35,
                      onPressed: () {
                        musicPlayerProvider.changeToPreviousSong();
                      },
                    ),

                    // Conditionally show Play or Pause button
                    Consumer<MusicPlayerProvider>(
                        builder: (context, musicPlayerProvider, child) {
                      return Container(
                        margin: EdgeInsets.only(left: 5.sp),
                        decoration: BoxDecoration(
                          color: ColorManager.colorGrey,
                          borderRadius: BorderRadius.circular(2.sp),
                        ),
                        child: musicPlayerProvider.isPlaying
                            ? IconButton(
                                icon: const Icon(
                                  Icons.pause_rounded,
                                  color: Colors.white,
                                ),
                                iconSize: 35,
                                onPressed: _pauseMusic,
                              )
                            : IconButton(
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                ),
                                iconSize: 35,
                                onPressed: () => _playMusic(),
                              ),
                      );
                    }),
                    Padding(
                      padding: EdgeInsets.only(left: 5.sp),
                      child: IconButton(
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                        ),
                        iconSize: 35,
                        onPressed: () {
                          musicPlayerProvider.changeToNextSong();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
