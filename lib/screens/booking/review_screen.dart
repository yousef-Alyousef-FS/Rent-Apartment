import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0; // 0 means no rating yet
  final _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'How was your stay at Ocean View Villa?', // Placeholder title
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
      bottomNavigationBar: _buildSubmitButton(theme),
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

  Widget _buildSubmitButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: (_rating > 0 && _reviewController.text.isNotEmpty) ? () {
          // TODO: Submit review logic
          Navigator.pop(context);
        } : null, // Disable button if no rating or review
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: const Text('Submit Review'),
      ),
    );
  }
}
