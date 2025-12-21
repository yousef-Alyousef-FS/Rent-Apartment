import 'package:flutter/material.dart';

class OwnerProfileScreen extends StatelessWidget {
  const OwnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Owner Profile')),
      body: Center(
        child: Text('Owner Profile Screen'),
      ),
    );
  }
}
