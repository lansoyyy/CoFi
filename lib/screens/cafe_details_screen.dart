import 'package:flutter/material.dart';
import '../widgets/text_widget.dart';
import '../utils/colors.dart';
import 'reviews_screen.dart';
import 'log_visit_screen.dart';
import 'write_review_screen.dart';

class CafeDetailsScreen extends StatelessWidget {
  const CafeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            // Image placeholder
            Stack(
              children: [
                Container(
                  height: 400,
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.image, color: Colors.white38, size: 60),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon:
                        const Icon(Icons.bookmark_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      TextWidget(
                        text: '5.0 (10) · Verified',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Fiend Coffee Club',
                        fontSize: 28,
                        color: Colors.white,
                        isBold: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 8,
                      children: [
                        _buildChip('Aesthetic'),
                        _buildChip('Matcha Drinks'),
                        _buildChip('Cozy & Chill'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection('About',
                'More than just a café, it’s a club for the true coffee fiends.'),
            SizedBox(
              height: 10,
            ),
            _buildSection('Address',
                'Juna Ave. (Beside 6th Republic Resto) 8000 Davao City, Philippines'),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 250,
                color: Colors.grey[800],
                child: const Center(
                  child: Icon(Icons.map, color: Colors.white38, size: 60),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildSection('Schedule',
                'Monday · 11:00 AM - 02:00 AM\nTuesday · 11:00 AM - 02:00 AM\nWednesday · 11:00 AM - 02:00 AM\nThursday · 11:00 AM - 02:00 AM\nFriday · 11:00 AM - 02:00 AM\nSaturday · 11:00 AM - 02:00 AM\nSunday · 11:00 AM - 02:00 AM'),
            const SizedBox(height: 32),
            _buildSection('Contacts', 'Instagram\nFacebook\nTiktok'),
            const SizedBox(height: 32),
            _buildSection('Menu', 'Tap to view Menu', icon: Icons.menu_book),
            const SizedBox(height: 32),
            _buildReviewsSummary(),
            _buildReviewsSection(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          TextWidget(
            text: label,
            fontSize: 14,
            color: Colors.white,
          ),
        ],
      ),
      backgroundColor: primary,
    );
  }

  Widget _buildSection(String title, String content, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: title,
            fontSize: 18,
            color: Colors.white,
            isBold: true,
          ),
          const SizedBox(height: 8),
          if (title == 'Schedule')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.split('\n').map((line) {
                final parts = line.split('·');
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: parts[0].trim(),
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: '•',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: parts[1].trim(),
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ],
                );
              }).toList(),
            )
          else if (title == 'Contacts')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content.split('\n').map((contact) {
                IconData? icon;
                switch (contact.trim().toLowerCase()) {
                  case 'instagram':
                    icon = Icons.camera_alt;
                    break;
                  case 'facebook':
                    icon = Icons.facebook;
                    break;
                  case 'tiktok':
                    icon = Icons.music_note;
                    break;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 24),
                      const SizedBox(width: 8),
                      TextWidget(
                        text: contact.trim(),
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          else if (icon != null)
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                TextWidget(
                  text: content,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ],
            )
          else
            TextWidget(
              text: content,
              fontSize: 16,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Reviews',
            fontSize: 18,
            color: Colors.white,
            isBold: true,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextWidget(
                text: '5.0',
                fontSize: 32,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: '8 Reviews',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  TextWidget(
                    text: '10 Visits',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Reviews',
            fontSize: 18,
            color: Colors.white,
            isBold: true,
          ),
          const SizedBox(height: 8),
          _buildReviewCard(
            name: 'Jeremy Juaton',
            review: 'Very cozy coffee shop, worth visiting',
            tags: ['Chill Hangout'],
            imagePath: 'assets/images/review1.jpg',
          ),
          _buildReviewCard(
            name: 'Princess Castillo',
            review: 'Amazing Coffee shop',
            tags: ['Off / Hangout', 'Study Vibes'],
            imagePath: 'assets/images/review2.jpg',
          ),
          _buildReviewCard(
            name: 'Kyle Cabanig',
            review: 'Love the vibes >>',
            tags: ['Business Meeting', 'Cozy / Chill'],
            imagePath: 'assets/images/review3.jpg',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard({
    required String name,
    required String review,
    required List<String> tags,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                        Icon(Icons.location_on, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: name,
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextWidget(
                          text: '1 week ago',
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: tags
                  .map((tag) => Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        label: TextWidget(
                          text: tag,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.grey[800],
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            TextWidget(
              text: review,
              fontSize: 14,
              color: Colors.white70,
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: const Center(
                child: Icon(Icons.image, color: Colors.white38, size: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewsScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              maximumSize: Size(350, 50),
              minimumSize: Size(350, 50),
              backgroundColor: Colors.transparent,
              side: BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: TextWidget(
              text: 'Show all reviews',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LogVisitScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 8),
                    TextWidget(
                      text: 'Log a Visit',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WriteReviewScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.white),
                    const SizedBox(width: 8),
                    TextWidget(
                      text: 'Review',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
