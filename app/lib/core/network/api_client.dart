import 'package:http/http.dart' as http;
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/update_user.dart';
import '../../domain/usecases/delete_user.dart';

class ApiClient {
  late final http.Client client;
  late final UserRemoteDataSource remote;
  late final UserRepositoryImpl repository;

  late final GetUsers getUsers;
  late final CreateUser createUser;
  late final UpdateUser updateUser;
  late final DeleteUser deleteUser;

  ApiClient({String baseUrl = 'http://0.0.0.0:9090/api'}) {
    client = http.Client();
    remote = UserRemoteDataSource(baseUrl: baseUrl, client: client);
    repository = UserRepositoryImpl(remote: remote);

    getUsers = GetUsers(repository);
    createUser = CreateUser(repository);
    updateUser = UpdateUser(repository);
    deleteUser = DeleteUser(repository);
  }
}
