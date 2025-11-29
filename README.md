# Flutter Clean Architecture Structure
lib/
├─ main.dart
├─ core/
│  └─ network/
│     └─ api_client.dart
├─ data/
│  ├─ models/
│  │  └─ user_model.dart
│  ├─ datasources/
│  │  └─ user_remote_data_source.dart
│  └─ repositories/
│     └─ user_repository_impl.dart
├─ domain/
│  ├─ entities/
│  │  └─ user.dart
│  ├─ repositories/
│  │  └─ user_repository.dart
│  └─ usecases/
│     ├─ get_users.dart
│     ├─ create_user.dart
│     ├─ update_user.dart
│     └─ delete_user.dart
├─ presentation/
│  ├─ providers/
│  │  └─ user_provider.dart
│  └─ pages/
│     ├─ user_list_page.dart
│     └─ user_form_page.dart
