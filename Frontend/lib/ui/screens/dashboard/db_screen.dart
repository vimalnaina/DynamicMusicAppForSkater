import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/provider/db_menu_provider.dart';
import 'package:skating_app/provider/music_player_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/ui/screens/board_screen.dart';
import 'package:skating_app/ui/screens/dashboard/calendar/calendar_tab.dart';
import 'package:skating_app/ui/screens/dashboard/home/home_tab.dart';
import 'package:skating_app/ui/screens/dashboard/settings/settings_tab.dart';
import 'package:skating_app/ui/screens/music_player/music_player_widget.dart';

class DBScreen extends StatefulWidget {
  const DBScreen({super.key});

  static const List<String> routeNames = [
    '/board',
    '/home',
    // '/history',
    '/calendar',
    '/settings'
  ];

  @override
  State<DBScreen> createState() => _DBScreenState();
}

class _DBScreenState extends State<DBScreen> {
  Uint8List? currentSong;
  bool isSongChange = false;
  Uint8List? currentUserAnnouncement;
  Uint8List? currentSongAnnouncement;
  List<Uint8List>? songQueue;

  final List<Widget> screens = [
    BoardScreen(),
    HomeTab(
      onSongClick: (SongList) {},
    ),
    // HistoryTab(),
    CalendarTab(),
    SettingsTab(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final currentPath = window.location.pathname;
      final index = DBScreen.routeNames.indexOf(currentPath!);
      final menuProvider = Provider.of<DBMenuProvider>(context, listen: false);
      menuProvider.selectMenu(index != -1 ? index : 0);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final MusicPlayerWidget _musicPlayerWidget = const MusicPlayerWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorPrimary,
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<DBMenuProvider>(
                builder: (context, menuProvider, child) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.sp, horizontal: 2.sp),
                    width: 15.w,
                    margin: EdgeInsets.all(2.sp),
                    decoration: BoxDecoration(
                      color: ColorManager.colorSecondary,
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
                            icon: Icons.schedule,
                            label: "Board",
                            isSelected: menuProvider.selectedIndex == 0,
                          ),
                          label: Text(''), // Empty to avoid duplication
                        ),
                        NavigationRailDestination(
                          icon: _buildNavigationRailDestination(
                            context,
                            icon: Icons.home,
                            label: "Practice",
                            isSelected: menuProvider.selectedIndex == 1,
                          ),
                          label: Text(''), // Empty to avoid duplication
                        ),
                        // NavigationRailDestination(
                        //   icon: _buildNavigationRailDestination(
                        //     context,
                        //     icon: Icons.history,
                        //     label: "History",
                        //     isSelected: menuProvider.selectedIndex == 2,
                        //   ),
                        //   label: Text(''), // Empty to avoid duplication
                        // ),
                        NavigationRailDestination(
                          icon: _buildNavigationRailDestination(
                            context,
                            icon: Icons.calendar_today,
                            label: "Appointments",
                            isSelected: menuProvider.selectedIndex == 2,
                          ),
                          label: Text(''), // Empty to avoid duplication
                        ),
                        NavigationRailDestination(
                          icon: _buildNavigationRailDestination(
                            context,
                            icon: Icons.settings,
                            label: "Settings",
                            isSelected: menuProvider.selectedIndex == 3,
                          ),
                          label: Text(''), // Empty to avoid duplication
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: Consumer<DBMenuProvider>(
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
      // bottomSheet: MusicPlayerWidget(),
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
