import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isNotVAlid=false;
  Future SendEmail() async
  {
    String mail=_emailController.text;
    String subject=_subjectController.text;
    String msg=_messageController.text;
    final Uri email=Uri(scheme: 'mailto',
    path: mail,
    query: 'subject='+Uri.encodeComponent(subject)+'&body='+Uri.encodeComponent(msg));
    if(await canLaunchUrl(email))
      {
        await launchUrl((email));
      }else{
      debugPrint('error');
    }
  }

  void AddEmail() async {
    if (_emailController.text.isNotEmpty &&
        _messageController.text.isNotEmpty &&
        _subjectController.text.isNotEmpty &&
        _nameController.text.isNotEmpty) {
      var regBody = {
        "Name": _nameController.text,
        "Subject": _subjectController.text,
        "email": _emailController.text,
        "msg": _messageController.text,
      };
      var response = await http.post(
        Uri.parse(addemail),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        print("email sent");
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
        _isNotVAlid = true;
      });
    }
  }
  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _subjectController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name', errorText: _isNotVAlid ? 'Enter proper Info':null),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject',errorText: _isNotVAlid ? 'Enter proper Info':null),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email',errorText: _isNotVAlid ? 'Enter proper Info':null),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message',errorText: _isNotVAlid ? 'Enter proper Info':null),
              maxLines: 4,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                AddEmail();
                SendEmail();
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
