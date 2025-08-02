import 'package:flutter/material.dart';
import '../../../widgets/text_widget.dart';
import '../../../utils/colors.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Event Image
                  Stack(
                    children: [
                      Container(
                        height: 400,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: const Center(
                          child: Icon(Icons.image,
                              color: Colors.white38, size: 60),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              text: 'Coffee Day',
                              fontSize: 24,
                              color: Colors.white,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Section
                        TextWidget(
                          text: 'Date',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: 'SAT, 5 JUL | 04:00 PM - 08:00 PM',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 24),

                        // Address Section
                        TextWidget(
                          text: 'Address',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text:
                              'Juna Ave. (Beside 6th Republic Resto) 8000\nDavao City, Philippines',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 16),

                        // Map placeholder
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[800],
                          ),
                          child: const Center(
                            child: Icon(Icons.map,
                                color: Colors.white38, size: 60),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // About Section
                        TextWidget(
                          text: 'About',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text:
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dictum nisl eget pretium laoreet. Vestibulum blandit at orci. Condimentum suscipit. Suspendisse lectus libero mauris cursus in, sit viverra mollis ipsum est molestie massa. Bibendum ut. Aliquam morbi placerat lorem dolor congue justo faucibus. Ac lacus mi laoreet, eget rutrum risus sit nec donec fringilla varius odio, vitae fringilla elit dapibus quis.',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 24),

                        // Email Section
                        TextWidget(
                          text: 'Email',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        TextWidget(
                          text: 'SampleCafe@yopmail.com',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 100), // Space for button
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.touch_app, color: Colors.white),
                      const SizedBox(width: 8),
                      TextWidget(
                        text: 'Tap to participate',
                        fontSize: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white),
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
}
