import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import '../widgets/text_widget.dart';

class PostJobBottomSheet extends StatefulWidget {
  const PostJobBottomSheet({super.key});

  @override
  State<PostJobBottomSheet> createState() => _PostJobBottomSheetState();
}

class _PostJobBottomSheetState extends State<PostJobBottomSheet> {
  final _jobNameController = TextEditingController();
  final _typeController = TextEditingController();
  final _payController = TextEditingController();
  final _requiredController = TextEditingController();
  final _startDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _emailController = TextEditingController();
  final _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default values
    _jobNameController.text = 'Barista Wanted';
    _typeController.text = 'Input Field';
    _payController.text = 'Input Field';
    _requiredController.text = 'Input Field';
    _startDateController.text = 'Input Field';
    _descriptionController.text = 'Add list description';
    _emailController.text = 'SampleCafe@gmail.com';
    _linkController.text = 'www.applyforjob.com/SampleCafejob-name';
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _typeController.dispose();
    _payController.dispose();
    _requiredController.dispose();
    _startDateController.dispose();
    _descriptionController.dispose();
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
                    text: 'Post a job',
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
                      // Job name
                      _buildField('Job name', _jobNameController),

                      const SizedBox(height: 20),

                      // Type
                      _buildField('Type', _typeController),

                      const SizedBox(height: 20),

                      // Pay
                      _buildField('Pay', _payController),

                      const SizedBox(height: 20),

                      // Required
                      _buildField('Required', _requiredController),

                      const SizedBox(height: 20),

                      // Start Date
                      _buildField('Start Date', _startDateController),

                      const SizedBox(height: 20),

                      // Description
                      _buildField('Description', _descriptionController,
                          isDescription: true),

                      const SizedBox(height: 20),

                      // Email
                      _buildField('Email', _emailController),

                      const SizedBox(height: 20),

                      // Link (Optional)
                      _buildField('Link (Optional)', _linkController),

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
                            backgroundColor: primary, // Red color
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

  Widget _buildField(String label, TextEditingController controller,
      {bool isDescription = false}) {
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
            maxLines: isDescription ? 4 : 1,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(isDescription ? 16 : 12),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const PostJobBottomSheet(),
    );
  }
}
