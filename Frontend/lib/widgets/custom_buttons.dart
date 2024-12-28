import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.title,
      required this.onClick,
      this.buttonBgColor,
      this.textColor})
      : super(key: key);

  final String title;
  final Color? textColor;
  final Function() onClick;
  final Color? buttonBgColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 3.sp),
        decoration: BoxDecoration(
          color: buttonBgColor ?? ColorManager.colorAccent,
          borderRadius: BorderRadius.circular(2.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                color: textColor ?? ColorManager.white,
                fontSize: FontSize.s16,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  const CustomButtonWithIcon(
      {Key? key,
      required this.title,
      required this.onClick,
      this.textStyle,
      required this.icon})
      : super(key: key);

  final String title;
  final Function() onClick;
  final TextStyle? textStyle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 3.sp),
        decoration: BoxDecoration(
          color: ColorManager.colorAccent,
          borderRadius: BorderRadius.circular(2.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: ColorManager.textColorWhite),
            SizedBox(width: 2.sp),
            Text(
              title,
              textAlign: TextAlign.center,
              style: getMediumStyle(
                color: ColorManager.white,
                fontSize: FontSize.s16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
