import 'package:flutter/material.dart';
import 'package:skating_app/ui/screens/dashboard/settings/settings_tab.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: SettingsTab());
  }
}
