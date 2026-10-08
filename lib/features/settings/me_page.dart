import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/appearance_controller.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../core/format.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/capsule_toast.dart';
import '../../core/ui/grouped_list.dart';
import '../../core/ui/input_sheets.dart';
import '../../core/ui/page_scaffolds.dart';
import '../../core/ui/segmented.dart';
import '../../domain/models.dart';
import 'appearance_actions.dart';
import 'backup_actions.dart';
import 'reminders.dart';
import 'scheme_picker.dart';

const String appVersion = '1.0.0';

class MePage extends ConsumerWidget {
  const MePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final p = context.palette;
    final appearance = ref.watch(appearanceProvider);
    final registry = ref.watch(themeRegistryProvider);
    final settings = ref.watch(settingsProvider).value ?? const AppSettings();
    final profile = ref.watch(profileProvider).value;
    final controller = ref.read(settingsControllerProvider);

    return LargeTitlePage(
      title: l10n.meTitle,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile -----------------------------------------------------
              GroupedSection(
                header: l10n.sectionProfile,
                separatorIndent: 16,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: p.accentTint,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            profile?.avatarChar ?? '',
                            style: AppTextStyles.title.copyWith(
                              color: p.accent,
                              fontSize: 26,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          profile?.nickname ?? '',
                          style: AppTextStyles.title.copyWith(color: p.label),
                        ),
                      ],
                    ),
                  ),
                  GroupedRow(
                    title: l10n.nickname,
                    value: profile?.nickname,
                    showChevron: true,
                    onTap: () async {
                      final v = await showTextInputSheet(
                        context,
                        title: l10n.nickname,
                        initial: profile?.nickname ?? '',
                        maxCharacters: 12,
                      );
                      if (v != null) {
                        await controller.updateProfile(
                          (c) => c.copyWith(nickname: v),
                        );
                      }
                    },
                  ),
                  GroupedRow(
                    title: l10n.avatarChar,
                    value: profile?.avatarChar,
                    showChevron: true,
                    onTap: () async {
                      final v = await showTextInputSheet(
                        context,
                        title: l10n.avatarChar,
                        initial: profile?.avatarChar ?? '',
                        maxCharacters: 1,
                      );
                      if (v != null) {
                        await controller.updateProfile(
                          (c) => c.copyWith(avatarChar: v),
                        );
                      }
                    },
                  ),
                ],
              ),

              // Appearance --------------------------------------------------
              _Header(l10n.sectionAppearance),
              SchemeStrip(
                schemes: registry.schemes,
                selectedId: appearance.schemeId,
                customScheme: customSchemeOf(ref),
                onSelect: (id) => setScheme(ref, id),
                onCustomTap: () => pickCustomAccent(context, ref),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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

              // Tasks -------------------------------------------------------
              GroupedSection(
                header: l10n.sectionTasks,
                separatorIndent: 16,
                children: [
                  GroupedRow(
                    title: l10n.manageTasks,
                    showChevron: true,
                    onTap: () => context.push(Routes.manageTasks),
                  ),
                  GroupedRow(
                    title: l10n.newTask,
                    titleColor: p.accent,
                    onTap: () => context.push(Routes.newTask),
                  ),
                ],
              ),

              // General -----------------------------------------------------
              GroupedSection(
                header: l10n.sectionGeneral,
                footer: l10n.dayStartFooter,
                separatorIndent: 16,
                children: [
                  GroupedRow(
                    title: l10n.dayStartHour,
                    value: context.timeOfDay(settings.dayStartHour * 60),
                    showChevron: true,
                    onTap: () async {
                      final h = await showWheelPickerSheet<int>(
                        context,
                        title: l10n.dayStartHour,
                        values: [for (var i = 0; i <= 12; i++) i],
                        initial: settings.dayStartHour,
                        label: (h) => context.timeOfDay(h * 60),
                      );
                      if (h != null) {
                        await controller.update(
                          (s) => s.copyWith(dayStartHour: h),
                        );
                        ref.read(dayTickProvider.notifier).bump();
                      }
                    },
                  ),
                  GroupedRow(
                    title: l10n.reminder,
                    trailing: Switch.adaptive(
                      value: settings.reminderEnabled,
                      onChanged: (on) async {
                        if (on) {
                          final granted = await ref
                              .read(reminderSchedulerProvider)
                              .requestPermission();
                          if (!granted && context.mounted) {
                            CapsuleToast.show(
                              context,
                              l10n.reminderPermissionDenied,
                            );
                          }
                        }
                        await controller.update(
                          (s) => s.copyWith(reminderEnabled: on),
                        );
                      },
                    ),
                  ),
                  if (settings.reminderEnabled)
                    GroupedRow(
                      title: l10n.reminderTime,
                      value: context.timeOfDay(settings.reminderMinutes),
                      showChevron: true,
                      onTap: () async {
                        final m = await showTimePickerSheet(
                          context,
                          title: l10n.reminderTime,
                          initialMinutes: settings.reminderMinutes,
                        );
                        if (m != null) {
                          await controller.update(
                            (s) => s.copyWith(reminderMinutes: m),
                          );
                        }
                      },
                    ),
                ],
              ),

              // Data --------------------------------------------------------
              GroupedSection(
                header: l10n.sectionData,
                separatorIndent: 16,
                children: [
                  Builder(
                    builder: (rowContext) => GroupedRow(
                      title: l10n.exportBackup,
                      titleColor: p.accent,
                      onTap: () => BackupActions.export(rowContext, ref),
                    ),
                  ),
                  GroupedRow(
                    title: l10n.importBackup,
                    titleColor: p.accent,
                    onTap: () => BackupActions.import(context, ref),
                  ),
                  GroupedRow(
                    title: l10n.resetData,
                    destructive: true,
                    onTap: () => BackupActions.reset(context, ref),
                  ),
                ],
              ),

              // About -------------------------------------------------------
              GroupedSection(
                header: l10n.about,
                separatorIndent: 16,
                children: [
                  GroupedRow(
                    title: l10n.themePreview,
                    showChevron: true,
                    onTap: () => context.push(Routes.themePreview),
                  ),
                  GroupedRow(title: l10n.version, value: appVersion),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(32, 0, 32, 6),
    child: Text(
      text,
      style: AppTextStyles.footnote.copyWith(
        color: context.palette.secondaryLabel,
      ),
    ),
  );
}
