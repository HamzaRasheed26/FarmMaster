import 'dart:convert';

import 'package:flutter/material.dart';
import 'login.dart'; // Import the login page file
import 'package:http/http.dart' as http;
import 'config.dart';
class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HappyFarm'),
        backgroundColor: Colors.green, // Set AppBar background color
      ),
      body: Container(
        color: Colors.green, // Set the background color of the body
        child: Center(
          child: SignUpForm(),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String _selectedRole = 'Admin';

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isNotValid = false;

  void registerUser() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty) {
      var regBody = {
        "firstName": _firstNameController.text,
        "lastName": _lastNameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "role": _selectedRole
      };
      var response = await http.post(
        Uri.parse(registration),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
      else if(jsonResponse['error']== "Email already exists")
      {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text("Email already exists"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            }
        );
      }
      else if(jsonResponse['error']== "Password already in use") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Alert'),
                content: Text("Password already in use"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            }
        );
      }
      else
        {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Alert'),
                  content: Text("Something went wrong"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              }
          );
        }
    } else {
      setState(() {
        _isNotValid = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HappyFarm', style: TextStyle(
        color: Colors.green), // Set AppBar background color
      ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 24.0),
          Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.green,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          TextFormField(
            controller: _firstNameController,
            decoration: InputDecoration(
              labelText: 'First Name',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),

              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              errorText: _isNotValid ? 'Enter proper Info':null,
            ),
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(
              labelText: 'Last Name',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              errorText: _isNotValid ? 'Enter proper Info':null,
            ),
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              errorText: _isNotValid ? 'Enter proper Info':null,
            ),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              errorText: _isNotValid ? 'Enter proper Info':null,
            ),
            obscureText: true,
            style: TextStyle(color: Colors.green),
          ),
          SizedBox(height: 12.0),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            items: ['Admin', 'Farmer']
                .map((role) => DropdownMenuItem<String>(
              value: role,
              child: Text(role, style: TextStyle(color: Colors.green)),
            ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
            },
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              registerUser();
            },
            child: Text('Sign Up', style: TextStyle(color: Colors.green)),
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Set button color to white
            ),
          ),
          SizedBox(height: 16.0),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Already registered? Login',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}