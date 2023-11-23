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
  Future SendEmail() async
  {
    // const serviceId="service_t4wlhgg";
    // const templateId="template_zhicz5d";
    // const userId="T4wrAk-G98PSGhP0f";
    // final response = await http.post(Uri.parse(email),
    //     headers: {'origin':'http://localhost',
    //   'Content-Type': 'application/json'},
    //     body: jsonEncode({
    //       "service_id": serviceId,
    //       "template_id":templateId,
    //       "user_id":userId,
    //       "template_params":{
    //         "name":_nameController.text,
    //         "subject":_subjectController.text,
    //         "message":_messageController.text,
    //         "to_email":_emailController.text,
    //         "user_email":"mahnoorfatima3324@gmail.com",
    //       }
    //     })
    // );
    //  print(response.statusCode);
    String mail=_emailController.text;
    String subject=_emailController.text;
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
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Message'),
              maxLines: 4,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
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
