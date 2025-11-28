import 'dart:io';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;
  UpdateUser(this.repository);

  Future<User> call(int id, String name, String email, File? image) {
    return repository.updateUser(id, name, email, image);
  }
}
