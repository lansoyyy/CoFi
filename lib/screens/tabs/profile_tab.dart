import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/text_widget.dart';

class ProfileTab extends StatelessWidget {
  final VoidCallback? onOpenExplore;
  const ProfileTab({super.key, this.onOpenExplore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 32),
            // Profile header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 72,
                    height: 72,
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
                  Row(
                    children: [
                      PopupMenuButton<int>(
                        icon: const Icon(Icons.more_vert,
                            color: Colors.white, size: 26),
                        onSelected: (value) async {
                          if (value == 0) {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: Colors.grey[900],
                                title: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(ctx).pop(true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                            if (shouldLogout == true) {
                              try {
                                await FirebaseAuth.instance.signOut();
                                // AuthGate will navigate to LandingScreen automatically
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Logout failed: $e')),
                                  );
                                }
                              }
                            }
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              value: 0,
                              child: TextWidget(
                                text: 'Logout',
                                fontSize: 16,
                              ),
                            )
                          ];
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Builder(builder: (context) {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  return TextWidget(
                    text: 'Guest',
                    fontSize: 32,
                    color: Colors.white,
                    isBold: true,
                  );
                }
                final userDocStream = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots();
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userDocStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data?.data();
                    final name = (data?['name'] as String?)?.trim();
                    final displayName = (name?.isNotEmpty == true)
                        ? name!
                        : (user.displayName ?? 'User');
                    return TextWidget(
                      text: displayName,
                      fontSize: 32,
                      color: Colors.white,
                      isBold: true,
                    );
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Builder(builder: (context) {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  return TextWidget(
                    text: 'Not signed in',
                    fontSize: 16,
                    color: Colors.white70,
                  );
                }
                final userDocStream = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots();
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: userDocStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data?.data();
                    final address = (data?['address'] as String?)?.trim();
                    final text =
                        (address == null || address.isEmpty) ? '' : address;
                    if (text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return TextWidget(
                      text: text,
                      fontSize: 16,
                      color: Colors.white70,
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 32),
            // Stats Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: '2025 Stats',
                      fontSize: 20,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 18),
                    Builder(builder: (context) {
                      final now = DateTime.now();
                      final startOfToday =
                          DateTime(now.year, now.month, now.day);
                      final startOfWeek = startOfToday.subtract(
                          Duration(days: startOfToday.weekday - 1)); // Monday
                      final startOfMonth = DateTime(now.year, now.month, 1);
                      final startOfYear = DateTime(now.year, 1, 1);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatRowStream(
                            _streamVisitCount(start: startOfWeek, end: now),
                            'Shops Visited',
                            'This week',
                            onTap: () {
                              Navigator.pushNamed(context, '/visitedCafes');
                            },
                          ),
                          const Divider(color: Colors.white24, thickness: 1),
                          _buildStatRowStream(
                            _streamVisitCount(start: startOfMonth, end: now),
                            'Shops Visited',
                            'This month',
                            onTap: () {
                              Navigator.pushNamed(context, '/visitedCafes');
                            },
                          ),
                          const Divider(color: Colors.white24, thickness: 1),
                          _buildStatRowStream(
                            _streamVisitCount(start: startOfYear, end: now),
                            'Shops Visited',
                            'This year',
                            underline: true,
                            onTap: () {
                              Navigator.pushNamed(context, '/visitedCafes');
                            },
                          ),
                          const Divider(color: Colors.white24, thickness: 1),
                          _buildStatRowStream(
                            _streamReviewCount(start: startOfYear, end: now),
                            'Shops Reviewed',
                            '',
                            onTap: () {
                              Navigator.pushNamed(context, '/yourReviews');
                            },
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Contribute to Community
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWidget(
                text: 'Contribute to Community',
                fontSize: 18,
                color: Colors.white,
                isBold: true,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Builder(
                builder: (context) {
                  final user = FirebaseAuth.instance.currentUser;
                  final stream = user == null
                      ? null
                      : FirebaseFirestore.instance
                          .collection('shops')
                          .where('posterId', isEqualTo: user.uid)
                          .limit(1)
                          .snapshots();

                  return StreamBuilder<QuerySnapshot>(
                    stream: stream,
                    builder: (context, snapshot) {
                      final hasShop =
                          snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                      String label = hasShop ? 'View Shop' : 'Submit A Shop';
                      String subtitle = '';

                      if (hasShop) {
                        final doc = snapshot.data!.docs.first;
                        final data = doc.data() as Map<String, dynamic>;
                        final isVerified = data['isVerified'] ?? false;

                        if (!isVerified) {
                          label = 'Shop Under Verification';
                          subtitle = 'Your shop is being reviewed';
                        }
                      }

                      void navigate() {
                        if (hasShop) {
                          final doc = snapshot.data!.docs.first;
                          final data = doc.data() as Map<String, dynamic>;
                          Navigator.pushNamed(
                            context,
                            '/businessProfile',
                            arguments: {
                              ...data,
                              'id': doc.id,
                            },
                          );
                        } else {
                          Navigator.pushNamed(context, '/submitShop');
                        }
                      }

                      return GestureDetector(
                        onTap: navigate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.local_cafe,
                                        color: Colors.white, size: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      text: label,
                                      fontSize: 18,
                                      color: Colors.white,
                                      isBold: true,
                                    ),
                                    if (subtitle.isNotEmpty)
                                      TextWidget(
                                        text: subtitle,
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios,
                                    color: Colors.white, size: 22),
                                onPressed: navigate,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Find the perfect cafe
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child:
                          Icon(Icons.local_cafe, color: Colors.white, size: 36),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextWidget(
                    text: 'Find the perfect cafe',
                    fontSize: 22,
                    color: Colors.white,
                    isBold: true,
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    align: TextAlign.center,
                    text:
                        'Explore, check cafe shops to visit and share it in the reviews.',
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onOpenExplore,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Explore Cafes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String stat, String title, String subtitle,
      {bool underline = false, VoidCallback? onTap}) {
    Widget content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: stat,
            fontSize: 28,
            color: Colors.white,
            isBold: true,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              underline
                  ? TextWidget(
                      text: title,
                      fontSize: 18,
                      color: Colors.white,
                      isBold: true,
                    )
                  : TextWidget(
                      text: title,
                      fontSize: 18,
                      color: Colors.white,
                      isBold: true,
                    ),
              if (subtitle.isNotEmpty)
                TextWidget(
                  text: subtitle,
                  fontSize: 14,
                  color: Colors.white54,
                ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }

  // Streams the count of UNIQUE shops the user has visited in a date range
  // using collectionGroup('visits') across all shops.
  Stream<int> _streamVisitCount(
      {required DateTime start, required DateTime end}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream<int>.value(0);
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);
    final query = FirebaseFirestore.instance
        .collectionGroup('visits')
        .where('userId', isEqualTo: user.uid)
        .where('createdAt', isGreaterThanOrEqualTo: startTs)
        .where('createdAt', isLessThanOrEqualTo: endTs);
    return query.snapshots().map((snap) {
      final uniqueShopIds = <String>{};
      for (final doc in snap.docs) {
        final shopId = doc.reference.parent.parent?.id;
        if (shopId != null) uniqueShopIds.add(shopId);
      }
      return uniqueShopIds.length;
    });
  }

  // Streams the count of UNIQUE shops the user has reviewed in a date range
  // using collectionGroup('reviews') across all shops.
  Stream<int> _streamReviewCount(
      {required DateTime start, required DateTime end}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream<int>.value(0);
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);
    final query = FirebaseFirestore.instance
        .collectionGroup('reviews')
        .where('userId', isEqualTo: user.uid)
        .where('createdAt', isGreaterThanOrEqualTo: startTs)
        .where('createdAt', isLessThanOrEqualTo: endTs);
    return query.snapshots().map((snap) {
      final uniqueShopIds = <String>{};
      for (final doc in snap.docs) {
        final shopId = doc.reference.parent.parent?.id;
        if (shopId != null) uniqueShopIds.add(shopId);
      }
      return uniqueShopIds.length;
    });
  }

  // Builds a stat row that listens to a count stream and renders it.
  Widget _buildStatRowStream(
    Stream<int> countStream,
    String title,
    String subtitle, {
    bool underline = false,
    VoidCallback? onTap,
  }) {
    return StreamBuilder<int>(
      stream: countStream,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return _buildStatRow(
          count.toString(),
          title,
          subtitle,
          underline: underline,
          onTap: onTap,
        );
      },
    );
  }
}
