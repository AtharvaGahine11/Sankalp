import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'services/app_state_provider.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService.init();

  runApp(
    ChangeNotifierProvider<AppStateProvider>(
      create: (_) => AppStateProvider(),
      child: const SankalpApp(),
    ),
  );
}
