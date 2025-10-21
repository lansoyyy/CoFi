import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cofi/widgets/app_text_form_field.dart';
import 'package:cofi/widgets/button_widget.dart';
import 'package:cofi/widgets/text_widget.dart';
import 'package:cofi/utils/colors.dart';

class JobApplicationScreen extends StatefulWidget {
  final Map<String, dynamic>? job;
  final String shopId;
  const JobApplicationScreen({Key? key, this.job, required this.shopId})
      : super(key: key);

  @override
  State<JobApplicationScreen> createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _coverLetterController = TextEditingController();

  String? _resumePath;
  String _resumeFileName = 'No file selected';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _pickResume() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        // allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _resumePath = result.files.single.path;
          _resumeFileName = result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      if (_resumePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload your resume/CV'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final job = widget.job ?? <String, dynamic>{};
        final jobId = job['id'] ?? job['documentId'] ?? '';

        if (jobId.isEmpty) {
          throw Exception('Job ID not found');
        }

        // Upload resume to Firebase Storage
        final file = File(_resumePath!);
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_$_resumeFileName';
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('job_applications')
            .child(jobId)
            .child(fileName);

        final uploadTask = await storageRef.putFile(file);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        // Get current user
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception('User not authenticated');
        }

        // Create application data
        final applicationData = {
          'applicantId': currentUser.uid,
          'applicantName': _nameController.text,
          'applicantEmail': _emailController.text,
          'applicantPhone': _phoneController.text,
          'resumeUrl': downloadUrl,
          'resumeFileName': _resumeFileName,
          'coverLetter': _coverLetterController.text,
          'appliedAt': Timestamp.now(),
          'jobId': jobId,
          'status': 'pending',
        };

        // Update the applications array field in the job document
        await FirebaseFirestore.instance
          ..collection('shops')
              .doc(widget.shopId)
              .collection('jobs')
              .doc(widget.job!['id'])
              .update({
            'applications': FieldValue.arrayUnion([applicationData])
          });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting application: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job ?? <String, dynamic>{};

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextWidget(
          text: 'Job Application',
          fontSize: 20,
          color: Colors.white,
          isBold: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Details Preview
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: job['title'] ?? 'Job Position',
                      fontSize: 18,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    TextWidget(
                      text: job['address'] ?? 'Location',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Personal Information Section
              TextWidget(
                text: 'Personal Information',
                fontSize: 18,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 16),

              AppTextFormField(
                controller: _nameController,
                labelText: 'Full Name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),

              AppTextFormField(
                controller: _emailController,
                labelText: 'Email Address',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email address';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),

              AppTextFormField(
                controller: _phoneController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Resume Upload Section
              TextWidget(
                text: 'Resume/CV',
                fontSize: 18,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _resumePath != null ? primary : Colors.grey,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.description,
                          color: _resumePath != null ? primary : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextWidget(
                            text: _resumeFileName,
                            fontSize: 14,
                            color: _resumePath != null
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ButtonWidget(
                      label: 'Upload Resume/CV',
                      onPressed: _pickResume,
                      width: double.infinity,
                      height: 40,
                      fontSize: 14,
                      color: primary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Cover Letter Section
              TextWidget(
                text: 'Cover Letter (Optional)',
                fontSize: 18,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 16),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _coverLetterController,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText:
                        'Tell us why you\'re interested in this position...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              ButtonWidget(
                label: 'Submit Application',
                onPressed: _submitApplication,
                width: double.infinity,
                isLoading: _isLoading,
                color: primary,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
