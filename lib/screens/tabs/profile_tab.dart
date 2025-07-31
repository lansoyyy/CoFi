import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

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
                      child: TextWidget(
                        text: 'cofi',
                        fontSize: 20,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share,
                            color: Colors.white, size: 26),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert,
                            color: Colors.white, size: 26),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWidget(
                text: 'Juan Dela Cruz',
                fontSize: 32,
                color: Colors.white,
                isBold: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWidget(
                text: 'Davao City, PH',
                fontSize: 16,
                color: Colors.white70,
              ),
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
                    _buildStatRow('1', 'Shops Visited', 'This week'),
                    const Divider(color: Colors.white24, thickness: 1),
                    _buildStatRow('3', 'Shops Visited', 'This month'),
                    const Divider(color: Colors.white24, thickness: 1),
                    _buildStatRow('5', 'Shops Visited', 'This year',
                        underline: true),
                    const Divider(color: Colors.white24, thickness: 1),
                    _buildStatRow('3', 'Shops Reviewed', ''),
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
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Container(
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextWidget(
                        text: 'Submit A Shop',
                        fontSize: 18,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
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
                      onPressed: () {},
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
      {bool underline = false}) {
    return Padding(
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
  }
}
