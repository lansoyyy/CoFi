import 'package:flutter/material.dart';
import '../widgets/text_widget.dart';

class CommunityCommitmentScreen extends StatelessWidget {
  const CommunityCommitmentScreen({super.key});

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
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: TextWidget(
                    text: 'Learn more',
                    fontSize: 14.5,
                    color: const Color(0xFFDF2C2C),
                    isBold: true,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDF2C2C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: TextWidget(
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
                onPressed: () {},
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
