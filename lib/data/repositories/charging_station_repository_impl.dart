// lib/data/repositories/charging_station_repository_impl.dart

import 'package:plug_point/domain/entities/charging_station.dart';
import 'package:plug_point/domain/repositories/charging_station_repository.dart';

import '../models/charging_station_model.dart';
import '../services/api_service.dart';

class ChargingStationRepositoryImpl implements ChargingStationRepository {
  @override
  Future<List<ChargingStation>> getChargingStations() async {
    final data = await ApiService.fetchChargingStations();
    return data.map((e) => ChargingStationModel.fromJson(e)).toList();
  }

  @override
  Future<ChargingStation> getChargerDetails(String id) async {
    final data = await ApiService.fetchChargerDetails(id);
    return ChargingStationModel.fromJson(data);
  }
}
