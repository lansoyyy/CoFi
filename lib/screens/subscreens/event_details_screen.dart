import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/text_widget.dart';
import '../../../utils/colors.dart';
import 'event_comments_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? event;
  const EventDetailsScreen({Key? key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final e = event ?? <String, dynamic>{};
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Event Image
                  Stack(
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                              opacity: 0.65,
                              image: NetworkImage(
                                e['imageUrl'],
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: (e['title'] ?? 'Event').toString(),
                              fontSize: 24,
                              color: Colors.white,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Section
                        TextWidget(
                          text: 'Start Date',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: _formatEventDate(e),
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 24),
 TextWidget(
                          text: 'End Date',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: _formatEventDate1(e),
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 24),
                        // Address Section
                        TextWidget(
                          text: 'Address',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: (e['address'] ?? 'Address not specified')
                              .toString(),
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 16),

                        // About Section
                        TextWidget(
                          text: 'About',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: (e['about'] ?? 'No description provided')
                              .toString(),
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 24),

                        // Email Section
                        TextWidget(
                          text: 'Email',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: (e['email'] ?? 'N/A').toString(),
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 100), // Space for button
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventCommentsScreen(
                          eventId: e['id'] ?? '',
                          shopId: e['shopId'] ?? '',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.touch_app, color: Colors.white),
                      const SizedBox(width: 8),
                      TextWidget(
                        text: 'Tap to participate',
                        fontSize: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventDate(Map<String, dynamic> e) {
    // Try 'date' first, then 'startDate'. Accept String or Timestamp.
    DateTime? dt;
    final d = e['date'];
    if (d is Timestamp) dt = d.toDate();
    if (d is String && d.isNotEmpty) {
      dt = DateTime.tryParse(d);
    }
    final sd = e['startDate'];
    if (dt == null) {
      if (sd is Timestamp) dt = sd.toDate();
      if (sd is String && sd.isNotEmpty) dt = DateTime.tryParse(sd);
    }
    if (dt == null) return 'Date not set';
    final day = dt.day.toString().padLeft(2, '0');
    final mon = dt.month.toString().padLeft(2, '0');
    final yr = dt.year.toString();
    return '$yr-$mon-$day';
  }


    String _formatEventDate1(Map<String, dynamic> e) {
    // Try 'date' first, then 'startDate'. Accept String or Timestamp.
    DateTime? dt;
    final d = e['date'];
    if (d is Timestamp) dt = d.toDate();
    if (d is String && d.isNotEmpty) {
      dt = DateTime.tryParse(d);
    }
    final sd = e['endDate'];
    if (dt == null) {
      if (sd is Timestamp) dt = sd.toDate();
      if (sd is String && sd.isNotEmpty) dt = DateTime.tryParse(sd);
    }
    if (dt == null) return 'Date not set';
    final day = dt.day.toString().padLeft(2, '0');
    final mon = dt.month.toString().padLeft(2, '0');
    final yr = dt.year.toString();
    return '$yr-$mon-$day';
  }
}
