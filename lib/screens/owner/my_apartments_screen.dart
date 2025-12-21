import 'package:flutter/material.dart';

class MyApartmentsScreen extends StatelessWidget {
  const MyApartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Apartments')),
      body: Center(
        child: Text('My Apartments Screen'),
      ),
    );
  }
}
