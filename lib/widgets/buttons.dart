import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/fontsizes.dart';
import '../utils/theme.dart';

final buttonLoadingProvider = StateProvider<Map<ButtonType, bool>>((ref) => {});

enum ButtonType { primary, secondary, grey, outlined, cardButton }

class CustomButton extends ConsumerWidget {
  final String label;
  final Future<void> Function() onPressed;
  final bool isSmall;
  final ButtonType type;
  final bool noCurve;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isSmall,
    required this.type,
    this.noCurve = false,
  });

  Color backgroundColorFor(ButtonType type) {
    switch (type) {
      case ButtonType.primary:
        return AppTheme.lightTheme.colorScheme.primary;
      case ButtonType.secondary:
        return AppTheme.lightTheme.colorScheme.secondary;
      case ButtonType.grey:
        return Colors.grey[300]!;
      case ButtonType.outlined:
        return Colors.white;
      case ButtonType.cardButton:
        return const Color(0xffF8F9A6);
    }
  }

  Color foregroundColorFor(ButtonType type) {
    switch (type) {
      case ButtonType.primary:
        return Colors.white;
      case ButtonType.secondary:
        return Colors.white;
      case ButtonType.grey:
        return Colors.black;
      case ButtonType.outlined:
        return AppTheme.lightTheme.colorScheme.primary;
      case ButtonType.cardButton:
        return Colors.black;
    }
  }

  Color borderColorFor(ButtonType type) {
    switch (type) {
      case ButtonType.primary:
        return AppTheme.lightTheme.colorScheme.primary;
      case ButtonType.secondary:
        return AppTheme.lightTheme.colorScheme.secondary;
      case ButtonType.grey:
        return Colors.grey[300]!;
      case ButtonType.outlined:
        return AppTheme.lightTheme.colorScheme.primary;
      case ButtonType.cardButton:
        return const Color(0xffF8F9A6);
    }
  }

  double getResponsiveFontSize(BuildContext context) {
    final base = isSmall ? baseFontSize - 2 : baseFontSize;
    final width = MediaQuery.of(context).size.width;
    final scaled = base * (width / 375.0);
    return scaled.clamp(base, base + 2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(buttonLoadingProvider)[type] ?? false;

    return SizedBox(
      width: isSmall ? null : double.infinity,
      height: isSmall ? 40.0 : 48.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColorFor(type),
          foregroundColor: foregroundColorFor(type),
          padding: EdgeInsets.symmetric(horizontal: commonPaddingSize),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColorFor(type)),
            borderRadius: noCurve
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(commonRadiusSize),
                    bottomRight: Radius.circular(commonRadiusSize),
                  )
                : BorderRadius.circular(commonRadiusSize),
          ),
        ),
        onPressed: loading
            ? null
            : () async {
                ref
                    .read(buttonLoadingProvider.notifier)
                    .update((state) => {...state, type: true});
                try {
                  // LoaderHelper.showLoader();
                  await onPressed();
                  // LoaderHelper.hideLoader();
                } finally {
                  // LoaderHelper.hideLoader();
                  ref
                      .read(buttonLoadingProvider.notifier)
                      .update((state) => {...state, type: false});
                }
              },
        child: loading
            ? Transform.scale(
                scale: 0.4,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColorFor(type),
                  ),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context),
                  color: foregroundColorFor(type),
                ),
              ),
      ),
    );
  }
}
