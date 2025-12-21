import 'package:flutter/material.dart';

class BookingsListScreen extends StatelessWidget {
  const BookingsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Bookings')),
      body: Center(
        child: Text('Bookings List Screen'),
      ),
    );
  }
}
