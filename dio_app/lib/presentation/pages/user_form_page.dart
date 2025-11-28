import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../../domain/entities/user.dart';

class UserFormPage extends StatefulWidget {
  final User? user;
  const UserFormPage({this.user});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _name = widget.user?.name;
    _email = widget.user?.email;
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final provider = Provider.of<UserProvider>(context, listen: false);

    if (widget.user == null) {
      await provider.addUser(_name!, _email!, _imageFile);
    } else {
      await provider.editUser(widget.user!.id!, _name!, _email!, _imageFile);
    }

    if (provider.status == Status.loaded)
      Navigator.pop(context);
    else if (provider.status == Status.error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final preview = _imageFile != null
        ? Image.file(_imageFile!, width: 100, height: 100, fit: BoxFit.cover)
        : (widget.user?.image != null
              ? Image.network(widget.user!.image!, width: 100, height: 100)
              : CircleAvatar(radius: 50, child: Icon(Icons.person)));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Create User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(onTap: _pickImage, child: preview),
              SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(labelText: 'Name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter name' : null,
                      onSaved: (v) => _name = v,
                    ),
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (v) => v == null || !v.contains('@')
                          ? 'Enter valid email'
                          : null,
                      onSaved: (v) => _email = v,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(onPressed: _submit, child: Text('Submit')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
