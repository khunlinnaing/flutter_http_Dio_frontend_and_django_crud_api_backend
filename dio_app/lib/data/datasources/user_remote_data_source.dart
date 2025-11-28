import 'dart:io';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final Dio dio;
  UserRemoteDataSource({required this.dio});

  Future<List<UserModel>> getUsers() async {
    final response = await dio.get('/users');
    return (response.data as List)
        .map((json) => UserModel.fromJson(json))
        .toList();
  }

  Future<UserModel> createUser(String name, String email, File? image) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'email': email,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await dio.post('/users', data: formData);
    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateUser(
    int id,
    String name,
    String email,
    File? image,
  ) async {
    FormData formData = FormData.fromMap({
      'name': name,
      'email': email,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await dio.put('/users/$id', data: formData);
    return UserModel.fromJson(response.data);
  }

  Future<void> deleteUser(int id) async {
    await dio.delete('/users/$id');
  }
}
