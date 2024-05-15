import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'favourites.dart';

class UpdateRefillScreen extends StatefulWidget {
  final String? refillId;

  const UpdateRefillScreen({super.key, this.refillId});

  @override
  _UpdateRefillScreenState createState() => _UpdateRefillScreenState();
}

class _UpdateRefillScreenState extends State<UpdateRefillScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedFuelType = '95'; // Initial selection
  double _price = 0.0;
  double _filled = 0.0;
  double _sumUSD = 0.0;
  String _comment = '';
  double _odometer = 0.0;

  final CollectionReference _ref = FirebaseFirestore.instance.collection('Refills');
bool _isLoaded = false;

@override
void initState() {

  _loadRefillDetails().then((_){
    setState(() {
      _isLoaded = true;
    });
  });
  super.initState();
  
}

 Future<void> _loadRefillDetails() async {
  if (widget.refillId != null) {
    final DocumentSnapshot refillSnapshot = await _ref.doc(widget.refillId).get();
    if (refillSnapshot.exists) {
      setState(() {
       _odometer = refillSnapshot['odometer']; 
        _filled = refillSnapshot['filled'];
        _price = refillSnapshot['price'];
        _sumUSD = refillSnapshot['sum'];
        _comment = refillSnapshot['comment'];
        _selectedDate = DateTime.parse(refillSnapshot['date']);
        _selectedTime = _parseTime(refillSnapshot['time']);
        _selectedFuelType = refillSnapshot['fuelType'];
      });
    }
  }
}

TimeOfDay _parseTime(String time) {
  final startIndex = time.indexOf('(') + 1;
  final endIndex = time.indexOf(':');
  final hour = int.parse(time.substring(startIndex, endIndex));
  final minute = int.parse(time.substring(endIndex + 1, time.indexOf(')')));
  return TimeOfDay(hour: hour, minute: minute);
}


  void _updateRefillData() {
    Map<String, dynamic> refillData = {
      'odometer': _odometer,
      'filled': _filled,
      'price': _price,
      'sum': _sumUSD,
      'date': _selectedDate.toString(),
      'time': _selectedTime.toString(),
      'fuelType': _selectedFuelType,
      'comment': _comment,
    };

    _ref.doc(widget.refillId).update(refillData).then((_) {
      _showSnackBar('Refill data updated successfully');
      print(refillData);
    }).catchError((error) {
      _showSnackBar('Failed to update refill data');
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Refill'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoaded ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildInputRow(
              label: 'Odometer (km)',
              initialValue: _odometer.toString(),
              onChanged: (value) {
                setState(() {
                  _odometer = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildInputRow(
              label: 'Filled (L)',
              initialValue: _filled.toString(),
              onChanged: (value) {
                setState(() {
                  _filled = double.tryParse(value) ?? 0.0;
                  _updateSumUSD();
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildInputRow(
              label: 'Price (USD/L)',
              initialValue: _price.toString(),
              onChanged: (value) {
                setState(() {
                  _price = double.tryParse(value) ?? 0.0;
                  _updateSumUSD();
                });
              },
            ),
            const SizedBox(height: 16.0),
            _buildInputRow(
              label: 'Sum (USD)',
              initialValue: _sumUSD.toStringAsFixed(2),
              enabled: false,
            ),
            const SizedBox(height: 16.0),
            _buildDateRow(),
            const SizedBox(height: 16.0),
            _buildInputRow(
              label: 'Fuel Type',
              initialValue: _selectedFuelType, // Provide initial value here
              inputField: ElevatedButton(
                onPressed: () {
                  _showFuelTypeDialog(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 55, 55, 55),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 183, 88, 0),
                  ),
                ),
                child: Text(_selectedFuelType),
              ),
              showBorder: false, // Don't show border for this row
            ),
            const SizedBox(height: 16.0),
            _buildInputRow(
              label: 'Comment',
              initialValue: _comment,
              onChanged: (value) {
                setState(() {
                  _comment = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7, // Fill 70% of available width
                child: ElevatedButton(
                  onPressed: (){ 
                  _updateRefillData();
                   Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 183, 88, 0),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ),
            ),
          ],
        )
      : const Center(child: CircularProgressIndicator()
      ),
    ));
  }

  void _updateSumUSD() {
    setState(() {
      _sumUSD = _price  * _filled;
    });
  }

 Widget _buildInputRow({
  required String label,
  required String initialValue, // Change type to String
  ValueChanged<String>? onChanged,
  bool showBorder = true,
  bool enabled = true,
  Widget? inputField,
}) {
   print('Initial Value: $initialValue');
  
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
        decoration: showBorder
            ? BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 159, 159, 159),
                ),
                borderRadius: BorderRadius.circular(8.0),
              )
            : null,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: inputField ??
                TextFormField(
                  initialValue: initialValue, // Set initial value here
                  // controller: TextEditingController(text: initialValue),
                  enabled: true,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    border: InputBorder.none,
                  ),
                ),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildDateRow() {
    return Row(
      children: [
        const Text(
          'Date',
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 55, 55, 55),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 183, 88, 0),
                  ),
                ),
                child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 55, 55, 55),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 183, 88, 0),
                  ),
                ),
                child: Text('${_selectedTime.hour}:${_selectedTime.minute}'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showFuelTypeDialog(BuildContext context) async {
    final String? selectedFuelType = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 55, 55, 55),
          title: const Text('Select Fuel Type'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: _selectedFuelType,
                  onChanged: (String? newValue) {
                    Navigator.of(context).pop(newValue);
                  },
                  items: <String>['95', '98', 'Diesel', 'Gas']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (selectedFuelType != null) {
      setState(() {
        _selectedFuelType = selectedFuelType;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
