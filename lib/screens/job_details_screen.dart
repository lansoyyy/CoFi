import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/text_widget.dart';
import '../widgets/button_widget.dart';
import '../utils/colors.dart';
import 'job_application_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? job;
  final String shopId;
  const JobDetailsScreen({Key? key, this.job, required this.shopId})
      : super(key: key);

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  bool _isBusinessOwner = false;
  bool _isLoading = true;
  String? _userAccountType;

  @override
  void initState() {
    super.initState();
    _checkUserType();
  }

  Future<void> _checkUserType() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Check user account type
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      
      final userData = userDoc.data();
      final accountType = userData?['accountType'] as String? ?? 'user';
      
      setState(() {
        _userAccountType = accountType;
        _isBusinessOwner = accountType == 'business';
        _isLoading = false;
      });
    } catch (e) {
      print('Error checking user type: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _closeJobApplication() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Close Job Application',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to close this job application? This will prevent new users from applying.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('shops')
            .doc(widget.shopId)
            .collection('jobs')
            .doc(widget.job!['id'])
            .update({
          'status': 'closed',
          'closedAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job application closed successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error closing job: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    final j = widget.job ?? <String, dynamic>{};
    final isJobClosed = j['status'] == 'closed';
    
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
        actions: _isBusinessOwner
            ? [
                if (!isJobClosed)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: _closeJobApplication,
                    tooltip: 'Close Job Application',
                  ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Job status badge
            if (isJobClosed)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: const Text(
                  'CLOSED',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
              text: (j['rate'] ?? j['pay'] ?? 'TBD').toString(),
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
              text: (j['qualifications'] ?? j['required'] ?? 'Not specified').toString(),
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
              child: _buildBottomButton(j, isJobClosed),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(Map<String, dynamic> job, bool isJobClosed) {
    if (_isBusinessOwner) {
      // Business owner view
      if (isJobClosed) {
        return ButtonWidget(
          label: 'Job Application Closed',
          onPressed: () {}, // Empty function to disable button
          width: double.infinity,
          color: Colors.grey,
        );
      } else {
        return Column(
          children: [
            ButtonWidget(
              label: 'Close Job Application',
              onPressed: _closeJobApplication,
              width: double.infinity,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            TextWidget(
              text: 'Close this job when you\'ve hired someone',
              fontSize: 12,
              color: Colors.grey,
            ),
          ],
        );
      }
    } else {
      // Regular user view
      if (isJobClosed) {
        return ButtonWidget(
          label: 'Application Closed',
          onPressed: () {}, // Empty function to disable button
          width: double.infinity,
          color: Colors.grey,
        );
      } else {
        return SizedBox(
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
        );
      }
    }
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobApplicationScreen(job: widget.job, shopId: widget.shopId),
      ),
    );
  }
}
