import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/authentication/login/login_screen.dart';
import 'package:skating_app/utils/custom_page_transition.dart';
import 'package:skating_app/utils/preference_manager.dart';

class AppUtils {
  static Future<dynamic> navigateTo(
    BuildContext context,
    CustomPageTransition customPageTransition,
  ) async {
    return await Navigator.push(context, customPageTransition);
  }

  static Future<dynamic> navigateToPush(
    BuildContext context,
    CustomPageTransition customPageTransition,
  ) async {
    return await Navigator.pushReplacement(context, customPageTransition);
  }

  static void navigateUp(BuildContext context, {dynamic argument}) {
    Navigator.pop(context, argument);
  }

  static showLoaderDialog(BuildContext context, bool status) {
    if (status) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                  color: Colors.transparent,
                  width: 10,
                  height: 100,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.cyan,
                      strokeWidth: 3,
                    ),
                  )));
        },
      );
    } else {
      navigateUp(context);
    }
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 2,
        backgroundColor: ColorManager.white,
        webBgColor: "linear-gradient(to right, #ffffff, #ffffff)",
        textColor: ColorManager.textColorLightBlack,
        fontSize: 12.sp);
  }

  static showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 2,
        backgroundColor: ColorManager.colorRed,
        webBgColor: "linear-gradient(to right, #e64646, #e64646)",
        textColor: ColorManager.textColorWhite,
        fontSize: 12.sp);
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorManager.colorLightCyan,
      content: Text(
        message.toString(),
        style: getMediumStyle(
            color: ColorManager.textColorLightBlack, fontSize: FontSize.s14),
      ),
      duration: Duration(milliseconds: 2000),
    ));
  }

  static showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorManager.colorLightRed,
      content: Text(
        message.toString(),
        style: getMediumStyle(
            color: ColorManager.textColorRed, fontSize: FontSize.s14),
      ),
      duration: Duration(milliseconds: 2000),
    ));
  }

  static String parseDate(int milliseconds, String format) {
    int milli = milliseconds;
    if (milliseconds.toString().length < 13) {
      milli = milliseconds * 1000;
    }
    var date = DateTime.fromMillisecondsSinceEpoch(milli);
    return DateFormat(format).format(date);
  }

  static bool equalsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase() == string2.toLowerCase();
  }

  static Future<bool> checkNetworkConnection() async {
    bool isConnected = false;
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
    }
    return isConnected;
  }

  static void logout(BuildContext context) {
    PreferenceManager.clearAllPrefs();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.routeName,
      (route) => false,
    );
  }

  static dynamic nextElement(List<dynamic> list, dynamic currentElement) {
    print("nextElement===${list.length}");
    for (int i = 0; i < list.length - 1; i++) {
      if (list[i].songId == currentElement.songId) {
        return list[i + 1];
      }
    }
    print("nextElement currentElement ===${currentElement.songId}");
    return null;
  }

  static dynamic previousElement(List<dynamic> list, dynamic currentElement) {
    for (int i = list.length - 1; i > 0; i--) {
      if (list[i].songId == currentElement.songId) {
        return list[i - 1];
      }
    }
    return null;
  }

  static bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString); // Attempt to parse the string
      return true; // If no exception is thrown, it's valid JSON
    } catch (e) {
      return false; // If an exception is thrown, it's not valid JSON
    }
  }

  static String convertTo12HourFormat(String time24) {
    try {
      // Split the input time into hours and minutes
      List<String> parts = time24.split(':');
      if (parts.length != 2) {
        throw FormatException("Invalid time format");
      }

      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);

      // Determine AM or PM
      String period = hours >= 12 ? 'PM' : 'AM';

      // Convert hours to 12-hour format
      hours = hours % 12;
      if (hours == 0) hours = 12; // Midnight or Noon case

      // Format the output as HH:MM AM/PM
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return "Invalid time format";
    }
  }

  static String formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  static int getDifficultyLevel(String? difficulty) {
    int difficultylvl = 1;
    if (difficulty == "Easy") {
      difficultylvl = 1;
    } else if (difficulty == "Medium") {
      difficultylvl = 2;
    } else if (difficulty == "Hard") {
      difficultylvl = 3;
    }
    return difficultylvl;
  }
}
