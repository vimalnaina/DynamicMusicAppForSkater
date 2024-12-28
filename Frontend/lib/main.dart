import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/provider/appointment_provider.dart';
import 'package:skating_app/provider/auth_provider.dart';
import 'package:skating_app/provider/db_menu_provider.dart';
import 'package:skating_app/provider/db_menu_provider_coach.dart';
import 'package:skating_app/provider/song_provider.dart';
import 'package:skating_app/provider/songlist_screen_provider.dart';
import 'package:skating_app/provider/user_provider.dart';
import 'package:skating_app/resources/route_manager.dart';
import 'package:skating_app/services/websocket_service.dart';
import 'package:skating_app/ui/screens/authentication/login/login_screen.dart';
import 'package:skating_app/ui/screens/dashboard/coach/db_screen_coach.dart';
import 'package:skating_app/ui/screens/board_screen.dart';
import 'package:skating_app/ui/screens/dashboard/db_screen.dart';
import 'package:skating_app/ui/screens/dashboard/not_found_screen.dart';

import 'package:skating_app/utils/preference_manager.dart';
import 'package:url_strategy/url_strategy.dart';

import 'provider/music_player_provider.dart';

import 'model/login/login_response.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await initLocalStorage();
  runApp(MusicPlayerApp());
}

class MusicPlayerApp extends StatefulWidget {
  const MusicPlayerApp({super.key});

  static GlobalKey myAppKey = GlobalKey();

  @override
  State<MusicPlayerApp> createState() => _MusicPlayerAppState();
}

class _MusicPlayerAppState extends State<MusicPlayerApp> {
  String initRoute = LoginScreen.routeName;
  late WebSocketService webSocketService;

  @override
  void initState() {
    super.initState();
    setInitRoute();
    webSocketService = WebSocketService.getInstance(context);
    webSocketService.connect();
  }

  Future<bool> isLoggedIn() async {
    return await PreferenceManager.getBoolean(PreferenceManager.IS_LOGIN);
    ; // Or false, depending on the user's login status
  }

  setInitRoute() async {
    bool isLogIn = await isLoggedIn();
    // localStorage.setItem(key, value)
    print("is logged in == " + isLoggedIn.toString());

    if (isLogIn) {
      UserData user = UserData.fromJson(await PreferenceManager.getUserData());
      switch (user.type) {
        case 1:
          initRoute = DBScreen.routeNames[0];
          break;
        case 2:
          initRoute = DBScreenCoach.routeNames[0];
          break;
      }
    } else {
      initRoute = LoginScreen.routeName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<SongProvider>(create: (_) => SongProvider()),
        ChangeNotifierProvider<AppointmentProvider>(
            create: (_) => AppointmentProvider()),
        ChangeNotifierProvider<MusicPlayerProvider>(
            create: (_) => MusicPlayerProvider()),
        ChangeNotifierProvider<DBMenuProvider>(
            create: (context) =>
                DBMenuProvider(context.read<MusicPlayerProvider>())),
        ChangeNotifierProvider<DBMenuProviderCoach>(
            create: (context) =>
                DBMenuProviderCoach(context.read<MusicPlayerProvider>())),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<SonglistScreenProvider>(
            create: (_) => SonglistScreenProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            onGenerateRoute: (RouteSettings settings) {
              print("settings===${settings.name}");
              List<String> authRoutes = [
                '/login',
                '/signup',
              ];
              List<String> validRoutes = [
                '/songs',
                '/competition',
                '/competition/songList',
                '/settings',
              ];
              if (!validRoutes.contains(settings.name?.split('/').first)) {
                return MaterialPageRoute(builder: (_) => NotFoundScreen());
              } else {
                if (!authRoutes.contains(settings.name?.split('/').first)) {
                  return MaterialPageRoute(
                    builder: (context) => FutureBuilder<bool>(
                      future: isLoggedIn(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Scaffold(
                            body: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError || !snapshot.data!) {
                          // Redirect to login if not logged in
                          return LoginScreen();
                        } else {
                          return SizedBox();
                        }
                      },
                    ),
                  );
                }
              }
            },
            debugShowCheckedModeBanner: false,
            title: 'Music Player',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            routes: routes,
            initialRoute: initRoute,
            supportedLocales: const [
              Locale('en', ''),
            ],
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
