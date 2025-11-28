import 'dart:io';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CreateUser {
  final UserRepository repository;
  CreateUser(this.repository);

  Future<User> call(String name, String email, File? image) {
    return repository.createUser(name, email, image);
  }
}
