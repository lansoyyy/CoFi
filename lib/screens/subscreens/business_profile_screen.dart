import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class BusinessProfileScreen extends StatelessWidget {
  const BusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
                    // Business Logo
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
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
                    const SizedBox(width: 16),

                    // Business Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'Fiend Coffee Club',
                            fontSize: 18,
                            color: Colors.white,
                            isBold: true,
                          ),
                          const SizedBox(height: 4),
                          TextWidget(
                            text: 'Tap to Manage profile',
                            fontSize: 14,
                            color: Colors.grey[400]!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Grid of sections
                Column(
                  children: [
                    // First row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSectionCard(
                            title: 'Reviews',
                            subtitle: 'Show my shops reviews',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSectionCard(
                            title: 'Events',
                            subtitle: 'Show upcoming Events',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Second row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSectionCard(
                            title: 'Post an Event',
                            subtitle: 'List my upcoming events',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSectionCard(
                            title: 'Jobs',
                            subtitle: 'Show my submitted jobs',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Third row
                    Row(
                      children: [
                        Expanded(
                          child: _buildSectionCard(
                            title: 'Post a Job',
                            subtitle: 'List a job - find staff fast',
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
}
