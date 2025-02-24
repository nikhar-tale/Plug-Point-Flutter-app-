// lib/presentation/widgets/map_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/charging_station.dart';

class MapWidget extends StatelessWidget {
  final List<ChargingStation> stations;
  final Function(ChargingStation) onMarkerTap;
  
  const MapWidget(
      {Key? key,
      required this.stations,
      required this.onMarkerTap,
    })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert each station into a Marker with a GestureDetector.
    final markers = stations.map((station) {
      return Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(station.latitude, station.longitude),
        child: GestureDetector(
         
          onTap: () => onMarkerTap(station),
          child: const Icon(
            Icons.location_on,
            color: Colors.green,
            size: 40,
          ),
        ),
      );
    }).toList();

    // Set the initial map center based on the first station (or fallback).
    final initialCenter = stations.isNotEmpty
        ? LatLng(stations[0].latitude, stations[0].longitude)
        : const LatLng(37.7749, -122.4194);

    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        // zoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // attributionWidget: const Text("© OpenStreetMap contributors"),
        ),
        MarkerLayer(
          markers: markers,
        ),
      ],
    );
  }
}
