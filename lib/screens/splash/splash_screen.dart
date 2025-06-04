import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/fontsizes.dart';
import '../../utils/routes.dart';
import '../../utils/screen_size.dart';

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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.white,
          //     AppTheme.lightTheme.primaryColor.withOpacity(0.3),
          //   ],
          //   begin: Alignment.topLeft,
          //   tileMode: TileMode.clamp,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: ScreenSize.width(30),
                height: ScreenSize.height(30),
              ),

              Text(
                "Tikzy",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                  fontSize: baseFontSize + 10,
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: theme.colorScheme.primary.withOpacity(0.25),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoNext() {
    Future.delayed(Duration(seconds: 2), () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is signed in, navigate to dashboard
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      } else {
        // User is not signed in, navigate to sign-in page
        Navigator.pushReplacementNamed(context, Routes.signin);
      }
    });
  }
}
