import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/delete_user.dart';

enum Status { idle, loading, loaded, error }

class UserProvider extends ChangeNotifier {
  final GetUsers getUsersUsecase;
  final CreateUser createUserUsecase;
  final UpdateUser updateUserUsecase;
  final DeleteUser deleteUserUsecase;

  List<User> users = [];
  Status status = Status.idle;
  String? errorMessage;

  UserProvider({
    required this.getUsersUsecase,
    required this.createUserUsecase,
    required this.updateUserUsecase,
    required this.deleteUserUsecase,
  });

  Future<void> fetchUsers() async {
    status = Status.loading;
    notifyListeners();
    try {
      users = await getUsersUsecase();
      status = Status.loaded;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> addUser(String name, String email, File? image) async {
    status = Status.loading;
    notifyListeners();
    try {
      final user = await createUserUsecase(name, email, image);
      users.add(user);
      status = Status.loaded;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> editUser(int id, String name, String email, File? image) async {
    status = Status.loading;
    notifyListeners();
    try {
      final updated = await updateUserUsecase(id, name, email, image);
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) users[index] = updated;
      status = Status.loaded;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> removeUser(int id) async {
    status = Status.loading;
    notifyListeners();
    try {
      await deleteUserUsecase(id);
      users.removeWhere((u) => u.id == id);
      status = Status.loaded;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}
