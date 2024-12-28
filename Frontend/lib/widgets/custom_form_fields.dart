import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/resources/assets_manager.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';

class CustomDropdownField extends StatelessWidget {
  const CustomDropdownField(
      {Key? key,
      required this.hint,
      required this.hintStyle,
      required this.textStyle,
      this.onChanged,
      this.selectedItemBuilder,
      this.items,
      this.value})
      : super(key: key);

  final String hint;
  final TextStyle hintStyle, textStyle;
  final Function(dynamic)? onChanged;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final List<DropdownMenuItem<dynamic>>? items;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2.sp),
      ),
      child: DropdownButtonFormField<dynamic>(
        style: textStyle,
        value: value,
        enableFeedback: true,
        iconEnabledColor: Colors.white,
        dropdownColor: Colors.grey[800],
        icon: SvgPicture.asset(IconsManager.downIcon, color: ColorManager.white,),
        elevation: 1,
        disabledHint: Text(
          hint,
          style: getRegularStyle(
            color: ColorManager.white.withOpacity(0.6),
            fontSize: FontSize.s16,
          ),
        ),
        selectedItemBuilder: selectedItemBuilder,
        decoration: inputDecorationDropdownField(hint, hintStyle),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.onSubmit,
      this.onChange,
      this.isEnable,
      this.isLastField,
      required this.hintStyle,
      required this.textStyle})
      : super(key: key);

  final TextEditingController controller;
  final String hint;
  final Function(String value)? onSubmit;
  final Function(String value)? onChange;
  final bool? isEnable, isLastField;
  final TextStyle hintStyle, textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2.sp),
      ),
      child: TextFormField(
        textInputAction: (isLastField ?? false)
            ? TextInputAction.done
            : TextInputAction.next,
        controller: controller,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        enabled: isEnable ?? true,
        style: textStyle,
        decoration: inputDecorationTextField(controller, hint, hintStyle),
      ),
    );
  }
}

class CustomTextAreaField extends StatelessWidget {
  const CustomTextAreaField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.onSubmit,
      this.onChange,
      this.isEnable,
      this.isLastField,
      required this.hintStyle,
      required this.textStyle})
      : super(key: key);

  final TextEditingController controller;
  final String hint;
  final Function(String value)? onSubmit;
  final Function(String value)? onChange;
  final bool? isEnable, isLastField;
  final TextStyle hintStyle, textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2.sp),
      ),
      child: TextFormField(
        minLines: 4,
        maxLines: 4,
        textInputAction: (isLastField ?? false)
            ? TextInputAction.done
            : TextInputAction.next,
        controller: controller,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        enabled: isEnable ?? true,
        style: textStyle,
        decoration: inputDecorationTextField(controller, hint, hintStyle),
      ),
    );
  }
}

class CustomPasswordField extends StatelessWidget {
  const CustomPasswordField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.onSubmit,
      this.onChange,
      this.isEnable,
      this.isLastField,
      required this.hintStyle,
      required this.textStyle,
      required this.obscureText,
      required this.onToggle})
      : super(key: key);

  final TextEditingController controller;
  final String hint;
  final Function(String value)? onSubmit;
  final Function(String value)? onChange;
  final bool? isEnable, isLastField;
  final TextStyle hintStyle, textStyle;
  final bool obscureText;
  final Function() onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2.sp),
      ),
      child: TextFormField(
        obscureText: obscureText,
        textInputAction: (isLastField ?? false)
            ? TextInputAction.done
            : TextInputAction.next,
        controller: controller,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        enabled: isEnable ?? true,
        style: textStyle,
        decoration: inputDecorationPasswordField(
            controller, obscureText, hint, hintStyle, onToggle),
      ),
    );
  }
}

class CustomSearchField extends StatelessWidget {
  const CustomSearchField(
      {Key? key,
      required this.controller,
      required this.hint,
      this.onSubmit,
      this.onChange,
      this.isEnable,
      this.isLastField,
      required this.hintStyle,
      required this.textStyle})
      : super(key: key);

  final TextEditingController controller;
  final String hint;
  final Function(String value)? onSubmit;
  final Function(String value)? onChange;
  final bool? isEnable, isLastField;
  final TextStyle hintStyle, textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2.sp),
      ),
      child: TextFormField(
        textInputAction: (isLastField ?? false)
            ? TextInputAction.done
            : TextInputAction.next,
        controller: controller,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        enabled: isEnable ?? true,
        style: textStyle,
        decoration: inputDecorationSearchField(controller, hint, hintStyle),
      ),
    );
  }
}

InputDecoration inputDecorationTextField(
    TextEditingController controller, String hint, TextStyle hintStyle) {
  return InputDecoration(
    border: InputBorder.none,
    counterText: "",
    hintText: hint,
    hintStyle: hintStyle,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 3.sp),
  );
}

InputDecoration inputDecorationSearchField(
    TextEditingController controller, String hint, TextStyle hintStyle) {
  return InputDecoration(
    border: InputBorder.none,
    counterText: "",
    hintText: hint,
    hintStyle: hintStyle,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.symmetric(vertical: 2.5.sp, horizontal: 3.sp),
    prefixIcon: Icon(
      Icons.search,
      color: ColorManager.white,
      size: FontSize.s20,
    ),
  );
}

InputDecoration inputDecorationDropdownField(String hint, TextStyle hintStyle) {
  return InputDecoration(
    border: InputBorder.none,
    counterText: "",
    hintText: hint,
    hintStyle: hintStyle,
    contentPadding: EdgeInsets.only(top: 1.sp, bottom: 1.sp, left: 3.sp, right: 3.sp),
  );
}

InputDecoration inputDecorationPasswordField(TextEditingController controller,
    bool obscureText, String hint, TextStyle hintStyle, Function() onToggle) {
  return InputDecoration(
    border: InputBorder.none,
    counterText: "",
    hintText: hint,
    hintStyle: hintStyle,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    contentPadding: EdgeInsets.only(left: 3.sp, right: 3.sp, top: 3.sp),
    suffixIcon: InkWell(
      onTap: onToggle,
      child: Icon(
        obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 5.sp,
        color: ColorManager.white,
      ),
    ),
  );
}
