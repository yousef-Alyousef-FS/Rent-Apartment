import 'package:flutter/material.dart';

class OwnerBookingsScreen extends StatelessWidget {
  const OwnerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings for Ocean View Villa'), // Mock apartment name
      ),
      body: ListView.builder(
        itemCount: 3, // Mock count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text('Renter Name ${index + 1}'),
              subtitle: const Text('Dates: Oct 10 - Oct 15'),
              trailing: Chip(
                label: const Text('Confirmed'),
                backgroundColor: Colors.green[100],
              ),
            ),
          );
        },
      ),
    );
  }
}
