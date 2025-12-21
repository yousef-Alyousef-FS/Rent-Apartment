import 'package:flutter/material.dart';

class OwnerBookingsScreen extends StatelessWidget {
  const OwnerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apartment Bookings')),
      body: Center(
        child: Text('Owner Bookings Screen'),
      ),
    );
  }
}
