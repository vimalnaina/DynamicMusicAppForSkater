import 'package:flutter/material.dart';
import 'package:skating_app/resources/color_manager.dart';
import 'package:skating_app/resources/fonts_manager.dart';
import 'package:skating_app/resources/styles_manager.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.colorPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "404 Not Found",
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
