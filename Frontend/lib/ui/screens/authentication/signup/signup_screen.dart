import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/login/login_response.dart';
import 'package:skating_app/provider/auth_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/string_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/authentication/login/login_screen.dart';
import 'package:skating_app/ui/screens/dashboard/db_screen.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';
import 'package:skating_app/widgets/custom_form_fields.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AuthProvider authProvider;

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? selectedUserType;
  List<String> userTypeList = [
    StringManager.lblSkater,
    StringManager.lblCoach,
  ];

  bool _obscurePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onSignUpClick() async {
    AppUtils.showLoaderDialog(context, true);

    int userType = 0;
    if (AppUtils.equalsIgnoreCase(
        selectedUserType ?? "", StringManager.lblSkater)) {
      userType = 1;
    } else if (AppUtils.equalsIgnoreCase(
        selectedUserType ?? "", StringManager.lblCoach)) {
      userType = 2;
    }

    if (userType == 0) {
      return;
    }

    authProvider
        .signUp(
            userName: userNameController.text,
            password: passwordController.text,
            type: userType,
            context: context)
        .then((response) async {
      AppUtils.showLoaderDialog(context, false);
      if (response["status"]) {
        LoginResponse loginResponse = LoginResponse.fromJson(response["data"]);
        if (loginResponse.code == 1) {
          PreferenceManager.saveUserData(loginResponse.data);
          PreferenceManager.setString(
              PreferenceManager.AUTH_TOKEN, loginResponse.data?.token ?? "");
          PreferenceManager.setBoolean(
              PreferenceManager.IS_LOGIN, true);
          Navigator.pushNamedAndRemoveUntil(
              context, DBScreen.routeNames[0], (Route<dynamic> route) => false);
        } else {
          AppUtils.showToast(
              loginResponse.msg ?? StringManager.somethingWentWrong);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: ColorManager.colorPrimary,
      body: Container(
        width: 100.w,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.sp),
              child: Text(
                StringManager.lblSignUp,
                style: getBoldStyle(
                  fontSize: FontSize.s28,
                  color: ColorManager.white,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(top: 10.sp),
                width: 50.w,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: userNameController,
                      hint: StringManager.lblUserName,
                      hintStyle: getRegularStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s15,
                      ),
                      textStyle: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s15,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    CustomPasswordField(
                      obscureText: _obscurePassword,
                      controller: passwordController,
                      hint: StringManager.lblPassword,
                      hintStyle: getRegularStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s15,
                      ),
                      textStyle: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s15,
                      ),
                      onToggle: () {
                        _obscurePassword = !_obscurePassword;
                        setState(() {});
                      },
                      isLastField: true,
                    ),
                    SizedBox(height: 5.sp),
                    CustomDropdownField(
                      hint: StringManager.selectUserType,
                      hintStyle: getRegularStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s15,
                      ),
                      textStyle: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s15,
                      ),
                      value: (selectedUserType ?? "").isEmpty
                          ? null
                          : selectedUserType,
                      items: userTypeList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(child: Text(value)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedUserType = value;
                      },
                    ),
                    SizedBox(height: 10.sp),
                    CustomButton(
                      title: StringManager.lblSignUp,
                      onClick: () {
                        onSignUpClick();
                      },
                    ),
                    SizedBox(height: 5.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringManager.alreadyHaveAnAccount,
                          style: getRegularStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s14,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.sp),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                LoginScreen.routeName,
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              StringManager.lblLogin,
                              style: getMediumStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
