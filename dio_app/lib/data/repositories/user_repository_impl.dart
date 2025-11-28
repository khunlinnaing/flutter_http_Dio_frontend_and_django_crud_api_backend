import 'dart:io';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  UserRepositoryImpl({required this.remote});

  @override
  Future<User> createUser(String name, String email, File? image) async {
    final userModel = await remote.createUser(name, email, image);
    return userModel;
  }

  @override
  Future<void> deleteUser(int id) async {
    await remote.deleteUser(id);
  }

  @override
  Future<List<User>> getUsers() async {
    final users = await remote.getUsers();
    return users;
  }

  @override
  Future<User> updateUser(
    int id,
    String name,
    String email,
    File? image,
  ) async {
    final user = await remote.updateUser(id, name, email, image);
    return user;
  }
}
