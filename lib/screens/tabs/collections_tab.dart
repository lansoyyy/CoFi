import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/list_bottom_sheet.dart';
import '../../widgets/create_list_bottom_sheet.dart';

class CollectionsTab extends StatelessWidget {
  const CollectionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Collections',
                    fontSize: 32,
                    color: Colors.white,
                    isBold: true,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) => const CreateListBottomSheet(),
                        );
                      },
                      icon:
                          const Icon(Icons.add, color: Colors.white, size: 22),
                      label: TextWidget(
                        text: 'Create',
                        fontSize: 18,
                        color: Colors.white,
                        isBold: true,
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white24, thickness: 1),
            // Favorites
            _buildCollectionItem(
              icon: Icons.bookmark_border,
              iconBg: primary,
              title: 'Favorites',
              subtitle: '20 Shops',
            ),
            // Visited Cafes
            _buildCollectionItem(
              context: context,
              icon: Icons.coffee,
              iconBg: primary,
              title: 'Visited Cafes',
              subtitle: '20 Shops',
              customIcon: TextWidget(
                text: 'cofi',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
            ),
            const Divider(color: Colors.white24, thickness: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: TextWidget(
                text: 'Cafe Lists',
                fontSize: 20,
                color: Colors.white,
                isBold: true,
              ),
            ),
            _buildCollectionItem(
              context: context,
              icon: Icons.local_cafe,
              iconBg: primary,
              title: 'Cafes with Wifi',
              subtitle: '3 Shops',
              customIcon:
                  const Icon(Icons.local_cafe, color: Colors.white, size: 28),
            ),
            _buildCollectionItem(
              context: context,
              icon: Icons.local_cafe,
              iconBg: primary,
              title: 'Untitled',
              subtitle: '5 Shops',
              customIcon:
                  const Icon(Icons.local_cafe, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionItem(
      {required IconData icon,
      required Color iconBg,
      required String title,
      required String subtitle,
      Widget? customIcon,
      context}) {
    return GestureDetector(
      onTap: () {
        if (title == 'Cafes with Wifi' || title == 'Untitled') {
          ListBottomSheet.show(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: customIcon ?? Icon(icon, color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(width: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 18,
                  color: Colors.white,
                  isBold: true,
                ),
                const SizedBox(height: 2),
                TextWidget(
                  text: subtitle,
                  fontSize: 15,
                  color: Colors.white54,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
