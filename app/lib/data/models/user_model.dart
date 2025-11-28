import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    int? id,
    required String name,
    required String email,
    String? avatarUrl,
  }) : super(id: id, name: name, email: email, image: avatarUrl);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['image'] as String?, // depends on API key
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      // avatar is uploaded as multipart, so usually not in JSON for create/update
    };
  }
}
