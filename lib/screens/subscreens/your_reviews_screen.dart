import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class YourReviewsScreen extends StatelessWidget {
  const YourReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          text: 'Your Reviews',
          fontSize: 20,
          color: Colors.white,
          isBold: true,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextWidget(
                text: '3 Reviews',
                fontSize: 16,
                color: Colors.white70,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildReviewCard(
                      shopName: 'Juan Dela Cruz',
                      rating: 5,
                      timeAgo: '1 week ago',
                      reviewText: 'nice',
                      imagePath:
                          'assets/images/cafe1.jpg', // You can add actual images
                      hasImage: true,
                    ),
                    const SizedBox(height: 16),
                    _buildReviewCard(
                      shopName: 'Juan Dela Cruz',
                      rating: 5,
                      timeAgo: '1 week ago',
                      reviewText: 'Sarap!!',
                      imagePath: 'assets/images/cafe2.jpg',
                      hasImage: true,
                    ),
                    const SizedBox(height: 16),
                    _buildReviewCard(
                      shopName: 'Juan Dela Cruz',
                      rating: 4,
                      timeAgo: '1 week ago',
                      reviewText: 'Anobio',
                      imagePath: 'assets/images/cafe3.jpg',
                      hasImage: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    required String shopName,
    required int rating,
    required String timeAgo,
    required String reviewText,
    required String imagePath,
    required bool hasImage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with cafe icon and shop name
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_cafe,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              const SizedBox(width: 8),
              TextWidget(
                text: shopName,
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Star rating
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: index < rating ? Colors.amber : Colors.grey,
                  size: 20,
                );
              }),
              const SizedBox(width: 8),
              TextWidget(
                text: timeAgo,
                fontSize: 14,
                color: Colors.white54,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review tags
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextWidget(
                  text: 'Coffee Quality',
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextWidget(
                  text: 'Value for Money',
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review text
          TextWidget(
            text: reviewText,
            fontSize: 14,
            color: Colors.white,
          ),

          if (hasImage) ...[
            const SizedBox(height: 12),
            // Review image
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.grey[700],
                  child: const Icon(
                    Icons.image,
                    color: Colors.white54,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
