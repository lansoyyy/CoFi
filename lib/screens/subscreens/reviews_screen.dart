import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Reviews',
          fontSize: 18,
          color: Colors.white,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextWidget(
              text: '8 Reviews',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 16),
          _buildReviewCard(
            name: 'Jeremy Juaton',
            review: 'Very cozy coffee shop, worth visiting',
            tags: ['Chill Hangout'],
            imagePath: 'assets/images/review1.jpg',
          ),
          _buildReviewCard(
            name: 'Princess Castillo',
            review: 'Amazing Coffee shop',
            tags: ['Off / Hangout', 'Study Vibes'],
            imagePath: 'assets/images/review2.jpg',
          ),
          _buildReviewCard(
            name: 'Kyle Cabanig',
            review: 'Love the vibes >>',
            tags: ['Business Meeting', 'Cozy / Chill'],
            imagePath: 'assets/images/review3.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String review,
    required List<String> tags,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.location_on, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: name,
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextWidget(
                          text: '1 week ago',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: tags
                  .map((tag) => Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        label: TextWidget(
                          text: tag,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.grey[800],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextWidget(
              text: review,
              fontSize: 14,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: const Center(
                child: Icon(Icons.image, color: Colors.white38, size: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
