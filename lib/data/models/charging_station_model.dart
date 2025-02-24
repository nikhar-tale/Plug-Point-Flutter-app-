// lib/data/models/charging_station_model.dart
import '../../domain/entities/charging_station.dart';

class ChargingStationModel extends ChargingStation {
  ChargingStationModel({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required String availability,
    required String details,

    // New fields
    required String address,
    required String imageUrl,
    required String chargePower,
    required String openHours,
    required String distance,
    required String plugAvailable,
  }) : super(
          id: id,
          name: name,
          latitude: latitude,
          longitude: longitude,
          availability: availability,
          details: details,
          address: address,
          imageUrl: imageUrl,
          chargePower: chargePower,
          openHours: openHours,
          distance: distance,
          plugAvailable: plugAvailable,
        );

  factory ChargingStationModel.fromJson(Map<String, dynamic> json) {
    // We’ll use the null-coalescing operator (??) to provide default values if a field is missing.
    return ChargingStationModel(
      id: json['id'],
      name: json['name'],
      latitude: (json['location']['lat'] as num).toDouble(),
      longitude: (json['location']['lng'] as num).toDouble(),
      availability: json['availability'],
      details: json['details'],

      // New fields
      address: json['address'] ?? "No address provided",
      imageUrl: json['imageUrl'] ?? "",
      chargePower: json['chargePower'] ?? "",
      openHours: json['openHours'] ?? "",
      distance: json['distance'] ?? "",
      plugAvailable: json['plugAvailable'] ?? "",
    );
  }
}
