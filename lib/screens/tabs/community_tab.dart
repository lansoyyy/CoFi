import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofi/screens/subscreens/event_details_screen.dart';
import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';
import '../job_details_screen.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text: 'Latest in',
                        fontSize: 28,
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: 'Baloo2',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: 'Davao City',
                        fontSize: 28,
                        color: Colors.white,
                        fontFamily: 'Medium',
                        isBold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Events Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWidget(
                text: 'Events',
                fontSize: 22,
                color: Colors.white,
                fontFamily: 'Baloo2',
                isBold: true,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('events')
                    .orderBy('createdAt', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return TextWidget(
                      text: 'Failed to load events',
                      fontSize: 14,
                      color: Colors.redAccent,
                    );
                  }
                  final docs = snapshot.data?.docs ?? [];
                  DocumentSnapshot<Map<String, dynamic>>? todayDoc;
                  for (final d in docs) {
                    final data = d.data();
                    if (true) {
                      todayDoc = d;
                      break;
                    }
                  }
                  if (todayDoc == null) {
                    return TextWidget(
                      text: 'No events today',
                      fontSize: 14,
                      color: Colors.white60,
                    );
                  }
                  final event = todayDoc.data()!;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailsScreen(event: {
                            ...event,
                            'id': todayDoc!.id,
                          }),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                  opacity: 0.65,
                                  image: NetworkImage(
                                    event['imageUrl'],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            bottom: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                  text: (event['title'] ?? 'Event').toString(),
                                  fontSize: 20,
                                  color: Colors.white,
                                  isBold: true,
                                ),
                                const SizedBox(height: 4),
                                TextWidget(
                                  text: _eventSubtitle(event),
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Shared Collections Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWidget(
                text: 'Shared Collections',
                fontSize: 22,
                color: Colors.white,
                fontFamily: 'Baloo2',
                isBold: true,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('sharedCollections')
                    .orderBy('sharedAt', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return TextWidget(
                      text: 'Failed to load shared collections',
                      fontSize: 14,
                      color: Colors.redAccent,
                    );
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return TextWidget(
                      text: 'No shared collections yet',
                      fontSize: 14,
                      color: Colors.white60,
                    );
                  }
                  return Column(
                    children: docs.map((d) {
                      final collection = d.data();
                      return _buildSharedCollectionCard(
                          context, collection, d.id);
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            // Job Hirings Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWidget(
                text: 'Job Hirings',
                fontSize: 22,
                color: Colors.white,
                fontFamily: 'Baloo2',
                isBold: true,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collectionGroup('jobs')
                    .orderBy('createdAt', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return TextWidget(
                      text: 'Failed to load jobs',
                      fontSize: 14,
                      color: Colors.redAccent,
                    );
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return TextWidget(
                      text: 'No jobs available',
                      fontSize: 14,
                      color: Colors.white60,
                    );
                  }
                  return Column(
                    children: docs.map((d) {
                      final job = d.data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailsScreen(
                                job: {
                                  ...job,
                                  'id': d.id,
                                },
                                shopId: d['shopId'],
                              ),
                            ),
                          );
                        },
                        child: _buildJobRow(context, job),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobRow(BuildContext context, Map<String, dynamic> job) {
    final cafe =
        (job['shopName'] ?? job['cafe'] ?? job['shopId'] ?? 'Coffee Shop')
            .toString();
    final title = (job['title'] ?? 'Job').toString();
    final city = (job['city'] ?? 'Davao City').toString();
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.bookmark_border, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TextWidget(
                //   text: cafe,
                //   fontSize: 14,
                //   color: Colors.white.withOpacity(0.7),
                // ),
                TextWidget(
                  text: title,
                  fontSize: 16,
                  color: Colors.white,
                  isBold: true,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white54, size: 16),
                    const SizedBox(width: 4),
                    TextWidget(
                      text: city,
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isEventToday(Map<String, dynamic> data) {
    DateTime? dt;
    final sd = data['startDate'];
    if (sd is Timestamp) {
      dt = sd.toDate();
    } else if (sd is String) {
      dt = DateTime.tryParse(sd);
    }
    if (dt == null) {
      final d = data['date'];
      if (d is String) {
        dt = DateTime.tryParse(d);
      } else if (d is Timestamp) {
        dt = d.toDate();
      }
    }
    if (dt == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(dt.year, dt.month, dt.day);
    return that == today;
  }

  String _eventSubtitle(Map<String, dynamic> event) {
    final date = event['date'];
    final start = event['startDate'];
    if (date is String && date.isNotEmpty) return date;
    if (start is String && start.isNotEmpty) return start;
    return 'Today';
  }

  Widget _buildSharedCollectionCard(BuildContext context,
      Map<String, dynamic> collection, String collectionId) {
    final title = collection['title'] ?? 'Untitled Collection';
    final shopCount = collection['shopCount'] ?? 0;
    final sharedBy = collection['sharedBy'] ?? 'Anonymous';
    final sharedAt = collection['sharedAt'] as Timestamp?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.collections_bookmark,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: title,
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 2),
                    TextWidget(
                      text: '$shopCount coffee shops',
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: 'Shared by $sharedBy',
                fontSize: 12,
                color: Colors.white54,
              ),
              TextWidget(
                text:
                    sharedAt != null ? _formatTimestamp(sharedAt) : 'Recently',
                fontSize: 12,
                color: Colors.white54,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/sharedCollection',
                  arguments: {
                    'collectionId': collectionId,
                    'title': title,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: TextWidget(
                text: 'View Collection',
                fontSize: 14,
                color: Colors.white,
                isBold: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
