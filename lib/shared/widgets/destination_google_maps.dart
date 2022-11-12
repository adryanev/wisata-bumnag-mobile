import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DestinationGoogleMaps extends StatefulWidget {
  const DestinationGoogleMaps({
    super.key,
    required this.latitude,
    required this.longitude,
  });
  final double latitude;
  final double longitude;
  @override
  State<DestinationGoogleMaps> createState() => _DestinationGoogleMapsState();
}

class _DestinationGoogleMapsState extends State<DestinationGoogleMaps> {
  // GoogleMapController? _controller;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 9,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('poi'),
          position: LatLng(widget.latitude, widget.longitude),
        ),
      },
      // onMapCreated: (controller) {
      //   setState(() {
      //     _controller = controller;
      //   });
      // },
    );
  }
}
