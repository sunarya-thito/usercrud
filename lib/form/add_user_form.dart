import 'package:flutter/material.dart';
import 'package:usercrud/dto.dart';

class AddUserForm extends StatefulWidget {
  const AddUserForm({Key? key}) : super(key: key);

  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('addUserDialog'),
      title: const Text('Add User'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              key: const Key('usernameField'),
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is required';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('nameField'),
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('emailField'),
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
            ),
            TextFormField(
              key: const Key('passwordField'),
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const Key('cancelButton'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          key: const Key('submitAddUserButton'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              UserDto.add(
                _usernameController.text,
                _nameController.text,
                _passwordController.text,
                _emailController.text,
              ).then((value) {
                Navigator.of(context).pop(UserDto(
                  id: value,
                  username: _usernameController.text,
                  name: _nameController.text,
                  password: _passwordController.text,
                  email: _emailController.text,
                ));
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
