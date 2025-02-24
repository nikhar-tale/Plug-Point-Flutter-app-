// lib/domain/repositories/charging_station_repository.dart
import '../entities/charging_station.dart';

abstract class ChargingStationRepository {
  Future<List<ChargingStation>> getChargingStations();
  Future<ChargingStation> getChargerDetails(String id);
}
