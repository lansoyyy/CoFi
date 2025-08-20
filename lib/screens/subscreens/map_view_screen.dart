import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/coffee_shop_details_bottom_sheet.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    Widget buildShopsMap(Set<String> bookmarks, User? user) {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('shops').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          final markers = <Marker>[];

          Future<void> toggleBookmark(String shopId, bool isBookmarked) async {
            if (user == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign in to bookmark shops')),
              );
              return;
            }
            final ref =
                FirebaseFirestore.instance.collection('users').doc(user.uid);
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

          for (final doc in docs) {
            final data = doc.data();
            final lat = (data['latitude'] as num?)?.toDouble();
            final lng = (data['longitude'] as num?)?.toDouble();
            if (lat == null || lng == null) continue;

            final name = (data['name'] as String?) ?? 'Unknown';
            final address = (data['address'] as String?) ?? '';
            // Embedded fallback values (may be stale). Live values are streamed below.
            final embeddedAvg = ((data['ratings'] as num?)?.toDouble() ?? 0.0);
            final embeddedCount = ((data['reviews'] as List?)?.length ?? 0);
            final ratingText =
                '${embeddedAvg.toStringAsFixed(1)} ($embeddedCount)';
            final hours = _formatTodayHours(
                (data['schedule'] as Map<String, dynamic>?) ?? {});
            final isBM = bookmarks.contains(doc.id);

            markers.add(
              Marker(
                width: 75,
                height: 55,
                point: LatLng(lat, lng),
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    CoffeeShopDetailsBottomSheet.show(
                      context,
                      shopId: doc.id,
                      name: name,
                      location: address,
                      hours: hours,
                      rating: ratingText,
                      isBookmarked: isBM,
                      onToggleBookmark: () => toggleBookmark(doc.id, isBM),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
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
                            const SizedBox(width: 6),
                            _ratingShortStream(
                              doc.id,
                              embeddedAvg,
                              embeddedCount,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 2,
                        height: 8,
                        color: primary,
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final center = markers.isNotEmpty
              ? markers.first.point
              : const LatLng(7.1907, 125.4553);
          return FlutterMap(
            options: MapOptions(
              initialCenter: center, // Davao City default when no markers
              initialZoom: markers.isNotEmpty ? 14 : 12,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'cofi',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: user != null
          ? StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, userSnap) {
                Set<String> bookmarks = {};
                if (userSnap.hasData) {
                  final u = userSnap.data!.data();
                  bookmarks = ((u?['bookmarks'] as List?)?.cast<String>() ?? [])
                      .toSet();
                }
                return buildShopsMap(bookmarks, user);
              },
            )
          : buildShopsMap(<String>{}, null),
    );
  }

  String _formatTodayHours(Map<String, dynamic> schedule) {
    try {
      final dayKeys = [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday',
      ];
      final now = DateTime.now();
      final idx = (now.weekday - 1).clamp(0, 6);
      final key = dayKeys[idx];
      final m = (schedule[key] as Map?)?.cast<String, dynamic>() ?? {};
      final isOpen = (m['isOpen'] as bool?) ?? false;
      if (!isOpen) return 'Closed today';
      final open = (m['open'] as String?) ?? '';
      final close = (m['close'] as String?) ?? '';
      if (open.isEmpty || close.isEmpty) return 'Mixed Hours · Tap to view';
      String fmt(String hhmm) {
        final parts = hhmm.split(':');
        if (parts.length != 2) return hhmm;
        int h = int.tryParse(parts[0]) ?? 0;
        final m = int.tryParse(parts[1]) ?? 0;
        final ampm = h >= 12 ? 'PM' : 'AM';
        h = h % 12;
        if (h == 0) h = 12;
        return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
      }

      return '${fmt(open)} - ${fmt(close)}';
    } catch (_) {
      return 'Mixed Hours · Tap to view';
    }
  }
}

// Live short rating (e.g., "4.5") from reviews subcollection with embedded fallback
Widget _ratingShortStream(
    String shopId, double embeddedAvg, int embeddedCount) {
  final query = FirebaseFirestore.instance
      .collection('shops')
      .doc(shopId)
      .collection('reviews');
  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: query.snapshots(),
    builder: (context, snapshot) {
      double avg = embeddedAvg;
      int count = embeddedCount;
      if (snapshot.hasData) {
        final docs = snapshot.data!.docs;
        final ratings = docs
            .map((d) => d.data()['rating'])
            .whereType<num>()
            .map((n) => n.toDouble())
            .toList();
        count = ratings.length;
        avg = count == 0 ? 0.0 : ratings.reduce((a, b) => a + b) / count;
      }
      return TextWidget(
        text: avg.toStringAsFixed(1),
        fontSize: 12,
        color: Colors.white,
        isBold: true,
      );
    },
  );
}
