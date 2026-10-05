import '../models/user_model.dart';
import '../data/mock_data.dart';
import 'local_storage_service.dart';

class MockAuthService {
  UserModel _currentUser = MockData.demoUser;

  UserModel get currentUser => _currentUser;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.trim().isEmpty || password.trim().isEmpty) {
      throw Exception('Email and password cannot be empty.');
    }
    if (!email.contains('@')) {
      throw Exception('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }

    _currentUser = _currentUser.copyWith(email: email.trim());
    await LocalStorageService.setLoggedIn(true);
    return true;
  }

  Future<bool> signup(String name, String email, String password, String confirmPassword) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (name.trim().isEmpty) {
      throw Exception('Please enter your full name.');
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      throw Exception('Please enter a valid email address.');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }
    if (password != confirmPassword) {
      throw Exception('Passwords do not match.');
    }

    _currentUser = _currentUser.copyWith(
      name: name.trim(),
      email: email.trim(),
    );
    await LocalStorageService.setLoggedIn(true);
    return true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await LocalStorageService.setLoggedIn(false);
  }
}
