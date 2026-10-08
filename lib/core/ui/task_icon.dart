import 'package:flutter/cupertino.dart';

import '../theme/app_palette.dart';
import '../theme/design_tokens.dart';

/// A built-in task symbol. Stored in the database as `sym:<key>`; anything
/// else stored in `TaskTemplate.icon` is rendered as a text glyph.
class TaskSymbol {
  const TaskSymbol(this.key, this.icon, this.sfSymbol, this.fallbackGlyph);

  final String key;
  final IconData icon;

  /// SF Symbol name used by the iOS widget.
  final String sfSymbol;

  /// Glyph used where icon fonts are unavailable (Android widget).
  final String fallbackGlyph;

  String get storageValue => '$prefix$key';

  static const String prefix = 'sym:';

  static const List<TaskSymbol> all = [
    TaskSymbol('book', CupertinoIcons.book_fill, 'book.fill', '📖'),
    TaskSymbol('pencil', CupertinoIcons.pencil, 'pencil', '✏️'),
    TaskSymbol('doc', CupertinoIcons.doc_text_fill, 'doc.text.fill', '📝'),
    TaskSymbol('timer', CupertinoIcons.timer, 'timer', '⏱'),
    TaskSymbol('run', CupertinoIcons.flame_fill, 'flame.fill', '🔥'),
    TaskSymbol('headphones', CupertinoIcons.headphones, 'headphones', '🎧'),
    TaskSymbol('globe', CupertinoIcons.globe, 'globe', '🌐'),
    TaskSymbol('music', CupertinoIcons.music_note, 'music.note', '🎵'),
    TaskSymbol('heart', CupertinoIcons.heart_fill, 'heart.fill', '❤️'),
    TaskSymbol('star', CupertinoIcons.star_fill, 'star.fill', '⭐️'),
    TaskSymbol('moon', CupertinoIcons.moon_fill, 'moon.fill', '🌙'),
    TaskSymbol('drop', CupertinoIcons.drop_fill, 'drop.fill', '💧'),
    TaskSymbol('bolt', CupertinoIcons.bolt_fill, 'bolt.fill', '⚡️'),
    TaskSymbol('brain', CupertinoIcons.lightbulb_fill, 'lightbulb.fill', '💡'),
    TaskSymbol(
      'check',
      CupertinoIcons.checkmark_seal_fill,
      'checkmark.seal.fill',
      '✅',
    ),
    TaskSymbol('leaf', CupertinoIcons.tree, 'leaf.fill', '🌿'),
  ];

  static TaskSymbol? fromStorage(String value) {
    if (!value.startsWith(prefix)) return null;
    final key = value.substring(prefix.length);
    for (final s in all) {
      if (s.key == key) return s;
    }
    return null;
  }

  /// A text glyph for [storedIcon] usable outside Flutter (widgets).
  static String glyphFor(String storedIcon, String fallbackName) {
    final symbol = fromStorage(storedIcon);
    if (symbol != null) return symbol.fallbackGlyph;
    if (storedIcon.trim().isNotEmpty) return storedIcon.characters.first;
    return fallbackName.isEmpty ? '•' : fallbackName.characters.first;
  }
}

/// Colored rounded square with a glyph or built-in icon.
class TaskIcon extends StatelessWidget {
  const TaskIcon({
    super.key,
    required this.icon,
    required this.colorIndex,
    this.size = DesignTokens.iconSize,
  });

  final String icon;
  final int colorIndex;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final bg = p.taskColor(colorIndex);
    final fg = p.onTaskColor(colorIndex);
    final symbol = TaskSymbol.fromStorage(icon);
    final Widget glyph = symbol != null
        ? Icon(symbol.icon, size: size * 0.6, color: fg)
        : Text(
            icon.isEmpty ? '•' : icon.characters.first,
            style: TextStyle(
              fontSize: size * 0.52,
              fontWeight: FontWeight.w600,
              color: fg,
              height: 1,
            ),
          );
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(
          size * DesignTokens.iconRadius / 30,
        ),
      ),
      child: glyph,
    );
  }
}
