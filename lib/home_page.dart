import 'package:flutter/material.dart';
import 'package:usercrud/components/data_widget.dart';
import 'package:usercrud/components/standard_page.dart';

import 'dto.dart';
import 'form/add_user_form.dart';
import 'form/login_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserDto? _currentUser;
  List<UserDto> _users = [];
  late Future<List<UserDto>> _future;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    _future = UserDto.findAll().then((value) {
      _users = value;
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StandardPage(
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(top: 96, left: 24, right: 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: _currentUser == null
                          ? Text(
                              'User Management',
                              style: Theme.of(context).textTheme.headline6,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, ${_currentUser!.name}',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  'You are logged in as ${_currentUser!.username}',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                    ),
                    ElevatedButton(
                      key: const Key('addUserButton'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AddUserForm();
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              _users.add(value);
                            });
                          }
                        });
                      },
                      child: const Text('Add User'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      key: const Key('loginButton'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return LoginForm();
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              _currentUser = value;
                            });
                          }
                        });
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      // if error
                      if (snapshot.hasError) {
                        return ListView(
                          controller: context.data<ScrollController>(),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Error Loading Users'),
                                  const SizedBox(height: 16),
                                  Text(snapshot.error.toString()),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      if (!snapshot.hasData) {
                        return ListView(
                          controller: context.data<ScrollController>(),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Loading Users...'),
                                  const SizedBox(height: 16),
                                  const CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        controller: context.data<ScrollController>(),
                        itemCount: snapshot.data!.length + 1,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('ID',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Text('Username',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: Text('Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: Text('Email',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      flex: 4,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          var user = _users[index - 1];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(user.id.toString()),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(user.username),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(user.name),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(user.email),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
