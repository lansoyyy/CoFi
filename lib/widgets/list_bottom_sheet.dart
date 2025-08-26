import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/text_widget.dart';

class ListBottomSheet extends StatelessWidget {
  final String title;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? itemsStream;
  final Stream<List<String>>? shopIdsStream;
  final Stream<QuerySnapshot<Map<String, dynamic>>>? shopsStream;
  final List<Map<String, dynamic>>? shopsList;

  const ListBottomSheet(
      {Key? key,
      required this.title,
      this.itemsStream,
      this.shopIdsStream,
      this.shopsStream,
      this.shopsList})
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
                // If no data source is provided, avoid indefinite loading
                final noData = shopsList == null &&
                    shopsStream == null &&
                    itemsStream == null &&
                    shopIdsStream == null;
                if (noData) {
                  return const Center(
                    child: Text(
                      'Nothing to show (no data source provided).',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                // Static list path (preferred when provided)
                if (shopsList != null) {
                  final shops = shopsList!;
                  if (shops.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(
                          child: Center(
                            child: Text(
                              'No cafes yet',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: shops.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Colors.white24),
                          itemBuilder: (context, index) {
                            final data = shops[index];
                            final shopName =
                                (data['name'] as String?) ?? 'Cafe';
                            return _buildCafeItem(
                                name: shopName, logo: data['logoUrl']);
                          },
                        ),
                      ),
                    ],
                  );
                }
                // Priority: direct shops stream -> list items -> shopIds
                if (shopsStream != null) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: shopsStream,
                    builder: (context, snapshot) {
                      final debugLine =
                          'src=shops, state=${snapshot.connectionState}, hasData=${snapshot.hasData}, count=${snapshot.data?.docs.length}';
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Error loading cafes',
                                    style: TextStyle(color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      final shops = snapshot.data?.docs;

                      if (shops == null || shops.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'No cafes yet',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(debugLine,
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 12)),
                          ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: shops.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(color: Colors.white24),
                              itemBuilder: (context, index) {
                                final shop = shops[index];
                                final data = shop.data();
                                final shopName =
                                    (data['name'] as String?) ?? 'Cafe';
                                return _buildCafeItem(
                                    name: shopName, logo: data['logoUrl']);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                if (itemsStream != null) {
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: itemsStream,
                    builder: (context, snapshot) {
                      final debugLine =
                          'src=items, state=${snapshot.connectionState}, hasData=${snapshot.hasData}, count=${snapshot.data?.docs.length}';
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (kDebugMode)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(debugLine,
                                    style: const TextStyle(
                                        color: Colors.white38, fontSize: 12)),
                              ),
                            const Expanded(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'Error loading list',
                                    style: TextStyle(color: Colors.white70),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      final items = snapshot.data?.docs;
                      if (items == null || items.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'No cafes yet',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (kDebugMode)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(debugLine,
                                  style: const TextStyle(
                                      color: Colors.white38, fontSize: 12)),
                            ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(color: Colors.white24),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final data = item.data();
                                final shopId =
                                    (data['shopId'] as String?) ?? item.id;
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
                                    if (shopSnap.hasError) {
                                      return _buildCafeItem(
                                          name: 'Cafe', logo: '');
                                    }

                                    if (!shopSnap.hasData ||
                                        !shopSnap.data!.exists) {
                                      return _buildCafeItem(
                                          name: 'Cafe', logo: '');
                                    }

                                    final shopData = shopSnap.data!.data();
                                    final shopName =
                                        (shopData?['name'] as String?) ??
                                            'Cafe';
                                    final logoUrl =
                                        (shopData?['logoUrl'] as String?) ?? '';
                                    return _buildCafeItem(
                                        name: shopName, logo: logoUrl);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                // shopIdsStream rendering path
                return StreamBuilder<List<String>>(
                  stream: shopIdsStream!,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Error loading cafes',
                                  style: TextStyle(color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    final ids = snapshot.data;
                    if (ids == null || ids.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                'No cafes yet',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: ids.length,
                            separatorBuilder: (_, __) =>
                                const Divider(color: Colors.white24),
                            itemBuilder: (context, index) {
                              final shopId = ids[index];
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
                                  if (shopSnap.hasError) {
                                    return _buildCafeItem(
                                        name: 'Cafe', logo: '');
                                  }

                                  if (!shopSnap.hasData ||
                                      !shopSnap.data!.exists) {
                                    return SizedBox();
                                  }

                                  final shopData = shopSnap.data!.data();
                                  final shopName =
                                      (shopData?['name'] as String?) ?? 'Cafe';
                                  final logoUrl =
                                      (shopData?['logoUrl'] as String?) ?? '';
                                  return _buildCafeItem(
                                      name: shopName, logo: logoUrl);
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
    required String logo,
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
              image: logo.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(logo),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: logo.isEmpty
                ? const Icon(
                    Icons.local_cafe,
                    color: Colors.white70,
                    size: 24,
                  )
                : null,
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
      List<Map<String, dynamic>>? shopsList,
      Stream<QuerySnapshot<Map<String, dynamic>>>? itemsStream,
      Stream<List<String>>? shopIdsStream,
      Stream<QuerySnapshot<Map<String, dynamic>>>? shopsStream}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ListBottomSheet(
          title: title,
          shopsList: shopsList,
          itemsStream: itemsStream,
          shopIdsStream: shopIdsStream,
          shopsStream: shopsStream),
    );
  }
}
