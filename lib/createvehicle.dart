import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings.dart';

class CreateVehicleScreen extends StatefulWidget {
  const CreateVehicleScreen({Key? key}) : super(key: key);

  @override
  _CreateVehicleScreenState createState() => _CreateVehicleScreenState();
}

class _CreateVehicleScreenState extends State<CreateVehicleScreen> {
  final _formKey = GlobalKey<FormState>();


  String _model = '';
  String? _make;
  String _type = '';
  String _logoUrl = '';
  int? _modelYear;
  double? _engineSize;
  int? _cylinders;
  String _transmission = '';
  String _fuelType = '';
  double? _fuelConsumptionCity;
  double? _fuelConsumptionHwy;
  int? _combMPG;
  int? _co2Emissions;
  int? _co2Rating;
  int? _smogRating;

  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('Vehicles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputRow(
                  label: 'MODEL YEAR',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Model Year required';
                      }
                      final size = double.tryParse(value);
                      if (size == null || size <= 0) {
                        return 'Please enter a valid year';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _modelYear = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildDropDown(
                  label: 'MAKE',
                  value: _make,
                  items: [
                    'ACURA',
                    'ALFA ROMEO',
                    'AUDI',
                    'BENTLEY',
                    'BMW',
                    'BUICK',
                    'CADILLAC',
                    'CHEVROLET',
                    'CHRYSLER',
                    'DODGE',
                    'EAGLE',
                    'FERRARI',
                    'FORD',
                    'GEO',
                    'GMC',
                    'HONDA',
                    'HYUNDAI',
                    'INFINITI',
                    'ISUZU',
                    'JAGUAR',
                    'JEEP',
                    'LAND ROVER',
                    'LEXUS',
                    'LINCOLN',
                    'MAZDA',
                    'MERCEDES-BENZ',
                    'MERCURY',
                    'NISSAN',
                    'OLDSMOBILE',
                    'PLYMOUTH',
                    'PONTIAC',
                    'PORSCHE',
                    'ROLLS-ROYCE',
                    'SAAB',
                    'SATURN',
                    'SUBARU',
                    'SUZUKI',
                    'TOYOTA',
                    'VOLKSWAGEN',
                    'VOLVO',
                    'DAEWOO',
                    'KIA',
                    'MASERATI',
                    'MINI',
                    'MITSUBISHI',
                    'SMART',
                    'HUMMER',
                    'ASTON MARTIN',
                    'LAMBORGHINI',
                    'BUGATTI',
                    'SCION',
                    'FIAT',
                    'RAM',
                    'SRT',
                    'GENESIS'
                  ],
                  onChanged: (value) {
                    setState(() {
                      _make = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'MODEL(# =high output engine)',
                  inputField: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Model is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _model = value;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'VEHICLE CLASS',
                  inputField: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vehicle Class is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _type = value;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'ENGINE SIZE (L)',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Engine Size is required';
                      }
                      final size = double.tryParse(value);
                      if (size == null || size <= 0) {
                        return 'Please enter a valid engine size';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _engineSize = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'CYLINDERS',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cylinders is required';
                      }
                      final cylinders = int.tryParse(value);
                      if (cylinders == null || cylinders <= 0) {
                        return 'Please enter a valid number of cylinders';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _cylinders = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'TRANSMISSION',
                  inputField: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Transmission is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _transmission = value;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'FUEL TYPE',
                  inputField: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Fuel Type is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _fuelType = value;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'F_CONSUMPTION CITY(L/100)',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final consumption = double.tryParse(value);
                      if (consumption == null || consumption <= 0) {
                        return 'Please enter a valid fuel consumption';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _fuelConsumptionCity = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'F_CONSUMPTION HWY(L/100)',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final consumption = double.tryParse(value);
                      if (consumption == null || consumption <= 0) {
                        return 'Please enter a valid fuel consumption';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _fuelConsumptionHwy = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'COMB (mpg)',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Comb is required';
                      }
                      final comb = int.tryParse(value);
                      if (comb == null || comb <= 0) {
                        return 'Please enter a valid Comb';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _combMPG = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'CO2 EMISSIONS (g/km)',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CO2 Emissions is required';
                      }
                      final co2 = int.tryParse(value);
                      if (co2 == null || co2 <= 0) {
                        return 'Please enter a valid CO2 Emissions';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _co2Emissions = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'CO2 Rating',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CO2 Rating is required';
                      }
                      final rating = int.tryParse(value);
                      if (rating == null || rating <= 0) {
                        return 'Please enter a valid CO2 Rating';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _co2Rating = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'Smog Rating',
                  inputField: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Smog Rating is required';
                      }
                      final rating = int.tryParse(value);
                      if (rating == null || rating <= 0) {
                        return 'Please enter a valid Smog Rating';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _smogRating = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildInputRow(
                  label: 'Logo Url',
                  inputField: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Logo Url is required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _logoUrl = value;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                      onPressed: _saveVehicleData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 183, 88, 0),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow({required String label, required Widget inputField}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16.0),
        ),
        Container(
          width: 150,
          height: 50,
          child: inputField,
        ),
      ],
    );
  }

  Widget _buildDropDown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return FormField<String>(
      validator: (value) {
        if (value == null) {
          return 'Please select a $label';
        }
        return null;
      },
      builder: (state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16.0),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(
                          255, 45, 45, 45), // Change the color of the popup
                      contentPadding: EdgeInsets.zero,
                      content: Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = items[index];
                            return ListTile(
                              title: Text(item,
                                  style: const TextStyle(
                                      color: Colors
                                          .white)), // Change text color of items
                              onTap: () {
                                Navigator.of(context).pop();
                                onChanged(item);
                                state.didChange(item);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: 150,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(value ?? 'Select', textAlign: TextAlign.center),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveVehicleData() {
    if (_formKey.currentState!.validate()) {
      // Create a map with the vehicle data
      Map<String, dynamic> vehicleData = {
        'model': _model,
        'make': _make,
        'type': _type,
        'logoUrl': _logoUrl,
        'modelYear': _modelYear,
        'engineSize': _engineSize,
        'cylinders': _cylinders,
        'transmission': _transmission,
        'fuelType': _fuelType,
        'fuelConsumptionCity': _fuelConsumptionCity,
        'fuelConsumptionHwy': _fuelConsumptionHwy,
        'combMPG': _combMPG,
        'co2Emissions': _co2Emissions,
        'co2Rating': _co2Rating,
        'smogRating': _smogRating,
      };

      // Add vehicle data to Firestore
      _ref.add(vehicleData).then((_) {
        // Data successfully saved
        _showSnackBar('Vehicle data saved successfully');
        // Redirect to settings screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
      }).catchError((error) {
        // Error occurred while saving data
        _showSnackBar('Failed to save vehicle data');
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
