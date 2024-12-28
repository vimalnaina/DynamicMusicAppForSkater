import 'dart:html';
import 'package:skating_app/provider/music_player_provider.dart';
import 'package:skating_app/ui/screens/dashboard/coach/settings_tab.dart';
import 'package:skating_app/ui/screens/dashboard/coach/song_management/songs_management_tab.dart';
import 'package:skating_app/ui/screens/dashboard/coach/competition_management/competition_management_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/db_menu_provider_coach.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/ui/screens/music_player/music_player_widget.dart';

class DBScreenCoach extends StatefulWidget {
  const DBScreenCoach({super.key});

  static const List<String> routeNames = [
    '/songs',
    '/competition',
    '/settings'
  ];

  @override
  State<DBScreenCoach> createState() => _DBScreenCoachState();
}

class _DBScreenCoachState extends State<DBScreenCoach> {
  SongList? currentSong;
  bool isSongChange = false;
  final MusicPlayerWidget _musicPlayerWidget = const MusicPlayerWidget();

  final List<Widget> screens = [
    SongManagementScreen(),
    CompetitionWidget(),
    SettingsWidget(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final currentPath = window.location.pathname;
      final index = DBScreenCoach.routeNames.indexOf(currentPath!);
      print("index===$index");
      final menuProvider =
          Provider.of<DBMenuProviderCoach>(context, listen: false);
      menuProvider.selectMenu(index != -1 ? index : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorPrimary,
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<DBMenuProviderCoach>(
                builder: (context, menuProvider, child) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.sp, horizontal: 2.sp),
                    width: 15.w,
                    margin: EdgeInsets.all(2.sp),
                    decoration: BoxDecoration(
                      color: ColorManager.colorAccent,
                      borderRadius: BorderRadius.circular(2.sp),
                    ),
                    child: NavigationRail(
                      backgroundColor: Colors.transparent,
                      selectedIndex: menuProvider.selectedIndex,
                      onDestinationSelected: menuProvider.selectMenu,
                      labelType: NavigationRailLabelType.all,
                      indicatorColor: Colors.transparent,
                      // Make indicator background transparent
                      indicatorShape: StadiumBorder(
                        side: BorderSide.none, // No border
                      ),
                      useIndicator: false,
                      destinations: [
                        // Use custom widget for destinations
                        NavigationRailDestination(
                          icon: _buildNavigationRailDestination(
                            context,
                            icon: Icons.home,
                            label: "Songs",
                            isSelected: menuProvider.selectedIndex == 0,
                          ),
                          label: Text(''), // Empty to avoid duplication
                        ),
                        NavigationRailDestination(
                          icon: _buildNavigationRailDestination(
                            context,
                            icon: Icons.history,
                            label: "Competition",
                            isSelected: menuProvider.selectedIndex == 1,
                          ),
                          label: Text(''), // Empty to avoid duplication
                        ),
                        NavigationRailDestination(
                          icon: _buildNavigationRailDestination(
                            context,
                            icon: Icons.settings,
                            label: "Settings",
                            isSelected: menuProvider.selectedIndex == 2,
                          ),
                          label: Text(''), // Empty to avoid duplication
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: Consumer<DBMenuProviderCoach>(
                  builder: (context, menuProvider, child) {
                    return IndexedStack(
                      index: menuProvider.selectedIndex,
                      children: screens,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Consumer<MusicPlayerProvider>(
        builder: (context, musicPlayerProvider, child) {
          return musicPlayerProvider.isOpenMusicPlayer
              ? _musicPlayerWidget
              : const SizedBox();
        },
      ),
    );
  }
}

Widget _buildNavigationRailDestination(
  BuildContext context, {
  required IconData icon,
  required String label,
  required bool isSelected,
}) {
  return Container(
    decoration: BoxDecoration(
      color: isSelected ? ColorManager.colorGrey : Colors.transparent,
      // Change background color based on selection
      borderRadius:
          BorderRadius.circular(8), // Adjust the border radius as needed
    ),
    padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 2.sp),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, color: ColorManager.white),
        SizedBox(width: 8), // Space between icon and label
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: ColorManager.white,
            ),
          ),
        ),
      ],
    ),
  );
}
