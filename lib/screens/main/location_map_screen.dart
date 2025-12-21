import 'package:flutter/material.dart';

class LocationMapScreen extends StatelessWidget {
  const LocationMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: const Center(
        child: Text('Location Map Screen'),
      ),
    );
  }
}
