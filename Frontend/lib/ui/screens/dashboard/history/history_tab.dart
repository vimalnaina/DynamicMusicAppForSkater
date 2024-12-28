import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/songlist/favourite_songlist_response.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/utils/local_database.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  late SongProvider songProvider;
  List<FavouriteSong> data = [];
  late LocalDatabase db;

  @override
  void initState() {
    super.initState();
    print("called history initState");
    db = LocalDatabase();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      songProvider = Provider.of<SongProvider>(context, listen: false);
      fetchHistory();
    });
  }

  fetchHistory() async {
    songProvider.retriveHistory(context: context).then((response) {
      if (response["status"]) {
        FavouriteSongListResponse favouriteSongListResponse =
            FavouriteSongListResponse.fromJson(response["data"]);
        data = favouriteSongListResponse.data ?? [];
        sortFavouriteSongsByCreateTime(data);
      }
    });
  }

  void sortFavouriteSongsByCreateTime(List<FavouriteSong> songs) {
    songs.sort((a, b) {
      // Parse createTime into DateTime objects
      DateTime? createTimeA = a.song?.createTime != null
          ? DateTime.tryParse(a.song!.createTime!)
          : null;
      DateTime? createTimeB = b.song?.createTime != null
          ? DateTime.tryParse(b.song!.createTime!)
          : null;

      // Handle null cases, consider null as earliest or latest
      if (createTimeA == null && createTimeB == null) return 0;
      if (createTimeA == null) return 1; // null goes last
      if (createTimeB == null) return -1; // null goes last

      // Compare the DateTime objects
      return createTimeA.compareTo(createTimeB);
    });
    data = songs;
    setState(() {});
  }

  /// Helper function to determine group label
  String _getGroupLabel(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.isAfter(today.subtract(const Duration(days: 1)))) {
      return "Today";
    } else if (dateTime.isAfter(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat.yMMMd().format(dateTime); // e.g., "Oct 10, 2024"
    }
  }

  Future<Uint8List> getImage(String id) async {
    var img = await db.getImageById(id);
    if (img != null) {
      return img["image"];
    } else {
      final response =
      await songProvider.getImage(imageId: id, context: context);
      await db.insertImage({"imageId": id, "image": response});
      return response;
    }
  }

  @override
  void dispose() {
    print("called history dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.sp),
          child: Text(
            "#History",
            style: getMediumStyle(
              color: ColorManager.white,
              fontSize: FontSize.s18,
            ),
          ),
        ),
        Expanded(
          child: GroupedListView<FavouriteSong, String>(
            elements: data,
            groupBy: (FavouriteSong song) {
              final createTime = song.song?.createTime;
              if (createTime == null) return "Unknown";
              DateTime date = DateTime.parse(createTime);
              return _getGroupLabel(date);
            },
            groupSeparatorBuilder: (String groupByValue) => Container(
              padding: EdgeInsets.symmetric(horizontal: 3.sp, vertical: 1.sp),
              child: Text(
                groupByValue,
                textAlign: TextAlign.left,
                style: getMediumStyle(
                    color: ColorManager.white, fontSize: FontSize.s16),
              ),
            ),
            itemBuilder: (context, FavouriteSong song) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 3.sp, vertical: 1.sp),
                margin: EdgeInsets.only(top: 1.sp, bottom: 1.sp, right: 3.sp),
                decoration: BoxDecoration(
                  color: ColorManager.colorAccent,
                  borderRadius: BorderRadius.circular(1.sp),
                ),
                child: Row(
                  children: [
                    FutureBuilder<Uint8List>(
                      future: getImage(song.song?.imageId ?? ""),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: 10.sp,
                            height: 10.sp,
                            padding: EdgeInsets.all(2.sp),
                            child: CircularProgressIndicator(
                              color: ColorManager.white,
                            ),
                          ); // Loading indicator
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Error message
                        } else if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(2.sp),
                            child: Image.memory(
                              snapshot.data!,
                              width: 10.sp,
                              height: 10.sp,
                              errorBuilder: (context, url, error) => Container(
                                width: 10.sp,
                                height: 10.sp,
                                decoration: BoxDecoration(
                                  color: ColorManager.grey,
                                  borderRadius: BorderRadius.circular(2.sp),
                                ),
                              ),
                              fit: BoxFit.contain,
                            ),
                          );
                        } else {
                          return Text('No image data found');
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 2.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.song?.name ?? "Unknown Song",
                            style: getRegularStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          Text(
                            "Singer: ${song.song?.singer ?? 'Unknown'}",
                            style: getRegularStyle(
                              color: ColorManager.white,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemComparator: (item1, item2) {
              DateTime? time1 = item1.song?.createTime != null
                  ? DateTime.tryParse(item1.song!.createTime!)
                  : null;
              DateTime? time2 = item2.song?.createTime != null
                  ? DateTime.tryParse(item2.song!.createTime!)
                  : null;
              if (time1 == null && time2 == null) return 0;
              if (time1 == null) return 1;
              if (time2 == null) return -1;
              return time1.compareTo(time2);
            },
            useStickyGroupSeparators: false,
            floatingHeader: false,
            order: GroupedListOrder.DESC,
            scrollDirection: Axis.vertical,
          ),
        ),
      ],
    );
  }
}
