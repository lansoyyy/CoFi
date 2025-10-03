import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class CustomLocationScreen extends StatefulWidget {
  final LatLng? initialLocation;

  const CustomLocationScreen({super.key, this.initialLocation});

  @override
  State<CustomLocationScreen> createState() => _CustomLocationScreenState();
}

class _CustomLocationScreenState extends State<CustomLocationScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  Set<Marker> _markers = {};
  bool _isLoading = true;

  // Davao City coordinates
  static const LatLng _davaoCityCenter = LatLng(7.0731, 125.6128);

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation ?? _davaoCityCenter;
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    setState(() {
      _isLoading = false;
      _updateMarker();
    });
  }

  void _updateMarker() {
    if (_selectedLocation != null) {
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('selected_location'),
            position: _selectedLocation!,
            infoWindow: const InfoWindow(title: 'Shop Location'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        };
      });
    }
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _updateMarker();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation);
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
          text: 'Select Shop Location',
          fontSize: 16,
          color: Colors.white,
          isBold: true,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _selectedLocation ?? _davaoCityCenter,
                      zoom: 14.0,
                    ),
                    onTap: _onMapTap,
                    markers: _markers,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Tap on the map to set the shop location',
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      if (_selectedLocation != null) ...[
                        const SizedBox(height: 8),
                        TextWidget(
                          text:
                              'Selected: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _confirmLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: TextWidget(
                            text: 'Confirm Location',
                            fontSize: 16,
                            color: Colors.white,
                            isBold: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
