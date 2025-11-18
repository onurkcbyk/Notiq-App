import 'package:flutter/material.dart';
import '../data/models.dart';

class CategoryFilter extends StatelessWidget {
  final NoteCategory selectedCategory;
  final Function(NoteCategory) onCategorySelected;

  const CategoryFilter({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: NoteCategory.values.map((category) {
          final isSelected = category == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(
                _getCategoryName(category),
                style: TextStyle(
                  color: isSelected ? Colors.white : null,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onCategorySelected(category),
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
            ),
          );
        }).toList(),
      ),
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
}