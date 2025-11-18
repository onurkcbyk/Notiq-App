import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models.dart';
import '../screens/edit.dart';
import '../services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:share_plus/share_plus.dart';

class NoteDetailScreen extends StatefulWidget {
  final Function() triggerRefetch;
  final NoteEntry activeNote;

  NoteDetailScreen({Key? key, required this.triggerRefetch, required this.activeNote}) : super(key: key);

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() => _showAppBar = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          _buildAppBar(context),

          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  AnimatedOpacity(
                    duration: Duration(milliseconds: 400),
                    opacity: _showAppBar ? 1 : 0,
                    child: Text(
                      widget.activeNote.title,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onBackground,
                        height: 1.3,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  AnimatedOpacity(
                    duration: Duration(milliseconds: 600),
                    opacity: _showAppBar ? 1 : 0,
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                        SizedBox(width: 8),
                        Text(
                          DateFormat.yMMMd().add_jm().format(widget.activeNote.date),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),

                        SizedBox(width: 16),

                        if (widget.activeNote.isImportant)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.amber.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  'Important',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.amber.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // CONTENT
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 800),
                    opacity: _showAppBar ? 1 : 0,
                    child: Text(
                      widget.activeNote.content,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _showAppBar ? 80 : 0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // BACK BUTTON
              IconButton(
                icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                onPressed: handleBack,
              ),

              const Spacer(),

              // IMPORTANT BUTTON
              IconButton(
                icon: Icon(
                  widget.activeNote.isImportant ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: widget.activeNote.isImportant
                      ? Colors.amber
                      : Theme.of(context).colorScheme.onSurface,
                  size: 28,
                ),
                onPressed: markImportantAsDirty,
              ),

              // SHARE BUTTON
              IconButton(
                icon: Icon(OMIcons.share, color: Theme.of(context).colorScheme.onSurface),
                onPressed: handleShare,
              ),

              // EDIT BUTTON
              IconButton(
                icon: Icon(OMIcons.edit, color: Theme.of(context).colorScheme.onSurface),
                onPressed: handleEdit,
              ),

              // DELETE BUTTON
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                onPressed: handleDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSave() async {
    await NotesDB.db.updateNoteInDB(widget.activeNote);
    widget.triggerRefetch();
  }

  void markImportantAsDirty() {
    setState(() => widget.activeNote.isImportant = !widget.activeNote.isImportant);
    handleSave();
  }

  void handleEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          existingNote: widget.activeNote,
          triggerRefetch: widget.triggerRefetch,
        ),
      ),
    );
  }

  void handleShare() {
    Share.share(
      '${widget.activeNote.title.trim()}\n\n${widget.activeNote.content}\n\n— Shared from Notes App',
      subject: widget.activeNote.title,
    );
  }

  void handleBack() => Navigator.pop(context);

  void handleDelete() async {
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
              await NotesDB.db.deleteNoteInDB(widget.activeNote);
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