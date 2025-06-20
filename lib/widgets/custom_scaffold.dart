import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../utils/fontsizes.dart';
import '../utils/screen_size.dart';
import '../utils/spaces.dart';

// ignore: must_be_immutable
class CustomScaffold extends ConsumerStatefulWidget {
  Widget body;
  bool isScrollable = false;
  CustomScaffold({super.key, required this.body, this.isScrollable = false});

  @override
  ConsumerState<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends ConsumerState<CustomScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userLocalProvider);
    final role = user?.role ?? 'user';
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: DashboardSidePanel(role: role, ref: ref),
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: ScreenSize.height(5),
              ),
              sb(2, 0),
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
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          ],
        ),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.only(
            top: commonPaddingSize + 10,
            left: commonPaddingSize + 10,
            right: commonPaddingSize + 10,
            bottom: widget.isScrollable ? 0 : commonPaddingSize,
          ),
          child: widget.isScrollable
              ? SingleChildScrollView(child: widget.body)
              : widget.body,
        ),
      ),
    );
  }
}
