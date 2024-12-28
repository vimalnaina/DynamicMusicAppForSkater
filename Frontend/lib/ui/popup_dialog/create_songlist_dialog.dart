import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/favourite_songlist_response.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/model/songlist/user_response.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/widgets/custom_buttons.dart';
import 'package:skating_app/widgets/custom_form_fields.dart';

import '../../provider/user_provider.dart';
import 'select_song_dialog.dart';

class CreateSongListDialog extends StatefulWidget {
  const CreateSongListDialog({Key? key, this.timeLimit = 0}) : super(key: key);

  final int timeLimit;

  @override
  State<CreateSongListDialog> createState() => _CreateSongListDialogState();
}

class _CreateSongListDialogState extends State<CreateSongListDialog> {
  @override
  void initState() {
    super.initState();
  }

  void _submit(Map<String, dynamic> result) {
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          insetPadding: EdgeInsets.all(2.sp),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.sp),
          ),
          elevation: 10,
          backgroundColor: ColorManager.colorPrimary,
          child: DialogContent(
            onSubmit: (result) {
              _submit(result);
            },
            timeLimit: widget.timeLimit,
          ),
        ),
      ),
    );
  }
}

class DialogContent extends StatefulWidget {
  const DialogContent({super.key, required this.onSubmit, this.timeLimit = 0});

  final Function(Map<String, dynamic>) onSubmit;
  final int timeLimit;

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  TextEditingController songListNameController = TextEditingController();
  final PageController _pageController = PageController();

  Map<String, dynamic> result = {};

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    // Change page programmatically with animation
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.timeLimit == 0
                      ? "Create a practice list"
                      : "Create a practice list within ${AppUtils.formatDuration(widget.timeLimit)}",
                  style: getBoldStyle(
                    fontSize: FontSize.s20,
                    color: ColorManager.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.sp),
                child: InkWell(
                  child: Icon(
                    Icons.close,
                    size: 8.sp,
                    color: ColorManager.white,
                  ),
                  onTap: () {
                    Navigator.pop(context, null);
                  },
                ),
              ),
            ],
          ),
          Flexible(
            child: PageView.builder(
              controller: _pageController,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return [
                  ExpandableFormPage(
                    onNext: (data) {
                      result = data;
                      setState(() {});
                      _goToPage(1);
                    },
                    timeLimit: widget.timeLimit,
                  ),
                  SongListTitlePage(
                    onCreate: (data) {
                      setState(() {
                        result.addAll(data);
                      });
                      widget.onSubmit(result);
                    },
                  ),
                ][index];
              },
              itemCount: 2, // Number of pages
            ),
          ),
        ],
      ),
    );
  }
}

class SelectedSongSkaterPair {
  SongList? songData;
  SkaterData? skaterData;

  SelectedSongSkaterPair({this.songData, this.skaterData});
}

class ExpandableFormPage extends StatefulWidget {
  const ExpandableFormPage(
      {super.key, required this.onNext, this.timeLimit = 0});

  final Function(Map<String, dynamic>) onNext;
  final int timeLimit;

  @override
  State<ExpandableFormPage> createState() => _ExpandableFormPageState();
}

class _ExpandableFormPageState extends State<ExpandableFormPage> {
  late SongProvider songProvider;
  late UserProvider userProvider;

  //List<SongList> songList = [];
  //List<SkaterData> skaterList = [];
  List<SongList?> selectedSongs = [null]; // List of songs
  List<FavouriteSong> favouriteSongs = []; // List of recommended songs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      songProvider = Provider.of<SongProvider>(context, listen: false);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      fetchFavouriteSongs();
      //fetchSongsAndSkaters();
      //fetchSkaters();
    });
  }

  Future<void> fetchFavouriteSongs() async {
    AppUtils.showLoaderDialog(context, true);
    songProvider.getFavouriteSongList(context: context).then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        FavouriteSongListResponse favouriteSongListResponse =
            FavouriteSongListResponse.fromJson(response["data"]);
        print("favouriteSongs successful");
        print(favouriteSongListResponse);
        if (favouriteSongListResponse.code == 1) {
          favouriteSongs = favouriteSongListResponse.data ?? [];
          print("favouriteSongs successful");
          print(favouriteSongs);
          setState(() {});
        }
      }
    });
  }

