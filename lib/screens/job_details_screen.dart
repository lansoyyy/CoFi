import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';
import '../../utils/colors.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            TextWidget(
              text: 'SampleCafe',
              fontSize: 14,
              color: Colors.white70,
            ),
            const SizedBox(height: 4),
            TextWidget(
              text: 'Barista',
              fontSize: 24,
              color: Colors.white,
              isBold: true,
            ),
            const SizedBox(height: 4),
            TextWidget(
              text:
                  'Juna Ave. (Beside 6th Republic Resto) 8000 Davao City, Philippines',
              fontSize: 13,
              color: Colors.white54,
              maxLines: 5,
            ),
            const SizedBox(height: 32),

            // Type Section
            TextWidget(
              text: 'Type',
              fontSize: 16,
              color: Colors.white,
              isBold: true,
            ),
            const SizedBox(height: 8),
            TextWidget(
              text: 'Part Time',
              fontSize: 14,
              color: Colors.white70,
            ),
            const SizedBox(height: 24),

            // Pay Section
            TextWidget(
              text: 'Pay',
              fontSize: 16,
              color: Colors.white,
              isBold: true,
            ),
            const SizedBox(height: 8),
            TextWidget(
              text: 'TBD',
              fontSize: 14,
              color: Colors.white70,
            ),
            const SizedBox(height: 24),

            // Required Section
            TextWidget(
              text: 'Required',
              fontSize: 16,
              color: Colors.white,
              isBold: true,
            ),
            const SizedBox(height: 8),
            TextWidget(
              text: 'Experience',
              fontSize: 14,
              color: Colors.white70,
            ),
            const SizedBox(height: 24),

            // Start Date Section
            TextWidget(
              text: 'Start Date',
              fontSize: 16,
              color: Colors.white,
              isBold: true,
            ),
            const SizedBox(height: 8),
            TextWidget(
              text: 'Unknown',
              fontSize: 14,
              color: Colors.white70,
            ),
            const SizedBox(height: 24),

            // Description Section
            TextWidget(
              text: 'Description',
              fontSize: 16,
              color: Colors.white,
              isBold: true,
            ),
            const SizedBox(height: 8),
            TextWidget(
              text:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dictum nisl eget pretium laoreet. Vestibulum blandit at orci condimentum suscipit. Suspendisse lectus libero mauris cursus in, sit viverra mollis ipsum est molestie massa. Bibendum ut. Aliquam morbi placerat lorem dolor congue justo faucibus. Ac lacus mi laoreet, eget rutrum risus sit nec donec fringilla varius odio, vitae fringilla elit dapibus quis.',
              fontSize: 14,
              color: Colors.white70,
            ),
            const Spacer(),

            // Bottom Button
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
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
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.touch_app,
                              color: Colors.red, size: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextWidget(
                        text: 'Apply now!',
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
