import 'package:cofi/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/text_widget.dart';

class ReviewShopScreen extends StatefulWidget {
  final String shopId;
  final String shopName;
  final String shopAddress;

  const ReviewShopScreen(
      {Key? key,
      required this.shopId,
      required this.shopName,
      required this.shopAddress})
      : super(key: key);

  @override
  State<ReviewShopScreen> createState() => _ReviewShopScreenState();
}

class _ReviewShopScreenState extends State<ReviewShopScreen> {
  int _rating = 0;
  final Set<String> _selectedTags = <String>{};
  final _textCtrl = TextEditingController();
  bool _submitting = false;

  final List<String> _availableTags = const [
    'Business Meeting',
    'Chill / Hangout',
    'Study Session',
    'Group Gathering',
  ];

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a rating.')));
      return;
    }
    setState(() => _submitting = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please sign in to submit a review.')));
        return;
      }
      final reviewMap = {
        'userId': user.uid,
        'authorName': user.displayName ?? (user.email ?? 'User'),
        'rating': _rating,
        'text': _textCtrl.text.trim(),
        'tags': _selectedTags.toList(),
        'createdAt': FieldValue.serverTimestamp(),
      };
      // Subcollection write
      final shopRef =
          FirebaseFirestore.instance.collection('shops').doc(widget.shopId);
      await shopRef.collection('reviews').add(reviewMap);
      // Optional: mirror in embedded array for client-side rendering
      await shopRef.update({
        'reviews': FieldValue.arrayUnion([
          {
            'authorName': reviewMap['authorName'],
            'rating': reviewMap['rating'],
            'text': reviewMap['text'],
            'tags': reviewMap['tags'],
            'createdAt': Timestamp.now(),
          }
        ])
      }).catchError((_) {});

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Review submitted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextWidget(
          text: 'Review',
          fontSize: 18,
          color: Colors.white,
          isBold: true,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[800],
                    ),
                    child: const Center(
                      child: Icon(Icons.image, color: Colors.white38, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: widget.shopName,
                        fontSize: 16,
                        color: Colors.white,
                        isBold: true,
                      ),
                      TextWidget(
                        text: widget.shopAddress,
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextWidget(
                text: 'How was it?',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) {
                    final star = index + 1;
                    final filled = _rating >= star;
                    return IconButton(
                      icon: Icon(
                        filled ? Icons.star : Icons.star_border,
                        color: filled ? Colors.amber : Colors.white,
                        size: 32,
                      ),
                      onPressed: () => setState(() => _rating = star),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              TextWidget(
                text: 'What best describes your visit?',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableTags.map((tag) {
                  final selected = _selectedTags.contains(tag);
                  return ChoiceChip(
                    label: TextWidget(
                        text: tag, fontSize: 12, color: Colors.white),
                    selected: selected,
                    selectedColor: primary.withOpacity(0.6),
                    backgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              TextWidget(
                text: 'Write a review',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 5,
                controller: _textCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Write your review here...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextWidget(
                text: 'Add a photo',
                fontSize: 16,
                color: Colors.white,
                isBold: true,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8), color: primary),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextWidget(
                    text: 'Max 1 photo only',
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: TextWidget(
                    text: _submitting ? 'Submitting...' : 'Submit',
                    fontSize: 16,
                    color: Colors.white,
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
