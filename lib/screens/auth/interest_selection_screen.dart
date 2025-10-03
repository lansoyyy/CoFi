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

  // Map each interest to an appropriate online image
  Map<String, String> interestImages = {
    'Specialty Coffee':
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
    'Matcha Drinks':
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    'Pastries':
        'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=400',
    'Work-Friendly (Wi-Fi + outlets)':
        'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400',
    'Pet-Friendly':
        'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400',
    'Parking Available':
        'https://images.unsplash.com/photo-1470224114660-3f6686c562eb?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'Family Friendly':
        'https://images.unsplash.com/photo-1511884642898-4c92249e20b6?w=400',
    'Study Sessions': 'https://picsum.photos/seed/study/400/300.jpg',
    'Night Café (Open Late)':
        'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400',
    'Minimalist / Modern': 'https://picsum.photos/seed/modern/400/300.jpg',
    'Rustic / Cozy': 'https://picsum.photos/seed/cozy/400/300.jpg',
    'Outdoor / Garden':
        'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
    'Seaside / Scenic': 'https://picsum.photos/seed/seaside/400/300.jpg',
    'Artsy / Aesthetic':
        'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400',
    'Instagrammable':
        'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=400',
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
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: interests.length,
                  itemBuilder: (context, index) {
                    String interest = interests.keys.elementAt(index);
                    bool isSelected = interests[interest]!;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          interests[interest] = !interests[interest]!;
                        });
                      },
                      child: Card(
                        elevation: isSelected ? 8 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isSelected
                              ? BorderSide(color: primary, width: 2)
                              : BorderSide.none,
                        ),
                        color: isSelected
                            ? primary.withOpacity(0.2)
                            : const Color(0xFF1E1E1E),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(interestImages[interest]!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: isSelected
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                          color: primary.withOpacity(0.3),
                                        ),
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  interest,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
