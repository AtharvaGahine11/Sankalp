import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../models/note_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/note_card.dart';
import '../../widgets/empty_state.dart';
import '../../app/routes.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _selectedSubjectFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final notes = appState.notes;

    final subjects = ['All', ...{...notes.map((n) => n.subject)}];
    final filteredNotes = _selectedSubjectFilter == 'All'
        ? notes
        : notes.where((n) => n.subject == _selectedSubjectFilter).toList();

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Study Notes',
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: subjects.map((subj) {
                final isSelected = _selectedSubjectFilter == subj;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(subj),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        _selectedSubjectFilter = subj;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Notes List
          Expanded(
            child: filteredNotes.isEmpty
                ? EmptyState(
                    icon: Icons.edit_note,
                    title: 'No notes created yet',
                    message: 'Summarize key UPSC concepts, articles, and judgments in personal study notes.',
                    buttonText: 'Create Your First Note',
                    onButtonPressed: () {
                      Navigator.pushNamed(context, AppRoutes.noteEditor);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return NoteCard(
                        note: note,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.noteDetail,
                            arguments: note,
                          );
                        },
                        onBookmarkToggle: () => appState.toggleBookmark(note.id),
                        onDelete: () {
                          _confirmDelete(context, appState, note);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.noteEditor);
        },
        backgroundColor: AppColors.secondaryOrange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppStateProvider appState, NoteModel note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Study Note?'),
        content: Text('Are you sure you want to delete "${note.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              appState.deleteNote(note.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
