import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakani/models/apartment.dart';
import 'package:sakani/providers/apartment_provider.dart';
import 'package:sakani/generated/app_localizations.dart';
import 'package:sakani/screens/apartments/apartment_details_screen.dart';
import 'package:sakani/screens/owner/edit_apartment_screen.dart';
import 'package:sakani/screens/owner/apartment_bookings_screen.dart';

class MyApartmentsScreen extends StatefulWidget {
  const MyApartmentsScreen({super.key});

  @override
  State<MyApartmentsScreen> createState() => _MyApartmentsScreenState();
}

class _MyApartmentsScreenState extends State<MyApartmentsScreen> {
  int? _deletingApartmentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMyApartments(forceRefresh: true);
    });
  }

  Future<void> _fetchMyApartments({bool forceRefresh = false}) {
    return Provider.of<ApartmentProvider>(context, listen: false).fetchMyApartments();
  }

  void _showDeleteDialog(BuildContext context, Apartment apartment, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.confirmDeleteApartment),
        content: Text(loc.areYouSureDeleteApartment),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(loc.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              setState(() => _deletingApartmentId = apartment.id);

              final success = await Provider.of<ApartmentProvider>(context, listen: false).deleteApartment(apartment.id);

              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.apartmentDeletedSuccess), backgroundColor: Colors.green),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.failedToDeleteApartment), backgroundColor: Theme.of(context).colorScheme.error),
                  );
                }
                setState(() => _deletingApartmentId = null);
              }
            },
            child: Text(loc.delete, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myApartments), // Corrected localization key
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchMyApartments(forceRefresh: true),
        child: Consumer<ApartmentProvider>(
          builder: (context, provider, child) {
            if (provider.status == ApartmentStatus.Loading && provider.myApartments.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.status == ApartmentStatus.Error) {
              return Center(child: Text(provider.errorMessage ?? loc.couldNotLoadApartments));
            }
            if (provider.myApartments.isEmpty) {
              return Center(child: Text(loc.noApartmentsAdded, style: Theme.of(context).textTheme.titleLarge));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.myApartments.length,
              itemBuilder: (context, index) {
                return _buildMyApartmentCard(context, provider.myApartments[index], loc);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMyApartmentCard(BuildContext context, Apartment apartment, AppLocalizations loc) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ApartmentDetailsScreen(apartment: apartment, isOwnerView: true),
        ));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      apartment.images.isNotEmpty ? apartment.images[0].imageUrl : '', // CORRECTED
                      width: 100, height: 100, fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(width: 100, height: 100, color: Colors.grey[200], child: const Icon(Icons.apartment, color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(apartment.title, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        _buildRatingDisplay(theme, apartment, loc),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_deletingApartmentId == apartment.id)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: loc.delete,
                      onPressed: () => _showDeleteDialog(context, apartment, loc),
                    ),
                  const Spacer(),
                  TextButton(
                    child: Text(loc.editApartment),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditApartmentScreen(apartment: apartment)),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: Text(loc.viewBookings),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ApartmentBookingsScreen(apartment: apartment)),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingDisplay(ThemeData theme, Apartment apartment, AppLocalizations loc) {
    final rating = apartment.average_rating ?? 0.0;
    final reviewCount = apartment.reviews_count ?? 0;
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 18),
        const SizedBox(width: 4),
        Text('$rating (${loc.reviews(reviewCount)})', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
