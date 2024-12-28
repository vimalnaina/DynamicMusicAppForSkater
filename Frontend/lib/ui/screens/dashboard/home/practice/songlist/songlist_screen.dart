import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/db_menu_provider.dart';
import 'package:skating_app/provider/music_player_provider.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/provider/songlist_screen_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/services/websocket_service.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/global_variable.dart';
import 'package:skating_app/utils/local_database.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen(
      {super.key, required this.songList, required this.onSongClick});

  final List<SongList> songList;
  final Function(SongList) onSongClick;

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late SongProvider songProvider;
  late DBMenuProvider dbMenuProvider;
  late SonglistScreenProvider songlistScreenProvider;
  late MusicPlayerProvider musicPlayerProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dbMenuProvider = Provider.of<DBMenuProvider>(context, listen: false);
      songlistScreenProvider =
          Provider.of<SonglistScreenProvider>(context, listen: false);
      musicPlayerProvider =
          Provider.of<MusicPlayerProvider>(context, listen: false);
      // musicPlayerProvider.openMusicPlayerFlag();
      musicPlayerProvider.reset();
      // getSongListDataById();
      setData();
    });
  }

  setData() async {
    musicPlayerProvider
        .changeSongList(dbMenuProvider.songListArgs?.songList ?? []);
    songlistScreenProvider.setData(dbMenuProvider.songListArgs);
  }

  // getSongListDataById() async {
  //   AppUtils.showLoaderDialog(context, true);
  //
  //   print("getSongListDataById = ${dbMenuProvider.songListArgs!.songlistId!}");
  //
  //   songProvider
  //       .getSongListDataById(
  //           id: dbMenuProvider.songListArgs!.songlistId!, context: context)
  //       .then((response) async {
  //     AppUtils.showLoaderDialog(context, false);
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    // musicPlayerProvider.resetOpenMusicPlayerFlag();
  }

  @override
  Widget build(BuildContext context) {
    songProvider = Provider.of<SongProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        print("called");
        musicPlayerProvider.reset();
        final menuProvider =
            Provider.of<DBMenuProvider>(context, listen: false);
        menuProvider.toggleSongListAndHome();
        return true;
      },
      child: SafeArea(
        child: Consumer<SonglistScreenProvider>(
            builder: (context, provider, child) {
          return Container(
            margin: EdgeInsets.only(
                top: 5.sp, bottom: 2.sp, right: 2.sp, left: 1.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    musicPlayerProvider.reset();
                    final menuProvider =
                        Provider.of<DBMenuProvider>(context, listen: false);
                    menuProvider.toggleSongListAndHome();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: 5.sp,
                        color: ColorManager.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1.sp),
                        child: Text(
                          "Back",
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.sp),
                  child: Text(
                    "# ${provider.data?.listName}",
                    style: getBoldStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s20,
                    ),
                  ),
                ),
                provider.data != null
                    ? Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(top: 5.sp),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.data!.songList!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SongListItemWidget(
                                songData: provider.data!.songList![index],
                                onSongClick: (songData) {
                                  musicPlayerProvider.changeSong(songData);
                                },
                                index: index,
                                provider: songProvider,
                              );
                            },
                          ),
                        ),
                    )
                    : SizedBox(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SongListItemWidget extends StatefulWidget {
  const SongListItemWidget({
    super.key,
    required this.index,
    required this.songData,
    required this.onSongClick,
    required this.provider,
  });

  final int index;
  final SongList songData;
  final Function(SongList) onSongClick;
  final SongProvider provider;

  @override
  State<SongListItemWidget> createState() => _SongListItemWidgetState();
}

class _SongListItemWidgetState extends State<SongListItemWidget> {
  Uint8List? imageData;
  Uint8List? songData;
  late LocalDatabase db;

  @override
  void initState() {
    super.initState();
    db = LocalDatabase();
    getSong();
  }

  // getImage() {
  //   widget.provider
  //       .getImage(imageId: "${widget.songData.imageId}", context: context)
  //       .then((response) {
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       if (mounted) {
  //         setState(() {
  //           imageData = response;
  //           widget.songData.image = imageData;
  //         });
  //       }
  //     });
  //   });
  // }

  Future<Uint8List> getImage(String id) async {
    var img = await db.getImageById(id);
    if (img != null) {
      return img["image"];
    } else {
      final response =
          await widget.provider.getImage(imageId: id, context: context);
      await db.insertImage({"imageId": id, "image": response});
      return response;
    }
  }

  getSong() {
    widget.provider
        .getSong(songId: "${widget.songData.songId}", context: context)
        .then((response) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          setState(() {
            songData = response;
            widget.songData.song = songData;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSongClick(widget.songData);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.sp),
        decoration: BoxDecoration(
          color: ColorManager.colorAccent,
          borderRadius: BorderRadius.circular(2.sp),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 1.sp),
          child: Row(
            children: [
              Text(
                "#${widget.index + 1}",
                style: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s15,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.sp),
                child: FutureBuilder<Uint8List>(
                  future: getImage(widget.songData.imageId ?? ""),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        width: 10.sp,
                        height: 10.sp,
                        padding: EdgeInsets.all(2.sp),
                        child: CircularProgressIndicator(
                          color: ColorManager.white,
                        ),
                      ); // Loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Error message
                    } else if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(2.sp),
                        child: Image.memory(
                          snapshot.data!,
                          width: 10.sp,
                          height: 10.sp,
                          errorBuilder: (context, url, error) => Container(
                            width: 10.sp,
                            height: 10.sp,
                            decoration: BoxDecoration(
                              color: ColorManager.grey,
                              borderRadius: BorderRadius.circular(2.sp),
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
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 4.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.songData.name ?? "-",
                        style: getMediumStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                      Text(
                        widget.songData.singer ?? "-",
                        style: getRegularStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
