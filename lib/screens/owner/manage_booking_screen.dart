import 'package:flutter/material.dart';

class ManageBookingScreen extends StatelessWidget {
  const ManageBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Booking')),
      body: Center(
        child: Text('Manage Booking Screen'),
      ),
    );
  }
}
