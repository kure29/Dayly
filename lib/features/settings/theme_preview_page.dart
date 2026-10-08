import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/appearance_controller.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/appearance.dart';
import '../../core/theme/color_utils.dart';
import '../../core/ui/app_sheet.dart';
import '../../core/ui/capsule_button.dart';
import '../../core/ui/capsule_toast.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/page_scaffolds.dart';
import '../../core/ui/progress_indicators.dart';
import '../../core/ui/segmented.dart';
import '../../core/ui/task_icon.dart';
import 'appearance_actions.dart';
import 'scheme_picker.dart';

/// Design-system self check: every token, the type scale and the core
/// components, with live scheme / brightness switching.
class ThemePreviewPage extends ConsumerWidget {
  const ThemePreviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = context.palette;
    final l10n = context.l10n;
    final appearance = ref.watch(appearanceProvider);
    final registry = ref.watch(themeRegistryProvider);
    final active = ref.watch(activeSchemeProvider);
    return DetailPage(
      title: l10n.themePreview,
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 40),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 24),
          GroupedSection(
            header: 'Neutral',
            separatorIndent: 16,
            children: [
              _TokenRow('background', p.background),
              _TokenRow('card', p.card),
              _TokenRow('cardElevated', p.cardElevated),
              _TokenRow('label', p.label),
              _TokenRow('secondaryLabel', p.secondaryLabel),
              _TokenRow('separator', p.separator),
              _TokenRow('fill', p.fill),
            ],
          ),
          GroupedSection(
            header: active.displayName(
              Localizations.localeOf(context).languageCode,
            ),
            separatorIndent: 16,
            children: [
              _TokenRow('accent', p.accent),
              _TokenRow('ring', p.ring),
              _TokenRow('success', p.success),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var i = 0; i < p.taskColors.length; i++)
                      TaskIcon(
                        icon: i.isEven ? TaskSymbol.all[i].storageValue : '词',
                        colorIndex: i,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const GroupedSection(
            header: 'Type',
            separatorIndent: 16,
            children: [
              _TypeRow('Large Title 34', AppTextStyles.largeTitle),
              _TypeRow('Title 20', AppTextStyles.title),
              _TypeRow('Body 17 正文', AppTextStyles.body),
              _TypeRow('Footnote 13 注释', AppTextStyles.footnote),
            ],
          ),
          GroupedSection(
            header: 'Components',
            children: [
              GroupedRow(
                leading: const TaskIcon(icon: 'sym:book', colorIndex: 0),
                title: '背单词',
                subtitle: '40 / 100 个',
                trailing: CapsuleButton(
                  label: '+10',
                  dense: true,
                  onPressed: () {},
                ),
              ),
              GroupedRow(
                leading: const TaskIcon(icon: 'sym:pencil', colorIndex: 1),
                title: '练习题',
                trailing: CapsuleButton(
                  label: l10n.done,
                  dense: true,
                  onPressed: () {},
                ),
              ),
              GroupedRow(
                leading: const TaskIcon(icon: 'sym:timer', colorIndex: 2),
                title: l10n.themePreview,
                showChevron: true,
                onTap: () => CapsuleToast.show(
                  context,
                  l10n.dayCompleteToast,
                  icon: CupertinoIcons.checkmark_circle_fill,
                ),
              ),
              GroupedRow(
                leading: const TaskIcon(icon: 'sym:moon', colorIndex: 3),
                title: 'Sheet',
                showChevron: true,
                onTap: () => showAppSheet<void>(
                  context,
                  title: 'Sheet',
                  builder: (_) => const SizedBox(height: 160),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ProgressRing(value: 0.62, child: Text('62%')),
                SizedBox(width: 20),
                Expanded(child: ThinProgressBar(value: 0.4)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                CapsuleButton(
                  label: 'Filled',
                  style: CapsuleStyle.filled,
                  onPressed: () {},
                ),
                CapsuleButton(label: 'Tinted', onPressed: () {}),
                CapsuleButton(
                  label: 'Gray',
                  style: CapsuleStyle.gray,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenRow extends StatelessWidget {
  const _TokenRow(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ratio = ColorUtils.contrastRatio(color, p.card);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: p.separator, width: 0.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.body.copyWith(color: p.label),
            ),
          ),
          Text(
            '${ColorUtils.toHex(color)}  ${ratio.toStringAsFixed(2)}:1',
            style: AppTextStyles.footnote.copyWith(color: p.secondaryLabel),
          ),
        ],
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow(this.text, this.style);

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Text(text, style: style.copyWith(color: context.palette.label)),
  );
}