/* 
  Future<void> fetchSongsAndSkaters() async {
    AppUtils.showLoaderDialog(context, true);

    // Fetch songs by difficulty
    await songProvider
        .songListByLevel(
          level: widget.data["difficulty"]["level"],
          context: context,
        )
        .then((response) {
      if (response["status"]) {
        SongListByLevelResponse songListResponse =
            SongListByLevelResponse.fromJson(response["data"]);
        if (songListResponse.code == 1) {
          songList = songListResponse.data ?? [];
        }
      }
    });

    // Fetch all skaters
    await userProvider.getAllSkaters(context: context).then((response) {
      if (response["status"]) {
        AllSkatersResponse skatersResponse =
            AllSkatersResponse.fromJson(response["data"]);
        if (skatersResponse.code == 1) {
          skaterList = skatersResponse.data ?? [];
        }
      }
    }); 

    AppUtils.showLoaderDialog(context, false);
    setState(() {});
  }*/
/* 
  Future<void> fetchSkaters() async {
    AppUtils.showLoaderDialog(context, true);

    // Fetch all skaters
    await userProvider.getAllSkaters(context: context).then((response) {
      if (response["status"]) {
        AllSkatersResponse skatersResponse =
            AllSkatersResponse.fromJson(response["data"]);
        if (skatersResponse.code == 1) {
          skaterList = skatersResponse.data ?? [];
        }
      }
    });

    AppUtils.showLoaderDialog(context, false);
    setState(() {});
  } */
  void appendFavouriteSong(SongList song) {
    if (selectedSongs.last == null) selectedSongs.removeLast();
    setState(() {
      selectedSongs.add(song);
    });
  }

  void addRow() {
    setState(() {
      selectedSongs.add(null);
    });
  }

  void removeRow(int index) {
    setState(() {
      selectedSongs.removeAt(index);
    });
  }

  void updateRow(int index, SongList? songData) {
    setState(() {
      selectedSongs[index] = songData;
    });
  }

  int calculateDuration() {
    return selectedSongs.fold(
        0, (sum, item) => sum + (item == null ? 0 : item.duration!));
  }

  openSelectSongDialog(int index) async {
    final Map<String, dynamic>? results = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return widget.timeLimit == 0
              ? const SelectSongDialog()
              : SelectSongDialog(
                  timeLimit: widget.timeLimit - calculateDuration());
        });

    // Update UI
    if (results != null) {
      if (widget.timeLimit == 0 ||
          widget.timeLimit >=
              calculateDuration() + results["songData"].duration) {
        updateRow(index, results["songData"]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Time limit exceeded',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  final ScrollController songListScroll = ScrollController();
  final ScrollController recommendationsScroll = ScrollController();
  final ScrollController containerScroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    final remainingTime =
        widget.timeLimit > 0 ? widget.timeLimit - calculateDuration() : null;

    final screenHeight = MediaQuery.of(context).size.height;

    return Scrollbar(
      controller: containerScroll,
      child: SingleChildScrollView(
        controller: containerScroll,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 6.sp, bottom: 4.sp),
                        child: Text(
                          "Select songs",
                          style: getMediumStyle(
                            fontSize: FontSize.s18,
                            color: ColorManager.white,
                          ),
                        ),
                      ),

                      // Song List Section
                      SizedBox(
                        height: screenHeight * 0.5, // 50% of the screen height
                        child: Scrollbar(
                          controller: songListScroll,
                          child: ListView.builder(
                            controller: songListScroll,
                            itemCount: selectedSongs.length,
                            itemBuilder: (context, index) {
                              final song = selectedSongs[index];
                              return Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => openSelectSongDialog(index),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: ColorManager.white),
                                          borderRadius: BorderRadius.circular(2.sp)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              song?.name ?? "Select Song",
                                              style: getRegularStyle(
                                                color: ColorManager.white,
                                                fontSize: FontSize.s14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            if (song?.duration != null) ...[
                                              SizedBox(width: 4.sp),
                                              Icon(
                                                Icons.access_time,
                                                color: ColorManager.white,
                                                size: 4.sp,
                                              ),
                                              SizedBox(width: 4.sp),
                                              Text(
                                                AppUtils.formatDuration(song!.duration!),
                                                style: getRegularStyle(
                                                  color: ColorManager.white,
                                                  fontSize: FontSize.s14,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_circle,
                                      color: ColorManager.white,
                                    ),
                                    onPressed: selectedSongs.length > 1
                                        ? () => removeRow(index)
                                        : () {
                                            updateRow(index, null);
                                          },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 4.sp),

                      // Add Line Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.add, color: ColorManager.white),
                          label: Text(
                            "Add Line",
                            style: getRegularStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s14,
                            ),
                          ),
                          onPressed: addRow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.colorPrimary,
                          ),
                        ),
                      ),

                      SizedBox(height: 6.sp),

                    ],
                  ),
                ),
                SizedBox(width: 6.sp),
                Expanded(
                  child: Column(
                    children: [
                      // Recommendation Section
                      if (favouriteSongs.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.timeLimit > 0
                                  ? "Recommended Songs (${remainingTime ?? 0} seconds remaining)"
                                  : "Recommended Songs",
                              style: getBoldStyle(
                                fontSize: FontSize.s18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.sp),
                            SizedBox(
                              height: screenHeight * 0.5, // 20% of the screen height
                              child: Scrollbar(
                                controller: recommendationsScroll,
                                child: ListView.builder(
                                  controller: recommendationsScroll,
                                  scrollDirection: Axis.vertical, // Vertical scrolling
                                  itemCount: favouriteSongs.length,
                                  itemBuilder: (context, index) {
                                    final song = favouriteSongs[index].song;
                                    final bool isDisabled = remainingTime != null &&
                                        song != null &&
                                        song.duration! > remainingTime;

                                    return InkWell(
                                      onTap: isDisabled
                                          ? null // Disable onTap if the song is unavailable
                                          : () {
                                        if (song != null) {
                                          appendFavouriteSong(song);
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 2.sp),
                                        padding: EdgeInsets.all(4.sp),
                                        width: double.infinity, // Take the full width
                                        decoration: BoxDecoration(
                                          color: isDisabled
                                              ? ColorManager
                                              .grey // Use a different color for disabled
                                              : ColorManager.colorSecondary,
                                          borderRadius: BorderRadius.circular(4.sp),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2, horizontal: 4),
                                                  decoration: BoxDecoration(
                                                    color: ColorManager.darkGrey,
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    "Lvl. ${song?.difficultyLevel}",
                                                    style: TextStyle(
                                                      color: ColorManager.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  song?.name ?? "Unknown",
                                                  style: getRegularStyle(
                                                    color: isDisabled
                                                        ? ColorManager.lightGrey
                                                        : ColorManager
                                                        .white, // Dim the text if disabled
                                                    fontSize: FontSize.s14,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(width: 4.sp),
                                                Icon(
                                                  Icons.access_time,
                                                  size: 4.sp,
                                                  color: isDisabled
                                                      ? ColorManager.lightGrey
                                                      : ColorManager
                                                      .white, // Dim the icon if disabled
                                                ),
                                                SizedBox(width: 2.sp),
                                                Text(
                                                  AppUtils.formatDuration(
                                                      song?.duration ?? 0),
                                                  style: getRegularStyle(
                                                    color: isDisabled
                                                        ? ColorManager.lightGrey
                                                        : ColorManager
                                                        .white, // Dim the text if disabled
                                                    fontSize: FontSize.s12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2.sp),
                                            Row(
                                              children: [
                                                Text(
                                                  song?.singer ?? "Unknown",
                                                  style: getRegularStyle(
                                                    color: isDisabled
                                                        ? ColorManager.lightGrey
                                                        : ColorManager
                                                        .white, // Dim the text if disabled
                                                    fontSize: FontSize.s12,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(height: 6.sp),
                    ],
                  ),
                )
              ],
            ),
            // Next Button
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 20.w,
                child: CustomButton(
                  textColor: ColorManager.white,
                  onClick: () {
                    bool isValid = true;

                    // Check if any song is null in selected pairs
                    for (var song in selectedSongs) {
                      if (song == null) {
                        isValid = false;
                        break;
                      }
                    }

                    if (!isValid) {
                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select a song for each row.',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    widget.onNext(
                        {"songListData": List<SongList>.from(selectedSongs)});
                  },
                  title: 'Next',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SongListTitlePage extends StatefulWidget {
  const SongListTitlePage({super.key, required this.onCreate});

  final Function(Map<String, dynamic>) onCreate;

  @override
  State<SongListTitlePage> createState() => _SongListTitlePageState();
}

class _SongListTitlePageState extends State<SongListTitlePage> {
  TextEditingController songNameController = TextEditingController();
  TextEditingController songDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 6.sp),
                child: CustomTextField(
                  controller: songNameController,
                  hint: "Enter song list name",
                  hintStyle: getRegularStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s15,
                  ),
                  textStyle: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.sp),
                child: CustomTextAreaField(
                  controller: songDescriptionController,
                  hint: "Enter song list description",
                  hintStyle: getRegularStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s15,
                  ),
                  textStyle: getMediumStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s15,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.sp),
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 20.w,
              child: CustomButton(
                textColor: ColorManager.white,
                onClick: () {
                  widget.onCreate({
                    "name": songNameController.text,
                    "description": songDescriptionController.text,
                  });
                },
                title: 'Create',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
