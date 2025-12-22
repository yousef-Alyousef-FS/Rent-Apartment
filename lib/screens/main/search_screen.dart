import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/widgets/apartment_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // Mock data for search results
  final List<Apartment> _searchResults = [
    Apartment(id: 10, title: 'Downtown Penthouse', price: 5000, location: 'Los Angeles, CA', bedrooms: 3, bathrooms: 3, area: 250, imageUrls: ['https://via.placeholder.com/400x250/F44336/FFFFFF?Text=Penthouse'], description: ''),
    Apartment(id: 11, title: 'Quiet Suburban Home', price: 2200, location: 'Austin, TX', bedrooms: 4, bathrooms: 2, area: 280, imageUrls: ['https://via.placeholder.com/400x250/2196F3/FFFFFF?Text=Home'], description: ''),
  ];

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
    // In a real app, you would filter results here based on the query
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // A search bar directly in the AppBar
        title: TextField(
          controller: _searchController,
          autofocus: true, // Automatically focus the search bar
          decoration: const InputDecoration(
            hintText: 'Search by city or address...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
          onChanged: _performSearch,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
          )
        ],
      ),
      body: _isSearching ? _buildSearchResults() : _buildInitialView(),
    );
  }

  Widget _buildInitialView() {
    // This view is shown before the user starts typing
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold)),
        ListTile(leading: Icon(Icons.history), title: Text('New York')),
        ListTile(leading: Icon(Icons.history), title: Text('Paris')),
      ],
    );
  }

  Widget _buildSearchResults() {
    // This view shows the results after the user types something
    if (_searchResults.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return ApartmentCard(apartment: _searchResults[index]);
      },
    );
  }
}
