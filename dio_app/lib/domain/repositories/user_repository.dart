import '../entities/user.dart';
import 'dart:io';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> createUser(String name, String email, File? image);
  Future<User> updateUser(int id, String name, String email, File? image);
  Future<void> deleteUser(int id);
}
