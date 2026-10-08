import 'package:flutter/cupertino.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

/// iOS segmented control themed from the palette.
class Segmented<T extends Object> extends StatelessWidget {
  const Segmented({
    super.key,
    required this.value,
    required this.segments,
    required this.onChanged,
  });

  final T value;
  final Map<T, String> segments;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return CupertinoSlidingSegmentedControl<T>(
      groupValue: value,
      backgroundColor: p.fill,
      thumbColor: p.isDark ? p.cardElevated : p.card,
      onValueChanged: (v) {
        if (v != null) onChanged(v);
      },
      children: {
        for (final e in segments.entries)
          e.key: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text(
              e.value,
              style: AppTextStyles.subhead.copyWith(
                color: p.label,
                fontWeight: e.key == value ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
      },
    );
  }
}
