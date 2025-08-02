import 'package:cofi/screens/subscreens/cafe_details_screen.dart';
import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../widgets/text_widget.dart';

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _selectedChip = 0;
  bool _isOpenNow = false;
  bool _isOpenToday = false;
  bool _isFavorites = false;
  bool _isVisited = false;

  Widget _buildFilterBottomSheet(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextWidget(
                text: 'Filters',
                fontSize: 24,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              onTap: () {
                setState(() {
                  _isOpenNow = !_isOpenNow;
                });
              },
              title: TextWidget(
                text: 'Open now',
                fontSize: 16,
                color: Colors.white,
              ),
              trailing: Checkbox(
                value: _isOpenNow,
                onChanged: (bool? value) {
                  setState(() {
                    _isOpenNow = value ?? false;
                  });
                },
                fillColor: MaterialStateProperty.all(Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _isOpenToday = !_isOpenToday;
                });
              },
              title: TextWidget(
                text: 'Open Today',
                fontSize: 16,
                color: Colors.white,
              ),
              trailing: Checkbox(
                value: _isOpenToday,
                onChanged: (bool? value) {
                  setState(() {
                    _isOpenToday = value ?? false;
                  });
                },
                fillColor: MaterialStateProperty.all(Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _isFavorites = !_isFavorites;
                });
              },
              title: TextWidget(
                text: 'Favorites',
                fontSize: 16,
                color: Colors.white,
              ),
              trailing: Checkbox(
                value: _isFavorites,
                onChanged: (bool? value) {
                  setState(() {
                    _isFavorites = value ?? false;
                  });
                },
                fillColor: MaterialStateProperty.all(Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _isVisited = !_isVisited;
                });
              },
              title: TextWidget(
                text: 'Visited',
                fontSize: 16,
                color: Colors.white,
              ),
              trailing: Checkbox(
                value: _isVisited,
                onChanged: (bool? value) {
                  setState(() {
                    _isVisited = value ?? false;
                  });
                },
                fillColor: MaterialStateProperty.all(Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Apply filters here
                    Navigator.pop(context);
                    // You can add your filter logic here using the state variables:
                    // _isOpenNow, _isOpenToday, _isFavorites, _isVisited
                    setState(() {
                      // Refresh the UI with filtered results
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterChips = [
      'Nearby',
      'Open now',
      'Newest',
      'Popular',
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      children: [
        const SizedBox(height: 16),
        _buildSearchBar(),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filterChips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) => FilterChip(
              label: TextWidget(
                text: filterChips[i],
                fontSize: 14,
                color: Colors.white,
                isBold: true,
              ),
              backgroundColor:
                  _selectedChip == i ? Colors.white12 : const Color(0xFF222222),
              selected: _selectedChip == i,
              selectedColor: primary,
              checkmarkColor: white,
              onSelected: (_) {
                setState(() {
                  _selectedChip = i;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        _sectionTitle('Featured Cafe Shops'),
        const SizedBox(height: 10),
        SizedBox(
          height: 275,
          width: 500,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < 2; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _buildFeaturedCafeCard(),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(onTap: () {}, child: _buildCheckCommunityButton()),
        const SizedBox(height: 18),
        _sectionTitle('Shops'),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CafeDetailsScreen(),
              ),
            );
          },
          child: _buildShopCard(
            name: 'Fiend Coffee Club',
            city: 'Davao City',
            hours: '11:00 AM - 02:00 AM',
            rating: '5.0 (10)',
            isFeatured: true,
            icon: FontAwesomeIcons.mugSaucer,
          ),
        ),
        const SizedBox(height: 10),
        _buildShopCard(
          name: 'Daily Dose',
          city: 'Davao City',
          hours: '09:00 AM - 12:00 AM',
          rating: '5.0 (8)',
          isFeatured: false,
          icon: FontAwesomeIcons.coffee,
        ),
        const SizedBox(height: 10),
        _buildShopCard(
          name: "Joe's Café ...",
          city: 'Davao City',
          hours: '10:00 AM - 03:00 AM',
          rating: '4.8 (15)',
          isFeatured: false,
          icon: FontAwesomeIcons.coffee,
        ),
        const SizedBox(height: 10),
        _buildShopCard(
          name: "Hid'n Cafe",
          city: 'Davao City',
          hours: 'Mixed Hours · Tap to view',
          rating: '4.5 (10)',
          isFeatured: false,
          icon: FontAwesomeIcons.coffee,
        ),
        const SizedBox(height: 10),
        _buildShopCard(
          name: "Outlook Coffee ...",
          city: 'Davao City',
          hours: '07:00 AM - 12:00 AM',
          rating: '4.8 (9)',
          isFeatured: false,
          icon: FontAwesomeIcons.coffee,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white54),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Find Cafes',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white54),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => _buildFilterBottomSheet(context),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextWidget(
        text: title,
        fontSize: 18,
        color: Colors.white,
        isBold: true,
      ),
    );
  }

  Widget _buildFeaturedCafeCard() {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          // Placeholder for image
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18), bottom: Radius.circular(18)),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.image, color: Colors.white38, size: 50),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text: '09:00 AM - 12:00 AM',
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 10),
                      const FaIcon(FontAwesomeIcons.solidStar,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      TextWidget(
                        text: '5.0 (10)',
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  TextWidget(
                    text: 'Daily Dose',
                    fontSize: 17,
                    color: Colors.white,
                    isBold: true,
                  ),
                  TextWidget(
                    text: 'Davao City',
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard({
    required String name,
    required String city,
    required String hours,
    required String rating,
    required bool isFeatured,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Placeholder for image
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18), bottom: Radius.circular(18)),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(Icons.image, color: Colors.white38, size: 50),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isFeatured ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text: hours,
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 10),
                      const FaIcon(FontAwesomeIcons.solidStar,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      TextWidget(
                        text: rating,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  TextWidget(
                    text: name,
                    fontSize: 17,
                    color: Colors.white,
                    isBold: true,
                  ),
                  TextWidget(
                    text: city,
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: FaIcon(icon, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckCommunityButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          const FaIcon(FontAwesomeIcons.mugSaucer,
              color: Colors.white, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Check Community',
                  fontSize: 16,
                  color: Colors.white,
                  isBold: true,
                ),
                TextWidget(
                  text: 'Find Coffee Events / Job Offers',
                  fontSize: 13,
                  color: Colors.white70,
                  isBold: false,
                ),
              ],
            ),
          ),
          const FaIcon(FontAwesomeIcons.angleRight,
              color: Colors.white, size: 20),
        ],
      ),
    );
  }
}
