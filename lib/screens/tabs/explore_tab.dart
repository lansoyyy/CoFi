import 'package:cofi/screens/subscreens/cafe_details_screen.dart';
import 'package:cofi/screens/subscreens/event_details_screen.dart';
import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/text_widget.dart';

class ExploreTab extends StatefulWidget {
  final VoidCallback? onOpenCommunity;
  const ExploreTab({super.key, this.onOpenCommunity});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _selectedChip = -1; // Changed to -1 to indicate no selection by default
  bool _isOpenNow = false;
  bool _isOpenToday = false;
  bool _isFavorites = false;
  bool _isVisited = false;

  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  User? _user;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _userStream;
  Set<String> _bookmarks = {};
  Set<String> _visited = {};
  List<String> _userInterests = []; // New field to store user interests

  // Tag filters
  Set<String> _selectedTags = {};
  final List<String> _availableTags = [
    'Specialty Coffee',
    'Matcha Drinks',
    'Pastries',
    'Work-Friendly (Wi-Fi + outlets)',
    'Pet-Friendly',
    'Parking Available',
    'Family Friendly',
    'Study Sessions',
    'Night Café (Open Late)',
    'Minimalist / Modern',
    'Rustic / Cozy',
    'Outdoor / Garden',
    'Seaside / Scenic',
    'Artsy / Aesthetic',
    'Instagrammable',
  ];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .snapshots();
    }
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.trim();
      if (q != _query) setState(() => _query = q);
    });

    // Fetch user interests
    _fetchUserInterests();
  }

  // New method to fetch user interests
  Future<void> _fetchUserInterests() async {
    if (_user == null) return;

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        final interests = (data?['interests'] as List?)?.cast<String>() ?? [];
        setState(() {
          _userInterests = interests;
        });
      }
    } catch (e) {
      // Handle error silently or log it
      print('Error fetching user interests: $e');
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

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
      'Popular',
      'Newest',
      'Open now',
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
        const SizedBox(height: 12),
        // Tag filters
        _buildTagFilters(),
        const SizedBox(height: 18),
        _sectionTitle('Featured Cafe Shops'),
        const SizedBox(height: 10),
        if (_userStream != null)
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _userStream,
            builder: (context, userSnap) {
              if (userSnap.hasData) {
                final data = userSnap.data!.data();
                final bm = (data?['bookmarks'] as List?)?.cast<String>() ?? [];
                final vd = (data?['visited'] as List?)?.cast<String>() ?? [];
                _bookmarks = bm.toSet();
                _visited = vd.toSet();
              }
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _getFeaturedShopsStream(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  final docs = snap.data!.docs;
                  // Apply chip/bottom-sheet filters to featured as well
                  final filtered = _applyFilters(docs);
                  if (filtered.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('No featured shops',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }
                  return SizedBox(
                    height: 275,
                    width: 500,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, idx) {
                        final d = filtered[idx];
                        return SizedBox(
                          width: 300,
                          child: _buildFeaturedCard(
                            id: d.id,
                            name: (d.data()['name'] ?? '') as String,
                            city: (d.data()['address'] ?? '') as String,
                            hours: _hoursFromSchedule((d.data()['schedule'] ??
                                {}) as Map<String, dynamic>),
                            ratingText: _ratingStreamText(
                              d.id,
                              d.data()['ratings'],
                              ((d.data()['reviews'] as List?)?.length ?? 0),
                            ),
                            isBookmarked: _bookmarks.contains(d.id),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CafeDetailsScreen(
                                    shopId: d.id,
                                    shop: d.data(),
                                  ),
                                ),
                              );
                            },
                            onBookmark: () => _toggleBookmark(
                              d.id,
                              _bookmarks.contains(d.id),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          )
        else
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Sign in to see featured',
                style: TextStyle(color: Colors.white70)),
          ),
        const SizedBox(height: 18),
        _sectionTitle('Upcoming Events'),
        const SizedBox(height: 10),
        _buildEventsSection(),
        const SizedBox(height: 18),
        GestureDetector(
            onTap: () => widget.onOpenCommunity?.call(),
            child: _buildCheckCommunityButton()),
        const SizedBox(height: 18),
        _sectionTitle('Shops'),
        const SizedBox(height: 10),
        // Bookmarks + Shops stream
        if (_userStream != null)
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _userStream,
            builder: (context, userSnap) {
              if (userSnap.hasData) {
                final data = userSnap.data!.data();
                final list =
                    (data?['bookmarks'] as List?)?.cast<String>() ?? [];
                final vlist = (data?['visited'] as List?)?.cast<String>() ?? [];
                _bookmarks = list.toSet();
                _visited = vlist.toSet();
              }
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _getShopsStream(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ));
                  }
                  if (snap.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Failed to load shops',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }
                  final docs = snap.data?.docs ?? [];
                  // Apply filters and sorting based on chips and bottom-sheet
                  final filtered = _applyFilters(docs);
                  if (filtered.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No shops yet',
                          style: TextStyle(color: Colors.white70)),
                    );
                  }
                  return Column(
                    children: [
                      for (final d in filtered) ...[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CafeDetailsScreen(
                                  shopId: d.id,
                                  shop: d.data(),
                                ),
                              ),
                            );
                          },
                          child: _buildShopCard(
                            logo: (d.data()['logoUrl'] ?? '') as String,
                            id: d.id,
                            name: (d.data()['name'] ?? '') as String,
                            city: (d.data()['address'] ?? '') as String,
                            hours: _hoursFromSchedule((d.data()['schedule'] ??
                                {}) as Map<String, dynamic>),
                            ratingText: _ratingStreamText(
                              d.id,
                              d.data()['ratings'],
                              ((d.data()['reviews'] as List?)?.length ?? 0),
                            ),
                            isBookmarked: _bookmarks.contains(d.id),
                            icon: FontAwesomeIcons.coffee,
                            onBookmark: () => _toggleBookmark(
                              d.id,
                              _bookmarks.contains(d.id),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 24),
                    ],
                  );
                },
              );
            },
          )
        else
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Sign in to see shops',
                style: TextStyle(color: Colors.white70)),
          ),
      ],
    );
  }

  // New method to get the appropriate stream for featured shops
  Stream<QuerySnapshot<Map<String, dynamic>>> _getFeaturedShopsStream() {
    // If we have user interests, show recommended shops
    if (_userInterests.isNotEmpty && _selectedChip == -1) {
      // Query shops that match user interests and are verified
      return FirebaseFirestore.instance
          .collection('shops')
          .where('isVerified', isEqualTo: true)
          .where('tags', arrayContainsAny: _userInterests)
          .orderBy('ratings', descending: true)
          .limit(10)
          .snapshots();
    } else {
      // Default behavior based on selected chip
      switch (_selectedChip) {
        case 2: // Open now
          return FirebaseFirestore.instance
              .collection('shops')
              .where('isVerified', isEqualTo: true)
              .orderBy('ratings', descending: true)
              .limit(10)
              .snapshots();
        case 1: // Newest
          return FirebaseFirestore.instance
              .collection('shops')
              .where('isVerified', isEqualTo: true)
              .orderBy('postedAt', descending: true)
              .limit(10)
              .snapshots();
        case 0: // Popular (default)
        default:
          return FirebaseFirestore.instance
              .collection('shops')
              .where('isVerified', isEqualTo: true)
              .orderBy('ratings', descending: true)
              .limit(10)
              .snapshots();
      }
    }
  }

  // New method to get the appropriate stream for regular shops
  Stream<QuerySnapshot<Map<String, dynamic>>> _getShopsStream() {
    // If we have user interests and no filter is selected, show recommended shops
    if (_userInterests.isNotEmpty && _selectedChip == -1) {
      // Query shops that match user interests and are verified
      return FirebaseFirestore.instance
          .collection('shops')
          .where('isVerified', isEqualTo: true)
          .where('tags', arrayContainsAny: _userInterests)
          .orderBy('postedAt', descending: true)
          .snapshots();
    } else {
      // Default behavior based on selected chip
      switch (_selectedChip) {
        case 1: // Newest
          return FirebaseFirestore.instance
              .collection('shops')
              .where('isVerified', isEqualTo: true)
              .orderBy('postedAt', descending: true)
              .snapshots();
        case 2: // Open now
          return FirebaseFirestore.instance
              .collection('shops')
              .where('isVerified', isEqualTo: true)
              .orderBy('postedAt', descending: true)
              .snapshots();
        case 0: // Popular (default)
        default:
          return FirebaseFirestore.instance
              .collection('shops')
              .where('isVerified', isEqualTo: true)
              .orderBy('ratings', descending: true)
              .snapshots();
      }
    }
  }

  // Modified filter method to handle recommendations
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _applyFilters(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> out = docs;

    // Bottom sheet filters
    if (_isFavorites) {
      out = out.where((d) => _bookmarks.contains(d.id));
    }
    if (_isVisited) {
      out = out.where((d) => _visited.contains(d.id));
    }
    if (_isOpenToday) {
      out = out.where((d) => _isOpenTodayFromSchedule(
          (d.data()['schedule'] ?? {}) as Map<String, dynamic>));
    }
    if (_isOpenNow) {
      out = out.where((d) => _isOpenNowFromSchedule(
          (d.data()['schedule'] ?? {}) as Map<String, dynamic>));
    }

    // Tag filters
    if (_selectedTags.isNotEmpty) {
      out = out.where((d) {
        final tags = (d.data()['tags'] as List?)?.cast<String>() ?? [];
        return _selectedTags.any((selectedTag) => tags.contains(selectedTag));
      });
    }

    final list = out.toList();

    // Search filter on name and address
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list.retainWhere((d) {
        final name = ((d.data()['name'] ?? '') as String).toLowerCase();
        final addr = ((d.data()['address'] ?? '') as String).toLowerCase();
        return name.contains(q) || addr.contains(q);
      });
    }

    // Chip filters: 0 Popular, 1 Newest, 2 Open now
    // Only apply filtering when a chip is selected (not -1)
    if (_selectedChip != -1) {
      switch (_selectedChip) {
        case 2: // Open now
          list.retainWhere((d) => _isOpenNowFromSchedule(
              (d.data()['schedule'] ?? {}) as Map<String, dynamic>));
          break;
        case 1: // Newest
          list.sort((a, b) {
            final ta = a.data()['postedAt'];
            final tb = b.data()['postedAt'];
            return (tb is Timestamp
                    ? tb.toDate()
                    : DateTime.fromMillisecondsSinceEpoch(0))
                .compareTo((ta is Timestamp
                    ? ta.toDate()
                    : DateTime.fromMillisecondsSinceEpoch(0)));
          });
          break;
        case 0: // Popular by ratings then reviews count
          list.sort((a, b) {
            num ra =
                (a.data()['ratings'] is num) ? a.data()['ratings'] as num : 0;
            num rb =
                (b.data()['ratings'] is num) ? b.data()['ratings'] as num : 0;
            if (rb != ra) return rb.compareTo(ra);
            int ca = ((a.data()['reviews'] as List?)?.length ?? 0);
            int cb = ((b.data()['reviews'] as List?)?.length ?? 0);
            return cb.compareTo(ca);
          });
          break;
        default:
          break;
      }
    } else if (_userInterests.isNotEmpty) {
      // When no filter is selected but we have user interests, we're showing recommendations
      // Sort by ratings as default for recommendations
      list.sort((a, b) {
        num ra = (a.data()['ratings'] is num) ? a.data()['ratings'] as num : 0;
        num rb = (b.data()['ratings'] is num) ? b.data()['ratings'] as num : 0;
        if (rb != ra) return rb.compareTo(ra);
        int ca = ((a.data()['reviews'] as List?)?.length ?? 0);
        int cb = ((b.data()['reviews'] as List?)?.length ?? 0);
        return cb.compareTo(ca);
      });
    }

    return list;
  }

  Widget _buildFeaturedCard({
    required String id,
    required String name,
    required String city,
    required String hours,
    required Widget ratingText,
    required bool isBookmarked,
    required VoidCallback onTap,
    required VoidCallback onBookmark,
  }) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('shops').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18), bottom: Radius.circular(18)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                          ratingText,
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
                ],
              ),
            ],
          );
        }

        if (snapshot.hasError) {
          return _buildFeaturedCardWithImage(
            id: id,
            name: name,
            city: city,
            hours: hours,
            ratingText: ratingText,
            isBookmarked: isBookmarked,
            onTap: onTap,
            onBookmark: onBookmark,
            imageUrl: null,
          );
        }

        final data = snapshot.data?.data();
        final logoUrl = data?['logoUrl'] as String?;
        final gallery = (data?['gallery'] as List?)?.cast<String>() ?? [];
        final firstGalleryImage = gallery.isNotEmpty ? gallery[0] : null;

        // Use logo if available, otherwise use first gallery image
        final imageUrl = logoUrl ?? firstGalleryImage;

        return _buildFeaturedCardWithImage(
          id: id,
          name: name,
          city: city,
          hours: hours,
          ratingText: ratingText,
          isBookmarked: isBookmarked,
          onTap: onTap,
          onBookmark: onBookmark,
          imageUrl: imageUrl,
        );
      },
    );
  }

  Widget _buildFeaturedCardWithImage({
    required String id,
    required String name,
    required String city,
    required String hours,
    required Widget ratingText,
    required bool isBookmarked,
    required VoidCallback onTap,
    required VoidCallback onBookmark,
    String? imageUrl,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18), bottom: Radius.circular(18)),
            ),
            child: Stack(
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18), bottom: Radius.circular(18)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child:
                            Icon(Icons.image, color: Colors.white38, size: 50),
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Icon(Icons.image, color: Colors.white38, size: 50),
                  ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: onBookmark,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
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
                    ratingText,
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
          ],
        ),
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
              controller: _searchCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Find Cafes',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => setState(() {}),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white54),
            onPressed: () {
              // showModalBottomSheet(
              //   context: context,
              //   isScrollControlled: true,
              //   backgroundColor: Colors.black,
              //   shape: const RoundedRectangleBorder(
              //     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              //   ),
              //   builder: (context) => _buildFilterBottomSheet(context),
              // );
            },
          ),
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white54),
              onPressed: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
    );
  }

  String _ratingText(dynamic ratings, dynamic ratingCount) {
    final num r = (ratings is num) ? ratings : 0;
    final num c = (ratingCount is num) ? ratingCount : 0;
    final display = (c > 0) ? (r.toDouble()).toStringAsFixed(1) : '0.0';
    return '$display (${c.toInt()})';
  }

  String _hoursFromSchedule(Map<String, dynamic> schedule) {
    final key = _weekdayKey(DateTime.now().weekday);
    final day = (schedule[key] ?? {}) as Map<String, dynamic>;
    final isOpen = (day['isOpen'] ?? false) == true;
    final open = (day['open'] ?? '') as String;
    final close = (day['close'] ?? '') as String;
    if (isOpen && open.isNotEmpty && close.isNotEmpty) {
      return '${_to12h(open)} - ${_to12h(close)}';
    }
    return 'Closed today';
  }

  // Live rating/count from reviews subcollection with fallback
  Widget _ratingStreamText(
      String shopId, dynamic embeddedRatings, int embeddedCount) {
    final query = FirebaseFirestore.instance
        .collection('shops')
        .doc(shopId)
        .collection('reviews');
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return TextWidget(
            text: _ratingText(embeddedRatings, embeddedCount),
            fontSize: 13,
            color: Colors.white,
          );
        }
        final docs = snapshot.data!.docs;
        final ratings = docs
            .map((d) => d.data()['rating'])
            .whereType<num>()
            .map((n) => n.toDouble())
            .toList();
        final count = ratings.length;
        final avg = count == 0 ? 0.0 : ratings.reduce((a, b) => a + b) / count;
        final text = '${avg.toStringAsFixed(1)} ($count)';
        return TextWidget(text: text, fontSize: 13, color: Colors.white);
      },
    );
  }

  bool _isOpenTodayFromSchedule(Map<String, dynamic> schedule) {
    final key = _weekdayKey(DateTime.now().weekday);
    final day = (schedule[key] ?? {}) as Map<String, dynamic>;
    return (day['isOpen'] ?? false) == true;
  }

  bool _isOpenNowFromSchedule(Map<String, dynamic> schedule) {
    final key = _weekdayKey(DateTime.now().weekday);
    final day = (schedule[key] ?? {}) as Map<String, dynamic>;
    if ((day['isOpen'] ?? false) != true) return false;
    final open = (day['open'] ?? '') as String;
    final close = (day['close'] ?? '') as String;
    if (open.isEmpty || close.isEmpty) return false;
    int om = _toMinutes(open);
    int cm = _toMinutes(close);
    final now = DateTime.now();
    int nm = now.hour * 60 + now.minute;
    // Handle overnight ranges (e.g., 22:00 - 02:00)
    if (cm <= om) {
      // closes next day
      return nm >= om || nm < cm;
    }
    return nm >= om && nm < cm;
  }

  int _toMinutes(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return 0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return h * 60 + m;
  }

  String _to12h(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return hhmm;
    int h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    final suffix = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    if (h == 0) h = 12;
    final mm = m.toString().padLeft(2, '0');
    return '$h:$mm $suffix';
  }

  String _weekdayKey(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
      default:
        return 'sunday';
    }
  }

  Future<void> _toggleBookmark(String shopId, bool isBookmarked) async {
    if (_user == null) return;
    final ref = FirebaseFirestore.instance.collection('users').doc(_user!.uid);
    try {
      await ref.update({
        'bookmarks': isBookmarked
            ? FieldValue.arrayRemove([shopId])
            : FieldValue.arrayUnion([shopId])
      });
    } catch (e) {
      await ref.set({
        'bookmarks': [shopId],
      }, SetOptions(merge: true));
    }
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

  Widget _buildShopCard({
    required String id,
    required String name,
    required String city,
    required String hours,
    required Widget ratingText,
    required bool isBookmarked,
    required IconData icon,
    required String logo,
    required VoidCallback onBookmark,
  }) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream:
          FirebaseFirestore.instance.collection('shops').doc(id).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18), bottom: Radius.circular(18)),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                const SizedBox(height: 10),
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
                            ratingText,
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
                      backgroundImage: NetworkImage(logo),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildShopCardWithImage(
            logo: logo,
            id: id,
            name: name,
            city: city,
            hours: hours,
            ratingText: ratingText,
            isBookmarked: isBookmarked,
            icon: icon,
            onBookmark: onBookmark,
            imageUrl: null,
          );
        }

        final data = snapshot.data?.data();
        final logoUrl = data?['logoUrl'] as String?;
        final gallery = (data?['gallery'] as List?)?.cast<String>() ?? [];
        final firstGalleryImage = gallery.isNotEmpty ? gallery[0] : null;

        // Use logo if available, otherwise use first gallery image
        final imageUrl = logoUrl ?? firstGalleryImage;

        return _buildShopCardWithImage(
          logo: logo,
          id: id,
          name: name,
          city: city,
          hours: hours,
          ratingText: ratingText,
          isBookmarked: isBookmarked,
          icon: icon,
          onBookmark: onBookmark,
          imageUrl: imageUrl,
        );
      },
    );
  }

  Widget _buildShopCardWithImage({
    required String id,
    required String name,
    required String city,
    required String hours,
    required Widget ratingText,
    required bool isBookmarked,
    required IconData icon,
    required VoidCallback onBookmark,
    required String logo,
    String? imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Image container
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18), bottom: Radius.circular(18)),
            ),
            child: Stack(
              children: [
                if (imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18), bottom: Radius.circular(18)),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child:
                            Icon(Icons.image, color: Colors.white38, size: 50),
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Icon(Icons.image, color: Colors.white38, size: 50),
                  ),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: onBookmark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
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
                      ratingText,
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
                backgroundImage: NetworkImage(logo),
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

  Widget _buildEventsSection() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collectionGroup('events')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Failed to load events',
                style: TextStyle(color: Colors.white70)),
          );
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Text('No events available',
                style: TextStyle(color: Colors.white70)),
          );
        }
        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, idx) {
              final event = docs[idx].data();
              final eventId = docs[idx].id;
              return SizedBox(
                width: 300,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(event: {
                          ...event,
                          'id': eventId,
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
                                fontSize: 18,
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
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _eventSubtitle(Map<String, dynamic> event) {
    final date = event['date'];
    final start = event['startDate'];
    if (date is String && date.isNotEmpty) return date;
    if (start is String && start.isNotEmpty) return start;
    return 'Today';
  }

  Widget _buildTagFilters() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _availableTags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final tag = _availableTags[i];
          final isSelected = _selectedTags.contains(tag);
          return FilterChip(
            label: TextWidget(
              text: tag,
              fontSize: 12,
              color: Colors.white,
              isBold: false,
            ),
            backgroundColor: isSelected ? primary : const Color(0xFF222222),
            selected: isSelected,
            selectedColor: primary,
            checkmarkColor: white,
            onSelected: (_) {
              setState(() {
                if (isSelected) {
                  _selectedTags.remove(tag);
                } else {
                  _selectedTags.add(tag);
                }
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: BorderSide.none,
          );
        },
      ),
    );
  }
}
