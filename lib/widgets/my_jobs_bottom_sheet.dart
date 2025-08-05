import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';
import '../widgets/post_job_bottom_sheet.dart';

class MyJobsBottomSheet extends StatelessWidget {
  const MyJobsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
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
                    text: 'My Jobs',
                    fontSize: 18,
                    color: Colors.white,
                    isBold: true,
                  ),
                  Expanded(child: const SizedBox(width: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // Immediately show the post job form
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (newContext) => const PostJobBottomSheet(),
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Jobs List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Barista Job
                    _buildJobItem(
                      title: 'Barista',
                      status: 'Approved',
                      statusColor: Colors.green,
                    ),

                    const SizedBox(height: 16),

                    // Sample Job
                    _buildJobItem(
                      title: 'Sample Job',
                      status: 'Pending for approval',
                      statusColor: Colors.orange,
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

  Widget _buildJobItem({
    required String title,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Job Icon
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

          // Job Details
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
      builder: (context) => const MyJobsBottomSheet(),
    );
  }
}
