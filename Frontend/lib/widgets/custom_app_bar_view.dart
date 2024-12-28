import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/resources/assets_manager.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';

class OtherScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const OtherScreenAppBar(
      {Key? key,
      required this.onBackClick,
      this.isSuffixTextAvail,
      this.suffixText,
      this.suffixTextStyle,
      this.onSuffixTextClick})
      : super(key: key);

  final Function() onBackClick;
  final bool? isSuffixTextAvail;
  final String? suffixText;
  final TextStyle? suffixTextStyle;
  final Function()? onSuffixTextClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.sp),
        child: InkWell(
          onTap: () {
            onBackClick();
          },
          child: SvgPicture.asset(
            IconsManager.backIcon,
          ),
        ),
      ),
      leadingWidth: 43.sp,
      actions: [
        (isSuffixTextAvail ?? false)
            ? InkWell(
                onTap: onSuffixTextClick,
                child: Padding(
                  padding: EdgeInsets.only(right: 15.sp),
                  child: Center(
                      child: Text(
                    suffixText ?? "",
                    style: suffixTextStyle ??
                        getMediumStyle(
                          color: ColorManager.black,
                          fontSize: FontSize.s14,
                        ),
                  )),
                ),
              )
            : SizedBox()
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(45.sp);
}

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar(
      {Key? key, required this.title, required this.onMenuClick})
      : super(key: key);

  final String title;
  final Function() onMenuClick;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: ColorManager.white,
      leading: Padding(
        padding: EdgeInsets.only(left: 15.sp),
        child: InkWell(
          onTap: onMenuClick,
          child: SvgPicture.asset(
            IconsManager.menuIcon,
          ),
        ),
      ),
      leadingWidth: 40.sp,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: getBoldStyle(
              fontSize: FontSize.s24,
              color: ColorManager.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(45.sp);
}
