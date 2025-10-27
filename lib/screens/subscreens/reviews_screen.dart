import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/text_widget.dart';

class ReviewsScreen extends StatelessWidget {
  final String? shopId;
  final List? fallbackReviews;

  const ReviewsScreen({Key? key, this.shopId, this.fallbackReviews})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasShopId = shopId != null && shopId!.isNotEmpty;
    final query = hasShopId
        ? FirebaseFirestore.instance
            .collection('shops')
            .doc(shopId)
            .collection('reviews')
            .orderBy('createdAt', descending: true)
        : null;


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextWidget(
            text: 'Reviews', fontSize: 18, color: Colors.white, isBold: true),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: hasShopId
                ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: query!.snapshots(),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.docs.length ?? 0;
                      return TextWidget(
                        text: '$count Reviews',
                        fontSize: 14,
                        color: Colors.white,
                      );
                    },
                  )
                : TextWidget(
                    text: '${(fallbackReviews ?? const []).length} Reviews',
                    fontSize: 14,
                    color: Colors.white,
                  ),
          ),
        ],
      ),
      body: hasShopId
          ? StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: query!.snapshots(),
              builder: (context, snapshot) {
                final docs = snapshot.data?.docs ?? const [];
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 16),
                    if (docs.isEmpty)
                      TextWidget(
                        text: 'No reviews yet',
                        fontSize: 14,
                        color: Colors.white70,
                      )
                    else
                      ...docs.map((d) {
                        final m = d.data();
                        final name =
                            (m['authorName'] ?? m['name'] ?? 'Anonymous')
                                .toString();
                        final review =
                            (m['text'] ?? m['comment'] ?? '').toString();
                        final tags = (m['tags'] is List)
                            ? (m['tags'] as List).cast<String>()
                            : <String>[];
                        final imageUrl = m['imageUrl'] as String?;


                        
                        return _buildReviewCard(
                                 rating: m['rating'],
                          name: name,
                          review: review.isNotEmpty ? review : '—',
                          tags: tags,
                          imagePath: 'assets/images/review_placeholder.jpg',
                          imageUrl: imageUrl,
                        );
                      }).toList(),
                  ],
                );
              },
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 16),
                if ((fallbackReviews ?? const []).isEmpty)
                  TextWidget(
                    text: 'No reviews yet',
                    fontSize: 14,
                    color: Colors.white70,
                  )
                else
                  ...fallbackReviews!.map((r) {
                    final m = (r is Map)
                        ? r.cast<String, dynamic>()
                        : <String, dynamic>{};
                  final name = (m['authorName'] ?? m['name'] ?? 'Anonymous')
                      .toString();
                  final review = (m['text'] ?? m['comment'] ?? '').toString();
                  final tags = (m['tags'] is List)
                      ? (m['tags'] as List).cast<String>()
                      : <String>[];
                  final imageUrl = m['imageUrl'] as String?;
                  final createdAt = m['createdAt'] as Timestamp?;

                 
                  return _buildReviewCard(
                      rating: m['rating'],
                    name: name,
                    review: review.isNotEmpty ? review : '—',
                    tags: tags,
                    imagePath: 'assets/images/review_placeholder.jpg',
                    imageUrl: imageUrl,
                    createdAt: createdAt,
                  );
                }).toList(),
              ],
            ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String review,
    required List<String> tags,
    required String imagePath,
    String? imageUrl,
    required int rating,
    Timestamp? createdAt,
  }) {
    // Calculate time difference
    String timeAgo = '1 week ago'; // Default fallback
    if (createdAt != null) {
      final now = DateTime.now();
      final reviewDate = createdAt.toDate();
      final difference = now.difference(reviewDate);
      
      if (difference.inDays > 7) {
        timeAgo = '${difference.inDays ~/ 7} week${(difference.inDays ~/ 7) > 1 ? 's' : ''} ago';
      } else if (difference.inDays > 0) {
        timeAgo = '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours > 0) {
        timeAgo = '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes > 0) {
        timeAgo = '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        timeAgo = 'Just now';
      }
    }
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
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
                            rating,
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextWidget(
                          text: timeAgo,
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
            if (imageUrl != null && imageUrl.isNotEmpty)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.image, color: Colors.white38, size: 60),
                    ),
                  ),
                ),
              )
            else
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
