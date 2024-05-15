import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuelapp/home.dart';
import 'createvehicle.dart';


class SettingsScreen extends StatelessWidget {

  const SettingsScreen({super.key, Key? customKey,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Vehicles').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot vehicle = snapshot.data!.docs[index];
              return _buildVehicleItem(context, vehicle);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create vehicle screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const CreateVehicleScreen()),
          );
        },
        backgroundColor: const Color.fromARGB(255, 183, 88, 0), // Set background color
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildVehicleItem(BuildContext context, DocumentSnapshot vehicle) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(vehicle['logoUrl']), // Assuming logoUrl is the URL of the brand logo
          ),
        ),
      ),
      title: Text(
        '${vehicle['make']} ${vehicle['model']}',
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${vehicle['type']}'),
          Text('Year: ${vehicle['modelYear']}'),
          Text('Id: ${vehicle.id}'),
          // Add more details as needed
        ],
      ),
      onTap: () {
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(selectedVehicleId: vehicle.id),
          ),
        );
      },
    );
  }
}
