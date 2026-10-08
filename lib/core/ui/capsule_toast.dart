import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_theme.dart';

/// A small capsule that slides in from the top (like iOS's "Copied" HUD).
abstract final class CapsuleToast {
  static OverlayEntry? _current;
  static Timer? _timer;

  static void show(
    BuildContext context,
    String message, {
    IconData? icon,
    Duration duration = const Duration(milliseconds: 2200),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _dismiss();
    final entry = OverlayEntry(
      builder: (context) => _ToastView(message: message, icon: icon),
    );
    _current = entry;
    overlay.insert(entry);
    _timer = Timer(duration, _dismiss);
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;
    _current?.remove();
    _current = null;
  }
}

class _ToastView extends StatefulWidget {
  const _ToastView({required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final top = MediaQuery.paddingOf(context).top + 8;
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOutBack);
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: FadeTransition(
            opacity: _c,
            child: SlideTransition(
              position: Tween(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(curved),
              child: Semantics(
                liveRegion: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: p.cardElevated.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: p.separator, width: 0.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(widget.icon, size: 18, color: p.success),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Text(
                              widget.message,
                              style: AppTextStyles.subhead.copyWith(
                                color: p.label,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
