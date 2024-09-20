import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController collegeCodeController = TextEditingController();
  final TextEditingController enrollmentNumberController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  void registerUser(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        // User registration successful, now save additional data to Firebase Database
        DatabaseReference userRef =
            FirebaseDatabase.instance.reference().child('users');
        userRef.child(userCredential.user!.uid).set({
          'email': emailController.text,
          'collegeCode': collegeCodeController.text,
          'enrollmentNumber': enrollmentNumberController.text,
        });

        // Show SnackBar message for registration success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful'),
            duration: Duration(seconds: 1), // Optional duration
            backgroundColor: Colors.green, // Optional background color
          ),
        );

        // Delay navigation to give time for SnackBar to be shown
        await Future.delayed(const Duration(seconds: 2));

        // Navigate back to the home page after registration
        Navigator.pop(context);
      } else {
        // Handle null user object
        print("Failed to register user: User object is null");
        // You can show error messages to the user here
      }
    } catch (e) {
      // Handle registration errors
      print("Failed to register user: $e");
      // You can show error messages to the user here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: collegeCodeController,
                decoration: const InputDecoration(
                  labelText: 'College Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: enrollmentNumberController,
                decoration: const InputDecoration(
                  labelText: 'Enrollment Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Register the user
                    registerUser(context);
                  },
                  child: const Text('REGISTER'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
