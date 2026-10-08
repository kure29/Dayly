import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/ui/page_scaffolds.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LargeTitlePage(title: context.l10n.statsTitle, slivers: const []);
  }
}
