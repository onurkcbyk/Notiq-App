
enum NoteCategory { all, personal, work, shopping, ideas }

class NoteEntry {
  int? id;
  String title;
  String content;
  bool isImportant;
  DateTime date;
  NoteCategory category;

  NoteEntry({
    this.id,
    required this.title,
    required this.content,
    required this.isImportant,
    required this.date,
    this.category = NoteCategory.all,
  });

  NoteEntry.empty()
      : id = null,
        title = '',
        content = '',
        isImportant = false,
        date = DateTime.now(),
        category = NoteCategory.all;

  NoteEntry.fromMap(Map<String, dynamic> map)
      : id = map['_id'],
        title = map['title'] ?? '',
        content = map['content'] ?? '',
        date = DateTime.parse(map['date']),
        isImportant = map['isImportant'] == 1,
        category = NoteCategory.values[map['category'] ?? 1];

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'content': content,
      'isImportant': isImportant ? 1 : 0,
      'date': date.toIso8601String(),
      'category': category.index,
    };
  }

}