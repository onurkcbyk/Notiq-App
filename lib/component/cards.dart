import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data/models.dart';
import '../provider/settings_provider.dart';
class NoteCardComponent extends StatelessWidget {
  final NoteEntry noteData;
  final void Function(NoteEntry noteData) onTapAction;

  const NoteCardComponent({
    Key? key,
    required this.noteData,
    required this.onTapAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final String neatDate = DateFormat.MMMd().add_jm().format(noteData.date);

    // Dinamik font boyutları
    final double titleSize = ((settings.textSize + 2) * textScaleFactor).clamp(16, 24);
    final double contentSize = (settings.textSize * textScaleFactor).clamp(12, 20);
    final double dateSize = ((settings.textSize - 2) * textScaleFactor).clamp(10, 14);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0x1AFFFFFF)
                : const Color(0x1A000000),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTapAction(noteData),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // TITLE ROW
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        noteData.title.isEmpty ? 'No Title' : noteData.title,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (noteData.isImportant)
                      Icon(
                        Icons.star_rounded,
                        size: 16 * textScaleFactor,
                        color: Colors.amber,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                // CONTENT
                Expanded(
                  child: Text(
                    noteData.content.isEmpty ? 'No content' : noteData.content,
                    style: TextStyle(
                      fontSize: contentSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                // DATE
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12 * textScaleFactor,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        neatDate,
                        style: TextStyle(
                          fontSize: dateSize,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddNoteCardComponent extends StatelessWidget {
  const AddNoteCardComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);
    final double fontSize = (settings.textSize * textScaleFactor).clamp(12, 16);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0x0DFFFFFF)
                : const Color(0x0D000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 28 * textScaleFactor,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 6),
                Text(
                  'Add New Note',
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}