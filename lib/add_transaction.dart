// add_transaction_page.dart

import 'package:flutter/material.dart';

class AddTransactionPage extends StatelessWidget {
  final String farmerName;
  final String farmerCode;

  AddTransactionPage({required this.farmerName, required this.farmerCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      body: AddTransactionForm(farmerName: farmerName, farmerCode: farmerCode),
    );
  }
}

class AddTransactionForm extends StatefulWidget {
  final String farmerName;
  final String farmerCode;

  AddTransactionForm({required this.farmerName, required this.farmerCode});

  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  // Add your form logic here

  @override
  Widget build(BuildContext context) {
    // Build your form UI using widget.farmerName and widget.farmerCode
    return Container(
      // Your form content goes here
      child: Text('Form for ${widget.farmerName} - ${widget.farmerCode}'),
    );
  }
}
