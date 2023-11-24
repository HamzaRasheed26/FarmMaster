import 'dart:convert';
import 'package:flutter/material.dart';
import 'signup.dart'; // Import the signup page file
import 'Farmermenu.dart';
import 'AdminMenu.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HappyFarm'),
      ),
      body: Container(
        color: Colors.green, // Set the background color here
        child: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isNotValid = false;

  void loginUser() async {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": _emailController.text,
        "password": _passwordController.text,
      };
      var response = await http.post(Uri.parse(login),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reqBody)
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if(jsonResponse['status']) {

        if (jsonResponse['role'] == "Admin") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminMenuPage()),
          );
        }
        else if (jsonResponse['role'] == "Farmer") {
          final email= _emailController.text;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MenuPage()),
          );
        }
        else {
          print("something went wrong");
        }
      }
      else {
        setState(() {
          _isNotValid=true;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 32.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              errorText: _isNotValid ? 'Enter proper Info' : null,

            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              errorText: _isNotValid ? 'Enter proper Info' : null,
            ),
            obscureText: true,
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              loginUser();
            },
            child: Text('Login'),
          ),
          SizedBox(height: 16.0),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpForm()),
              );
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Not registered? ',
                    style: TextStyle(
                      color: Colors.black, // Color for "Not registered?"
                    ),
                  ),
                  TextSpan(
                    text: 'SignUp',
                    style: TextStyle(
                      color: Colors.white, // Color for "SignUp"
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}