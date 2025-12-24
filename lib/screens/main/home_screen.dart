import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/widgets/apartment_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // After the first frame, trigger the fetch operation.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApartmentProvider>(context, listen: false).fetchApartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = Provider.of<UserProvider>(context).user?.first_name ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Home!', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70)),
            Text(userName, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, size: 28),
            onPressed: () { /* TODO: Navigate to notifications */ },
          ),
        ],
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          _buildSearchBar(context),
          _buildCategoryList(context),
          _buildSectionHeader(context, 'Featured Apartments'),
          Expanded(
            child: Consumer<ApartmentProvider>(
              builder: (context, provider, child) {
                switch (provider.status) {
                  case ApartmentStatus.Loading:
                    return const Center(child: CircularProgressIndicator());
                  case ApartmentStatus.Error:
                    return Center(child: Text('Error: ${provider.errorMessage}'));
                  case ApartmentStatus.Loaded:
                    if (provider.apartments.isEmpty) {
                      return const Center(child: Text('No apartments available right now.'));
                    }
                    return ListView.builder(
                      itemCount: provider.apartments.length,
                      itemBuilder: (context, index) {
                        return ApartmentCard(apartment: provider.apartments[index]);
                      },
                    );
                  case ApartmentStatus.Idle:
                  default:
                    return const Center(child: Text('Pull to refresh'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for a city, neighborhood, or address...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    final categories = ['For You', 'Popular', 'Near You', 'New'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(categories[index]),
              backgroundColor: index == 0 ? Theme.of(context).primaryColor : Colors.white,
              labelStyle: TextStyle(color: index == 0 ? Colors.white : Colors.black),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          TextButton(onPressed: () {}, child: const Text('See All')),
        ],
      ),
    );
  }
}
