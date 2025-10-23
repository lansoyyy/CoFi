import 'package:cofi/screens/auth/login_screen.dart';
import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/text_widget.dart';
import '../job_chat_screen.dart';

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
                      IconButton(
                          onPressed: () {
                            showDialog(
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
                                    onPressed: () async {
                                      try {
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                        // AuthGate will navigate to LandingScreen automatically
                                      } catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content:
                                                    Text('Logout failed: $e')),
                                          );
                                        }
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                    ),
                                    child: const Text('Logout'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.white,
                          )),
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
            // Stats Card - Different for Business vs User accounts
            Builder(
              builder: (context) {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return const SizedBox.shrink();

                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    final userData = userSnapshot.data?.data();
                    final accountType =
                        userData?['accountType'] as String? ?? 'user';

                    // Business Account - Show Analytics & Stats
                    if (accountType == 'business') {
                      return _buildBusinessAnalyticsSection(context, user.uid);
                    }

                    // User Account - Show regular stats
                    return _buildUserStatsSection(context, user.uid);
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            // Contribute to Community or Business Dashboard based on account type
            Builder(
              builder: (context) {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return const SizedBox.shrink();

                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    final userData = userSnapshot.data?.data();
                    final accountType =
                        userData?['accountType'] as String? ?? 'user';

                    // Business Account - Show Business Dashboard
                    if (accountType == 'business') {
                      return _buildBusinessSection(context, user.uid);
                    }

                    // User Account - Show Contribute Section
                    return _buildUserContributeSection(context, user.uid);
                  },
                );
              },
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

  // Business Analytics Section for business users
  Widget _buildBusinessAnalyticsSection(BuildContext context, String uid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .where('posterId', isEqualTo: uid)
            .limit(1)
            .snapshots(),
        builder: (context, shopSnapshot) {
          if (!shopSnapshot.hasData || shopSnapshot.data!.docs.isEmpty) {
            // No shop yet, show empty state
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Business Analytics',
                    fontSize: 20,
                    color: Colors.white,
                    isBold: true,
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.business,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 12),
                        TextWidget(
                          text: 'No shop data available',
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: 'Submit or claim a shop to see analytics',
                          fontSize: 14,
                          color: Colors.grey[600],
                          align: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final shopDoc = shopSnapshot.data!.docs.first;
          final shopId = shopDoc.id;

          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Business Analytics',
                  fontSize: 20,
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
                  builder: (context, shopDataSnapshot) {
                    final shopData = shopDataSnapshot.data?.data();
                    final ratings =
                        (shopData?['ratings'] as num?)?.toDouble() ?? 0.0;
                    final ratingCount = shopData?['ratingCount'] as int? ?? 0;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatItem(
                                icon: Icons.star,
                                label: 'Rating',
                                value: ratings > 0
                                    ? ratings.toStringAsFixed(1)
                                    : '0.0',
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
                                  final visitCount =
                                      visitSnapshot.data?.docs.length ?? 0;
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
                              child: FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .where('bookmarks', arrayContains: shopId)
                                    .get(),
                                builder: (context, bookmarkSnapshot) {
                                  final savedCount =
                                      bookmarkSnapshot.data?.docs.length ?? 0;
                                  return _buildStatItem(
                                    icon: Icons.bookmark,
                                    label: 'Saved',
                                    value: savedCount.toString(),
                                    color: primary,
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
        },
      ),
    );
  }

  // User Stats Section for regular users
  Widget _buildUserStatsSection(BuildContext context, String uid) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
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
              final startOfToday = DateTime(now.year, now.month, now.day);
              final startOfWeek = startOfToday
                  .subtract(Duration(days: startOfToday.weekday - 1)); // Monday
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

  // User Account: Show contribute section (submit shop, view submission status)
  Widget _buildUserContributeSection(BuildContext context, String uid) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, userSnapshot) {
        final userData = userSnapshot.data?.data();
        final accountType = userData?['accountType'] as String? ?? 'user';

        // For regular users, show job application section
        if (accountType == 'user') {
          return _buildUserJobApplicationSection(context, uid);
        }

        // For other account types, show shop submission section
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('shops')
                    .where('posterId', isEqualTo: uid)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  final hasShop =
                      snapshot.hasData && snapshot.data!.docs.isNotEmpty;
                  String label = hasShop ? 'View Submission' : 'Submit A Shop';
                  String subtitle = '';
                  IconData statusIcon = Icons.local_cafe;
                  Color statusColor = primary;

                  if (hasShop) {
                    final doc = snapshot.data!.docs.first;
                    final data = doc.data() as Map<String, dynamic>;
                    final isVerified = data['isVerified'] ?? false;

                    if (isVerified) {
                      label = 'Submission Approved';
                      subtitle = 'Your shop is live';
                      statusIcon = Icons.check_circle;
                      statusColor = Colors.green;
                    } else {
                      label = 'Submission Pending';
                      subtitle = 'Your shop is under review';
                      statusIcon = Icons.pending;
                      statusColor = Colors.orange;
                    }
                  }

                  void navigate() {
                    if (hasShop) {
                      final doc = snapshot.data!.docs.first;
                      final data = doc.data() as Map<String, dynamic>;
                      final isVerified = data['isVerified'] ?? false;

                      // User can only view submission status, not manage
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.grey[900],
                          title: Row(
                            children: [
                              Icon(statusIcon, color: statusColor, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  label,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shop Name: ${data['name'] ?? 'Unknown'}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Status: ${isVerified ? 'Approved' : 'Pending Verification'}',
                                style: TextStyle(color: statusColor),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                isVerified
                                    ? 'Your shop is now visible to all users!'
                                    : 'Your shop will be visible once approved by our team.',
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 14),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
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
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(statusIcon,
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
              ),
            ),
          ],
        );
      },
    );
  }

  // User Account: Show job application section for regular users
  Widget _buildUserJobApplicationSection(BuildContext context, String uid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextWidget(
            text: 'Job Applications',
            fontSize: 18,
            color: Colors.white,
            isBold: true,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collectionGroup('jobs').snapshots(),
            builder: (context, snapshot) {
              // Filter documents to find those that actually contain the user's application
              final relevantDocs = snapshot.data?.docs.where((doc) {
                    final applications =
                        (doc.data() as Map<String, dynamic>?)?['applications']
                                as List<dynamic>? ??
                            [];
                    return applications.any((app) =>
                        app is Map<String, dynamic> &&
                        app['applicantId'] == uid);
                  }).toList() ??
                  [];

              final hasApplications = relevantDocs.isNotEmpty;

              return GestureDetector(
                onTap: () {
                  if (hasApplications) {
                    _showJobApplicationsDialog(context, relevantDocs);
                  } else {
                    _showAvailableJobsDialog(context);
                  }
                },
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
                          decoration: BoxDecoration(
                            color: hasApplications ? Colors.green : primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              hasApplications ? Icons.work_history : Icons.work,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: hasApplications
                                  ? 'View Applications'
                                  : 'Find Jobs',
                              fontSize: 18,
                              color: Colors.white,
                              isBold: true,
                            ),
                            TextWidget(
                              text: hasApplications
                                  ? 'You have ${relevantDocs.length} application(s)'
                                  : 'Browse available job opportunities',
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 22),
                        onPressed: () {
                          if (hasApplications) {
                            _showJobApplicationsDialog(context, relevantDocs);
                          } else {
                            _showAvailableJobsDialog(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showJobApplicationsDialog(
      BuildContext context, List<DocumentSnapshot> jobDocs) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            const Icon(Icons.work_history, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Your Job Applications',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Here are the jobs you\'ve applied to:',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ...jobDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final applications =
                    (data['applications'] as List<dynamic>?) ?? [];
                final userApplications = applications
                    .where((app) =>
                        app is Map<String, dynamic> &&
                        app['applicantId'] ==
                            FirebaseAuth.instance.currentUser?.uid)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) return;

                        // Find the application data for the current user
                        final userApplication = userApplications.firstWhere(
                          (app) => app['applicantId'] == currentUser.uid,
                          orElse: () => null,
                        );

                        if (userApplication != null) {
                          FirebaseFirestore.instance
                              .collection('shops')
                              .doc(data['shopId'])
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              Navigator.of(ctx).pop();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobChatScreen(
                                    jobId: doc.id,
                                    jobTitle:
                                        data['title'] ?? 'Unknown Position',
                                    shopId: data['shopId'] ?? '',
                                    posterId:
                                        documentSnapshot['posterId'] ?? '',
                                    applicantId: currentUser.uid,
                                    applicationId: userApplication['id'] ?? '',
                                  ),
                                ),
                              );
                            }
                          });
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextWidget(
                                    text: data['title'] ?? 'Unknown Position',
                                    fontSize: 16,
                                    color: Colors.white,
                                    isBold: true,
                                  ),
                                ),
                                const Icon(
                                  Icons.chat,
                                  color: primary,
                                  size: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            TextWidget(
                              text: data['address'] ?? 'Unknown Location',
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            const SizedBox(height: 8),
                            ...userApplications.map((app) {
                              final appData = app as Map<String, dynamic>;
                              final status =
                                  appData['status'] as String? ?? 'pending';
                              final appliedAt =
                                  appData['appliedAt'] as Timestamp?;
                              final dateStr = appliedAt != null
                                  ? '${appliedAt.toDate().day}/${appliedAt.toDate().month}/${appliedAt.toDate().year}'
                                  : 'Unknown date';

                              Color statusColor = Colors.orange;
                              String statusText = 'Pending';

                              if (status == 'accepted') {
                                statusColor = Colors.green;
                                statusText = 'Accepted';
                              } else if (status == 'rejected') {
                                statusColor = Colors.red;
                                statusText = 'Rejected';
                              }

                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextWidget(
                                      text: 'Applied on $dateStr',
                                      fontSize: 12,
                                      color: Colors.white60,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 4),
                            TextWidget(
                              text: 'Tap to chat with employer',
                              fontSize: 12,
                              color: primary,
                              align: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAvailableJobsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Row(
          children: [
            const Icon(Icons.work, color: primary, size: 28),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Find Job Opportunities',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse the Explore tab to find available job postings from coffee shops.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              'Tap on any job posting to view details and submit your application.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Navigate to explore tab
              DefaultTabController.of(context)
                  ?.animateTo(1); // Explore tab index
            },
            child: const Text('Go to Explore'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Business Account: Show business dashboard with shop management
  Widget _buildBusinessSection(BuildContext context, String uid) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextWidget(
            text: 'My Business',
            fontSize: 18,
            color: Colors.white,
            isBold: true,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('shops')
                .where('posterId', isEqualTo: uid)
                .limit(1)
                .snapshots(),
            builder: (context, snapshot) {
              final hasShop =
                  snapshot.hasData && snapshot.data!.docs.isNotEmpty;
              String label =
                  hasShop ? 'Manage My Shop' : 'Claim or Submit Shop';
              String subtitle = hasShop
                  ? 'View dashboard & analytics'
                  : 'Get started with your business';

              if (hasShop) {
                final doc = snapshot.data!.docs.first;
                final data = doc.data() as Map<String, dynamic>;
                final isVerified = data['isVerified'] ?? false;

                if (!isVerified) {
                  label = 'Shop Under Verification';
                  subtitle = 'Dashboard available after approval';
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
                  // Show options: Claim existing shop or Submit new shop
                  Navigator.pushNamed(context, '/businessDashboard');
                }
              }

              return GestureDetector(
                onTap: navigate,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withOpacity(0.3),
                      width: 1.5,
                    ),
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
                            color: Color(0xFF2563EB),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.business,
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
          ),
        ),
      ],
    );
  }
}
