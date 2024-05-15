import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'favourites.dart';
import 'home.dart';
import 'createrefill.dart';
import 'settings.dart';
import 'updaterefill.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 28, 28, 28), // Adjust this color as needed
       inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 183, 88, 0)),
          ),
        ),
    ),
    
      initialRoute: '/',
      routes: {
        '/': (context) => const  HomeScreen(selectedVehicleId: null),
        '/favourites': (context) =>  FavoritesScreen(),
        '/createRefill': (context) => const CreateRefillScreen(),
        '/settings': (context) => const SettingsScreen(),
        
        
      },
    );
  }
}


