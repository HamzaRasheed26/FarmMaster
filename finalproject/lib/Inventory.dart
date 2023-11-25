import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

class Inventory {
  String? id;
  String? cropType;
  DateTime? plantDate;
  double? Quantity;
  double? price;
  String? weatherCondition;
  String? soilType;

  Inventory({
    this.id,
    this.cropType,
    this.plantDate,
    this.Quantity,
    this.price,
    this.weatherCondition,
    this.soilType,
  });

  factory Inventory.fromMap(Map<String, dynamic> map) {
    return Inventory(
      id: map['id'] as String?,
      cropType: map['cropType'] as String?,
      plantDate: map['plantDate'] != null ? DateTime.parse(map['plantDate'] as String) : null,
      Quantity: map['Quantity'] as double?,
      price: map['price'] as double?,
      weatherCondition: map['weatherCondition'] as String?,
      soilType: map['SoilType'] as String?,
    );
  }
}

class InventoryScreen extends StatefulWidget {
  @override
  InventoryScreenState createState() => InventoryScreenState();
}
class InventoryScreenState extends State<InventoryScreen> {
  List<Inventory> crops = [];
  late List<Inventory> filteredCrops;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController
    _searchController = TextEditingController();
    filteredCrops = []; // Initialize the filteredCrops list
    fetchCrops();
  }
  // Implement the search functionality for each criterion
  void searchByCropType(String query) {
    setState(() {
      filteredCrops = crops
          .where((crop) =>
          crop.cropType!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  Future<void> fetchCrops() async {
    try {
      List<Inventory> fetchedCrops = await getCrops();
      setState(() {
        crops = fetchedCrops;
        filteredCrops = List.from(crops); // Initialize filteredCrops with all crops initially
      });
    } catch (e) {
      print('Error fetching crops: $e');
      // Handle error
    }
  }
  void dispose() {
    // Clean up the controller when the widget is disposed
    _searchController.dispose();
    super.dispose();
  }
  @override
  Future<List<Inventory>> getCrops() async {
    var response = await http.get(Uri.parse(viewcrop));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('crops') && jsonResponse['crops'] is List) {
        List<dynamic> cropList = jsonResponse['crops'];
        List<Inventory> crops = cropList.map((data) => Inventory.fromMap(data))
            .toList();
        return crops;
      } else {
        throw Exception('Invalid response format or missing "crops" field');
      }
    } else {
      throw Exception('Failed to load crops');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Tracking'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
        Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: 'Search by Crop Type',
            labelStyle: TextStyle(color:Colors.green),
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            searchByCropType(value);
          }
        ),
      ),
      SizedBox(
        height: 800,
        child: ListView.builder(
          itemCount: filteredCrops.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crop Type: ${filteredCrops[index].cropType ?? ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                      Text(
                        'Plant Date: ${crops[index].plantDate?.toString() ??
                            ''}',
                      ),
                      Text(
                        'Quantity: ${crops[index].Quantity?.toString() ?? ''}',
                      ),
                      Text(
                        'Price: ${crops[index].price?.toString() ?? ''}',
                      ),
                      Text(
                        'Weather: ${crops[index].weatherCondition?.toString() ??
                            ''}',
                      ),
                      Text(
                        'Soil Type: ${crops[index].soilType?.toString() ?? ''}',
                      )
                  ],
                ),
              ),
            );
          },
        ),
      ),
            ],
        ),
      ),
    );
  }
}
