import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class Content {
  final String id;
  final String Name;
  final String Subject;
  final String email;
  final String msg;

  Content({
    required this.id,
    required this.Name,
    required this.Subject,
    required this.email,
    required this.msg,
  });

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      id: map['id'] as String,
      Name: map['Name'] as String,
      Subject: map['Subject'] as String,
      email: map['email'] as String,
      msg: map['msg'] as String,
    );
  }
}

class ContentPage extends StatefulWidget {
  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<ContentPage> {
  late List<Content> emails = [];

  Future<List<Content>> getemails() async {
    try {
      var response = await http.get(Uri.parse(getAllemails));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('emails') && jsonResponse['emails'] is List) {
          List<dynamic> emailList = jsonResponse['emails'];
          List<Content> fetchedEmails = emailList.map((data) => Content.fromMap(data)).toList();
          return fetchedEmails;
        } else {
          throw Exception('Invalid response format or missing "crops" field');
        }
      } else {
        throw Exception('Failed to load crops');
      }
    } catch (e) {
      throw Exception('Error fetching crops: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchEmails();
  }

  Future<void> fetchEmails() async {
    try {
      List<Content> fetchedEmails= await getemails();
      setState(() {
        emails = fetchedEmails;
      });
    } catch (e) {
      print('Error fetching crops: $e');
      // Handle error
    }
  }
  Future<void> deleteemail(String id) async {
    if (id != null) {
      // Adjust the endpoint as per your API
      try {
        var response = await http.delete(
          Uri.parse('$url$id'),
          headers: {'Content-Type': 'application/json'},
        );
        print((response.statusCode));
        if (response.statusCode == 204) {
          setState(() {
            // Remove the crop with the matching ID from the list displayed in UI
            emails.removeWhere((email) => email.id == id);
          });
          print('Crop deleted successfully');
        } else {
          print('Failed to delete crop');
        }
      } catch (error) {
        print('Error deleting crop: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Content'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: emails.length,
        itemBuilder: (context, index) {
          Content email = emails[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Name: ${email.Name}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subject: ${email.Name.toString()}'),
                  Text('email: ${email.email.toString()}'),
                  Text('msg: ${email.msg.toString()}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.green,
                onPressed: () {
                  deleteemail(email.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
