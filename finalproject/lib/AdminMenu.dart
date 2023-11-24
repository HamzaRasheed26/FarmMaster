import 'package:finalproject/welcome.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'cropManagement.dart';
import 'UserManagemnt.dart';
import 'ViewSell.dart';
import 'EmailSending.dart';
void main() {
  runApp(AdminMenuPage());
}

class AdminMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer Menu',
      home: AdminMenu(),
    );
  }
}

class AdminMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Admin Menu'),
      ),
      body:  Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Farm2.png', // Path to image
            width: 2000,
            height: 700,
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              'Take Care of Your Farm Here',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontWeight: FontWeight.bold,

              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Tooltip(
                  message: 'Menu',
                  child: Icon(Icons.menu, color: Colors.white),
                ),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
            ),
            IconButton(
              icon:Tooltip(
                message: 'LogOut',
                child: Icon(Icons.logout, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menu Options',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserManagementScreen()),
                );
                // Close drawer after selection
              },
            ),
            SizedBox(height: 50), // Adding space between options
            ListTile(
              leading: Icon(Icons.content_copy),
              title: Text('Content Management'),
              onTap: () {
                // Handle Inventory Tracking
                Navigator.pop(context); // Close drawer after selection
              },
            ),
            SizedBox(height: 50), // Adding space between options
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Reporting'),
              onTap: () {
                // Handle Weather & Forecasting
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome()),
                );
              },
            ),
            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Market oversight'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellCropViewPage()),
                );
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}