import 'package:nafas/features/auth/domain/user.dart';

abstract class AuthRepository {
  Future<User> login(String pseudonym, String maskId);
  Future<User?> getCurrentUser();
  Future<void> logout();
}
