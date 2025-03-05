import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPopup extends StatelessWidget {
  final LatLng location;
  
  const MapPopup({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Center(child: Text('Location Map', style: TextStyle(fontSize: 20),)),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: FlutterMap(
          options: MapOptions(initialCenter: location, initialZoom: 15.0),
          children: [
            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
            MarkerLayer(
              markers: [
                Marker(
                  point: location, 
                  width: 50,
                  height: 50,
                  rotate: true,
                  child: const Icon(
                    Icons.location_on, 
                    size: 40, 
                    color: Color(0xFF5D9EEA)
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: const Text('Close', style: TextStyle(color: Colors.black),)
            ),
          ],
        ),
      ],
    );
  }
}