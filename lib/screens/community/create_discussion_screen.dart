import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';

class CreateDiscussionScreen extends StatefulWidget {
  const CreateDiscussionScreen({super.key});

  @override
  State<CreateDiscussionScreen> createState() => _CreateDiscussionScreenState();
}

class _CreateDiscussionScreenState extends State<CreateDiscussionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String _selectedCategory = 'Strategy';
  final List<String> _categories = [
    'Strategy',
    'Prelims',
    'Mains',
    'Optional',
    'Current Affairs',
    'General Discussion',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _postDiscussion() {
    if (!_formKey.currentState!.validate()) return;

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.addDiscussion(
      title: _titleController.text.trim(),
      category: _selectedCategory,
      content: _contentController.text.trim(),
    );

    AppHelpers.showSnackBar(
      context,
      'Your discussion has been published to the community!',
      isSuccess: true,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'New Discussion Thread',
        actions: [
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.secondaryOrange),
            tooltip: 'Post Discussion',
            onPressed: _postDiscussion,
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
              // Category Selection
              const Text('Select Discussion Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(height: 18),

              // Title
              const Text('Discussion Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'e.g. How should I prepare Polity in 60 days?',
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter discussion title';
                  return null;
                },
              ),
              const SizedBox(height: 18),

              // Description / Content
              const Text('Detailed Question / Perspective', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _contentController,
                maxLines: 8,
                decoration: const InputDecoration(
                  hintText: 'Provide context, mention what you have studied so far, and describe what specific help or advice you need...',
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter detailed question content';
                  return null;
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _postDiscussion,
                  icon: const Icon(Icons.forum_outlined),
                  label: const Text('Post Discussion to Community'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
