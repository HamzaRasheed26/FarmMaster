import 'package:finalproject/welcome.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'cropManagement.dart';
import 'Inventory.dart';
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
      body:  Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Farm2.png', // Path to your image
            width: 2000, // Adjust width as needed
            height: 700, // Adjust height as needed
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
              icon:Tooltip(
                message: 'Menu',
                child:  Icon(Icons.menu, color: Colors.white),),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            IconButton(
              icon:Tooltip(
                message: 'LogOut',
                child:  Icon(Icons.logout, color: Colors.white),),
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
            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Inventory Tracking'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryScreen()),
                );// Close drawer after selection
              },
            ),
            SizedBox(height: 50),
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
            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Communication'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactPage()),
                );
              },
            ),
            SizedBox(height: 50),
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
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}