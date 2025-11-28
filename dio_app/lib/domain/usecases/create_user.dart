import '../entities/user.dart';
import '../repositories/user_repository.dart';
import 'dart:io';

class CreateUser {
  final UserRepository repository;
  CreateUser(this.repository);

  Future<User> call(String name, String email, File? image) async {
    return await repository.createUser(name, email, image);
  }
}
