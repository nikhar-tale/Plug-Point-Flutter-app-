// lib/presentation/viewmodels/charging_station_viewmodel.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/charging_station.dart';
import '../../domain/usecases/get_charging_stations.dart';
import '../../data/repositories/charging_station_repository_impl.dart';

final chargingStationViewModelProvider = StateNotifierProvider<ChargingStationViewModel, AsyncValue<List<ChargingStation>>>((ref) {
  return ChargingStationViewModel(GetChargingStations(ChargingStationRepositoryImpl()));
});

class ChargingStationViewModel extends StateNotifier<AsyncValue<List<ChargingStation>>> {
  final GetChargingStations getChargingStations;
  Timer? _timer;

  ChargingStationViewModel(this.getChargingStations) : super(const AsyncLoading()) {
    loadStations();
    // Poll every 30 seconds for updated data.
    _timer = Timer.periodic(Duration(seconds: 30), (_) => loadStations());
  }

  Future<void> loadStations() async {
    
    try {
      final stations = await getChargingStations();
      state = AsyncData(stations);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
