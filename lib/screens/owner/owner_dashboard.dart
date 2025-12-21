import 'package:flutter/material.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owner Dashboard')),
      body: Center(
        child: Text('Owner Dashboard Screen'),
      ),
    );
  }
}
