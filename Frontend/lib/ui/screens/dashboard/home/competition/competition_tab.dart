import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/login/login_response.dart';
import 'package:skating_app/model/songlist/all_competition_response.dart';
import 'package:skating_app/model/songlist/competition_response.dart';
import 'package:skating_app/model/songlist/create_competition_request.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/model/songlist/songlist_response_by_level.dart';
import 'package:skating_app/provider/db_menu_provider_coach.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/popup_dialog/create_competition_dialog.dart';
import 'package:skating_app/ui/screens/dashboard/home/competition/competition_single_screen.dart';
import 'package:skating_app/ui/screens/dashboard/home/competition/competition_songlist_screen.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';

class CompetitionTab extends StatefulWidget {
  const CompetitionTab({super.key, required this.userType});

  final int userType;

  @override
  State<CompetitionTab> createState() => _CompetitionTabState();
}

class _CompetitionTabState extends State<CompetitionTab> {
  late SongProvider songProvider;
  late DBMenuProviderCoach menuProvider;
  List<CompetitionData> allCompetitions = [];
  List<SongListData> allSongListData = [];
  List<SongList> songList = [];
  UserData? userData;
  int myIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      songProvider = Provider.of<SongProvider>(context, listen: false);
      menuProvider = Provider.of<DBMenuProviderCoach>(context, listen: false);
      menuProvider.addListener(_listenerCallback);
      getSongList();
      getAllCompetitions();
      getUserData();
    });
  }

  void _listenerCallback() {
    if (menuProvider.isReload) {
      if (menuProvider.selectedIndex == myIndex) {
        menuProvider.resetReload();
        getSongList();
        getAllCompetitions();
        getUserData();
      }
    }
  }

  Future<void> getSongList() async {
    songList = [];
    AppUtils.showLoaderDialog(context, true);

    List<Future<Map<String, dynamic>>> requests = [];
    for (int level = 1; level <= 3; level++) {
      requests.add(songProvider.songListByLevel(
          context: context, level: level.toString()));
    }

    List<Map<String, dynamic>> responses = await Future.wait(requests);
    List<SongList> combinedSongList = [];

    for (var response in responses) {
      if (response["status"]) {
        SongListResponseByLevel songListResponse =
            SongListResponseByLevel.fromJson(response["data"]);
        if (songListResponse.code == 1) {
          combinedSongList.addAll(songListResponse.data ?? []);
        }
      }
    }

    AppUtils.showLoaderDialog(context, false);

    // Update state with the combined list
    setState(() {
      songList = combinedSongList;
    });
  }

  getUserData() async {
    userData = UserData.fromJson(await PreferenceManager.getUserData());
    setState(() {});
  }

  getAllCompetitions() async {
    allCompetitions = [];
    allSongListData = [];
    AppUtils.showLoaderDialog(context, true);
    songProvider.getAllRaceLists(context: context).then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        AllCompetitionResponse competitionResponse =
            AllCompetitionResponse.fromJson(response["data"]);
        if (competitionResponse.code == 1) {
          allCompetitions = competitionResponse.data ?? [];
          allCompetitions.forEach((competition) {
            SongListData songListData = SongListData();

            List<String> songIds = competition.songUserPairs!
                .map((pair) => pair.songId) // Extract songId
                .whereType<String>() // Filter out null values
                .toList();

            // Step 1: Extract songId, userId, and userName into a Map
            Map<String, Map<String, String>> songIdToUserData = {
              for (var pair in competition.songUserPairs!)
                if (pair.songId != null)
                  pair.songId!: {
                    'userId': pair.userId ?? '',
                    'userName': pair.userName ?? '',
                  }
            };

            // Step 2: Update userId and userName in songLists
            List<SongList> updatedSongLists = songList
                .where((song) => songIds.contains(song.songId)) // Filter songs
                .map((song) {
              var userData = songIdToUserData[song.songId];
              if (userData != null) {
                song.userId = userData['userId']!; // Update userId
                song.userName = userData['userName']!; // Update userName
              }
              return song; // Return updated song
            }).toList();

            songListData.songList = updatedSongLists;
            songListData.songlistId = competition.songlistId;
            songListData.listName = competition.listName;
            songListData.createTime = competition.createTime;
            songListData.description = competition.description;
            songListData.userId = competition.userId;

            allSongListData.add(songListData);
          });
          setState(() {});
        }
      }
    });
  }

  openCreateCompetitionDialog() async {
    final Map<String, dynamic>? results = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const CreateCompetitionDialog();
      },
    );

    if (results != null) {
      String name = results["name"];
      String description = results["description"];
      List<SelectedSongSkaterPair> selectedPairs = results["selectedPairs"];
      List<SongUserPairCreation> songUserPairs = selectedPairs.map((pair) {
        return SongUserPairCreation(
          songId: pair.songData?.songId,
          userId: pair.skaterData?.id,
          userName: pair.skaterData?.userName,
        );
      }).toList();

      String uId =
          UserData.fromJson(await PreferenceManager.getUserData()).id ?? "";

      CreateCompetitionRequest request = CreateCompetitionRequest(
        userId: uId,
        description: description,
        listName: name,
        songUserPairs: songUserPairs,
      );

      await createCompetition(request);
      await getAllCompetitions();
    }
  }

  createCompetition(CreateCompetitionRequest requestModel) async {
    AppUtils.showLoaderDialog(context, true);
    await songProvider
        .createRaceList(context: context, requestModel: requestModel)
        .then((response) {
      AppUtils.showLoaderDialog(context, false);
    });
  }

  void openCompetitionDialog(CompetitionData competitionData) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
              child: SizedBox(
                width: 100.w,
                height: 80.h,
                child: CompetitionSingleScreen(
                  competitionData: competitionData,
                  allSongs: songList, // Pass the appropriate list of songs
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Create Competition Button
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.sp),
            child: SizedBox(
              width: 20.w,
              child: CustomButton(
                title: "+ Create Competition",
                onClick: openCreateCompetitionDialog,
              ),
            ),
          ),
        ),

        // User's Competitions Header
        Text(
          "# ${userData?.userName}'s Competitions",
          style: getMediumStyle(
            color: ColorManager.white,
            fontSize: FontSize.s18,
          ),
          textAlign: TextAlign.center,
        ),

        // List of Competitions
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allSongListData.length,
            itemBuilder: (BuildContext context, int index) {
              final competitionData = allSongListData[index];
              return Padding(
                padding: EdgeInsets.only(
                    top: 4.sp,
                    bottom: index == allSongListData.length - 1 ? 2.sp : 0),
                child: CompetitionWidget(
                  data: competitionData,
                  onClick: (data) {
                    menuProvider.toggleCompetitionAndHome(args: data);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CompetitionWidget extends StatefulWidget {
  const CompetitionWidget({
    super.key,
    required this.data,
    required this.onClick,
  });

  final SongListData data;
  final Function(SongListData) onClick;

  @override
  State<CompetitionWidget> createState() => _CompetitionWidgetState();
}

class _CompetitionWidgetState extends State<CompetitionWidget> {
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
            color: ColorManager.white,
          ),
          borderRadius: BorderRadius.circular(2.sp),
        ),
        child: Row(
          children: [
            Text(
              widget.data.listName ?? "",
              style: getRegularStyle(
                color: ColorManager.white,
                fontSize: FontSize.s15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompetitionModel {
  String? id;
  String? name;
  List<SongUserPair>? songUserPairs;

  CompetitionModel({this.id, this.name, this.songUserPairs});
}
