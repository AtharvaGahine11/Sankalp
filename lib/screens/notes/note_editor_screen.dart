import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note_model.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';

class NoteEditorScreen extends StatefulWidget {
  final dynamic initialNoteOrData;

  const NoteEditorScreen({super.key, this.initialNoteOrData});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subjectController;
  late TextEditingController _topicController;
  late TextEditingController _contentController;

  NoteModel? _existingNote;

  final List<String> _suggestedSubjects = [
    'Indian Polity',
    'Modern History',
    'Physical Geography',
    'Indian Economy',
    'Environment & Ecology',
    'Science & Technology',
    'Current Affairs',
    'CSAT',
    'Ethics GS IV',
  ];

  @override
  void initState() {
    super.initState();

    String title = '';
    String subject = 'Indian Polity';
    String topic = '';
    String content = '';

    if (widget.initialNoteOrData is NoteModel) {
      _existingNote = widget.initialNoteOrData as NoteModel;
      title = _existingNote!.title;
      subject = _existingNote!.subject;
      topic = _existingNote!.topic;
      content = _existingNote!.content;
    } else if (widget.initialNoteOrData is Map<String, dynamic>) {
      final map = widget.initialNoteOrData as Map<String, dynamic>;
      title = map['title'] ?? '';
      subject = map['subject'] ?? 'Indian Polity';
      topic = map['topic'] ?? '';
      content = map['content'] ?? '';
    }

    _titleController = TextEditingController(text: title);
    _subjectController = TextEditingController(text: subject);
    _topicController = TextEditingController(text: topic);
    _contentController = TextEditingController(text: content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (!_formKey.currentState!.validate()) return;

    final appState = Provider.of<AppStateProvider>(context, listen: false);

    if (_existingNote != null) {
      final updated = _existingNote!.copyWith(
        title: _titleController.text.trim(),
        subject: _subjectController.text.trim(),
        topic: _topicController.text.trim(),
        content: _contentController.text.trim(),
      );
      appState.updateNote(updated);
      AppHelpers.showSnackBar(context, 'Study note updated!', isSuccess: true);
    } else {
      appState.addNote(
        title: _titleController.text.trim(),
        subject: _subjectController.text.trim(),
        topic: _topicController.text.trim(),
        content: _contentController.text.trim(),
      );
      AppHelpers.showSnackBar(context, 'New study note saved!', isSuccess: true);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _existingNote != null ? 'Edit Note' : 'Create Note',
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.secondaryOrange, size: 26),
            tooltip: 'Save Note',
            onPressed: _saveNote,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Note Title (e.g. Fundamental Rights)',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter note title';
                  return null;
                },
              ),
              const Divider(height: 24),

              // Subject Dropdown / Input
              const Text('UPSC Subject', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _suggestedSubjects.contains(_subjectController.text)
                    ? _subjectController.text
                    : _suggestedSubjects.first,
                items: _suggestedSubjects
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _subjectController.text = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(height: 16),

              // Topic Field
              const Text('Specific Topic', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _topicController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Articles 14 to 18 Nuances',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please specify topic';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Content Area
              const Text('Notes Content & Key Takeaways', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contentController,
                maxLines: 14,
                style: const TextStyle(fontSize: 14, height: 1.5),
                decoration: const InputDecoration(
                  hintText: 'Write or paste your revision summaries, landmark judgments, mnemonics, or model answer points here...',
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter notes content';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(_existingNote != null ? 'Update Study Note' : 'Save Study Note'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
