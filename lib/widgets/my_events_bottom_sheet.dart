import 'package:cofi/widgets/post_event_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/text_widget.dart';
import '../screens/subscreens/event_details_screen.dart';

class MyEventsBottomSheet extends StatelessWidget {
  const MyEventsBottomSheet({super.key, required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextWidget(
                    text: 'My Events',
                    fontSize: 18,
                    color: Colors.white,
                    isBold: true,
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      PostEventBottomSheet.show(context, shopId: shopId);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Events List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('shops')
                      .doc(shopId)
                      .collection('events')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: TextWidget(
                          text: 'Failed to load events',
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      );
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextWidget(
                              text: 'No events yet',
                              fontSize: 16,
                              color: Colors.white,
                              isBold: true,
                            ),
                            const SizedBox(height: 8),
                            TextWidget(
                              text: 'Tap + to post your first event',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final data = docs[index].data();
                        final title = (data['title'] as String?) ?? 'Untitled';
                        final status = (data['status'] as String?) ?? 'pending';
                        final participants = data['participantsCount'] is int
                            ? data['participantsCount'] as int
                            : 0;
                        final statusColor = status.toLowerCase() == 'approved'
                            ? Colors.green
                            : status.toLowerCase() == 'rejected'
                                ? Colors.red
                                : Colors.orange;
                        return _buildEventItem(
                          context: context,
                          image:data['imageUrl'] ,
                          about: data['about'],
                          title: title,
                          status: status == 'pending'
                              ? ''
                              : status[0].toUpperCase() + status.substring(1),
                          statusColor: statusColor,
                          participants: participants > 0
                              ? '$participants Participants'
                              : null,
                          eventData: data,
                          eventId: docs[index].id,
                          shopId: shopId,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem({
    required BuildContext context,
    required String title,
        required String about,
    required String status,
    required String image,
    required Color statusColor,
    String? participants,
    required Map<String, dynamic> eventData,
    required String eventId,
    required String shopId,
  }) {
    return GestureDetector(
      onTap: () {
        // Add shopId and id to the event data
        final completeEventData = Map<String, dynamic>.from(eventData);
        completeEventData['shopId'] = shopId;
        completeEventData['id'] = eventId;
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(event: completeEventData),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Event Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5),
                image: DecorationImage(image: NetworkImage(image),
                fit: BoxFit.cover),
              )
            ),

            const SizedBox(width: 16),

            // Event Details
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
                    TextWidget(
                    text: about,
                    fontSize: 12,
                    color: Colors.white,
                   
                  ),
               
                  if (participants != null) ...[
                    const SizedBox(height: 4),
                    TextWidget(
                      text: participants,
                      fontSize: 14,
                      color: Colors.grey[400]!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, {required String shopId}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => MyEventsBottomSheet(shopId: shopId),
    );
  }
}
