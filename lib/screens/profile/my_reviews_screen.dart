import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for reviews
    final reviews = [
      {'apartment': 'Ocean View Villa', 'rating': 5, 'review': 'Absolutely stunning views and a beautiful home. Highly recommended!'},
      {'apartment': 'Urban Chic Loft', 'rating': 4, 'review': 'Great location and a very stylish apartment. A bit noisy at night, but overall a great experience.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(review['apartment'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (starIndex) {
                      return Icon(
                        starIndex < (review['rating'] as int) ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(review['review'] as String),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
