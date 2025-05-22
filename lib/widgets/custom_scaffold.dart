import 'package:flutter/material.dart';

import '../utils/screen_size.dart';
import '../utils/theme.dart';

class CustomScaffold extends StatelessWidget {
  Widget? floatingActionButton;
  String? label;
  Widget body;
  bool isScrollable = false;
  bool backNeeded = false;
  CustomScaffold(
      {super.key,
      required this.body,
      this.isScrollable = false,
      required this.backNeeded,
      this.floatingActionButton,
      this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: ScreenSize.screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                AppTheme.lightTheme.primaryColor.withOpacity(0.2)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: ScreenSize.height(10),
                      left: ScreenSize.height(10),
                      right: ScreenSize.height(10),
                      bottom: isScrollable ? 0 : ScreenSize.height(5)),
                  child:
                      isScrollable ? SingleChildScrollView(child: body) : body),
              if (backNeeded)
                Positioned(
                    top: 40,
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor,
                          shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
              if (label != null)
                Positioned(
                    top: 40,
                    right: ScreenSize.width(40),
                    left: ScreenSize.width(45),
                    child: Text(
                      label!,
                      style: TextStyle(
                          color: AppTheme.lightTheme.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
            ],
          ),
        ),
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
