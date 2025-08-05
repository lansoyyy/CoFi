import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class VisitedCafesScreen extends StatelessWidget {
  const VisitedCafesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextWidget(
          text: 'Visited Cafes',
          fontSize: 20,
          color: Colors.white,
          isBold: true,
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: TextWidget(
                text: '2025',
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 24),
              _buildCafeCard(
                cafeName: 'Daily dose',
                cafeImage: 'assets/images/daily_dose.jpg',
                backgroundColor: Colors.grey[700]!,
              ),
              const SizedBox(height: 16),
              _buildCafeCard(
                cafeName: 'Hidn Cafe',
                cafeImage: 'assets/images/hidn_cafe.jpg',
                backgroundColor: Colors.teal[600]!,
              ),
              const SizedBox(height: 16),
              _buildCafeCard(
                cafeName: 'Outlook Cafe',
                cafeImage: 'assets/images/outlook_cafe.jpg',
                backgroundColor: Colors.grey[600]!,
              ),
              const SizedBox(height: 16),
              _buildCafeCard(
                cafeName: 'Fiend Coffee Club',
                cafeImage: 'assets/images/fiend_coffee.jpg',
                backgroundColor: Colors.brown[600]!,
              ),
              const SizedBox(height: 16),
              _buildCafeCard(
                cafeName: 'Sample Cafe',
                cafeImage: 'assets/images/sample_cafe.jpg',
                backgroundColor: primary,
                hasRedIcon: true,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCafeCard({
    required String cafeName,
    required String cafeImage,
    required Color backgroundColor,
    bool hasRedIcon = false,
  }) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Cafe image/icon section
          Container(
            width: 72,
            height: 72,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: hasRedIcon
                ? Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_cafe,
                        color: Colors.red,
                        size: 16,
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.image,
                      color: Colors.white54,
                      size: 24,
                    ),
                  ),
          ),
          // Cafe name section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: TextWidget(
                text: cafeName,
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
