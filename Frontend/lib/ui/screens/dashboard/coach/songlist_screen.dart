import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen(
      {super.key, required this.songList, required this.onSongClick});

  final List<SongList> songList;
  final Function(SongList) onSongClick;

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.songList.length,
            itemBuilder: (BuildContext context, int index) {
              return SongListItemWidget(
                songData: widget.songList[index],
                onSongClick: (songData) {
                  widget.onSongClick(songData);
                },
                index: index,
                provider: SongProvider(),
              );
            },
          ),
        ],
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

  @override
  void initState() {
    super.initState();
    getImage();
    getSong();
  }

  getImage() {
    widget.provider
        .getImage(imageId: "${widget.songData.imageId}", context: context)
        .then((response) {
      setState(() {
        imageData = response;
        widget.songData.image = imageData;
      });
    });
  }

  getSong() {
    widget.provider
        .getSong(songId: "${widget.songData.songId}", context: context)
        .then((response) {
      setState(() {
        songData = response;
        widget.songData.song = imageData;
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
            ],
          ),
        ),
      ),
    );
  }
}
