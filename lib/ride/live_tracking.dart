import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrackingScreen extends StatelessWidget {
  final String rideId;
  const LiveTrackingScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver On The Way')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rides')
            .doc(rideId)
            .snapshots(),
        builder: (context, rideSnap) {
          if (!rideSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rideData = rideSnap.data!.data() as Map<String, dynamic>;
          final driverId = rideData['driverId'];

          if (driverId == null) {
            return const Center(child: Text('Waiting for driver...'));
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('drivers')
                .doc(driverId)
                .snapshots(),
            builder: (context, driverSnap) {
              if (!driverSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final driverData =
                  driverSnap.data!.data() as Map<String, dynamic>;

              final LatLng driverPos = LatLng(
                driverData['lat'],
                driverData['lng'],
              );

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: driverPos,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('driver'),
                    position: driverPos,
                    infoWindow: const InfoWindow(title: 'Driver'),
                  ),
                },
              );
            },
          );
        },
      ),
    );
  }
}
