import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models.dart';

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
    final String neatDate = DateFormat.MMMd().add_jm().format(noteData.date);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
            padding: const EdgeInsets.all(16),
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
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (noteData.isImportant)
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: Colors.amber,
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // CONTENT
                Expanded(
                  child: Text(
                    noteData.content.isEmpty ? 'No content' : noteData.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 12),

                // DATE
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      neatDate,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary, // ✅ TEMAYA UYUMLU
                ),
                const SizedBox(height: 8),
                Text(
                  'Add New Note',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, // ✅ TEMAYA UYUMLU
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