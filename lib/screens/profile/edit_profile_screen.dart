import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _targetExamController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppStateProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _roleController = TextEditingController(text: user.role);
    _targetExamController = TextEditingController(text: user.targetExam);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _targetExamController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final appState = Provider.of<AppStateProvider>(context, listen: false);
    appState.updateUserProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _roleController.text.trim(),
      targetExam: _targetExamController.text.trim(),
    );

    AppHelpers.showSnackBar(context, 'Profile information updated!', isSuccess: true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.secondaryOrange),
            tooltip: 'Save Profile',
            onPressed: _saveProfile,
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
              const Text('Full Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),

              const Text('Email Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 16),

              const Text('Current Role', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter your role' : null,
              ),
              const SizedBox(height: 16),

              const Text('Target Examination', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _targetExamController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter target exam' : null,
              ),
              const SizedBox(height: 28),

              PrimaryButton(
                text: 'Save Changes',
                icon: Icons.save,
                backgroundColor: AppColors.secondaryOrange,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
