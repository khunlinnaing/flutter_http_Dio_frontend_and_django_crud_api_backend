import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'presentation/providers/user_provider.dart';
import 'presentation/pages/user_list_page.dart';

void main() {
  final apiClient = ApiClient();
  runApp(MyApp(apiClient: apiClient));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  MyApp({required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(
            getUsersUsecase: apiClient.getUsers,
            createUserUsecase: apiClient.createUser,
            updateUserUsecase: apiClient.updateUser,
            deleteUserUsecase: apiClient.deleteUser,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter CRUD Dio Clean Architecture',
        home: UserListPage(),
      ),
    );
  }
}
