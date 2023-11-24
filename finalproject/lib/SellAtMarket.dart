import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'ViewSell.dart';

class SellCrop {
  String? id;
  String? cropType;
  String? weatherCondition;
  DateTime? plantDate;
  String? soilType;
  double? Quantity;
  double? price;

  SellCrop({
    this.id,
    this.cropType,
    this.weatherCondition,
    this.plantDate,
    this.soilType,
    this.Quantity,
    this.price,
  });

  factory SellCrop.fromMap(Map<String, dynamic> map) {
    return SellCrop(
      id: map['id'] as String?,
      cropType: map['cropType'] as String?,
      weatherCondition: map['weatherCondition'] as String?,
      plantDate: map['plantDate'] != null ? DateTime.parse(map['plantDate'] as String) : null,
      soilType: map['SoilType'] as String?,
      Quantity: map['Quantity'] as double?,
      price: map['price'] as double?,
    );
  }
}

class SellCropScreen extends StatefulWidget {
  @override
  _SellCropScreenState createState() => _SellCropScreenState();
}

class _SellCropScreenState extends State<SellCropScreen> {
  late List<SellCrop> cropsForSale = [];
  late List<SellCrop> crops = [];
  late bool isAdding = false;

  void AddCrop(String id) async {
    await fetchSellCrops(id); // Wait for fetchSellCrops to complete before continuing

    if (cropsForSale.isNotEmpty) {
      var reqBody = {
        "cropType": cropsForSale.last.cropType,
        "plantDate": cropsForSale.last.plantDate?.toIso8601String(),
        "Quantity": cropsForSale.last.Quantity,
        "price": cropsForSale.last.price,
        "weatherCondition": cropsForSale.last.weatherCondition,
        "SoilType": cropsForSale.last.soilType,
      };

      var response = await http.post(
        Uri.parse(addsellCrop),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['error']);
      if (jsonResponse['status'] == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Crop added for selling successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
      else if(jsonResponse['error']== "already exists")
      {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Fail'),
                content: Text('Crop Already at Marketplace'),
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
      else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Fail'),
              content: Text('Crop did not added'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print('No crops available for sale');
      // Handle empty cropsForSale list
    }
  }
  Future<SellCrop> getSellCrops(String id) async {
    var response = await http.get(
      Uri.parse('$getsellcrop$id'),
      headers: {'Content-Type': 'application/json'},
    );


    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('crops')) {
        Map<String, dynamic> cropMap = jsonResponse['crops'];
        return SellCrop.fromMap(cropMap);
      } else {
        throw Exception('Invalid response format or missing "crop" field');
      }
    } else {
      throw Exception('Failed to load crop');
    }
  }
  Future<List<SellCrop>> getCrops() async {
    var response = await http.get(Uri.parse(viewcrop));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('crops') && jsonResponse['crops'] is List) {
        List<dynamic> cropList = jsonResponse['crops'];
        List<SellCrop> crops =
        cropList.map((data) => SellCrop.fromMap(data)).toList();
        return crops;
      } else {
        throw Exception('Invalid response format or missing "crops" field');
      }
    } else {
      throw Exception('Failed to load crops');
    }
  }

  void initState() {
    super.initState();
    fetchCrops();
  }

  Future<void> fetchCrops() async {
    try {
      List<SellCrop> fetchedCrops = await getCrops();
      setState(() {
        crops = fetchedCrops;
      });
    } catch (e) {
      print('Error fetching crops: $e');
      // Handle error
    }
  }
  Future<void> fetchSellCrops(String id) async {
    try {
      SellCrop fetchedSellCrop = await getSellCrops(id);
      setState(() {
        cropsForSale = [fetchedSellCrop]; // Assuming cropsForSale is a list
      });
    } catch (e) {
      print('Error fetching crops: $e');
      // Handle error
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell at Marketplace'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: crops.length + 1, // Add one for the "View" button
              itemBuilder: (context, index) {
                if (index < crops.length) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crop Type: ${crops[index].cropType ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Weather: ${crops[index].weatherCondition ?? ''}',
                          ),
                          Text(
                            'Soil Type: ${crops[index].soilType ?? ''}',
                          ),
                          Text(
                            'Plant Date: ${crops[index].plantDate ?? ''}',
                          ),
                          Text(
                            'Quantity: ${crops[index].Quantity ?? ''}',
                          ),
                          Text(
                            'Price: ${crops[index].price ?? ''}',
                          ),
                          ElevatedButton(
                            onPressed: () {
                              AddCrop(crops[index].id.toString());
                            },
                            child: Text('Add'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SellCropViewPage()),
                      );
                    },
                    child: Text('View'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
