import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

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

  Future<void> generatePdf() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.ListView.builder(
            itemCount: sellCrops.length,
            itemBuilder: (pw.Context context, int index) {
              ViewSellCrop sellCrop = sellCrops[index];
              return pw.Container(
                margin: pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Crop Type: ${sellCrop.cropType}'),
                    pw.Text('Plant Date: ${sellCrop.plantDate.toString()}'),
                    pw.Text('Quantity: ${sellCrop.Quantity.toString()}'),
                    pw.Text('Price: ${sellCrop.price.toString()}'),
                    pw.Text('Weather Condition: ${sellCrop.weatherCondition}'),
                    pw.Text('Soil Type: ${sellCrop.soilType}'),
                    pw.Divider(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

    // Save the PDF file
    final output = await getTemporaryDirectory();
    final pdfFile = File('${output.path}/sell_crops.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    // Open the PDF file
    // You can use any PDF viewer installed on the device
    OpenFile.open(pdfFile.path);
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
        title: Text('Market Place'),
        backgroundColor: Colors.green,
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
                color: Colors.green,
                onPressed: () {
                  print(sellCrop.id);
                  deleteCrop(sellCrop.id);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generatePdf,
        child: Icon(Icons.picture_as_pdf),
        tooltip: 'Generate PDF',
      ),
    );
  }
}
