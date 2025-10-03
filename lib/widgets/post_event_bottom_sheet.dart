import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class PostEventBottomSheet extends StatefulWidget {
  const PostEventBottomSheet({super.key, required this.shopId});

  final String shopId;

  static void show(BuildContext context, {required String shopId}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => PostEventBottomSheet(shopId: shopId),
    );
  }

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
  bool _saving = false;

  // Image picker related variables
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveEvent() async {
    final title = _eventNameController.text.trim();
    final date = _dateController.text.trim();
    final address = _addressController.text.trim();
    final startDate = _startDateController.text.trim();
    final about = _aboutController.text.trim();
    final email = _emailController.text.trim();
    final link = _linkController.text.trim();

    if (title.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter at least Event Name and Date.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      // Upload image if selected
      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImageToFirebase();
      }

      final data = {
        'title': title,
        'date': date,
        'address': address,
        'startDate': startDate,
        'about': about,
        'email': email,
        'link': link,
        'imageUrl': imageUrl, // Store single image URL
        'status': 'pending',
        'participantsCount': 0,
        'shopId': widget.shopId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('shops')
          .doc(widget.shopId)
          .collection('events')
          .add(data);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event posted.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to post event: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<String?> _uploadImageToFirebase() async {
    if (_selectedImage == null) return null;

    try {
      setState(() {
        _isUploading = true;
      });

      final fileName =
          'event_${widget.shopId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef =
          FirebaseStorage.instance.ref().child('event_images').child(fileName);

      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
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
                        text: 'Event Image',
                        fontSize: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                      const SizedBox(height: 16),

                      // Image Picker
                      GestureDetector(
                        onTap: _isUploading ? null : _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _isUploading
                              ? const Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                )
                              : _selectedImage != null
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            _selectedImage!,
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedImage = null;
                                              });
                                            },
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate,
                                            color: Colors.white54,
                                            size: 48,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Tap to add image',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _saveEvent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFE53E3E), // Red color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : TextWidget(
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
}
