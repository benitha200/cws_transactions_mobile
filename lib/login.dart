import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'FarmerList.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> handleSignIn(BuildContext context) async {
    // Get values from the text controllers
    String emailOrPhone = emailController.text;
    String password = passwordController.text;

    var formData = {
      'username': emailOrPhone,
      'password': password,
    };

    try {
      var response = await http.post(
        Uri.parse('http://192.168.82.27:8000/api/login/'),
        body: formData,
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        print(result['access']);
        print(result['refresh']);
        print(result['cws_name']);
        print(result['cws_code']);
        print(result['role']);

        // Perform state management or other actions with the data if needed
        // ...

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FarmersListPage()),
        );
        // Store in shared preferences
        // You need to add the shared_preferences package to your pubspec.yaml file
        // and import it at the beginning of your Dart file
        // import 'package:shared_preferences/shared_preferences.dart';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", result['access']);
        prefs.setString("refreshtoken", result['refresh']);
        prefs.setString("cwscode", result['cws_code']);
        prefs.setString("cwsname", result['cws_name']);
        prefs.setString("role", result['role']);

        print(response.body);
      } else {
        print('Login failed');
      }
    } catch (error) {
      print('Error during login: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => handleSignIn(context),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginWidget(),
  ));
}
