import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class PostEventBottomSheet extends StatefulWidget {
  const PostEventBottomSheet({super.key});

  @override
  State<PostEventBottomSheet> createState() => _PostEventBottomSheetState();
}

class _PostEventBottomSheetState extends State<PostEventBottomSheet> {
  final _eventNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _addressController = TextEditingController();
  final _startDateController = TextEditingController();
  final _aboutController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values
    _eventNameController.text = 'Barista Wanted';
    _dateController.text = 'Input Field';
    _addressController.text = 'Input Field';
    _startDateController.text = 'Input Field';
    _aboutController.text = 'Input Field';
    _emailController.text = 'SampleCafe@gmail.com';
    _linkController.text = 'www.applyforjob.com/SampleCafejob-name';
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _dateController.dispose();
    _addressController.dispose();
    _startDateController.dispose();
    _aboutController.dispose();
    _emailController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextWidget(
                    text: 'Post an Event',
                    fontSize: 18,
                    color: Colors.white,
                    isBold: true,
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Name
                      _buildField('Event Name', _eventNameController),

                      const SizedBox(height: 20),

                      // Date
                      _buildField('Date', _dateController),

                      const SizedBox(height: 20),

                      // Address
                      _buildField('Address', _addressController),

                      const SizedBox(height: 20),

                      // Start Date
                      _buildField('Start Date', _startDateController),

                      const SizedBox(height: 20),

                      // About
                      _buildField('About', _aboutController),

                      const SizedBox(height: 20),

                      // Email
                      _buildField('Email', _emailController),

                      const SizedBox(height: 20),

                      // Link (Optional)
                      _buildField('Link (Optional)', _linkController),

                      const SizedBox(height: 20),

                      // Gallery Section
                      TextWidget(
                        text: 'Gallery',
                        fontSize: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                      const SizedBox(height: 16),

                      // Gallery Grid
                      Row(
                        children: [
                          // First row of gallery items
                          Expanded(
                            child: Row(
                              children: [
                                _buildGalleryItem(hasImage: true),
                                const SizedBox(width: 8),
                                _buildGalleryItem(hasImage: true),
                                const SizedBox(width: 8),
                                _buildGalleryItem(hasImage: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Second row of gallery items
                          _buildGalleryItem(hasImage: true),
                          const SizedBox(width: 8),
                          _buildGalleryItem(hasImage: true),
                          const SizedBox(width: 8),
                          _buildGalleryItem(hasImage: false, isAddButton: true),
                          const Spacer(),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle save functionality
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFE53E3E), // Red color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontSize: 16,
          color: Colors.white,
          isBold: true,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(12),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGalleryItem({required bool hasImage, bool isAddButton = false}) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isAddButton
          ? const Icon(
              Icons.add,
              color: Colors.white,
              size: 32,
            )
          : Center(
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
            ),
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const PostEventBottomSheet(),
    );
  }
}
