// lib/domain/entities/charging_station.dart

class ChargingStation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String availability;
  final String details;

  // Additional fields
  final String address;
  final String imageUrl;
  final String chargePower;
  final String openHours;
  final String distance;
  final String plugAvailable;

  ChargingStation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.availability,
    required this.details,
    required this.address,
    required this.imageUrl,
    required this.chargePower,
    required this.openHours,
    required this.distance,
    required this.plugAvailable,
  });
}
