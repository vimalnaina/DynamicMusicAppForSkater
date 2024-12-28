import 'package:skating_app/ui/screens/authentication/signup/signup_screen.dart';
import 'package:skating_app/ui/screens/dashboard/coach/db_screen_coach.dart';
import 'package:skating_app/ui/screens/board_screen.dart';
import 'package:skating_app/ui/screens/dashboard/db_screen.dart';

import '../ui/screens/authentication/login/login_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  // DashboardScreen.routeName: (context) => const DashboardScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  BoardScreen.routeName: (context) => const BoardScreen(),
  DBScreen.routeNames[0]: (context) => const DBScreen(),
  DBScreen.routeNames[1]: (context) => const DBScreen(),
  DBScreen.routeNames[2]: (context) => const DBScreen(),
  DBScreen.routeNames[3]: (context) => const DBScreen(),
  // DBScreen.routeNames[4]: (context) => const DBScreen(),
  DBScreenCoach.routeNames[0]: (context) => const DBScreenCoach(),
  DBScreenCoach.routeNames[1]: (context) => const DBScreenCoach(),
  DBScreenCoach.routeNames[2]: (context) => const DBScreenCoach(),
};

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
