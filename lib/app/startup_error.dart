import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/design_tokens.dart';

/// Shown instead of the app when startup fails or times out, so a problem is
/// visible (and reportable) rather than a frozen launch screen.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error, this.stack});

  final Object error;
  final StackTrace? stack;

  @override
  Widget build(BuildContext context) {
    const n = NeutralTokens.light;
    final details = '$error\n\n${stack ?? ''}';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: n.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '启动失败 / Startup failed',
                  style: TextStyle(
                    fontSize: DesignTokens.titleSize,
                    fontWeight: FontWeight.w600,
                    color: n.label,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '请长按下方文字复制，并发送给开发者。',
                  style: TextStyle(
                    fontSize: DesignTokens.footnoteSize,
                    color: n.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      details,
                      style: TextStyle(fontSize: 12, color: n.label),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: details)),
                  child: const Text('复制 / Copy'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
