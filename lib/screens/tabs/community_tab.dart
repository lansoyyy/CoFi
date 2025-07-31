import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[800],
                      child: const Center(
                        child:
                            Icon(Icons.image, color: Colors.white38, size: 60),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: 'Coffee Day',
                            fontSize: 20,
                            color: Colors.white,
                            isBold: true,
                          ),
                          const SizedBox(height: 4),
                          TextWidget(
                            text: 'SAT, 5 JUL | 04:00 PM - 08:00 PM',
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
            ..._buildJobList(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildJobList() {
    final jobs = [
      {
        'cafe': 'Baoba Cafe',
        'title': 'Barista Wanted - Join Us in Davao!',
        'city': 'Davao City',
      },
      {
        'cafe': 'SampleCafe',
        'title': 'Barista',
        'city': 'Davao City',
      },
      {
        'cafe': 'NoNameCafe',
        'title': 'Barista',
        'city': 'Davao City',
      },
      {
        'cafe': 'Unknown Cafe',
        'title': 'Barista',
        'city': 'Davao City',
      },
      {
        'cafe': 'IDKCafe',
        'title': 'Barista',
        'city': 'Davao City',
      },
    ];
    return jobs.map((job) {
      return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
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
                child:
                    Icon(Icons.bookmark_border, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: job['cafe']!,
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  TextWidget(
                    text: job['title']!,
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
                        text: job['city']!,
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
    }).toList();
  }
}
