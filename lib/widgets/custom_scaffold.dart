import 'package:flutter/material.dart';

import '../utils/fontsizes.dart';

// ignore: must_be_immutable
class CustomScaffold extends StatelessWidget {
  Widget body;
  bool isScrollable = false;
  CustomScaffold({super.key, required this.body, this.isScrollable = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.only(
            top: commonPaddingSize + 10,
            left: commonPaddingSize + 10,
            right: commonPaddingSize + 10,
            bottom: isScrollable ? 0 : commonPaddingSize,
          ),
          child: isScrollable ? SingleChildScrollView(child: body) : body,
        ),
      ),
    );
  }
}
