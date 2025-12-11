import 'package:flutter/material.dart';

class Apartments extends StatelessWidget{
  const Apartments({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent Apartments"), // The style will be picked from the theme
        // The background color will also be picked from the theme
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topCenter,
        // Example of using a text style from the theme
        child: Text(
          "Welcome to our Rent Apartments app",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
