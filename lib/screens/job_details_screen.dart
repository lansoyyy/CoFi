import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/text_widget.dart';
import '../../utils/colors.dart';

class JobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic>? job;
  const JobDetailsScreen({Key? key, this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final j = job ?? <String, dynamic>{};
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
            // TextWidget(
            //   text:
            //       (j['shopName'] ?? j['cafe'] ?? j['shopId'] ?? 'Coffee Shop')
            //           .toString(),
            //   fontSize: 14,
            //   color: Colors.white70,
            // ),
            const SizedBox(height: 4),
            TextWidget(
              text: (j['title'] ?? 'Job').toString(),
              fontSize: 24,
              color: Colors.white,
              isBold: true,
            ),
            const SizedBox(height: 4),
            TextWidget(
              text: (j['address'] ?? 'Address not specified').toString(),
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
              text: (j['type'] ?? 'Unknown').toString(),
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
              text: (j['pay'] ?? 'TBD').toString(),
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
              text: (j['required'] ?? 'Not specified').toString(),
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
              text: _formatDate(j['startDate']),
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
              text: (j['description'] ?? 'No description provided').toString(),
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
                  onPressed: () => _applyNow(context),
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

  String _formatDate(dynamic v) {
    if (v is Timestamp) {
      final dt = v.toDate();
      return _fmt(dt);
    }
    if (v is String && v.isNotEmpty) {
      final dt = DateTime.tryParse(v);
      if (dt != null) return _fmt(dt);
    }
    return 'Unknown';
  }

  String _fmt(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final mon = dt.month.toString().padLeft(2, '0');
    final yr = dt.year.toString();
    return '$yr-$mon-$day';
  }

  Future<void> _applyNow(BuildContext context) async {
    final data = job ?? <String, dynamic>{};
    // 1) Try opening a direct link if provided
    final rawLink = (data['link'] ?? data['url'] ?? '').toString().trim();
    if (rawLink.isNotEmpty) {
      Uri? uri = Uri.tryParse(rawLink);
      if (uri != null && (uri.scheme.isEmpty)) {
        uri = Uri.tryParse('https://$rawLink');
      }
      if (uri != null) {
        try {
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return;
          }
        } catch (_) {
          // fall through to email
        }
      }
    }

    // 2) Fallback to composing an email
    final email = (data['email'] ?? '').toString().trim();
    if (email.isNotEmpty) {
      final subject = 'Application: '
          '${(data['title'] ?? 'Job').toString()}';
      final body = 'Hi, I\'m interested in this role.';
      final mailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': subject,
          'body': body,
        },
      );
      try {
        if (await canLaunchUrl(mailUri)) {
          await launchUrl(mailUri);
          return;
        }
      } catch (_) {
        // continue to snackbar
      }
    }

    // 3) Nothing available
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No application link or email provided'),
      ),
    );
  }
}
