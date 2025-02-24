// lib/domain/usecases/get_charger_details.dart
import '../entities/charging_station.dart';
import '../repositories/charging_station_repository.dart';

class GetChargerDetails {
  final ChargingStationRepository repository;

  GetChargerDetails(this.repository);

  Future<ChargingStation> call(String id) async {
    return await repository.getChargerDetails(id);
  }
}
