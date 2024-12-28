import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/login/login_response.dart';
import 'package:skating_app/model/songlist/all_songlist_response.dart';
import 'package:skating_app/model/songlist/create_songlist_request.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/db_menu_provider.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/popup_dialog/create_songlist_dialog.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';

class PracticeTab extends StatefulWidget {
  const PracticeTab({
    super.key,
    //required this.songList,
    required this.onSongClick,
    this.onListItemClick = _defaultOnListItemClick,
    this.timeLimit = 0,
  });

  //final List<SongList> songList;
  final Function(SongList) onSongClick;
  final int timeLimit;
  final Function(SongListData) onListItemClick;
  static void _defaultOnListItemClick(SongListData data) {}

  @override
  State<PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<PracticeTab> {
  late SongProvider songProvider;
  late DBMenuProvider menuProvider;
  List<SongList> songList = [];
  List<SongListData> allSongList = [];
  UserData? userData;
  int myIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      songProvider = Provider.of<SongProvider>(context, listen: false);
      menuProvider = Provider.of<DBMenuProvider>(context, listen: false);
      menuProvider.addListener(_listenerCallback);
      getAllSongList();
      getUserData();
    });
  }

  void _listenerCallback() {
    if (menuProvider.isReload) {
      if (menuProvider.selectedIndex == myIndex) {
        print("callled===");
        menuProvider.resetReload();
        getAllSongList();
      }
    }
  }

  getUserData() async {
    userData = UserData.fromJson(await PreferenceManager.getUserData());
    setState(() {});
  }

  getAllSongList() async {
    AppUtils.showLoaderDialog(context, true);

    songProvider.getAllSongLists(context: context).then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        AllSongListResponse songListResponse =
            AllSongListResponse.fromJson(response["data"]);
        if (songListResponse.code == 1) {
          allSongList = songListResponse.data ?? [];
          setState(() {});
        }
      }
    });
  }

  openSelectSongsDialog() async {
    final Map<String, dynamic>? results = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CreateSongListDialog(
            timeLimit: widget.timeLimit,
          );
        });

    // Update UI
    if (results != null) {
      print("result====$results");
      String name = results["name"];
      String description = results["description"];
      List<SongList> selectedSongs = results["songListData"];
      List<String> songIds = [];
      selectedSongs.forEach((element) {
        songIds.add(element.songId!);
      });
      String uId =
          UserData.fromJson(await PreferenceManager.getUserData()).id ?? "";

      CreateSongListRequest createSongListRequest = CreateSongListRequest(
        userId: uId,
        description: description,
        listName: name,
        songIds: songIds,
      );
      await createSongList(createSongListRequest);
      await getAllSongList();
      setState(() {});
    }
  }

  createSongList(CreateSongListRequest requestModel) async {
    AppUtils.showLoaderDialog(context, true);

    await songProvider
        .createSongList(context: context, requestModel: requestModel)
        .then((response) async {
      AppUtils.showLoaderDialog(context, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.sp),
            child: SizedBox(
              width: 20.w,
              child: CustomButton(
                  title: "+ Create Song List",
                  onClick: () {
                    openSelectSongsDialog();
                  }),
            ),
          ),
        ),
        Text(
          "# ${userData?.userName}'s SongLists",
          style: getMediumStyle(
            color: ColorManager.white,
            fontSize: FontSize.s18,
          ),
          textAlign: TextAlign.center,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allSongList.length,
            itemBuilder: (BuildContext context, int index) {
              int duration = allSongList[index]
                  .songList!
                  .fold(0, (sum, item) => sum + item.duration!);
              return Padding(
                padding: EdgeInsets.only(
                    top: 4.sp, bottom: index == allSongList.length ? 2.sp : 0),
                child: SongListWidget(
                  data: allSongList[index],
                  onClick: (data) {
                    if (widget.timeLimit == 0) {
                      menuProvider.toggleSongListAndHome(args: data);
                    } else {
                      if (duration > widget.timeLimit) {
                        return;
                      } else {
                        Navigator.pop(context, {"songListData": data});
                        //widget.onListItemClick(data);
                      }
                    }
                  },
                  unavailable:
                      widget.timeLimit > 0 && duration > widget.timeLimit,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SongListWidget extends StatefulWidget {
  const SongListWidget(
      {super.key,
      required this.data,
      required this.onClick,
      this.unavailable = false});

  final SongListData data;
  final Function(SongListData) onClick;
  final bool unavailable;

  @override
  State<SongListWidget> createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onClick(widget.data);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: widget.unavailable ? ColorManager.grey : ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(2.sp),
        ),
        child: Row(
          children: [
            Text(
              widget.data.listName ?? "",
              style: getRegularStyle(
                color:
                    widget.unavailable ? ColorManager.grey : ColorManager.white,
                fontSize: FontSize.s15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              width: 3,
            ),
            Icon(
              Icons.access_time,
              size: 4.sp,
              color:
                  widget.unavailable ? ColorManager.grey : ColorManager.white,
            ),
            Text(
              AppUtils.formatDuration(widget.data.songList!
                  .fold(0, (sum, item) => sum + item.duration!)),
              style: getRegularStyle(
                color:
                    widget.unavailable ? ColorManager.grey : ColorManager.white,
                fontSize: FontSize.s15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
                child: Expanded(
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
