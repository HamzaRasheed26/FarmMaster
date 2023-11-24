import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class ViewSellCrop {
  final String id;
  final String cropType;
  final DateTime? plantDate;
  final double Quantity;
  final double price;
  final String weatherCondition;
  final String soilType;

  ViewSellCrop({
    required this.id,
    required this.cropType,
    required this.plantDate,
    required this.Quantity,
    required this.price,
    required this.weatherCondition,
    required this.soilType,
  });

  factory ViewSellCrop.fromMap(Map<String, dynamic> map) {
    return ViewSellCrop(
      id: map['id'] as String,
      cropType: map['cropType'] as String,
      weatherCondition: map['weatherCondition'] as String,
      plantDate: map['plantDate'] != null ? DateTime.parse(map['plantDate'] as String) : null,
      soilType: map['SoilType'] as String,
      Quantity: map['Quantity'] as double,
      price: map['price'] as double,
    );
  }
}

class SellCropViewPage extends StatefulWidget {
  @override
  _SellCropViewPageState createState() => _SellCropViewPageState();
}

class _SellCropViewPageState extends State<SellCropViewPage> {
  late List<ViewSellCrop> sellCrops = [];

  Future<List<ViewSellCrop>> getSellCrops() async {
    try {
      print(sellCrops);
      var response = await http.get(Uri.parse(getAllsellcrops));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.containsKey('crops') && jsonResponse['crops'] is List) {
          List<dynamic> cropList = jsonResponse['crops'];
          List<ViewSellCrop> fetchedCrops = cropList.map((data) => ViewSellCrop.fromMap(data)).toList();
          return fetchedCrops;
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
    fetchCrops();
    print(sellCrops);
  }

  Future<void> fetchCrops() async {
    try {
      List<ViewSellCrop> fetchedCrops = await getSellCrops();
      setState(() {
        sellCrops = fetchedCrops;
      });
    } catch (e) {
      print('Error fetching crops: $e');
      // Handle error
    }
  }
  Future<void> deleteCrop(String id) async {
    if (id != null) {
      // Adjust the endpoint as per your API
      try {
        var response = await http.delete(
          Uri.parse('$delsellcrops$id'),
          headers: {'Content-Type': 'application/json'},
        );
        print((response.statusCode));
        if (response.statusCode == 204) {
          setState(() {
            // Remove the crop with the matching ID from the list displayed in UI
            sellCrops.removeWhere((sellcrop) => sellcrop.id == id);
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
        title: Text('Sell Crop List'),
      ),
      body: ListView.builder(
        itemCount: sellCrops.length,
        itemBuilder: (context, index) {
          ViewSellCrop sellCrop = sellCrops[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Crop Type: ${sellCrop.cropType}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Plant Date: ${sellCrop.plantDate.toString()}'),
                  Text('Quantity: ${sellCrop.Quantity.toString()}'),
                  Text('Price: ${sellCrop.price.toString()}'),
                  Text('Weather Condition: ${sellCrop.weatherCondition}'),
                  Text('Soil Type: ${sellCrop.soilType}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  print(sellCrop.id);
                  deleteCrop(sellCrop.id);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
