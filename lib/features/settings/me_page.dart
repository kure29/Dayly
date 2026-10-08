import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/appearance_controller.dart';
import '../../app/router.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/appearance.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/page_scaffolds.dart';
import '../../core/ui/segmented.dart';
import 'appearance_actions.dart';
import 'scheme_picker.dart';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final appearance = ref.watch(appearanceProvider);
    final registry = ref.watch(themeRegistryProvider);
    return LargeTitlePage(
      title: l10n.meTitle,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SchemeStrip(
                schemes: registry.schemes,
                selectedId: appearance.schemeId,
                customScheme: customSchemeOf(ref),
                onSelect: (id) => setScheme(ref, id),
                onCustomTap: () => pickCustomAccent(context, ref),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Segmented<BrightnessMode>(
                  value: appearance.mode,
                  onChanged: (m) => setBrightnessMode(ref, m),
                  segments: {
                    BrightnessMode.system: l10n.modeSystem,
                    BrightnessMode.light: l10n.modeLight,
                    BrightnessMode.dark: l10n.modeDark,
                  },
                ),
              ),
              GroupedSection(
                separatorIndent: 16,
                children: [
                  GroupedRow(
                    title: l10n.themePreview,
                    leading: const Icon(CupertinoIcons.paintbrush),
                    showChevron: true,
                    onTap: () => context.push(Routes.themePreview),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
