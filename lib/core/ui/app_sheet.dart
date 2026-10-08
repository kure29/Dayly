import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

/// Shows a bottom sheet with rounded top corners and a drag handle.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  String? title,
  bool isScrollControlled = true,
}) {
  final p = context.palette;
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: isScrollControlled,
    backgroundColor: p.cardElevated,
    barrierColor: p.scrim,
    elevation: 0,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
    ),
    builder: (context) => SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetDragHandle(),
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headline.copyWith(color: p.label),
                ),
              ),
            Flexible(child: builder(context)),
          ],
        ),
      ),
    ),
  );
}

class SheetDragHandle extends StatelessWidget {
  const SheetDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 6, bottom: 8),
        width: 36,
        height: 5,
        decoration: BoxDecoration(
          color: context.palette.secondaryLabel.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}
