import 'package:flutter/material.dart';

class AddApartmentScreen extends StatelessWidget {
  const AddApartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Apartment')),
      body: Center(
        child: Text('Add Apartment Screen'),
      ),
    );
  }
}
