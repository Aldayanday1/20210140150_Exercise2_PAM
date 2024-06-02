import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StaticMap extends StatefulWidget {
  final LatLng location;

  const StaticMap({Key? key, required this.location}) : super(key: key);

  @override
  _StaticMapState createState() => _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  late GoogleMapController _mapController;

  @override
  void didUpdateWidget(covariant StaticMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.location != widget.location) {
      _moveCamera(widget.location);
    }
  }

  void _moveCamera(LatLng location) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 17.0),
      ),
    );
  }

  void _centerMapToMarker() {
    _moveCamera(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.location,
              zoom: 17.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: MarkerId('selectedLocation'),
                position: widget.location,
              ),
            },
            trafficEnabled: true,
            rotateGesturesEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
          ),
        ),
        Positioned(
          top: 55.0,
          right: 7.0,
          child: Opacity(
            opacity: 0.7,
            child: FloatingActionButton(
              onPressed: _centerMapToMarker,
              child: Icon(Icons.location_pin),
              backgroundColor: Colors.white,
              mini: true,
            ),
          ),
        ),
      ],
    );
  }
}
