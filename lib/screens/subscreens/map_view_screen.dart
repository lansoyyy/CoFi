import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/coffee_shop_details_bottom_sheet.dart';

class MapViewScreen extends StatelessWidget {
  const MapViewScreen({super.key});

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
      ),
      body: Stack(
        children: [
          // Map placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[800],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  TextWidget(
                    text: 'Map View',
                    fontSize: 24,
                    color: Colors.grey[400]!,
                    isBold: true,
                  ),
                  const SizedBox(height: 8),
                  TextWidget(
                    text: 'Coffee shops will be displayed here',
                    fontSize: 16,
                    color: Colors.grey[500]!,
                  ),
                ],
              ),
            ),
          ),

          // Coffee shop markers placeholder
          Positioned(
            top: 120,
            left: 50,
            child: _buildMapMarker(
              context: context,
              name: 'Fiend Coffee Club',
              rating: '5.0',
              location: 'Davao City',
              hours: '11:00 AM - 02:00 AM',
            ),
          ),

          Positioned(
            top: 200,
            right: 80,
            child: _buildMapMarker(
              context: context,
              name: 'Daily Dose',
              rating: '5.0',
              location: 'Davao City',
              hours: '09:00 AM - 12:00 AM',
            ),
          ),

          Positioned(
            bottom: 180,
            left: 100,
            child: _buildMapMarker(
              context: context,
              name: 'Joe\'s Café',
              rating: '4.8',
              location: 'Davao City',
              hours: '10:00 AM - 03:00 AM',
            ),
          ),

          Positioned(
            bottom: 250,
            right: 60,
            child: _buildMapMarker(
              context: context,
              name: 'Hid\'n Cafe',
              rating: '4.5',
              location: 'Davao City',
              hours: 'Mixed Hours · Tap to view',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker({
    required BuildContext context,
    required String name,
    required String rating,
    required String location,
    required String hours,
  }) {
    return GestureDetector(
      onTap: () {
        CoffeeShopDetailsBottomSheet.show(
          context,
          name: name,
          location: location,
          hours: hours,
          rating: rating,
        );
      },
      child: Column(
        children: [
          // Coffee marker
          Container(
            padding: const EdgeInsets.all(8),
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
                TextWidget(
                  text: rating,
                  fontSize: 12,
                  color: Colors.white,
                  isBold: true,
                ),
              ],
            ),
          ),

          // Marker pointer
          Container(
            width: 2,
            height: 8,
            color: primary,
          ),

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
    );
  }
}
