import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/text_widget.dart';
import '../../utils/colors.dart';

class CreateListBottomSheet extends StatefulWidget {
  const CreateListBottomSheet({Key? key}) : super(key: key);

  @override
  State<CreateListBottomSheet> createState() => _CreateListBottomSheetState();
}

class _CreateListBottomSheetState extends State<CreateListBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Reuse the same tag names as shops use in submit_shop_screen.dart
  final Map<String, bool> _selectedTags = {
    'Aesthetic': false,
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
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'Create a List',
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
              const SizedBox(height: 24),

              // Collection Name Field
              TextWidget(
                text: 'Collection Name',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ex: Perfect Cafe shops for nights out',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white24, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description Field
              TextWidget(
                text: 'Description',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add list description',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white24, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Filters: Tags
              TextWidget(
                text: 'Filters (optional)',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              TextWidget(
                text: 'Select tags to auto-filter shops in this list',
                fontSize: 12,
                color: Colors.white70,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _selectedTags.keys.map((t) {
                  final selected = _selectedTags[t] ?? false;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTags[t] = !selected),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? primary : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextWidget(
                        text: t,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = _nameController.text.trim();
                    final description = _descriptionController.text.trim();
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a name')),
                      );
                      return;
                    }
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Sign in to create lists')),
                      );
                      return;
                    }
                    try {
                      final listsCol = FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('lists');
                      final now = FieldValue.serverTimestamp();
                      final selectedTags = _selectedTags.entries
                          .where((e) => e.value)
                          .map((e) => e.key)
                          .toList();
                      final docRef = await listsCol.add({
                        'name': name,
                        'description': description,
                        'createdAt': now,
                        'updatedAt': now,
                        if (selectedTags.isNotEmpty)
                          'filters': {
                            'tags': selectedTags,
                          },
                      });
                      if (context.mounted) {
                        Navigator.pop(context, docRef.id);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create list: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
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
            ],
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
      builder: (context) => const CreateListBottomSheet(),
    );
  }
}
