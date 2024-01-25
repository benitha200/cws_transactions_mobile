import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'add_transaction.dart';

class FarmersListPage extends StatefulWidget {
  @override
  _FarmersListPageState createState() => _FarmersListPageState();
}

class _FarmersListPageState extends State<FarmersListPage> {

  Future<List<Map<String, dynamic>>> fetchFarmers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var url = Uri.parse('http://192.168.82.27:8000/api/farmers/');

    var headers = {
      'Authorization': 'Bearer $token',
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      return List<Map<String, dynamic>>.from(result);
    } else {
      throw Exception('Failed to fetch farmers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmers List'),
      ),
      body: FutureBuilder(
        future: fetchFarmers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // List<Map<String, dynamic>> farmers = snapshot.data;
            List<Map<String, dynamic>>? farmers;

            if (snapshot.data != null) {
              farmers = snapshot.data;
            } else {
              farmers = []; // Assign empty list if data is null
            }

            return ListView.builder(
                itemCount: farmers?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(farmers?[index]['farmer_name']),
                    subtitle: Text(farmers?[index]['farmer_code']),
                    onTap: () {
                      // Navigate to AddTransactionPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTransactionPage(
                            farmerName: farmers?[index]['farmer_name'],
                            farmerCode: farmers?[index]['farmer_code'],
                          ),
                        ),
                      );
                    },
                  );
                }
            );
          }
        },
      ),
    );
  }
}