import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime/mime.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  UserRemoteDataSource({required this.baseUrl, required this.client});

  Future<List<UserModel>> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final res = await client.get(url, headers: {'Accept': 'application/json'});

    if (res.statusCode == 200) {
      final List jsonList = json.decode(res.body) as List;
      return jsonList.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw HttpException('Failed to load users: ${res.statusCode}');
    }
  }

  Future<UserModel> createUser(
    String name,
    String email,
    File? imageFile,
  ) async {
    final uri = Uri.parse('$baseUrl/users');
    if (imageFile == null) {
      // simple POST JSON
      final res = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email}),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        print(UserModel.fromJson(json.decode(res.body)));
        return UserModel.fromJson(json.decode(res.body));
      } else {
        throw HttpException('Create failed: ${res.statusCode}');
      }
    } else {
      // multipart/form-data with image
      final request = http.MultipartRequest('POST', uri);
      request.fields['name'] = name;
      request.fields['email'] = email;
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final multipartFile = await http.MultipartFile.fromPath(
        'image', // field name expected by backend
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      if (res.statusCode == 201 || res.statusCode == 200) {
        return UserModel.fromJson(json.decode(res.body));
      } else {
        throw HttpException('Create with image failed: ${res.statusCode}');
      }
    }
  }

  Future<UserModel> updateUser(
    int id,
    String name,
    String email,
    File? imageFile,
  ) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    if (imageFile == null) {
      final res = await client.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email}),
      );
      if (res.statusCode == 200) {
        return UserModel.fromJson(json.decode(res.body));
      } else {
        throw HttpException('Update failed: ${res.statusCode}');
      }
    } else {
      final request = http.MultipartRequest('PUT', uri);
      // some backends require _method=PUT in multipart, or use proper endpoint for PATCH
      request.fields['_method'] = 'PUT'; // if server supports method override
      request.fields['name'] = name;
      request.fields['email'] = email;
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      if (res.statusCode == 200) {
        return UserModel.fromJson(json.decode(res.body));
      } else {
        throw HttpException('Update with image failed: ${res.statusCode}');
      }
    }
  }

  Future<void> deleteUser(int id) async {
    final uri = Uri.parse('$baseUrl/users/$id');
    final res = await client.delete(uri);
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw HttpException('Delete failed: ${res.statusCode}');
    }
  }
}
