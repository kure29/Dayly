import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/appearance_controller.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/appearance.dart';
import '../../core/theme/custom_scheme.dart';
import '../../core/theme/scheme_definition.dart';
import '../../core/ui/app_sheet.dart';
import 'scheme_picker.dart';

void setScheme(WidgetRef ref, String id) =>
    ref.read(appearanceProvider.notifier).setScheme(id);

void setBrightnessMode(WidgetRef ref, BrightnessMode mode) =>
    ref.read(appearanceProvider.notifier).setMode(mode);

/// The generated custom scheme if the user has picked a custom accent.
SchemeDefinition? customSchemeOf(WidgetRef ref) {
  final accent = ref.watch(appearanceProvider.select((a) => a.customAccent));
  if (accent == null) return null;
  return CustomSchemeGenerator.generate(
    Color(accent),
    base: ref.watch(themeRegistryProvider).fallback,
  );
}

Future<void> pickCustomAccent(BuildContext context, WidgetRef ref) async {
  final current = ref.read(appearanceProvider).customAccent;
  final initial = current != null ? Color(current) : context.palette.accent;
  await showAppSheet<void>(
    context,
    title: context.l10n.customAccent,
    builder: (sheetContext) => AccentColorPicker(
      initial: initial,
      onDone: (color) {
        ref.read(appearanceProvider.notifier).setCustomAccent(color.toARGB32());
        Navigator.of(sheetContext).pop();
      },
    ),
  );
}
