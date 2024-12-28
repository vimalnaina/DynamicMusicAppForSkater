import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#3cb4b4");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#B33cb4b4");

  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color black = HexColor.fromHex("#000000");
  static Color error = HexColor.fromHex("#e61f34");

  //App colors
  static Color colorMediumTransparent = HexColor.fromHex("#44000000");
  static Color colorBoldCyan = HexColor.fromHex("#3cb4b4");
  static Color colorLightCyan = HexColor.fromHex("#ebffff");
  static Color colorLightBlack = HexColor.fromHex("#006464");
  static Color colorDarkGrey = HexColor.fromHex("#878787");
  static Color colorLightGrey = HexColor.fromHex("#f0f0f0");
  static Color colorMediumGrey = HexColor.fromHex("#c8c8c8");
  static Color coloDisable = HexColor.fromHex("#c8c8c8");
  static Color colorLightRed = HexColor.fromHex("#F5DEDE");
  static Color colorRed = HexColor.fromHex("#e64646");

  static Color colorPrimary = HexColor.fromHex("#170505");
  static Color colorSecondary = HexColor.fromHex("#3b0b0b");
  static Color colorAccent = HexColor.fromHex("#b82727");
  static Color colorGrey = HexColor.fromHex("#3a2d2d");




  //Text colors
  static Color textColorBoldCyan = HexColor.fromHex("#3cb4b4");
  static Color textColorLightBlack = HexColor.fromHex("#006464");
  static Color textColorWhite = HexColor.fromHex("#ffffff");
  static Color textColorBlack = HexColor.fromHex("#000000");
  static Color textColorDarkGrey = HexColor.fromHex("#878787");
  static Color textColorRed = HexColor.fromHex("#e64646");

  //Button colors
  static Color btnColorBoldCyan = HexColor.fromHex("#3cb4b4");
  static Color btnColorLightCyan = HexColor.fromHex("#ebffff");
  static Color btnColorRed = HexColor.fromHex("#e64646");
  static Color btnColorGreen = HexColor.fromHex("#7DC819");
  static Color btnColorDisable = HexColor.fromHex("#c8c8c8");
  static Color btnColorWhite = HexColor.fromHex("#ffffff");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = 'FF' + hexColorString; // 8 Char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
