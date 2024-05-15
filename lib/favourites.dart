import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuelapp/home.dart';
import 'updaterefill.dart'; // Import the update refill screen

class FavoritesScreen extends StatelessWidget {
  final String? selectedVehicleId;

   FavoritesScreen({super.key, this.selectedVehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refills'),
        leading: GestureDetector(
          onTap: () {
           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(selectedVehicleId: selectedVehicleId),
                            ),
                       );
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Refills')
            .where('vehicleId', isEqualTo: selectedVehicleId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final refills = snapshot.data?.docs ?? [];

          if (refills.isEmpty) {
            return const Center(
              child: Text('No refills found'),
            );
          }

          // Group refills by month
          Map<String, List<Map<String, dynamic>>> groupedRefills = {};

          for (var refill in refills) {
            final data = refill.data();
            if (data != null && data is Map<String, dynamic>) {
              final date = data['date'] as String;
              final monthYear = date.substring(0, 7); // Extract month and year
              if (!groupedRefills.containsKey(monthYear)) {
                groupedRefills[monthYear] = [];
              }
              groupedRefills[monthYear]!.add(data);
            }
          }

          return ListView.separated(
            itemCount: groupedRefills.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final months = groupedRefills.keys.toList();
              final monthYear = months[index];
              final refillsInMonth = groupedRefills[monthYear] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      monthYear,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: refillsInMonth.length,
                    itemBuilder: (context, index) {
                      final refill = refillsInMonth[index];
                      final docId = refills[index].id; // Get document ID
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to update screen and pass refillId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateRefillScreen(refillId: docId),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 55, 55, 55),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text('${refill['date']}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Filled: ${refill['filled']}'),
                                  Text('Fuel Type: ${refill['fuelType']}'),
                                  Text('Odometer: ${refill['odometer']}'),
                                  Text('Price: ${refill['price']}'),
                                  Text('Sum: ${refill['sum']}'),
                                  Text('Time: ${refill['time']}'),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  // Show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: const Color.fromARGB(255, 55, 55, 55), // Set background color
                                      title: const Text('Delete Refill'),
                                      content: const Text('Are you sure you want to delete this refill?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                            foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 255, 255)), // Change text color of cancel button
                                          ),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Delete the refill item
                                            FirebaseFirestore.instance
                                                .collection('Refills')
                                                .doc(docId)
                                                .delete();
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 183, 88, 0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 183, 88, 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
