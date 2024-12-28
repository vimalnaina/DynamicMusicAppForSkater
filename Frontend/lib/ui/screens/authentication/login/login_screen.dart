import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/model/login/login_response.dart';
import 'package:skating_app/provider/auth_provider.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/string_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/authentication/signup/signup_screen.dart';
import 'package:skating_app/ui/screens/dashboard/coach/db_screen_coach.dart';
import 'package:skating_app/ui/screens/dashboard/db_screen.dart';
import 'package:skating_app/utils/app_utils.dart';
import 'package:skating_app/utils/preference_manager.dart';
import 'package:skating_app/widgets/custom_buttons.dart';
import 'package:skating_app/widgets/custom_form_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthProvider authProvider;

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onLoginClick() async {
    AppUtils.showLoaderDialog(context, true);

    authProvider
        .login(
            userName: userNameController.text,
            password: passwordController.text,
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
          switch (loginResponse.data?.type) {
            case 1:
              Navigator.pushNamedAndRemoveUntil(context, DBScreen.routeNames[0],
                  (Route<dynamic> route) => false);
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(context,
                  DBScreenCoach.routeNames[0], (Route<dynamic> route) => false);
              break;
          }
        } else {
          AppUtils.showErrorToast(
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
                StringManager.lblLogin,
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
                    SizedBox(height: 10.sp),
                    CustomButton(
                      title: StringManager.lblLogin,
                      onClick: () {
                        onLoginClick();
                      },
                    ),
                    SizedBox(height: 5.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringManager.dontHaveAnAccount,
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
                                SignUpScreen.routeName,
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              "Sign Up",
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
