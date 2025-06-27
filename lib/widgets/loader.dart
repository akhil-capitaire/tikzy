import 'package:flutter/material.dart';

import '../main.dart';

class LoaderHelper {
  static OverlayEntry? _loaderOverlay;

  static void showLoader({String? message}) {
    if (_loaderOverlay != null) return;

    final context = navigatorKey.currentContext;
    final overlay = navigatorKey.currentState?.overlay;
    if (context == null || overlay == null) return;

    _loaderOverlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_loaderOverlay!);
  }

  static void hideLoader() {
    _loaderOverlay?.remove();
    _loaderOverlay = null;
  }
}
