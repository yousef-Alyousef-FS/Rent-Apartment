import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/review_provider.dart';
// --- CORRECTED: The one true, standard path ---
import 'package:plproject/generated/app_localizations.dart';

class ReviewScreen extends StatefulWidget {
  final int apartmentId;

  const ReviewScreen({super.key, required this.apartmentId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    final loc = AppLocalizations.of(context)!;

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.pleaseSelectRating), backgroundColor: Colors.orange),
      );
      return;
    }
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.pleaseWriteComment), backgroundColor: Colors.orange),
      );
      return;
    }

    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

    final success = await reviewProvider.addReview(
      apartmentId: widget.apartmentId,
      rating: _rating,
      comment: _reviewController.text,
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.reviewSubmittedSuccess), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(reviewProvider.errorMessage ?? loc.failedToSubmitReview),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.writeReview),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            loc.howWasYourStay,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(loc.yourRating, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildRatingStars(),
          const SizedBox(height: 24),
          Text(loc.yourReview, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _reviewController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: loc.tellUsExperience,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ReviewProvider>(
          builder: (context, reviewProvider, child) {
            return ElevatedButton(
              onPressed: reviewProvider.status == ReviewStatus.Loading ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: reviewProvider.status == ReviewStatus.Loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(loc.submitReview),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
            });
          },
        );
      }),
    );
  }
}
