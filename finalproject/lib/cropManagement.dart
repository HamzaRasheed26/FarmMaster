import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

class Crop {
  String? id;
  String? cropType;
  DateTime? plantDate;
  double? Quantity;
  double? price;
  String? weatherCondition;
  String? soilType;

  Crop({
    this.id,
    this.cropType,
    this.plantDate,
    this.Quantity,
    this.price,
    this.weatherCondition,
    this.soilType,
  });

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
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

class CropManagementScreen extends StatefulWidget {
  @override
  _CropManagementScreenState createState() => _CropManagementScreenState();
}

class _CropManagementScreenState extends State<CropManagementScreen> {
  int selectedCropIndex = -1;
  List<Crop> crops = [];
  String _selectedCropType = 'Wheat';
  String _selectedWeather = 'sunny';
  String _selectedSoilType = 'Sand';
  final TextEditingController _plantDateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isNotValid = false;

  @override
  void dispose() {
    _plantDateController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void AddCrop() async {
    if (_plantDateController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty && _priceController.text.isNotEmpty) {
      var reqBody = {
        "cropType": _selectedCropType,
        "plantDate": _plantDateController.text,
        "Quantity": _quantityController.text,
        "price": _priceController.text,
        "weatherCondition": _selectedWeather,
        "SoilType": _selectedSoilType,
      };

      var response = await http.post(
        Uri.parse(addcrop),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if (jsonResponse['status'] == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Crop added successfully'),
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
      } else {
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
      setState(() {
        _isNotValid = true;
      });
    }
  }

  Future<List<Crop>> getCrops() async {
    var response = await http.get(Uri.parse(viewcrop));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('crops') && jsonResponse['crops'] is List) {
        List<dynamic> cropList = jsonResponse['crops'];
        List<Crop> crops = cropList.map((data) => Crop.fromMap(data)).toList();
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
      List<Crop> fetchedCrops = await getCrops();
      setState(() {
        print(fetchedCrops);
        crops = fetchedCrops;

      });
    } catch (e) {
      print('Error fetching crops: $e');
      // Handle error
    }
  }
  Future<void> deleteCrop(String id) async {
    print(id);
    if (id != null) {
     // Adjust the endpoint as per your API
      try {
        var response = await http.delete(
          Uri.parse('$url$id'),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 204) {
          setState(() {
            // Remove the crop with the matching ID from the list displayed in UI
            crops.removeWhere((crop) => crop.id == id);
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

  Future<void> editCrop(Crop crop) async {
    if (crop.id != null) {
     // Adjust the endpoint as per your API
    print(crop.id);
      var updatedCropData = {
        "cropType": _selectedCropType,
        "plantDate": _plantDateController.text,
        "Quantity": _quantityController.text,
        "price": _priceController.text,
        "weatherCondition": _selectedWeather,
        "SoilType": _selectedSoilType,
        // Add other fields as needed
      };

      try {
        var response = await http.put(
          Uri.parse('$url${crop.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(updatedCropData),
        );

        if (response.statusCode == 200) {
          // If the crop was successfully updated, refresh the crop list
          await fetchCrops();
          print('Crop updated successfully');
        } else {
          print('Failed to update crop');
        }
      } catch (error) {
        print('Error updating crop: $error');
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Crop Management'),
        ),
        body: SingleChildScrollView(
            child: Column(
                children: [
            // Input fields
            DropdownButtonFormField<String>(
              value: _selectedCropType,
              items: [
                'Wheat',
                'Soy',
                'Barley',
                'Rice',
                'Oat',
              ].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCropType = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Crop Type'),
            ),

            TextFormField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value:_selectedWeather,
              items: ['sunny', 'rainy', 'stormy', 'cloudy']
                  .map((type) => DropdownMenuItem<String>(child: Text(type), value: type))
                  .toList(),
              onChanged: (value) {
                setState(() {
                 _selectedWeather = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Weather condition '),
            ),
            DropdownButtonFormField<String>(
              value: _selectedSoilType,
              items: ['Sand', 'Clay', 'Silt', 'Loam']
                  .map((type) => DropdownMenuItem<String>(child: Text(type), value: type))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSoilType= value!;
                });
              },
              decoration: InputDecoration(labelText: 'Soil Type'),
            ),
            TextFormField(
              controller: _plantDateController,
              readOnly: true,
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2050),
                );
                if (selectedDate != null) {
                  setState(() {
                    _plantDateController.text = selectedDate.toString();
                  });
                }
              },
              decoration: InputDecoration(labelText: 'Planting Date'),
            ),
            // Other dropdowns for Fertilizer, Weather Condition, Soil Type...

            ElevatedButton(
              onPressed: () {
                setState(() {
                 AddCrop();
                 fetchCrops();
                });
              },
              child: Text('Add Data'),
            ),
            // Table to display crop data
                  SizedBox(
                    height: 400, // Adjust the height as needed
                    child: ListView.builder(
                      itemCount: crops.length,
                      itemBuilder: (context, index) {
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
                                  'Plant Date: ${crops[index].plantDate?.toString() ?? ''}',
                                ),
                                Text(
                                  'Quantity: ${crops[index].Quantity?.toString() ?? ''}',
                                ),
                                Text(
                                  'Price: ${crops[index].price?.toString() ?? ''}',
                                ),
                                Text(
                                  'Weather: ${crops[index].weatherCondition?.toString() ?? ''}',
                                ),
                                Text(
                                  'Soil Type: ${crops[index].soilType?.toString() ?? ''}',
                                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCropIndex = index; // Set the selected index
            // Assign the selected crop details to the input fields for editing
                       _selectedCropType = crops[index].cropType ?? '';
                       _priceController.text = crops[index].price.toString() ?? '';
                       _quantityController.text=crops[index].Quantity?.toString() ?? '';
                       _plantDateController.text=crops[index].plantDate?.toString() ?? '';
                       _selectedWeather=crops[index].weatherCondition?.toString() ?? '';
                       _selectedSoilType=crops[index].soilType?.toString() ?? '';
                    });
                    },
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteCrop(crops[index].id.toString());
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
                        ],
                      ),
                    ),
                  );
                  },
              ),
            ),
        ElevatedButton(
          onPressed: () async {
            if (selectedCropIndex != -1) {
              Crop selectedCrop = crops[selectedCropIndex];
              await editCrop(selectedCrop);
              setState(() {
                selectedCropIndex = -1; // Reset the selected index after editing
              });
            }
          },
          child: Text('Save Edited Data'),
        ),
        ])));
  }
}