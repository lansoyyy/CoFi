import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/text_widget.dart';

class ListBottomSheet extends StatelessWidget {
  final String title;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? itemsStream;
  final Stream<List<String>>? shopIdsStream;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? shopsStream;

  const ListBottomSheet(
      {Key? key,
      required this.title,
      this.itemsStream,
      this.shopIdsStream,
      this.shopsStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 18,
                  color: Colors.white,
                  isBold: true,
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // List items
          Expanded(
            child: Builder(
              builder: (context) {
                // If no streams are provided, avoid indefinite loading
                final noStreams = shopsStream == null &&
                    itemsStream == null &&
                    shopIdsStream == null;
                if (noStreams) {
                  return const Center(
                    child: Text(
                      'Nothing to show (no data source provided).',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                // Priority: direct shops stream -> list items -> shopIds
                if (shopsStream != null) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: shopsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Error loading cafes: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      final shops = snapshot.data?.docs;
                      if (shops == null) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white));
                      }
                      if (shops.isEmpty) {
                        return const Center(
                          child: Text(
                            'No cafes yet',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: shops.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white24),
                        itemBuilder: (context, index) {
                          final shop = shops[index];
                          final data = shop.data();
                          final shopName = (data['name'] as String?) ?? 'Cafe';
                          return _buildCafeItem(name: shopName);
                        },
                      );
                    },
                  );
                }
                if (itemsStream != null) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: itemsStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Error loading list: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      final items = snapshot.data?.docs;
                      if (items == null) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white));
                      }
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            'No cafes yet',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white24),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final data = item.data();
                          final shopId = (data['shopId'] as String?) ?? item.id;
                          if (shopId.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final shopRef = FirebaseFirestore.instance
                              .collection('shops')
                              .doc(shopId);
                          return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: shopRef.snapshots(),
                            builder: (context, shopSnap) {
                              final shopName =
                                  (shopSnap.data?.data()?['name'] as String?) ??
                                      'Cafe';
                              return _buildCafeItem(name: shopName);
                            },
                          );
                        },
                      );
                    },
                  );
                }
                // shopIdsStream rendering path
                return StreamBuilder<List<String>>(
                  stream: shopIdsStream!,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Error loading cafes: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    final ids = snapshot.data;
                    if (ids == null) {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white));
                    }
                    if (ids.isEmpty) {
                      return const Center(
                        child: Text(
                          'No cafes yet',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: ids.length,
                      separatorBuilder: (_, __) =>
                          const Divider(color: Colors.white24),
                      itemBuilder: (context, index) {
                        final shopId = ids[index];
                        if (shopId.isEmpty) return const SizedBox.shrink();
                        final shopRef = FirebaseFirestore.instance
                            .collection('shops')
                            .doc(shopId);
                        return StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: shopRef.snapshots(),
                          builder: (context, shopSnap) {
                            final shopName =
                                (shopSnap.data?.data()?['name'] as String?) ??
                                    'Cafe';
                            return _buildCafeItem(name: shopName);
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCafeItem({
    required String name,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[800],
            ),
            child: const Center(
              child: Icon(Icons.image, color: Colors.white38, size: 24),
            ),
          ),
          const SizedBox(width: 16),
          TextWidget(
            text: name,
            fontSize: 16,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context,
      {required String title,
      Stream<QuerySnapshot<Map<String, dynamic>>>? itemsStream,
      Stream<List<String>>? shopIdsStream,
      Stream<QuerySnapshot<Map<String, dynamic>>>? shopsStream}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ListBottomSheet(
          title: title,
          itemsStream: itemsStream,
          shopIdsStream: shopIdsStream,
          shopsStream: shopsStream),
    );
  }
}
