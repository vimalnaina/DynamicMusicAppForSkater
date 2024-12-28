import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/competition_response.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/music_player_provider.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/utils/local_database.dart';

class CompetitionSingleScreen extends StatefulWidget {
  const CompetitionSingleScreen({
    super.key,
    required this.competitionData,
    required this.allSongs,
  });

  final CompetitionData competitionData;
  final List<SongList> allSongs;

  @override
  State<CompetitionSingleScreen> createState() =>
      _CompetitionSingleScreenState();
}

class _CompetitionSingleScreenState extends State<CompetitionSingleScreen> {
  late SongProvider songProvider;
  late MusicPlayerProvider musicPlayerProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      songProvider = Provider.of<SongProvider>(context, listen: false);

      musicPlayerProvider.reset();
      setData();
    });
  }

  setData() {
    List<String> songIds = widget.competitionData.songUserPairs!
        .map((pair) => pair.songId) // Extract songId
        .whereType<String>() // Remove null values
        .toList();
    List<SongList> songLists =
        widget.allSongs.where((song) => songIds.contains(song.songId)).toList();
    musicPlayerProvider.changeSongList(songLists);
  }

  @override
  Widget build(BuildContext context) {
    musicPlayerProvider = Provider.of<MusicPlayerProvider>(context);
    return SafeArea(
      child: Container(
        margin:
            EdgeInsets.only(top: 5.sp, bottom: 2.sp, right: 2.sp, left: 1.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
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
                "# ${widget.competitionData.listName}",
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s20,
                ),
              ),
            ),
            widget.competitionData.songUserPairs != null
                ? Padding(
                    padding: EdgeInsets.only(top: 5.sp),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: musicPlayerProvider.currentSongList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CompetitionItemWidget(
                          songData: musicPlayerProvider.currentSongList[index],
                          skaterName: widget
                              .competitionData.songUserPairs![index].userName!,
                          onSongClick: (songData) {
                            musicPlayerProvider.changeSong(songData);
                          },
                          index: index,
                          provider: songProvider,
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

class CompetitionItemWidget extends StatefulWidget {
  const CompetitionItemWidget({
    super.key,
    required this.index,
    required this.songData,
    required this.skaterName,
    required this.onSongClick,
    required this.provider,
  });

  final int index;
  final SongList songData;
  final String skaterName;
  final Function(SongList) onSongClick;
  final SongProvider provider;

  @override
  State<CompetitionItemWidget> createState() => _CompetitionItemWidgetState();
}

class _CompetitionItemWidgetState extends State<CompetitionItemWidget> {
  Uint8List? imageData;
  late LocalDatabase db;

  @override
  void initState() {
    super.initState();
    db = LocalDatabase();
  }

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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.sp),
                  child: imageData != null
                      ? Image.memory(
                          imageData!,
                          width: 10.sp,
                          height: 10.sp,
                          errorBuilder: (context, url, error) => Container(),
                          fit: BoxFit.contain,
                        )
                      : Container(
                          width: 10.sp,
                          height: 10.sp,
                          decoration: BoxDecoration(
                            color: ColorManager.grey,
                            borderRadius: BorderRadius.circular(2.sp),
                          ),
                        ),
                  // child: CachedNetworkImage(
                  //   imageUrl: "${widget.songData.imageId}",
                  //   width: 10.sp,
                  //   height: 10.sp,
                  //   fadeInCurve: Curves.easeIn,
                  //   fit: BoxFit.contain,
                  //   errorWidget: (context, url, error) => Container(),
                  //   fadeInDuration: const Duration(seconds: 1),
                  // ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_run,
                          color: ColorManager.white, // Icon color
                          size: 16.0, // Icon size
                        ),
                        Text('${widget.skaterName ?? "-"}: ',
                            style: getBoldStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s16,
                            )),
                        Icon(
                          Icons.music_note,
                          color: ColorManager.white, // Icon color
                          size: 16.0, // Icon size
                        ),
                        Text(
                          widget.songData.name ?? "-",
                          style: getMediumStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                      ],
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
            ],
          ),
        ),
      ),
    );
  }
}
