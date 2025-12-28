import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/widgets/apartment_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Cancel the old timer if it exists
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        Provider.of<ApartmentProvider>(context, listen: false)
            .fetchApartments(filters: {'search': _searchController.text});
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Type to search live...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        // The search icon is no longer needed as search is live
      ),
      body: Consumer<ApartmentProvider>(
        builder: (context, provider, child) {
          // Show initial message only if the search box is empty
          if (_searchController.text.isEmpty) {
            return const Center(child: Text('Start typing to search for apartments.'));
          }
          if (provider.status == ApartmentStatus.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == ApartmentStatus.Error) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          if (provider.apartments.isEmpty) {
            return const Center(child: Text('No apartments match your search.'));
          }

          return ListView.builder(
            itemCount: provider.apartments.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ApartmentCard(apartment: provider.apartments[index]),
              );
            },
          );
        },
      ),
    );
  }
}
