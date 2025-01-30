import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteapp/Sign_up.dart';
import 'package:noteapp/firebase_services.dart';
import 'package:noteapp/Home_screen.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseServices _firebaseServices = FirebaseServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Log In', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              icon: Icons.email,
              hint: "Enter Email",
            ),
            const SizedBox(height: 10),
            _buildTextField(
              controller: _passwordController,
              icon: Icons.lock,
              hint: "Enter Password",
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width *
                  0.6, // Centered, smaller button
              child: ElevatedButton(
                style: _buttonStyle(),
                onPressed: _login,
                child: const Text('Log In',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text('Don’t have an account? Sign Up',
                  style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required IconData icon,
      required String hint,
      bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
      backgroundColor: const Color.fromARGB(255, 154, 110, 231),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  void _login() async {
    UserCredential userCredential =
        await _firebaseServices.signInWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (userCredential.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyView(userId: userCredential.user!.uid)),
      );
    }
  }
}
