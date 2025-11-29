import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/features/auth/domain/auth_repository.dart';
import 'package:nafas/features/auth/domain/user.dart';
import 'package:uuid/uuid.dart';

class MockAuthRepository implements AuthRepository {
  User? _currentUser;

  @override
  Future<User> login(String pseudonym, String maskId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    _currentUser = User(
      id: const Uuid().v4(),
      pseudonym: pseudonym,
      maskId: maskId,
      joinedAt: DateTime.now(),
    );
    
    return _currentUser!;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});

class CurrentUserNotifier extends Notifier<User?> {
  @override
  User? build() => null;
  
  void setUser(User? user) {
    state = user;
  }
}

final currentUserProvider = NotifierProvider<CurrentUserNotifier, User?>(
  () => CurrentUserNotifier(),
);
