 import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for a city, neighborhood, or address...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          // This should ideally use the theme's cardColor or a similar semantic color
          fillColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
