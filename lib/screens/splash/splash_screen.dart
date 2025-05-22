import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/fontsizes.dart';
import '../../utils/routes.dart';
import '../../utils/theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  initState() {
    super.initState();
    gotoNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              AppTheme.lightTheme.primaryColor.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            tileMode: TileMode.clamp,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image.asset('assets/images/logo.png', width: ScreenSize.width(30)),
              Text(
                "tikzy",
                style: TextStyle(
                    fontSize: baseFontSize, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoNext() {
    Future.delayed(Duration(seconds: 2), () async {
      Navigator.pushReplacementNamed(context, Routes.signin);
    });
  }
}
