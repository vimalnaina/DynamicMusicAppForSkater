import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/login/login_response.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    userData = UserData.fromJson(await PreferenceManager.getUserData());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile",
            style: getBoldStyle(
              color: Colors.white,
              fontSize: FontSize.s26,
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(2.sp),
                  margin: EdgeInsets.only(top: 10.sp),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: ColorManager.white),
                    borderRadius: BorderRadius.circular(30.sp),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 10.sp,
                    color: ColorManager.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.sp),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "UserName: ",
                        style: getRegularStyle(
                          color: Colors.white,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.sp),
                        child: Text(
                          "${userData?.userName ?? "-"}",
                          style: getMediumStyle(
                            color: Colors.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.sp),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Type: ",
                        style: getRegularStyle(
                          color: Colors.white,
                          fontSize: FontSize.s16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.sp),
                        child: Text(
                          "${userData?.type == 1 ? "Skater" : "Coach"}",
                          style: getRegularStyle(
                            color: Colors.white,
                            fontSize: FontSize.s16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.sp),
                  child: SizedBox(
                    width: 15.w,
                    child: CustomButton(
                      title: "Logout",
                      onClick: () {
                        AppUtils.logout(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
