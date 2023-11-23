import 'package:finalproject/welcome.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'cropManagement.dart';
import 'welcome.dart';
import 'SellAtMarket.dart';
import 'EmailSending.dart';
void main() {
  runApp(MenuPage());
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer Menu',
      home: FarmerMenu(),
    );
  }
}

class FarmerMenu extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Farmer Menu'),
      ),
      body: Center(
        child: Text(
          'Tap the menu icon at the bottom to open the drawer.',
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                // Handle Profile action
              },
            ),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
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
              leading: Icon(Icons.spa),
              title: Text('Crop Management'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropManagementScreen()),
                );
               // Close drawer after selection
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Inventory Tracking'),
              onTap: () {
                // Handle Inventory Tracking
                Navigator.pop(context); // Close drawer after selection
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Weather & Forecasting'),
              onTap: () {
                // Handle Weather & Forecasting
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Communication with Advisors'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Sell Crops at Marketplace'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SellCropScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}