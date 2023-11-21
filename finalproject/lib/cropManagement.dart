import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

class Crop {
  String? cropType;
  DateTime? plantDate;
  DateTime? harvestDate;
  String? fertilizerUsed;
  String? weatherCondition;
  String? soilType;

  Crop({
    this.cropType,
    this.plantDate,
    this.harvestDate,
    this.fertilizerUsed,
    this.weatherCondition,
    this.soilType,
  });

  factory Crop.fromMap(Map<String, dynamic> map) {
    return Crop(
      cropType: map['cropType'] as String?,
      plantDate: map['plantDate'] != null ? DateTime.parse(map['plantDate'] as String) : null,
      harvestDate: map['harvestDate'] != null ? DateTime.parse(map['harvestDate'] as String) : null,
      fertilizerUsed: map['fertilizerUsed'] as String?,
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
  List<Crop> crops=[];
  String _selectedCropType = 'Wheat';
  String _selectedFertilizer = 'Manure';
  String _selectedWeather = 'sunny';
  String _selectedSoilType = 'Sand';
  final TextEditingController _plantDateController = TextEditingController();
  final TextEditingController _harvestDateController = TextEditingController();
  bool _isNotValid=false;
  @override
  void dispose() {
    _plantDateController.dispose();
    _harvestDateController.dispose();
    super.dispose();
  }
  void AddCrop() async {
    if (_plantDateController.text.isNotEmpty && _harvestDateController.text.isNotEmpty) {
      var reqBody = {
        "cropType": _selectedCropType,
        "plantDate": _plantDateController.text,
        "harvestDate": _harvestDateController.text,
        "fertilizerUsed": _selectedFertilizer,
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
      if (jsonResponse['status']==true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Failed'),
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Crop added successfully.'),
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
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

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
        crops = fetchedCrops;
      });
    } catch (e) {
      print('Error fetching crops: $e');
      // Handle error
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
              items: ['Wheat', 'Soy', 'Barley', 'Rice', 'Type 5']
                  .map((type) => DropdownMenuItem<String>(child: Text(type), value: type))
                  .toList(),
              onChanged: (value) {
                setState(() {
                 _selectedCropType = value!;

                });
              },
              decoration: InputDecoration(labelText: 'Crop Type'),
            ),
            DropdownButtonFormField<String>(
              value:_selectedFertilizer,
              items: ['Manure', 'Nitrogen', 'Potassium', 'Peat', 'Potash']
                  .map((type) => DropdownMenuItem<String>(child: Text(type), value: type))
                  .toList(),
              onChanged: (value) {
                setState(() {
                 _selectedFertilizer= value!;
                });
              },
              decoration: InputDecoration(labelText: 'Fertilizer Used'),
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
            TextFormField(
              controller: _harvestDateController,
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
                    _harvestDateController.text = selectedDate.toString();

                  });
                }
              },
              decoration: InputDecoration(labelText: 'Harvest Date'),
            ),
            // Other dropdowns for Fertilizer, Weather Condition, Soil Type...

            ElevatedButton(
              onPressed: () {
                setState(() {
                 AddCrop();
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
    'Harvest Date: ${crops[index].harvestDate?.toString() ?? ''}',
    ),
      Text(
        'Fertilizer Used : ${crops[index].fertilizerUsed?.toString() ?? ''}',
      ),
      Text(
        'weather: ${crops[index].weatherCondition?.toString() ?? ''}',
      ),
      Text(
        'Soil Type: ${crops[index].soilType?.toString() ?? ''}',
      ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                   // Trigger edit function
                                },
                                child: Text('Edit'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Trigger delete function
                                },
                                child: Text('Delete'),
                              ),
                            ],
                          ),
    // Add more details as needed
    ],
    ),
    ),
    );
    },
    ),
    ),
            ElevatedButton(
              onPressed: () {
                // Implement save edited data functionality
              },
              child: Text('Save Edited Data'),
            ),
          ],
        ),
      ),
    );
  }
}