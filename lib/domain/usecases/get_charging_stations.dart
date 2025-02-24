// lib/domain/usecases/get_charging_stations.dart
import '../entities/charging_station.dart';
import '../repositories/charging_station_repository.dart';

class GetChargingStations {
  final ChargingStationRepository repository;
  
  GetChargingStations(this.repository);

  Future<List<ChargingStation>> call() async {
    return await repository.getChargingStations();
  }
}
