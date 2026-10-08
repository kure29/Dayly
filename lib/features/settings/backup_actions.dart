import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../core/l10n/l10n.dart';
import '../../core/ui/capsule_toast.dart';
import '../../core/ui/dialogs.dart';
import '../../domain/backup.dart';
import '../task_editor/builtin_templates.dart';

/// Export / import / reset, wired to platform pickers.
abstract final class BackupActions {
  static Future<void> export(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final data = await ref.read(backupRepositoryProvider).exportAll();
    final dir = await getTemporaryDirectory();
    final stamp = data.exportedAt.toIso8601String().substring(0, 10);
    final file = File(p.join(dir.path, 'dailyquest-backup-$stamp.json'));
    await file.writeAsString(data.encode());
    if (!context.mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
    if (context.mounted) {
      CapsuleToast.show(
        context,
        l10n.exportSuccess,
        icon: CupertinoIcons.checkmark_circle_fill,
      );
    }
  }

  static Future<void> import(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    if (picked == null || !context.mounted) return;
    final ok = await showConfirmDialog(
      context,
      title: l10n.importConfirmTitle,
      message: l10n.importConfirmMessage,
      confirmLabel: l10n.confirm,
      destructive: true,
    );
    if (!ok || !context.mounted) return;
    try {
      final data = BackupData.decode(await picked.xFile.readAsString());
      await ref.read(backupRepositoryProvider).importAll(data);
      ref.read(dayTickProvider.notifier).bump();
      if (context.mounted) {
        CapsuleToast.show(
          context,
          l10n.importSuccess,
          icon: CupertinoIcons.checkmark_circle_fill,
        );
      }
    } on FormatException catch (e) {
      if (context.mounted) {
        CapsuleToast.show(context, l10n.importFailed(e.message));
      }
    }
  }

  static Future<void> reset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await showConfirmDialog(
      context,
      title: l10n.resetConfirmTitle,
      message: l10n.resetConfirmMessage,
      confirmLabel: l10n.resetData,
      destructive: true,
    );
    if (!ok) return;
    await ref.read(backupRepositoryProvider).resetAll();
    final service = ref.read(taskServiceProvider);
    await service.seedIfNeeded(buildSeedContent(l10n, service.now()));
    ref.read(dayTickProvider.notifier).bump();
    if (context.mounted) {
      CapsuleToast.show(
        context,
        l10n.resetDone,
        icon: CupertinoIcons.checkmark_circle_fill,
      );
    }
  }
}
