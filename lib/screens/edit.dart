import 'package:flutter/material.dart';
import '../data/models.dart';
import '../services/database.dart';
import 'package:provider/provider.dart';
import '../provider/settings_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  final Function() triggerRefetch;
  final NoteEntry? existingNote;

  const NoteEditorScreen({
    Key? key,
    required this.triggerRefetch,
    this.existingNote,
  }) : super(key: key);

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  bool isDirty = false;
  bool isNoteNew = true;
  late FocusNode titleFocus;
  late FocusNode contentFocus;
  late NoteEntry currentNote;
  late TextEditingController titleController;
  late TextEditingController contentController;
  NoteCategory selectedCategory = NoteCategory.all;

  @override
  void initState() {
    super.initState();
    titleFocus = FocusNode();
    contentFocus = FocusNode();

    if (widget.existingNote == null) {
      currentNote = NoteEntry(
        content: '',
        title: '',
        date: DateTime.now(),
        isImportant: false,
        category: NoteCategory.all,
      );
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote!;
      isNoteNew = false;
      selectedCategory = widget.existingNote!.category;
    }

    titleController = TextEditingController(text: currentNote.title);
    contentController = TextEditingController(text: currentNote.content);

    titleController.addListener(_checkDirty);
    contentController.addListener(_checkDirty);
  }

  void _checkDirty() {
    final titleChanged = titleController.text != currentNote.title;
    final contentChanged = contentController.text != currentNote.content;
    final categoryChanged = selectedCategory != currentNote.category;

    setState(() {
      isDirty = titleChanged || contentChanged || categoryChanged;
    });
  }

  @override
  void dispose() {
    titleController.removeListener(_checkDirty);
    contentController.removeListener(_checkDirty);
    titleFocus.dispose();
    contentFocus.dispose();
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: handleBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isNoteNew ? 'New Note' : 'Edit Note',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
              ),
            ),
            Text(
              _getCategoryName(selectedCategory),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [

          PopupMenuButton<NoteCategory>(
            onSelected: (category) {
              setState(() {
                selectedCategory = category;
                isDirty = true;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: NoteCategory.all,
                child: Row(
                  children: [
                    Icon(Icons.all_out_outlined,
                        color: selectedCategory == NoteCategory.all
                            ? Theme.of(context).colorScheme.primary
                            : null),
                    SizedBox(width: 12),
                    Text('All'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: NoteCategory.personal,
                child: Row(
                  children: [
                    Icon(Icons.person_outline,
                        color: selectedCategory == NoteCategory.personal
                            ? Theme.of(context).colorScheme.primary
                            : null),
                    SizedBox(width: 12),
                    Text('Personal'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: NoteCategory.work,
                child: Row(
                  children: [
                    Icon(Icons.work_outline,
                        color: selectedCategory == NoteCategory.work
                            ? Theme.of(context).colorScheme.primary
                            : null),
                    SizedBox(width: 12),
                    Text('Work'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: NoteCategory.shopping,
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined,
                        color: selectedCategory == NoteCategory.shopping
                            ? Theme.of(context).colorScheme.primary
                            : null),
                    SizedBox(width: 12),
                    Text('Shopping'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: NoteCategory.ideas,
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: selectedCategory == NoteCategory.ideas
                            ? Theme.of(context).colorScheme.primary
                            : null),
                    SizedBox(width: 12),
                    Text('Ideas'),
                  ],
                ),
              ),
            ],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(_getCategoryIcon(selectedCategory), size: 18),
                  SizedBox(width: 6),
                  Text(
                    _getCategoryName(selectedCategory),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 16),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          // IMPORTANT BUTTON
          IconButton(
            icon: Icon(
              currentNote.isImportant ? Icons.star_rounded : Icons.star_outline_rounded,
              color: currentNote.isImportant ? Colors.amber : Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: titleController.text.trim().isNotEmpty && contentController.text.trim().isNotEmpty
                ? markImportantAsDirty
                : null,
          ),
          // DELETE BUTTON
          IconButton(
            icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onSurface),
            onPressed: handleDelete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE FIELD
            TextField(
              focusNode: titleFocus,
              autofocus: true,
              controller: titleController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSubmitted: (_) {
                titleFocus.unfocus();
                FocusScope.of(context).requestFocus(contentFocus);
              },
              onChanged: (value) => _checkDirty(),
              textInputAction: TextInputAction.next,
              style: TextStyle(
                fontSize: settings.textSize + 4,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
                hintStyle: TextStyle(
                  fontSize: settings.textSize + 6,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade400,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CONTENT FIELD
            Expanded(
              child: TextField(
                focusNode: contentFocus,
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (value) => _checkDirty(),
                style: TextStyle(
                  fontSize: settings.textSize,
                  height: 1.5,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start writing your note...',
                  hintStyle: TextStyle(
                    fontSize: settings.textSize,
                    height: 1.5,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isDirty ? FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        child: Icon(Icons.done, size: 28),
        onPressed: handleSave,
      ) : null,
    );
  }

  String _getCategoryName(NoteCategory category) {
    switch (category) {
      case NoteCategory.all: return 'All';
      case NoteCategory.personal: return 'Personal';
      case NoteCategory.work: return 'Work';
      case NoteCategory.shopping: return 'Shopping';
      case NoteCategory.ideas: return 'Ideas';
      default: return 'All';
    }
  }

  IconData _getCategoryIcon(NoteCategory category) {
    switch (category) {
      case NoteCategory.all: return Icons.all_out_outlined;
      case NoteCategory.personal: return Icons.person_outline;
      case NoteCategory.work: return Icons.work_outline;
      case NoteCategory.shopping: return Icons.shopping_cart_outlined;
      case NoteCategory.ideas: return Icons.lightbulb_outlined;
      default: return Icons.note_outlined;
    }
  }

  // ✅ DÜZGÜN ÇALIŞAN SAVE METODU
  void handleSave() async {
    // Önce currentNote'u güncelle
    setState(() {
      currentNote.title = titleController.text;
      currentNote.content = contentController.text;
      currentNote.category = selectedCategory;
    });

    try {
      if (isNoteNew) {
        var latestNote = await NotesDB.db.addNoteInDB(currentNote);
        setState(() {
          currentNote = latestNote;
          isNoteNew = false;
        });
      } else {
        await NotesDB.db.updateNoteInDB(currentNote);
      }

      setState(() {
        isDirty = false;
      });

      widget.triggerRefetch();
      titleFocus.unfocus();
      contentFocus.unfocus();
      Navigator.pop(context);

    } catch (e) {
      print('Save error: $e');
    }
  }

  void markImportantAsDirty() {
    setState(() {
      currentNote.isImportant = !currentNote.isImportant;
      isDirty = true;
    });
  }

  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Delete Note', style: TextStyle(fontWeight: FontWeight.w600)),
          content: Text('This note will be permanently deleted.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey.shade600)),
            ),
            TextButton(
              onPressed: () async {
                await NotesDB.db.deleteNoteInDB(currentNote);
                widget.triggerRefetch();
                Navigator.pop(context, true);
                Navigator.pop(context);
              },
              child: Text(
                'DELETE',
                style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }
  }

  void handleBack() => Navigator.pop(context);
}