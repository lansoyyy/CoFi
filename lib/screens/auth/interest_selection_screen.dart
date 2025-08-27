import 'package:cofi/screens/home_screen.dart';
import 'package:cofi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/button_widget.dart';

class InterestSelectionScreen extends StatefulWidget {
  const InterestSelectionScreen({super.key});

  @override
  State<InterestSelectionScreen> createState() =>
      _InterestSelectionScreenState();
}

class _InterestSelectionScreenState extends State<InterestSelectionScreen> {
  Map<String, bool> interests = {
    'Specialty Coffee': false,
    'Matcha Drinks': false,
    'Pastries': false,
    'Work-Friendly (Wi-Fi + outlets)': false,
    'Pet-Friendly': false,
    'Parking Available': false,
    'Family Friendly': false,
    'Study Sessions': false,
    'Night Café (Open Late)': false,
    'Minimalist / Modern': false,
    'Rustic / Cozy': false,
    'Outdoor / Garden': false,
    'Seaside / Scenic': false,
    'Artsy / Aesthetic': false,
    'Instagrammable': false,
  };

  bool _isLoading = false;

  List<String> _getSelectedInterests() {
    return interests.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  Future<void> _saveInterestsAndContinue() async {
    // Validate at least one interest is selected
    if (_getSelectedInterests().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one interest')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'interests': _getSelectedInterests(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save interests: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = _getSelectedInterests().length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  'Interest',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: const Text(
                  'Pick things you\'d like to see in your home feed.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: interests.keys.map((interest) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          interests[interest] = !interests[interest]!;
                        });
                      },
                      child: Chip(
                        label: Text(
                          interest,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: interests[interest]!
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                        backgroundColor: interests[interest]!
                            ? primary
                            : const Color(0xFF1E1E1E),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide.none,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: TextButton(
                  onPressed: _isLoading ? null : _saveInterestsAndContinue,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: primary.withOpacity(0.7),
                    padding: EdgeInsets.zero,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '$selectedCount of ${interests.length} Selected',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Medium',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
