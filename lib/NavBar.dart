import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'createRefill.dart';
import 'favourites.dart';

class NavBar extends StatelessWidget {
  final String? selectedVehicleId;
  const NavBar({super.key, this.selectedVehicleId});
  final selectedRefillId = null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
            height: 110, // Adjust the height as needed
            color: const Color.fromARGB(255, 55, 55,55), // Background color
            padding: const EdgeInsets.only(bottom:0),
              child:  const DrawerHeader(
                
                child: Text(
                  'FUELMETER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 44, 44,44), // Set your desired background color here
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (selectedVehicleId != null) // Check if a vehicle is selected
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('Vehicles').doc(selectedVehicleId).get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(); // Return an empty container when loading
                          }
                          if (!snapshot.hasData) {
                            return const Text('Vehicle not found');
                          }
                          final data = snapshot.data!.data() as Map<String, dynamic>;
                          final brand = data['make'];
                          final logoUrl = data['logoUrl'];

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(logoUrl),
                              radius: 20,
                            ),
                            title: Text(
                              brand,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ListTile(
                      leading: const Icon(Icons.receipt_long),
                      title: const Text('Refills'),
                      onTap: () {
                        Navigator.pop(context);
                       Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FavoritesScreen(selectedVehicleId: selectedVehicleId),
                            ),
                       );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.playlist_add),
                      title: const Text('New Refill'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateRefillScreen(selectedVehicleId: selectedVehicleId),
                            ),
                       );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.storage),
                      title: const Text('Details'),
                      onTap: () {},
                    ),
                    const ListTile(
                      leading: Icon(Icons.stacked_bar_chart),
                      title: Text('Stats'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text('Policies'),
                      onTap: () {},
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Exit'),
                      leading: const Icon(Icons.exit_to_app),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
