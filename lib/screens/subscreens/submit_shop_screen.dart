import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';
import 'custom_location_screen.dart';

class SubmitShopScreen extends StatefulWidget {
  const SubmitShopScreen({super.key});

  @override
  State<SubmitShopScreen> createState() => _SubmitShopScreenState();
}

class _SubmitShopScreenState extends State<SubmitShopScreen> {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Image picker related variables
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  List<File> _galleryImages = [];
  bool _isUploading = false;

  // Selected tags state
  Map<String, bool> selectedTags = {
    'Specialty Coffee': true,
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

  bool _isSaving = false;
  User? _currentUser;
  bool _isEditing = false;
  String? _editShopId;
  bool _isLoadingExisting = false;
  bool _didLoadArgs = false;
  bool _locationReady = false;

  // Location selection
  String _locationType = 'my_location'; // 'my_location' or 'custom_location'
  LatLng? _selectedLocation;

  // Schedule state: each day has isOpen + open/close times (TimeOfDay?)
  final List<MapEntry<String, String>> _days = const [
    MapEntry('monday', 'Monday'),
    MapEntry('tuesday', 'Tuesday'),
    MapEntry('wednesday', 'Wednesday'),
    MapEntry('thursday', 'Thursday'),
    MapEntry('friday', 'Friday'),
    MapEntry('saturday', 'Saturday'),
    MapEntry('sunday', 'Sunday'),
  ];
  late Map<String, Map<String, dynamic>> _schedule;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _schedule = {
      for (final d in _days)
        d.key: {
          'isOpen': false,
          'open': null, // TimeOfDay?
          'close': null, // TimeOfDay?
        }
    };

    // Ensure location services and permission are enabled on screen entry
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLocationReady();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLoadArgs) return;
    _didLoadArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['editShopId'] is String) {
      _isEditing = true;
      _editShopId = args['editShopId'] as String;
      _loadExistingShop(_editShopId!);
    }
  }

  Future<void> _loadExistingShop(String id) async {
    setState(() => _isLoadingExisting = true);
    try {
      final snap =
          await FirebaseFirestore.instance.collection('shops').doc(id).get();
      final data = snap.data() as Map<String, dynamic>?;
      if (data == null) return;

      shopNameController.text = (data['name'] as String?) ?? '';
      addressController.text = (data['address'] as String?) ?? '';
      aboutController.text = (data['about'] as String?) ?? '';

      final contacts = (data['contacts'] as Map<String, dynamic>?) ?? {};
      instagramController.text = (contacts['instagram'] as String?) ?? '';
      facebookController.text = (contacts['facebook'] as String?) ?? '';
      tiktokController.text = (contacts['tiktok'] as String?) ?? '';
      emailController.text = (contacts['email'] as String?) ?? '';
      websiteController.text = (contacts['website'] as String?) ?? '';
      phoneController.text = (contacts['phone'] as String?) ?? '';

      // Tags
      final tags = ((data['tags'] as List?)?.cast<String>()) ?? <String>[];
      // Reset defaults then mark present tags
      selectedTags = {
        for (final entry in selectedTags.entries) entry.key: false,
      };
      for (final t in tags) {
        if (!selectedTags.containsKey(t)) {
          selectedTags[t] = true; // include unknown tag to preserve
        } else {
          selectedTags[t] = true;
        }
      }

      // Schedule
      final sched = (data['schedule'] as Map<String, dynamic>?) ?? {};
      for (final d in _days) {
        final dayKey = d.key;
        final m = (sched[dayKey] as Map<String, dynamic>?) ?? {};
        _schedule[dayKey] = {
          'isOpen': (m['isOpen'] as bool?) ?? false,
          'open': _parseTimeOfDay(m['open'] as String?),
          'close': _parseTimeOfDay(m['close'] as String?),
        };
      }

      // Load existing location
      final double? latitude = data['latitude'] as double?;
      final double? longitude = data['longitude'] as double?;
      if (latitude != null && longitude != null) {
        setState(() {
          _selectedLocation = LatLng(latitude, longitude);
          _locationType = 'custom_location';
        });
      }
    } catch (_) {
      // ignore, basic UX handled by unchanged fields
    } finally {
      if (mounted) setState(() => _isLoadingExisting = false);
    }
  }

  TimeOfDay? _parseTimeOfDay(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final parts = s.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  List<String> _selectedTagsList() {
    return selectedTags.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
  }

  Future<void> _ensureLocationReady() async {
    if (!mounted) return;
    while (mounted) {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Enable Location Services'),
            content: const Text(
                'Please turn on Location Services to submit a shop with your current location.'),
            actions: [
              TextButton(
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                },
                child: const Text('Open Settings'),
              ),
              TextButton(
                onPressed: () {
                  // Retry check
                  if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
        // Loop and re-check
        continue;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('Location Permission Needed'),
            content: const Text(
                'Please grant location permission in App Settings to continue.'),
            actions: [
              TextButton(
                onPressed: () async {
                  await Geolocator.openAppSettings();
                  if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                },
                child: const Text('Open App Settings'),
              ),
              TextButton(
                onPressed: () {
                  if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
        continue;
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        if (mounted) setState(() => _locationReady = true);
        break;
      }
      // If still denied (not forever), loop to request again
    }
  }

  Future<Position?> _getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Optionally inform the user that location services are disabled
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        // Permissions are denied, next time we could show a dialog directing to settings
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _submitShop() async {
    final name = shopNameController.text.trim();
    final address = addressController.text.trim();
    final about = aboutController.text.trim();

    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in shop name and address.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final user = _currentUser;
      final postedBy = user == null
          ? {
              'uid': null,
              'displayName': null,
              'email': null,
            }
          : {
              'uid': user.uid,
              'displayName': user.displayName,
              'email': user.email,
            };

      // Get location based on selection
      double? latitude;
      double? longitude;

      if (_locationType == 'my_location') {
        final position = await _getCurrentPosition();
        latitude = position?.latitude;
        longitude = position?.longitude;
      } else if (_selectedLocation != null) {
        latitude = _selectedLocation!.latitude;
        longitude = _selectedLocation!.longitude;
      }

      if (_isEditing && _editShopId != null && _editShopId!.isNotEmpty) {
        // Update existing shop
        final updateData = {
          'name': name,
          'address': address,
          'about': about,
          'contacts': {
            'instagram': instagramController.text.trim(),
            'facebook': facebookController.text.trim(),
            'tiktok': tiktokController.text.trim(),
            'email': emailController.text.trim(),
            'website': websiteController.text.trim(),
            'phone': phoneController.text.trim(),
          },
          'schedule': _buildSchedulePayload(),
          'tags': _selectedTagsList(),
          if (latitude != null && longitude != null) 'latitude': latitude,
          if (latitude != null && longitude != null) 'longitude': longitude,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Upload logo image if selected
        if (_selectedImage != null) {
          final imageUrl = await _uploadImageToFirebase(_editShopId!);
          if (imageUrl != null) {
            updateData['logoUrl'] = imageUrl;
          }
        }

        // Upload gallery images if selected
        if (_galleryImages.isNotEmpty) {
          final galleryUrls =
              await _uploadGalleryImagesToFirebase(_editShopId!);
          if (galleryUrls.isNotEmpty) {
            updateData['gallery'] = galleryUrls;
          }
        }

        await FirebaseFirestore.instance
            .collection('shops')
            .doc(_editShopId)
            .update(updateData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shop updated successfully.')),
          );
          Navigator.pushReplacementNamed(
            context,
            '/businessProfile',
            arguments: {
              'id': _editShopId,
              'name': name,
            },
          );
        }
      } else {
        // Create new shop
        final data = {
          'name': name,
          'address': address,
          'about': about,
          'contacts': {
            'instagram': instagramController.text.trim(),
            'facebook': facebookController.text.trim(),
            'tiktok': tiktokController.text.trim(),
            'email': emailController.text.trim(),
            'website': websiteController.text.trim(),
            'phone': phoneController.text.trim(),
          },
          // Daily schedule from UI state
          'schedule': _buildSchedulePayload(),
          'logoUrl': null,
          'gallery': <String>[],
          'tags': _selectedTagsList(),
          if (latitude != null && longitude != null) 'latitude': latitude,
          if (latitude != null && longitude != null) 'longitude': longitude,
          'postedBy': postedBy,
          'posterId': user?.uid,
          'postedAt': FieldValue.serverTimestamp(),
          'reviews': [],
          'ratings': 0,
          'ratingCount': 0,
          'visits': [],
          'menu': [],
          'isVerified': false, // New field for shop verification
        };

        final ref =
            await FirebaseFirestore.instance.collection('shops').add(data);

        // Upload logo image if selected
        if (_selectedImage != null) {
          final imageUrl = await _uploadImageToFirebase(ref.id);
          if (imageUrl != null) {
            await ref.update({'logoUrl': imageUrl});
          }
        }

        // Upload gallery images if selected
        if (_galleryImages.isNotEmpty) {
          final galleryUrls = await _uploadGalleryImagesToFirebase(ref.id);
          if (galleryUrls.isNotEmpty) {
            await ref.update({'gallery': galleryUrls});
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Shop submitted successfully. Your shop is currently under verification.')),
          );
          Navigator.pushReplacementNamed(
            context,
            '/businessProfile',
            arguments: {
              'id': ref.id,
              'name': name,
            },
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: TextWidget(
          text: _isEditing ? 'Edit Shop' : 'Submit Shop',
          fontSize: 16,
          color: Colors.white,
          isBold: true,
        ),
      ),
      body: SafeArea(
        child: _isLoadingExisting
            ? const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Posting as indicator
                    if (_currentUser != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.account_circle,
                                color: Colors.white70, size: 18),
                            const SizedBox(width: 8),
                            TextWidget(
                              text: 'Posting as ' +
                                  (_currentUser!.displayName?.isNotEmpty == true
                                      ? _currentUser!.displayName!
                                      : (_currentUser!.email ?? 'Anonymous')),
                              fontSize: 13,
                              color: Colors.white70,
                              isBold: false,
                            ),
                          ],
                        ),
                      ),

                    // Shop Logo Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Shop Logo',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                        GestureDetector(
                          onTap: _isUploading ? null : _pickImage,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _isUploading
                                ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  )
                                : _selectedImage != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _selectedImage!,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.add_a_photo,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Shop Name
                    TextWidget(
                      text: 'Shop Name',
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: shopNameController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Sample Cafe Name',
                          hintStyle:
                              TextStyle(color: Colors.grey[500], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Address
                    TextWidget(
                      text: 'Address',
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: addressController,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Davao City',
                          hintStyle:
                              TextStyle(color: Colors.grey[500], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Gallery
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'Gallery',
                          fontSize: 16,
                          color: Colors.white,
                          isBold: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Gallery Images
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _isUploading ? null : _pickGalleryImages,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _isUploading
                                ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ..._galleryImages.asMap().entries.map((entry) {
                          int idx = entry.key;
                          File image = entry.value;
                          return Container(
                            width: 80,
                            height: 80,
                            margin: EdgeInsets.only(
                                right:
                                    idx == _galleryImages.length - 1 ? 0 : 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // About Me
                    TextWidget(
                      text: 'About the Shop',
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: aboutController,
                        maxLines: 4,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle:
                              TextStyle(color: Colors.grey[500], fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Contacts
                    TextWidget(
                      text: 'Contacts',
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 16),

                    // Instagram
                    _buildContactField(
                      icon: Icons.camera_alt,
                      controller: instagramController,
                      label: 'Instagram',
                    ),
                    const SizedBox(height: 12),

                    // Facebook
                    _buildContactField(
                      icon: Icons.facebook,
                      controller: facebookController,
                      label: 'Facebook',
                    ),
                    const SizedBox(height: 12),

                    // TikTok
                    _buildContactField(
                      icon: Icons.music_note,
                      controller: tiktokController,
                      label: 'Tiktok',
                    ),
                    const SizedBox(height: 32),

                    // Select Tags
                    TextWidget(
                      text: 'Select Tags',
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 16),

                    // Tags Grid
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: selectedTags.keys.map((tag) {
                        return _buildTag(tag, selectedTags[tag]!);
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Daily Schedule Section
                    _buildScheduleSection(),

                    const SizedBox(height: 40),

                    // Location Selection Section
                    TextWidget(
                      text: 'Shop Location',
                      fontSize: 16,
                      color: Colors.white,
                      isBold: true,
                    ),
                    const SizedBox(height: 12),

                    // Location Type Selection
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: TextWidget(
                              text: 'My Current Location',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            subtitle: TextWidget(
                              text: 'Use my current location for the shop',
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            value: 'my_location',
                            groupValue: _locationType,
                            onChanged: (value) {
                              setState(() {
                                _locationType = value!;
                              });
                            },
                            activeColor: primary,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          RadioListTile<String>(
                            title: TextWidget(
                              text: 'Custom Location',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            subtitle: TextWidget(
                              text: 'Select a custom location on the map',
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            value: 'custom_location',
                            groupValue: _locationType,
                            onChanged: (value) {
                              setState(() {
                                _locationType = value!;
                              });
                            },
                            activeColor: primary,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ],
                      ),
                    ),

                    // Show selected custom location info
                    if (_locationType == 'custom_location' &&
                        _selectedLocation != null)
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: primary, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextWidget(
                                text:
                                    'Selected: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                            TextButton(
                              onPressed: _selectCustomLocation,
                              child: const Text('Change',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),

                    // Custom location selection button
                    if (_locationType == 'custom_location')
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _selectCustomLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: TextWidget(
                            text: _selectedLocation == null
                                ? 'Select Location on Map'
                                : 'Change Location',
                            fontSize: 16,
                            color: Colors.white,
                            isBold: true,
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Location requirement notice for my location
                    if (_locationType == 'my_location' && !_locationReady)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.amber.withOpacity(0.4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_off,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Location required',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Please enable Location Services and grant permission to proceed.',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 12),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton(
                                      onPressed: _ensureLocationReady,
                                      child: const Text('Fix',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Save Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: (_isSaving ||
                                (_locationType == 'my_location' &&
                                    !_locationReady) ||
                                (_locationType == 'custom_location' &&
                                    _selectedLocation == null))
                            ? null
                            : _submitShop,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : TextWidget(
                                text: (_locationType == 'my_location' &&
                                        !_locationReady)
                                    ? 'Enable Location'
                                    : (_locationType == 'custom_location' &&
                                            _selectedLocation == null)
                                        ? 'Select Location'
                                        : (_isEditing ? 'Update' : 'Save'),
                                fontSize: 16,
                                color: Colors.white,
                                isBold: true,
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Future<String?> _uploadImageToFirebase(String shopId) async {
    if (_selectedImage == null) return null;

    try {
      setState(() {
        _isUploading = true;
      });

      final fileName =
          'shop_${shopId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef =
          FirebaseStorage.instance.ref().child('shop_images').child(fileName);

      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<List<String>> _uploadGalleryImagesToFirebase(String shopId) async {
    List<String> downloadUrls = [];

    if (_galleryImages.isEmpty) return downloadUrls;

    try {
      setState(() {
        _isUploading = true;
      });

      for (int i = 0; i < _galleryImages.length; i++) {
        final fileName =
            'gallery_${shopId}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        final storageRef =
            FirebaseStorage.instance.ref().child('shop_images').child(fileName);

        final uploadTask = storageRef.putFile(_galleryImages[i]);
        final snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload gallery images: $e')),
      );
      return [];
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Map<String, dynamic> _buildSchedulePayload() {
    String _fmt(TimeOfDay? t) => t == null
        ? ''
        : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return {
      for (final d in _days)
        d.key: {
          'open': _fmt(_schedule[d.key]!['open'] as TimeOfDay?),
          'close': _fmt(_schedule[d.key]!['close'] as TimeOfDay?),
          'isOpen': _schedule[d.key]!['isOpen'] as bool,
        }
    };
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'Daily Schedule',
          fontSize: 16,
          color: Colors.white,
          isBold: true,
        ),
        const SizedBox(height: 12),
        ..._days.map((d) => _buildDayRow(d.key, d.value)).toList(),
      ],
    );
  }

  Widget _buildDayRow(String key, String label) {
    final isOpen = (_schedule[key]!['isOpen'] as bool);
    final TimeOfDay? open = _schedule[key]!['open'] as TimeOfDay?;
    final TimeOfDay? close = _schedule[key]!['close'] as TimeOfDay?;

    String _fmt(TimeOfDay? t) => t == null
        ? '--:--'
        : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: label,
                fontSize: 14,
                color: Colors.white,
                isBold: true,
              ),
              Switch(
                value: isOpen,
                activeColor: primary,
                onChanged: (val) {
                  setState(() {
                    _schedule[key]!['isOpen'] = val;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTimePickerTile(
                  label: 'Open',
                  value: _fmt(open),
                  enabled: isOpen,
                  onTap: () => _pickTime(key, 'open'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePickerTile(
                  label: 'Close',
                  value: _fmt(close),
                  enabled: isOpen,
                  onTap: () => _pickTime(key, 'close'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTimePickerTile({
    required String label,
    required String value,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final tileColor = enabled ? Colors.grey[850] : Colors.grey[800];
    final textColor = enabled ? Colors.white : Colors.white54;
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: label,
              fontSize: 13,
              color: textColor,
              isBold: false,
            ),
            Row(
              children: [
                TextWidget(
                  text: value,
                  fontSize: 13,
                  color: textColor,
                  isBold: true,
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, color: textColor, size: 16),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime(String dayKey, String field) async {
    final initial = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: primary,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _schedule[dayKey]![field] = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _pickGalleryImages() async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _galleryImages = pickedFiles.map((file) => File(file.path)).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
    }
  }

  Widget _buildContactField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Icon(
              icon,
              color: Colors.white54,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTags[text] = !selectedTags[text]!;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextWidget(
          text: text,
          fontSize: 14,
          color: Colors.white,
          isBold: false,
        ),
      ),
    );
  }

  Future<void> _selectCustomLocation() async {
    final LatLng? selectedLocation = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => CustomLocationScreen(
          initialLocation: _selectedLocation,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
      });
    }
  }

  @override
  void dispose() {
    shopNameController.dispose();
    addressController.dispose();
    aboutController.dispose();
    instagramController.dispose();
    facebookController.dispose();
    tiktokController.dispose();
    emailController.dispose();
    websiteController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
