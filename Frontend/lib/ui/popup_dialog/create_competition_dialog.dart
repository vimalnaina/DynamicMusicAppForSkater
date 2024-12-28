import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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

class CreateCompetitionDialog extends StatefulWidget {
  const CreateCompetitionDialog({Key? key}) : super(key: key);

  @override
  State<CreateCompetitionDialog> createState() =>
      _CreateCompetitionDialogState();
}

class _CreateCompetitionDialogState extends State<CreateCompetitionDialog> {
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
          ),
        ),
      ),
    );
  }
}

class DialogContent extends StatefulWidget {
  const DialogContent({super.key, required this.onSubmit});

  final Function(Map<String, dynamic>) onSubmit;

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
                  "Create a competition",
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
  const ExpandableFormPage({super.key, required this.onNext});

  final Function(Map<String, dynamic>) onNext;

  @override
  State<ExpandableFormPage> createState() => _ExpandableFormPageState();
}

class _ExpandableFormPageState extends State<ExpandableFormPage> {
  late SongProvider songProvider;
  late UserProvider userProvider;

  //List<SongList> songList = [];
  List<SkaterData> skaterList = [];
  List<SelectedSongSkaterPair> selectedSongSkaterPairs = [
    SelectedSongSkaterPair(songData: null, skaterData: null)
  ]; // List of song-skater pairs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //songProvider = Provider.of<SongProvider>(context, listen: false);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      //fetchSongsAndSkaters();
      fetchSkaters();
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
  }

  void addRow() {
    setState(() {
      selectedSongSkaterPairs
          .add(SelectedSongSkaterPair(songData: null, skaterData: null));
    });
  }

  void removeRow(int index) {
    setState(() {
      selectedSongSkaterPairs.removeAt(index);
    });
  }

  void updateRow(int index, {SongList? songData, SkaterData? skaterData}) {
    setState(() {
      if (songData != null) {
        selectedSongSkaterPairs[index].songData = songData;
      }
      if (skaterData != null) {
        selectedSongSkaterPairs[index].skaterData = skaterData;
      }
    });
  }

  openSelectSongDialog(int index) async {
    final Map<String, dynamic>? results = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SelectSongDialog();
        });

    // Update UI
    if (results != null) {
      updateRow(index, songData: results["songData"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.sp, bottom: 4.sp),
          child: Text(
            "Select songs and assign skaters",
            style: getMediumStyle(
              fontSize: FontSize.s18,
              color: ColorManager.white,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: selectedSongSkaterPairs.length,
            itemBuilder: (context, index) {
              final pair = selectedSongSkaterPairs[index];
              return Row(
                children: [
                  // Song Dropdown
                  Expanded(
                    child: InkWell(
                      onTap: () => openSelectSongDialog(index),
                      child: Container(
                        padding: EdgeInsets.all(2.sp),
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: ColorManager.white),
                          borderRadius: BorderRadius.circular(2.sp),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pair.songData?.name ?? "Select Song",
                              style: getRegularStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Icon(
                              Icons.arrow_drop_down_outlined,
                              color: ColorManager.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  // Skater Dropdown
                  Expanded(
                    child: CustomDropdownField(
                      hint: "Select Skater",
                      hintStyle: getRegularStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s14,
                      ),
                      textStyle: getRegularStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s14,
                      ),
                      items: skaterList.map((skater) {
                        return DropdownMenuItem<SkaterData>(
                          value: skater,
                          child: Text(
                            skater.userName ?? "Unnamed Skater",
                            style: getRegularStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        updateRow(index, skaterData: value);
                      },
                    ),
                    // DropdownButton<SkaterData>(
                    //   value: pair.skaterData,
                    //   hint: Text(
                    //     "Select Skater",
                    //     style: getRegularStyle(
                    //       color: ColorManager.white,
                    //       fontSize: FontSize.s14,
                    //     ),
                    //   ),
                    //   dropdownColor: ColorManager.colorPrimary,
                    //   items: skaterList.map((skater) {
                    //     return DropdownMenuItem<SkaterData>(
                    //       value: skater,
                    //       child: Text(
                    //         skater.userName ?? "Unnamed Skater",
                    //         style: getRegularStyle(
                    //           color: ColorManager.white,
                    //           fontSize: FontSize.s14,
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     updateRow(index, skaterData: value);
                    //   },
                    // ),
                  ),
                  SizedBox(width: 2.w),
                  // Remove Button
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: ColorManager.white,
                    ),
                    onPressed: selectedSongSkaterPairs.length > 1
                        ? () => removeRow(index)
                        : () {
                            removeRow(index);
                            addRow();
                          },
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 4.sp),
        // Add Row Button
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
        // Next Button
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 20.w,
            child: CustomButton(
              textColor: ColorManager.white,
              onClick: () {
                bool isValid = true;

                // Check if any song or skater is null in selected pairs
                for (var pair in selectedSongSkaterPairs) {
                  if (pair.songData == null || pair.skaterData == null) {
                    isValid = false;
                    break;
                  }
                }

                if (!isValid) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select both a song and a skater for each row.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                widget.onNext({"selectedPairs": selectedSongSkaterPairs});
              },
              title: 'Next',
            ),
          ),
        ),
      ],
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
                  hint: "Enter competition description",
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
