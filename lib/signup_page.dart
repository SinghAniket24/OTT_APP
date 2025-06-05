import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http; // <-- Add this
import 'dart:convert'; // <-- Add this
import 'main.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final aadharController = TextEditingController();
  final phoneController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // Regex patterns
  final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp phoneRegex = RegExp(r'^[6-9]\d{9}$');
  final RegExp aadharRegex = RegExp(r'^\d{12}$');
  // final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$'); // At least 8 chars, 1 letter, 1 digit

  void signUpUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmController.text;
    final aadhar = aadharController.text.trim();
    final phone = phoneController.text.trim();

    // Validation: All fields required
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || aadhar.isEmpty || phone.isEmpty) {
      _showSnackBar("All fields are required");
      return;
    }

    // Email validation
    if (!emailRegex.hasMatch(email)) {
      _showSnackBar("Enter a valid email address");
      return;
    }

    // Phone validation (Indian mobile numbers)
    if (!phoneRegex.hasMatch(phone)) {
      _showSnackBar("Enter a valid 10-digit Indian mobile number");
      return;
    }

    // Aadhar validation (12 digits)
    if (!aadharRegex.hasMatch(aadhar)) {
      _showSnackBar("Enter a valid 12-digit Aadhar number");
      return;
    }

    // Password match validation
    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match");
      return;
    }

    // Password strength validation (optional, uncomment to use)
    // if (!passwordRegex.hasMatch(password)) {
    //   _showSnackBar("Password must be at least 8 characters, include a letter and a number");
    //   return;
    // }

    try {
      UserCredential userCred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection("users").doc(userCred.user!.uid).set({
        "uid": userCred.user!.uid,
        "email": email,
        "aadhar": aadhar,
        "phone": phone,
      });

      // --- Add MongoDB signup call here ---
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/user'), // <-- Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "uid": userCred.user!.uid,
          "email": email,
          "password": password, // Consider hashing on backend
          "aadhar": aadhar,
          "phone": phone,
        }),
      );

      if (response.statusCode == 200) {
        _showSnackBar("Sign up successful!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        _showSnackBar("MongoDB Error: ${response.body}");
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _showSnackBar("Google sign-in cancelled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await auth.signInWithCredential(credential);

      DocumentSnapshot userDoc = await firestore.collection("users").doc(userCred.user!.uid).get();

      if (!userDoc.exists) {
        await firestore.collection("users").doc(userCred.user!.uid).set({
          "uid": userCred.user!.uid,
          "email": userCred.user!.email,
          "aadhar": "", // Prompt for this later if needed
          "phone": userCred.user!.phoneNumber ?? "",
        });
      }

      _showSnackBar("Signed up with Google!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      _showSnackBar("Google Sign-In Error: ${e.toString()}");
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('background.jpg', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'SignUp',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Enter username or email id"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Enter password"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: confirmController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Confirm password"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: aadharController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("Enter Aadhar card details"),
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration("+91"),
                      maxLength: 10,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: signUpUser,
                        child: const Text('SIGN UP',
                            style: TextStyle(
                                fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(color: Colors.white70)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreen()));
                          },
                          child: const Text("Login",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: signInWithGoogle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('google_logo.jpg',
                                height: 24, width: 24),
                            const SizedBox(width: 10),
                            const Text("Sign up with Google",
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white12,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide.none,
      ),
    );
  }
}
