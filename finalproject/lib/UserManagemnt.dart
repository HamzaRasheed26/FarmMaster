import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'edituser.dart';
import 'dart:convert';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? role;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      email: map['email'] as String?,
      password: map['password'] as String?,
      role: map['role'] as String?,
    );
  }
}
class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  int selectedCropIndex = -1;
  List<EUser> users = [];
  bool _isNotValid = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    var response = await http.get(Uri.parse(getusers));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('users') && jsonResponse['users'] is List) {
        List<dynamic> userList = jsonResponse['users'];
        return List<Map<String, dynamic>>.from(userList);
      } else {
        throw Exception('Invalid response format or missing "crops" field');
      }
    } else {
      throw Exception('Failed to load crops');
    }
  }

  void initState() {
    EfetchUsers();
    super.initState();
    EfetchUsers();
  }

  Future<void> EfetchUsers() async {
    try {
      List<Map<String, dynamic>> fetchedUsers = await getUsers();
      List<EUser> convertedUsers = fetchedUsers.map((userMap) {
        return EUser.fromMap(userMap);
      }).toList();
      setState(() {
        users = convertedUsers;
      });
    } catch (e) {
      print('Error fetching users: $e');
      // Handle error
    }
  }

  Future<void> deleteUser(String id) async {
    if (id != null) {
      // Adjust the endpoint as per your API
      try {
        var response = await http.delete(
          Uri.parse('$deleteusers$id'),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 204) {
          setState(() {
            // Remove the user with the matching ID from the list displayed in UI
            users.removeWhere((user) => user.id == id);
          });
          print('User deleted successfully');
        } else {
          print('Failed to delete User');
        }
      } catch (error) {
        print('Error deleting user: $error');
      }
    }
  }
  Future<void> navigateToEditUserScreen(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditUserScreen(
              selectedIndex: index,
              userList: users,
            ),
      ),
    );
    await EfetchUsers();
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('User Management'),
          ),
          body: SingleChildScrollView(
              child: Column(
                  children: [
                    SizedBox(
                      height: 800, // Adjust the height as needed
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'First Name: ${users[index].firstName ??
                                        ''}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    'Last Name: ${users[index].lastName
                                        ?.toString() ?? ''}',
                                  ),
                                  Text(
                                    'Email: ${users[index].email?.toString() ??
                                        ''}',
                                  ),
                                  Text(
                                    'Password: ${users[index].password
                                        ?.toString() ?? ''}',
                                  ),
                                  Text(
                                    'Role: ${users[index].role?.toString() ??
                                        ''}',
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          navigateToEditUserScreen(index);
                                        },

                                        child: Text('Edit'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          deleteUser(
                                              users[index].id.toString());
                                        },
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]
              )
          )
      );
    }
  }
