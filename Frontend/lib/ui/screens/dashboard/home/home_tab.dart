import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/songlist_response.dart';
import 'package:skating_app/provider/db_menu_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/dashboard/home/competition/competition_tab.dart';
import 'package:skating_app/ui/screens/dashboard/home/practice/practice_tab.dart';
import 'package:skating_app/ui/screens/dashboard/home/practice/songlist/songlist_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key, required this.onSongClick});

  final Function(SongList) onSongClick;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DBMenuProvider menuProvider;
  List<SongList> songList = [];

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    menuProvider = Provider.of<DBMenuProvider>(context, listen: false);
    // buildDummyData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<DBMenuProvider>(context);

    print("showSongListFromHome: ${menuProvider.showSongListFromHome}");

    return SafeArea(
      child: menuProvider.showSongListFromHome
          ? SongListScreen(songList: songList, onSongClick: (song) {})
          : Container(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "Practice",
                      style: getBoldStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s26,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 5.sp),
                  //   height: 8.sp,
                  //   decoration: BoxDecoration(
                  //     color: ColorManager.colorGrey,
                  //     borderRadius: BorderRadius.circular(2.sp),
                  //   ),
                  //   child: TabBar(
                  //     controller: _tabController,
                  //     dividerColor: Colors.transparent,
                  //     indicatorSize: TabBarIndicatorSize.tab,
                  //     indicator: BoxDecoration(
                  //       color: ColorManager.colorAccent,
                  //       borderRadius: BorderRadius.circular(2.sp),
                  //     ),
                  //     labelColor: ColorManager.textColorWhite,
                  //     unselectedLabelColor: ColorManager.textColorWhite,
                  //     labelStyle: getBoldStyle(
                  //       color: ColorManager.textColorWhite,
                  //       fontSize: FontSize.s14,
                  //     ),
                  //     unselectedLabelStyle: getMediumStyle(
                  //       color: ColorManager.textColorWhite,
                  //       fontSize: FontSize.s14,
                  //     ),
                  //     tabs: const [
                  //       Tab(
                  //         text: StringManager.lblPractice,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        PracticeTab(
                          //songList: songList,
                          onSongClick: widget.onSongClick,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
