import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/appointment/available_slots_response.dart';
import 'package:skating_app/model/appointment/board_slots_response.dart';
import 'package:skating_app/provider/appointment_provider.dart';
import 'package:skating_app/provider/music_player_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/services/websocket_service.dart';
import 'package:skating_app/ui/screens/authentication/login/login_screen.dart';
import 'package:skating_app/ui/screens/music_player/music_player_widget.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/appointment/board_slots_response.dart';
import 'package:skating_app/provider/appointment_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/authentication/login/login_screen.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/appointment/board_slots_response.dart';
import 'package:skating_app/provider/appointment_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/authentication/login/login_screen.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';

import '../../model/songlist/songlist_response.dart';
import '../../provider/db_menu_provider.dart';
import '../../provider/song_provider.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  static String routeName = '/board';

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  late AppointmentProvider appointmentProvider;
  late DBMenuProvider menuProvider;
  late MusicPlayerProvider musicPlayerProvider;
  late SongProvider songProvider;
  List<BoardSlotData> slotsList = [];
  SongListData? currentList;
  int? selectedIndex = null;
  String? selectedDate;
  bool isUserLoggedIn = false;
  int myIndex = 0;

  final MusicPlayerWidget _musicPlayerWidget = const MusicPlayerWidget();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      appointmentProvider =
          Provider.of<AppointmentProvider>(context, listen: false);
      musicPlayerProvider =
          Provider.of<MusicPlayerProvider>(context, listen: false);
      songProvider = Provider.of<SongProvider>(context, listen: false);
      menuProvider = Provider.of<DBMenuProvider>(context, listen: false);
      menuProvider.addListener(_listenerCallback);

      getUserLoggedIn();
      setCurrentDate();
      fetchAvailableSlots();
    });
  }

  void _listenerCallback() {
    if (menuProvider.isReload) {
      if (menuProvider.selectedIndex == myIndex) {
        menuProvider.resetReload();
        fetchAvailableSlots();
      }
    }
  }

  getUserLoggedIn() async {
    isUserLoggedIn =
        await PreferenceManager.getBoolean(PreferenceManager.IS_LOGIN);
    setState(() {});
  }

  setCurrentDate() {
    selectedDate =
        AppUtils.parseDate(DateTime.now().millisecondsSinceEpoch, "yyyy-MM-dd");

    setState(() {});
  }

  fetchAvailableSlots() {
    AppUtils.showLoaderDialog(context, true);

    print("selectedDate==${selectedDate}");

    appointmentProvider
        .getBoardSlots(date: selectedDate ?? "", context: context)
        .then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        print("got response");
        BoardSlotResponse boardSlotsResponse =
            BoardSlotResponse.fromJson(response["data"]);
        if (boardSlotsResponse.code == 1) {
          print("got data===${boardSlotsResponse.data?.length}");
          slotsList = boardSlotsResponse.data ?? [];
          setState(() {});
        }
      }
    });
  }

  SongListData convertToSongListData(SongListVO songListVO) {
    return SongListData(
      songlistId: songListVO.songlistId,
      listName: songListVO.listName,
      description: songListVO.description,
      createTime: songListVO.createTime,
      userId: songListVO.userId,
      songList: songListVO.songList, // Assuming songList structure matches
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        musicPlayerProvider.reset();
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorManager.colorPrimary,
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 600;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !isUserLoggedIn
                      ? Padding(
                          padding: EdgeInsets.only(top: 8, right: 5.sp),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 15.w,
                              child: CustomButton(
                                title: "Login / SignUp",
                                onClick: () {
                                  Navigator.pushNamed(
                                      context, LoginScreen.routeName);
                                },
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(top: 8, left: 8),
                    child: Text(
                      "Scheduled board",
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s26,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: ColorManager.white),
                      borderRadius: BorderRadius.circular(2.sp),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 1.sp, horizontal: 2.sp),
                          decoration: BoxDecoration(
                            color: ColorManager.colorAccent,
                            borderRadius: BorderRadius.circular(2.sp),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Start Time",
                                  style: getBoldStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "End Time",
                                  style: getBoldStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "User",
                                  style: getBoldStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Song List",
                                  style: getBoldStyle(
                                    color: Colors.white,
                                    fontSize: FontSize.s16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                                child: const Icon(Icons.play_arrow,
                                    color: Colors.transparent),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: slotsList.length,
                          itemBuilder: (context, index) {
                            final slot = slotsList[index];
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.sp, horizontal: 2.sp),
                              decoration: BoxDecoration(
                                color: (selectedIndex == index)
                                    ? ColorManager.colorSecondary
                                    : null,
                                border: Border(
                                  bottom: BorderSide(
                                    color: ColorManager.white,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      DateFormat.Hm().format(slot.startTime),
                                      style: getRegularStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.s16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      DateFormat.Hm().format(slot.endTime),
                                      style: getRegularStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.s16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      slot.userName ?? "N/A",
                                      style: getRegularStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.s16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      slot.songListVO.listName ?? "N/A",
                                      style: getRegularStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.s16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                    child: IconButton(
                                      icon: Icon(Icons.play_arrow,
                                          color: ColorManager.white),
                                      onPressed: () {
                                        setState(() {
                                          selectedIndex = index;
                                        });
                                        musicPlayerProvider
                                            .openMusicPlayerFlag();
                                        musicPlayerProvider.changeSongList(
                                            slot.songListVO.songList);
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          musicPlayerProvider.changeSong(
                                              slot.songListVO.songList.first);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
