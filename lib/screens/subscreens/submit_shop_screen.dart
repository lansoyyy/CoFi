import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class SubmitShopScreen extends StatefulWidget {
  const SubmitShopScreen({super.key});

  @override
  State<SubmitShopScreen> createState() => _SubmitShopScreenState();
}

class _SubmitShopScreenState extends State<SubmitShopScreen> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Selected tags state
  Map<String, bool> selectedTags = {
    'Aesthetic': true,
    'Matcha Drinks': false,
    'Cozy & Chill': false,
    'Community Hub': false,
    'Newly Opened': false,
    'Free Wifi': false,
    'Pet Friendly': false,
    'Power Outlets': false,
    'Parking Spaces': false,
    'Study-Friendly': false,
  };

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
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Shop Logo Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Shop Logo',
                    fontSize: 16,
                    color: Colors.white,
                    isBold: true,
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
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
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Shop Name
              TextWidget(
                text: 'Shop Name',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: shopNameController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Sample Cafe Name',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Address
              TextWidget(
                text: 'Address',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: addressController,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Davao City',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Gallery
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Gallery',
                    fontSize: 16,
                    color: Colors.white,
                    isBold: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Gallery Image
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.local_cafe,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // About Me
              TextWidget(
                text: 'About Me',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: aboutController,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText:
                        'Lorem ipsum dolor sit amet consectetur. Lacus lectus ullamcorper lorem tellus sagittis. Tellus morbi pellentesque tortor pellentesque vitae nec dui sit.',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Contacts
              TextWidget(
                text: 'Contacts',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 16),

              // Instagram
              _buildContactField(
                icon: Icons.camera_alt,
                controller: instagramController,
                label: 'Instagram',
              ),
              const SizedBox(height: 12),

              // Facebook
              _buildContactField(
                icon: Icons.facebook,
                controller: facebookController,
                label: 'Facebook',
              ),
              const SizedBox(height: 12),

              // TikTok
              _buildContactField(
                icon: Icons.music_note,
                controller: tiktokController,
                label: 'Tiktok',
              ),
              const SizedBox(height: 32),

              // Select Tags
              TextWidget(
                text: 'Select Tags',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 16),

              // Tags Grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: selectedTags.keys.map((tag) {
                  return _buildTag(tag, selectedTags[tag]!);
                }).toList(),
              ),
              const SizedBox(height: 40),

              // Save Button
              Container(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save and navigate to business screen
                    Navigator.pushNamed(context, '/business');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: TextWidget(
                    text: 'Save',
                    fontSize: 16,
                    color: Colors.white,
                    isBold: true,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              icon,
              color: Colors.white54,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTags[text] = !selectedTags[text]!;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextWidget(
          text: text,
          fontSize: 14,
          color: Colors.white,
          isBold: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    shopNameController.dispose();
    addressController.dispose();
    aboutController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    tiktokController.dispose();
    emailController.dispose();
    websiteController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
