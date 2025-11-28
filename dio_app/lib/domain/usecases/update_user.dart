import '../entities/user.dart';
import '../repositories/user_repository.dart';
import 'dart:io';

class UpdateUser {
  final UserRepository repository;
  UpdateUser(this.repository);

  Future<User> call(int id, String name, String email, File? image) async {
    return await repository.updateUser(id, name, email, image);
  }
}
