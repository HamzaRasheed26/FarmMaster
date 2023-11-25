import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

class EUser {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  String? role;

  EUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.role,
  });

  factory EUser.fromMap(Map<String, dynamic> map) {
    return EUser(
      id: map['id'] as String?,
      firstName: map['firstName'] as String?,
      lastName: map['lastName'] as String?,
      email: map['email'] as String?,
      password: map['password'] as String?,
      role: map['role'] as String?,
    );
  }
}
class EditUserScreen extends StatefulWidget {
  final int selectedIndex;
  final List<EUser> userList;

  EditUserScreen({required this.selectedIndex, required this.userList});

  @override
  EditUserScreenState createState() => EditUserScreenState(selectedIndex, userList);
}

class EditUserScreenState extends State<EditUserScreen> {
  int selectedUserIndex = -1;
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordDateController = TextEditingController();
  String _selectedRole = 'Farmer';
  bool _isNotValid = false;

  int selectedIndex;
  List<EUser> UserList;

  EditUserScreenState(this.selectedIndex, this.UserList);

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordDateController.dispose();
    super.dispose();
  }

  Future<void> editUser(EUser user) async {
    if (user.id != null) {
      // Adjust the endpoint as per your API
      print(user.id);
      var updateduserData = {
        "firstName": _firstnameController.text,
        "lastName": _lastnameController.text,
        "email": _emailController.text,
        "password": _passwordDateController.text,
        "role": _selectedRole,
      };

      try {
        var response = await http.put(
          Uri.parse('$updateusers${user.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updateduserData),
        );

        if (response.statusCode == 200) {
          // If the crop was successfully updated, refresh the crop list
          print('Crop updated successfully');
        } else {
          print('Failed to update crop');
        }
      } catch (error) {
        print('Error updating crop: $error');
      }
    }
  }

  void initState() {
    super.initState();
    setState(() {
      selectedUserIndex = widget.selectedIndex; // Use widget property
      // Assign the selected user details to the input fields for editing
      _selectedRole = widget.userList[widget.selectedIndex].role ?? '';
      _emailController.text = widget.userList[widget.selectedIndex].email?.toString() ?? '';
      _firstnameController.text = widget.userList[widget.selectedIndex].firstName?.toString() ?? '';
      _lastnameController.text = widget.userList[widget.selectedIndex].lastName?.toString() ?? '';
      _passwordDateController.text = widget.userList[widget.selectedIndex].password?.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Users'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: Column(
                children: [
                  // Input fields
                  TextFormField(
                    controller: _firstnameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                    keyboardType: TextInputType.number,
                  ),

                  TextFormField(
                    controller: _lastnameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.number,
                    enabled: false,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: ['Admin', 'Farmer']
                        .map((role) =>
                        DropdownMenuItem<String>(
                          value: role,
                          child: Text(
                              role, style: TextStyle(color: Colors.green)),
                        ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  // Table to display crop data
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedUserIndex != -1) {
                        EUser selectedUser = UserList[selectedUserIndex];
                        await editUser(selectedUser);
                        setState(() {
                          selectedUserIndex =
                          -1; // Reset the selected index after editing
                        });
                      }
                    },
                    child: Text('Save',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set button color to white
                    ),
                  ),
                ])));
  }
}