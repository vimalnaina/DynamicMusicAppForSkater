import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/songlist_by_level_response.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/widgets/custom_buttons.dart';

class SelectSongDialog extends StatefulWidget {
  const SelectSongDialog({Key? key, this.timeLimit}) : super(key: key);

  final int? timeLimit; // Optional time limit

  @override
  State<SelectSongDialog> createState() => _SelectSongDialogState();
}

class _SelectSongDialogState extends State<SelectSongDialog> {
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
  const DialogContent({super.key, required this.onSubmit, this.timeLimit});

  final Function(Map<String, dynamic>) onSubmit;
  final int? timeLimit;

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
                  "Select a song to book appointment",
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
                  SelectSongDifficultyPage(
                    onNext: (data) {
                      result = data;
                      setState(() {});
                      _goToPage(1);
                    },
                  ),
                  SelectSongPage(
                    onNext: (data) {
                      setState(() {
                        result.addAll(data);
                      });
                      widget.onSubmit(result);
                    },
                    data: result,
                    timeLimit: widget.timeLimit,
                  ),
                ][index];
              },
              itemCount: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class SelectSongDifficultyPage extends StatefulWidget {
  const SelectSongDifficultyPage({super.key, required this.onNext});

  final Function(Map<String, dynamic>) onNext;

  @override
  State<SelectSongDifficultyPage> createState() =>
      _SelectSongDifficultyPageState();
}

class _SelectSongDifficultyPageState extends State<SelectSongDifficultyPage> {
  List<Map<String, String>> difficultyLevels = [
    {"level": "1", "name": "Easy"},
    {"level": "2", "name": "Medium"},
    {"level": "3", "name": "Hard"}
  ];
  Map<String, String>? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.sp, bottom: 4.sp),
          child: Text(
            "Select song difficulty level",
            style: getMediumStyle(
              fontSize: FontSize.s18,
              color: ColorManager.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.sp),
          child: ListBody(
            children: difficultyLevels
                .map((item) => InkWell(
                      onTap: () {
                        selectedDifficulty = item;
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.sp, horizontal: 3.sp),
                        margin: EdgeInsets.only(top: 1.sp),
                        decoration: BoxDecoration(
                          color: selectedDifficulty == item
                              ? ColorManager.white
                              : Colors.transparent,
                          border:
                              Border.all(color: ColorManager.white, width: 1),
                          borderRadius: BorderRadius.circular(1.sp),
                        ),
                        child: Row(
                          children: [
                            Text(
                              item["name"] ?? "",
                              style: getRegularStyle(
                                color: selectedDifficulty == item
                                    ? ColorManager.black
                                    : ColorManager.white,
                                fontSize: FontSize.s16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
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
                  if (selectedDifficulty != null) {
                    widget.onNext({"difficulty": selectedDifficulty});
                  } else {
                    AppUtils.showErrorSnackBar(
                        context, "Please select song difficulty level");
                  }
                },
                title: 'Next',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SelectSongPage extends StatefulWidget {
  const SelectSongPage(
      {super.key, required this.onNext, required this.data, this.timeLimit});

  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onNext;
  final int? timeLimit;

  @override
  State<SelectSongPage> createState() => _SelectSongPageState();
}

class _SelectSongPageState extends State<SelectSongPage> {
  late SongProvider songProvider;
  SongList? selectedSong;
  List<SongList> songList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      songProvider = Provider.of<SongProvider>(context, listen: false);
      getAllSongListByLevel();
    });
  }

  getAllSongListByLevel() async {
    AppUtils.showLoaderDialog(context, true);

    songProvider
        .songListByLevel(
            level: widget.data["difficulty"]["level"], context: context)
        .then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        SongListByLevelResponse songListResponse =
            SongListByLevelResponse.fromJson(response["data"]);
        if (songListResponse.code == 1) {
          songList = songListResponse.data ?? [];
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.sp),
          child: ListBody(
            children: songList.map((item) {
              final bool isDisabled = widget.timeLimit != null &&
                  item.duration! > widget.timeLimit!;
              return InkWell(
                onTap: isDisabled
                    ? null
                    : () {
                        selectedSong = item;
                        setState(() {});
                      },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.sp, vertical: 2.sp),
                  margin: EdgeInsets.only(top: 1.sp),
                  decoration: BoxDecoration(
                    color: selectedSong == item
                        ? ColorManager.white
                        : isDisabled
                            ? ColorManager.grey
                            : Colors.transparent,
                    border: Border.all(color: ColorManager.white, width: 1),
                    borderRadius: BorderRadius.circular(1.sp),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name ?? "",
                        style: getRegularStyle(
                          color: selectedSong == item
                              ? ColorManager.black
                              : isDisabled
                                  ? ColorManager.lightGrey
                                  : ColorManager.white,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      Text(
                        AppUtils.formatDuration(item.duration ?? 0),
                        style: getRegularStyle(
                          color: isDisabled
                              ? ColorManager.lightGrey
                              : ColorManager.white,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
                  if (selectedSong != null) {
                    widget.onNext({"songData": selectedSong});
                  } else {
                    AppUtils.showErrorSnackBar(context, "Please select a song");
                  }
                },
                title: 'Submit',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
