import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class MyEventsBottomSheet extends StatelessWidget {
  const MyEventsBottomSheet({super.key});

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
                ],
              ),
            ),

            // Events List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Coffee Day Event
                    _buildEventItem(
                      title: 'Coffee Day',
                      status: 'Approved',
                      statusColor: Colors.green,
                      participants: '25 Participants',
                    ),

                    const SizedBox(height: 16),

                    // Sample Event
                    _buildEventItem(
                      title: 'Sample Event',
                      status: 'Pending for approval',
                      statusColor: Colors.orange,
                      participants: null,
                    ),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventItem({
    required String title,
    required String status,
    required Color statusColor,
    String? participants,
  }) {
    return Container(
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
              color: primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_cafe,
                  color: Colors.red,
                  size: 12,
                ),
              ),
            ),
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
                const SizedBox(height: 4),
                TextWidget(
                  text: status,
                  fontSize: 14,
                  color: statusColor,
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
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const MyEventsBottomSheet(),
    );
  }
}
