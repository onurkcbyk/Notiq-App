import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../component/faderoute.dart';
import '../data/models.dart';
import '../screens/view.dart';
import '../services/database.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import '../component/cards.dart';
import '../screens/edit.dart';
import '../screens/settings.dart' as settings_screen;
import '../component/category_filter.dart'; // ✅ BU IMPORTU EKLE

class NotesHomeScreen extends StatefulWidget {
  @override
  _NotesHomeScreenState createState() => _NotesHomeScreenState();
}

class _NotesHomeScreenState extends State<NotesHomeScreen> {
  bool showImportantOnly = false;
  List<NoteEntry> allNotes = [];
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;
  NoteCategory selectedCategory = NoteCategory.all;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  void _initAsync() async {
    await NotesDB.db.database;
    loadNotes();
  }

  loadNotes() async {
    var fetchedNotes = await NotesDB.db.getNotesFromDB();
    setState(() {
      allNotes = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: openNoteEditor,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(
              'Notes',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(OMIcons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => settings_screen.SettingsPage(),
                    ),
                  );
                },
              ),
            ],
            floating: true,
            snap: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CategoryFilter(
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showImportantOnly = !showImportantOnly;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: showImportantOnly
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: showImportantOnly
                              ? Colors.yellow
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        showImportantOnly ? Icons.star : Icons.star_outline,
                        color: showImportantOnly
                            ? Colors.yellow
                            : Colors.yellow,
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: handleSearch,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Search notes...',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          if (!isSearchEmpty)
                            IconButton(
                              icon: Icon(Icons.close, size: 20),
                              onPressed: cancelSearch,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (showImportantOnly)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'Showing important notes ',
                      style: TextStyle(color: Colors.yellow, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: _buildNotesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    final filteredNotes = _getFilteredNotes();

    if (filteredNotes.isEmpty) {
      return SliverFillRemaining(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_outlined, size: 64, color: Colors.grey.shade300),
            SizedBox(height: 16),
            Text(
              'No notes found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to create your first note',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return NoteCardComponent(
            noteData: filteredNotes[index],
            onTapAction: openNoteToRead,
          );
        },
        childCount: filteredNotes.length,
      ),
    );
  }

  List<NoteEntry> _getFilteredNotes() {
    var notes = allNotes;
    notes.sort((a, b) => b.date.compareTo(a.date));

    if (selectedCategory != NoteCategory.all) {
      notes = notes.where((note) => note.category == selectedCategory).toList();
    }

    if (searchController.text.isNotEmpty) {
      notes = notes.where((note) =>
      note.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
          note.content.toLowerCase().contains(searchController.text.toLowerCase())
      ).toList();
    }

    if (showImportantOnly) {
      notes = notes.where((note) => note.isImportant).toList();
    }

    return notes;
  }

  void handleSearch(String value) {
    setState(() {
      isSearchEmpty = value.isEmpty;
    });
  }

  void openNoteEditor() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => NoteEditorScreen(
          triggerRefetch: refreshNotes,
          existingNote: null,
        ),
      ),
    );
  }

  void refreshNotes() async {
    await loadNotes();
  }

  void openNoteToRead(NoteEntry noteData) async {
    Navigator.push(
      context,
      FadeRoute(
        page: NoteDetailScreen(triggerRefetch: refreshNotes, activeNote: noteData),
      ),
    );
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }
}