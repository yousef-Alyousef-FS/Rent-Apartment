import 'package:flutter/material.dart';
import 'package:plproject/generated/app_localizations.dart';

class CustomSearchBar extends StatefulWidget {
  // --- NEW: Callback to notify the parent screen of the search query ---
  final Function(String) onSubmitted;

  const CustomSearchBar({super.key, required this.onSubmitted});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        onSubmitted: widget.onSubmitted, // Use the passed callback
        decoration: InputDecoration(
          hintText: loc.searchHint, // Localized hint text
          prefixIcon: const Icon(Icons.search),
          filled: true,
          // --- CORRECTED: Uses the theme's cardColor for a cleaner look ---
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
