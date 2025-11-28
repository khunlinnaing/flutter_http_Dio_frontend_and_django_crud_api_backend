import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'user_form_page.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<UserProvider>(context, listen: false);
      provider.loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Consumer<UserProvider>(
        builder: (context, p, _) {
          if (p.status == Status.loading)
            return Center(child: CircularProgressIndicator());
          if (p.status == Status.error)
            return Center(child: Text(p.errorMessage ?? 'Error'));
          return ListView.builder(
            itemCount: p.users.length,
            itemBuilder: (context, index) {
              final user = p.users[index];
              return ListTile(
                leading: user.image != null
                    ? Image.network(
                        user.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : CircleAvatar(child: Icon(Icons.person)),
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UserFormPage(user: user),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => p.removeUser(user.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserFormPage()),
        ),
      ),
    );
  }
}
