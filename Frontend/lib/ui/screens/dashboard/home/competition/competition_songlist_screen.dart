import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/provider/db_menu_provider_coach.dart';
import 'package:skating_app/provider/music_player_provider.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/provider/songlist_screen_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/dashboard/coach/songlist_screen.dart';

class SongListScreen extends StatefulWidget {
  const SongListScreen({super.key});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  late SongProvider songProvider;
  late DBMenuProviderCoach dbMenuProvider;
  late SonglistScreenProvider songlistScreenProvider;
  late MusicPlayerProvider musicPlayerProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      dbMenuProvider = Provider.of<DBMenuProviderCoach>(context, listen: false);
      songlistScreenProvider =
          Provider.of<SonglistScreenProvider>(context, listen: false);
      musicPlayerProvider =
          Provider.of<MusicPlayerProvider>(context, listen: false);
      // musicPlayerProvider.openMusicPlayerFlag();
      musicPlayerProvider.reset();
      musicPlayerProvider.setIsCompetition();
      // getSongListDataById();
      setData();
    });
  }

  setData() async {
    musicPlayerProvider
        .changeSongList(dbMenuProvider.songListArgs?.songList ?? []);
    songlistScreenProvider.setData(dbMenuProvider.songListArgs);
  }

  @override
  Widget build(BuildContext context) {
    songProvider = Provider.of<SongProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        print("called");
        musicPlayerProvider.reset();
        final menuProvider =
            Provider.of<DBMenuProviderCoach>(context, listen: false);
        menuProvider.toggleCompetitionAndHome();
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
                    final menuProvider = Provider.of<DBMenuProviderCoach>(
                        context,
                        listen: false);
                    menuProvider.toggleCompetitionAndHome();
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
                provider.data != null
                    ? Padding(
                        padding: EdgeInsets.only(top: 5.sp),
                        child: Text(
                          "# ${provider.data?.listName}",
                          style: getBoldStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s20,
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 5.sp),
                        child: const CircularProgressIndicator(),
                      ),
                provider.data != null
                    ? Padding(
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
