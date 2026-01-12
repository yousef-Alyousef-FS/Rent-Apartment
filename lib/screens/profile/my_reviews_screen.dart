import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sakani/models/review.dart';
import 'package:sakani/providers/review_provider.dart';
import 'package:sakani/generated/app_localizations.dart';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch reviews when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReviewProvider>(context, listen: false).fetchMyReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myReviews),
      ),
      body: Consumer<ReviewProvider>(
        builder: (context, provider, child) {
          if (provider.status == ReviewStatus.Loading && provider.myReviews.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == ReviewStatus.Error) {
            return Center(child: Text(provider.errorMessage ?? loc.unexpectedErrorOccurred));
          }
          if (provider.myReviews.isEmpty) {
            return Center(
              child: Text(loc.noReviewsYet, style: Theme.of(context).textTheme.titleMedium),
            );
          }

          return ListView.builder(
            itemCount: provider.myReviews.length,
            itemBuilder: (context, index) {
              final review = provider.myReviews[index];
              return _buildReviewCard(context, review, loc);
            },
          );
        },
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Review review, AppLocalizations loc) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${loc.reviewOn}: ${review.apartment.title}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ...List.generate(5, (starIndex) {
                  return Icon(
                    starIndex < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
                const Spacer(),
                Text(
                  DateFormat('yMMMd', loc.localeName).format(review.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}
