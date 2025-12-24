import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/review_provider.dart';

class ReviewScreen extends StatefulWidget {
  // A real implementation would require the apartment ID to know where to post the review
  final int apartmentId;

  const ReviewScreen({super.key, required this.apartmentId});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0; 
  final _reviewController = TextEditingController();
  
  Future<void> _submitReview() async {
    if (_rating == 0 || _reviewController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please provide a rating and a comment.')),
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
                const SnackBar(content: Text('Review submitted successfully!'), backgroundColor: Colors.green),
            );
            Navigator.of(context).pop();
        } else {
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(reviewProvider.errorMessage ?? 'Failed to submit review.'), backgroundColor: Colors.red),
            );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'How was your stay?', // More generic title
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          Text('Your Rating', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildRatingStars(),
          const SizedBox(height: 24),
          
          Text('Your Review', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _reviewController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Tell us about your experience...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
            onPressed: reviewProvider.status == ReviewStatus.Loading ? null : _submitReview,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
            ),
            child: reviewProvider.status == ReviewStatus.Loading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Submit Review'),
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
