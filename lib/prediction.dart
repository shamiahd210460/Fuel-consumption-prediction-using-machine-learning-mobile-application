import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  TextEditingController yearController = TextEditingController();
  TextEditingController makeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController vehicleClassController = TextEditingController();
  TextEditingController engineSizeController = TextEditingController();
  TextEditingController cylindersController = TextEditingController();
  TextEditingController transmissionController = TextEditingController();
  TextEditingController fuelTypeController = TextEditingController();
  TextEditingController fuelConsumptionCityController = TextEditingController();
  TextEditingController fuelConsumptionHwyController = TextEditingController();
  TextEditingController combController = TextEditingController();
  TextEditingController co2EmissionsController = TextEditingController();
  TextEditingController co2RatingController = TextEditingController();
  TextEditingController smogRatingController = TextEditingController();
  String prediction = '';
  String errorMessage = '';

  Future<void> predict() async {
    if (_validateData()) {
      Map<String, dynamic> requestData = {
        "MODEL YEAR": int.parse(yearController.text),
        "MAKE": makeController.text,
        "MODEL(# = high output engine)": modelController.text,
        "VEHICLE CLASS": vehicleClassController.text,
        "ENGINE SIZE (L)": double.parse(engineSizeController.text),
        "CYLINDERS": int.parse(cylindersController.text),
        "TRANSMISSION": transmissionController.text,
        "FUEL TYPE": fuelTypeController.text,
        "FUEL CONSUMPTION CITY (L/100)": double.parse(fuelConsumptionCityController.text),
        "FUEL CONSUMPTION HWY (L/100)": double.parse(fuelConsumptionHwyController.text),
        "COMB (mpg)": int.parse(combController.text),
        "CO2 EMISSIONS (g/km)": int.parse(co2EmissionsController.text),
        "CO2 Rating": int.parse(co2RatingController.text),
        "Smog Rating": int.parse(smogRatingController.text)
      };

      String jsonData = json.encode(requestData);
      print('Request Data: $jsonData');

      final Uri uri = Uri.parse('http://10.0.2.2:5000/predict');
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        setState(() {
          prediction = jsonDecode(response.body)['prediction'].toString();
          errorMessage = '';
        });
      } else {
        setState(() {
          prediction = '';
          errorMessage = 'Failed to load prediction';
        });
      }
      print('Prediction: $prediction');
    }
  }

 bool _validateData() {
  if (yearController.text.isEmpty ||
      makeController.text.isEmpty ||
      modelController.text.isEmpty ||
      vehicleClassController.text.isEmpty ||
      engineSizeController.text.isEmpty ||
      cylindersController.text.isEmpty ||
      transmissionController.text.isEmpty ||
      fuelTypeController.text.isEmpty ||
      fuelConsumptionCityController.text.isEmpty ||
      fuelConsumptionHwyController.text.isEmpty ||
      combController.text.isEmpty ||
      co2EmissionsController.text.isEmpty ||
      co2RatingController.text.isEmpty ||
      smogRatingController.text.isEmpty) {
    setState(() {
      errorMessage = 'All fields are required';
    });
    return false;
  } else {
    setState(() {
      errorMessage = '';
    });
    return true;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Predict Fuel Consumption'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(yearController, 'Model Year', TextInputType.number),
              _buildTextField(makeController, 'Make'),
              _buildTextField(modelController, 'Model'),
              _buildTextField(vehicleClassController, 'Vehicle Class'),
              _buildTextField(engineSizeController, 'Engine Size (L)', TextInputType.number),
              _buildTextField(cylindersController, 'Cylinders', TextInputType.number),
              _buildTextField(transmissionController, 'Transmission'),
              _buildTextField(fuelTypeController, 'Fuel Type'),
              _buildTextField(fuelConsumptionCityController, 'Fuel Consumption City (L/100)', TextInputType.number),
              _buildTextField(fuelConsumptionHwyController, 'Fuel Consumption Hwy (L/100)', TextInputType.number),
              _buildTextField(combController, 'COMB (mpg)', TextInputType.number),
              _buildTextField(co2EmissionsController, 'CO2 Emissions (g/km)', TextInputType.number),
              _buildTextField(co2RatingController, 'CO2 Rating', TextInputType.number),
              _buildTextField(smogRatingController, 'Smog Rating', TextInputType.number),
              SizedBox(height: 20),
             ElevatedButton(
  onPressed: () async {
    await predict();
  },
  style: ElevatedButton.styleFrom(
    backgroundColor:const Color.fromARGB(255, 183, 88, 0), // Button background color
  ),
  child: Text('Predict', style: TextStyle(color: Colors.white)), // Text with white color
),


              SizedBox(height: 20),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              if (prediction.isNotEmpty)
                Text(
                  'Predicted Fuel Consumption: $prediction L/100 km',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType,
    );
  }
}

