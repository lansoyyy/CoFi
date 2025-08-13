import 'package:cofi/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/text_widget.dart';

class CommunityCommitmentScreen extends StatefulWidget {
  const CommunityCommitmentScreen({super.key});

  @override
  State<CommunityCommitmentScreen> createState() =>
      _CommunityCommitmentScreenState();
}

class _CommunityCommitmentScreenState extends State<CommunityCommitmentScreen> {
  bool _isLoading = false;

  Future<void> _agreeAndContinue() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You must be signed in to continue.')),
          );
        }
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'commitment': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update commitment. ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextWidget(
                text: 'Our community commitment',
                fontSize: 13,
                color: Colors.white70,
                isBold: false,
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              TextWidget(
                text: 'CoFi is a cafe community\nwhere anyone can belong',
                fontSize: 24,
                color: Colors.white,
                isBold: true,
                maxLines: 3,
              ),
              const SizedBox(height: 18),
              TextWidget(
                text:
                    "To ensure this, we're asking you to commit to the following:",
                fontSize: 14.5,
                color: Colors.white,
                isBold: false,
                maxLines: 2,
              ),
              const SizedBox(height: 18),
              TextWidget(
                text:
                    'I agree to treat everyone in the Cofi community – regardless of their race, religion, national origin, ethnicity, skin color, disability, sex, gender identity, sexual orientation or age – with respect, and without judgment or bias.',
                fontSize: 14.5,
                color: Colors.white,
                isBold: false,
                maxLines: 8,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDF2C2C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading ? null : _agreeAndContinue,
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : TextWidget(
                        text: 'Agree and Continue',
                        fontSize: 17,
                        color: Colors.white,
                        isBold: true,
                        align: TextAlign.center,
                      ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222222),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
                child: TextWidget(
                  text: 'Decline',
                  fontSize: 17,
                  color: Colors.white,
                  isBold: true,
                  align: TextAlign.center,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
