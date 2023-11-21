import 'dart:convert';

import 'package:flutter/material.dart';
import 'login.dart'; // Import the login page file
import 'package:http/http.dart' as http;
import 'config.dart';
class SignupPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}
class _SignUpFormState extends State<SignUpForm> {
  String _selectedRole = 'Buyer'; // Default role selection

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isNotValid=false;
  void registerUser() async{
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){
      var regBody={
        "email":_emailController.text,
        "password":_passwordController.text,
        "role":_selectedRole
      };
      var response=await http.post(Uri.parse(registration),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode(regBody)

      );
      var jsonResponse=jsonDecode(response.body);
      if(jsonResponse['status']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
      else{
          print("Something went wrong");
      }
    }else
      {
        setState(() {
          _isNotValid=true;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
            errorText: _isNotValid ? 'Enter proper Info':null,
          ),
          obscureText: false,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            errorText: _isNotValid ?'Enter proper Info':null ,
          ),
          obscureText: true,
        ),
        SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          value: _selectedRole,
          items: ['Admin', 'Farmer', 'Advisor', 'Buyer']
              .map((role) => DropdownMenuItem<String>(
            value: role,
            child: Text(role),
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
          child: Text('Register'),
        ),
        SizedBox(height: 16.0),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text('Already registered? Login'),
        ),
      ],
    );
  }
}
