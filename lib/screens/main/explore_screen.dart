import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/widgets/apartment_card.dart';
import 'package:plproject/widgets/app_drawer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch apartments if the list is empty when the screen is first built.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ApartmentProvider>(context, listen: false);
      if (provider.apartments.isEmpty) {
        provider.fetchApartments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Explore Apartments'),
      ),
      body: Consumer<ApartmentProvider>(
        builder: (context, provider, child) {
          if (provider.status == ApartmentStatus.Loading && provider.apartments.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == ApartmentStatus.Error) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          if (provider.apartments.isEmpty) {
            return const Center(child: Text('No apartments found.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchApartments(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display two items per row
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.75, // Adjust this ratio to fit your card design
              ),
              itemCount: provider.apartments.length,
              itemBuilder: (context, index) {
                return ApartmentCard(apartment: provider.apartments[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
