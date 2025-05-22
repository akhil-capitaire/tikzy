import 'package:flutter/cupertino.dart';

import 'screen_size.dart';

sb(double? width, double? height) {
  return SizedBox(
    width: width != null ? ScreenSize.width(width) : 0,
    height: height != null ? ScreenSize.height(height) : 0,
  );
}

SizedBox sw10 = SizedBox(width: ScreenSize.width(10));
SizedBox sw20 = SizedBox(width: ScreenSize.width(20));
SizedBox sw30 = SizedBox(width: ScreenSize.width(30));
SizedBox sh10 = SizedBox(height: ScreenSize.height(10));
SizedBox sh20 = SizedBox(height: ScreenSize.height(20));
SizedBox sh30 = SizedBox(height: ScreenSize.height(30));
