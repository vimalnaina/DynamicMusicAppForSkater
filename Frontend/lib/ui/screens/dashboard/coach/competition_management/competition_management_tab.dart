import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skating_app/provider/db_menu_provider_coach.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';
import 'package:skating_app/ui/screens/dashboard/home/competition/competition_songlist_screen.dart';
import 'package:skating_app/ui/screens/dashboard/home/competition/competition_tab.dart';

class CompetitionWidget extends StatefulWidget {
  @override
  _CompetitionWidgetState createState() => _CompetitionWidgetState();
}

class _CompetitionWidgetState extends State<CompetitionWidget> {
  late DBMenuProviderCoach menuProvider;

  @override
  Widget build(BuildContext context) {
    menuProvider = Provider.of<DBMenuProviderCoach>(context);
    print(
        "showCompetitionFromHome === ${menuProvider.showCompetitionFromHome}");
    return SafeArea(
      child: menuProvider.showCompetitionFromHome
          ? const SongListScreen()
          : Padding(
              padding: const EdgeInsets.all(8),
              // Add padding around the CompetitionTab
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Competition Management",
                    style: getBoldStyle(
                      fontSize: FontSize.s26,
                      color: ColorManager.textColorWhite,
                    ),
                  ),
                  SizedBox(height: 3.sp), // Spacing between title and content
                  // CompetitionTab
                  const Expanded(
                    child: CompetitionTab(
                        userType: 2), // Adjust userType as needed
                  ),
                ],
              ),
            ),
    );
  }
}
