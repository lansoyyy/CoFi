import 'package:cofi/widgets/my_events_bottom_sheet.dart';
import 'package:cofi/widgets/my_jobs_bottom_sheet.dart';
import 'package:cofi/widgets/post_job_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/post_event_bottom_sheet.dart';
import 'reviews_screen.dart';

class BusinessProfileScreen extends StatelessWidget {
  const BusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic>? shop =
        args is Map<String, dynamic> ? args : null;
    final String shopName =
        (shop?['name'] as String?)?.trim().isNotEmpty == true
            ? (shop!['name'] as String)
            : 'My Shop';
    final String? shopId =
        (shop?['id'] is String && (shop?['id'] as String).trim().isNotEmpty)
            ? shop!['id'] as String
            : null;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: TextWidget(
          text: 'My Business',
          fontSize: 18,
          color: Colors.white,
          isBold: true,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Business Profile Card
                if (shopId != null && shopId.isNotEmpty)
                  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('shops')
                        .doc(shopId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildBusinessProfileCard(
                          context,
                          shopName,
                          shopId,
                          null, // logoUrl
                          null, // isVerified
                        );
                      }

                      if (snapshot.hasError) {
                        return _buildBusinessProfileCard(
                          context,
                          shopName,
                          shopId,
                          null, // logoUrl
                          null, // isVerified
                        );
                      }

                      final data = snapshot.data?.data();
                      final logoUrl = data?['logoUrl'] as String?;
                      final isVerified = data?['isVerified'] as bool? ?? false;

                      return _buildBusinessProfileCard(
                        context,
                        shopName,
                        shopId,
                        logoUrl,
                        isVerified,
                      );
                    },
                  )
                else
                  _buildBusinessProfileCard(
                    context,
                    shopName,
                    shopId,
                    null, // logoUrl
                    null, // isVerified
                  ),

                const SizedBox(height: 32),

                // Analytics Stats Section
                if (shopId != null && shopId.isNotEmpty)
                  _buildAnalyticsSection(shopId),

                const SizedBox(height: 32),

                // Grid of sections
                Column(
                  children: [
                    // First row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final fallback =
                                  (shop?['reviews'] as List?) ?? const [];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReviewsScreen(
                                    shopId: shopId,
                                    fallbackReviews: fallback,
                                  ),
                                ),
                              );
                            },
                            child: (shopId != null && shopId.isNotEmpty)
                                ? StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                    stream: FirebaseFirestore.instance
                                        .collection('shops')
                                        .doc(shopId)
                                        .collection('reviews')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      final count =
                                          snapshot.data?.docs.length ?? 0;
                                      final subtitle = count == 0
                                          ? 'No reviews yet'
                                          : '$count Reviews';
                                      return _buildSectionCard(
                                        title: 'Reviews',
                                        subtitle: subtitle,
                                      );
                                    },
                                  )
                                : _buildSectionCard(
                                    title: 'Reviews',
                                    subtitle: 'Show my shops reviews',
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (shopId != null && shopId.isNotEmpty) {
                                MyEventsBottomSheet.show(context,
                                    shopId: shopId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please create or select a shop first.'),
                                  ),
                                );
                              }
                            },
                            child: _buildSectionCard(
                              title: 'Events',
                              subtitle: 'Show upcoming Events',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Second row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (shopId != null && shopId.isNotEmpty) {
                                PostEventBottomSheet.show(context,
                                    shopId: shopId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please create or select a shop first.'),
                                  ),
                                );
                              }
                            },
                            child: _buildSectionCard(
                              title: 'Post an Event',
                              subtitle: 'List my upcoming events',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (shopId != null && shopId.isNotEmpty) {
                                MyJobsBottomSheet.show(context, shopId: shopId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please create or select a shop first.'),
                                  ),
                                );
                              }
                            },
                            child: _buildSectionCard(
                              title: 'Jobs',
                              subtitle: 'Show my submitted jobs',
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Third row
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (shopId != null && shopId.isNotEmpty) {
                                PostJobBottomSheet.show(context,
                                    shopId: shopId);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please create or select a shop first.'),
                                  ),
                                );
                              }
                            },
                            child: _buildSectionCard(
                              title: 'Post a Job',
                              subtitle: 'List a job - find staff fast',
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Container()), // Empty space
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessProfileCard(
    BuildContext context,
    String shopName,
    String? shopId,
    String? logoUrl,
    bool? isVerified,
  ) {
    return GestureDetector(
      onTap: () {
        if (shopId != null && shopId.isNotEmpty) {
          Navigator.pushNamed(
            context,
            '/submitShop',
            arguments: {'editShopId': shopId},
          );
        } else {
          Navigator.pushNamed(context, '/submitShop');
        }
      },
      child: Row(
        children: [
          // Business Logo
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: logoUrl != null && logoUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: logoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_cafe,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_cafe,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_cafe,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Business Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextWidget(
                      text: shopName,
                      fontSize: 18,
                      color: Colors.white,
                      isBold: true,
                    ),
                    if (isVerified != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        isVerified ? Icons.verified : Icons.pending,
                        color: isVerified ? Colors.green : Colors.orange,
                        size: 18,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                TextWidget(
                  text: isVerified == false
                      ? 'Shop is under verification'
                      : 'Tap to Manage profile',
                  fontSize: 14,
                  color:
                      isVerified == false ? Colors.orange : Colors.grey[400]!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title,
            fontSize: 16,
            color: Colors.white,
            isBold: true,
          ),
          const SizedBox(height: 8),
          TextWidget(
            text: subtitle,
            fontSize: 14,
            color: Colors.grey[400]!,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(String shopId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Analytics & Stats',
            fontSize: 18,
            color: Colors.white,
            isBold: true,
          ),
          const SizedBox(height: 20),
          
          // Stats Grid
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .doc(shopId)
                .snapshots(),
            builder: (context, shopSnapshot) {
              final shopData = shopSnapshot.data?.data();
              final ratings = (shopData?['ratings'] as num?)?.toDouble() ?? 0.0;
              final ratingCount = shopData?['ratingCount'] as int? ?? 0;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.star,
                          label: 'Rating',
                          value: ratings > 0 ? ratings.toStringAsFixed(1) : '0.0',
                          color: Colors.amber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatItem(
                          icon: Icons.rate_review,
                          label: 'Total Ratings',
                          value: ratingCount.toString(),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('shops')
                              .doc(shopId)
                              .collection('visits')
                              .snapshots(),
                          builder: (context, visitSnapshot) {
                            final visitCount = visitSnapshot.data?.docs.length ?? 0;
                            return _buildStatItem(
                              icon: Icons.people,
                              label: 'Customer Visits',
                              value: visitCount.toString(),
                              color: Colors.green,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (context, userSnapshot) {
                            // Count users who bookmarked this shop
                            return FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('bookmarks', arrayContains: shopId)
                                  .get(),
                              builder: (context, bookmarkSnapshot) {
                                final savedCount = bookmarkSnapshot.data?.docs.length ?? 0;
                                return _buildStatItem(
                                  icon: Icons.bookmark,
                                  label: 'Saved',
                                  value: savedCount.toString(),
                                  color: primary,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          TextWidget(
            text: value,
            fontSize: 24,
            color: Colors.white,
            isBold: true,
          ),
          const SizedBox(height: 4),
          TextWidget(
            text: label,
            fontSize: 12,
            color: Colors.grey[400]!,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

