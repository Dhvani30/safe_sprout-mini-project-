import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'gradient_container.dart';
import 'firebase_options.dart';
import 'modules/home_page.dart'; // Import your home page
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Check if the user is already authenticated
  User? user = FirebaseAuth.instance.currentUser;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Name',
      home: user != null
          ? const HomePage()
          : const Scaffold(
              backgroundColor: Color.fromARGB(255, 157, 129, 137),
              body: GradientContainer(
                Color.fromARGB(255, 201, 178, 239),
                // Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 212, 214, 249),
                Color.fromARGB(255, 233, 212, 232),
              ),
            ),
    ),
  );
}
