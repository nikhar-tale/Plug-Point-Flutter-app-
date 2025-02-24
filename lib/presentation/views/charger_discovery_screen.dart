// lib/presentation/views/charger_discovery_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/charging_station_viewmodel.dart';
import '../widgets/map_widget.dart';
import 'charger_details_screen.dart';

class ChargerDiscoveryScreen extends ConsumerStatefulWidget {
  const ChargerDiscoveryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChargerDiscoveryScreen> createState() =>
      _ChargerDiscoveryScreenState();
}

class _ChargerDiscoveryScreenState
    extends ConsumerState<ChargerDiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Map<String, dynamic>? _selectedStation;

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(chargingStationViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background map with filtered stations or error widget.
            stationsAsync.when(
              data: (stations) {
                final filteredStations = stations.where((station) {
                  return station.name
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                }).toList();

                // If no stations match the filter, show a "No results" message.
                if (filteredStations.isEmpty) {
                  return Center(
                    child: Text(
                      "No charging stations found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  );
                }

                return MapWidget(
                  stations: filteredStations,
                  onMarkerTap: (station) {
                    setState(() {
                      _selectedStation = {
                        'id': station.id,
                        'name': station.name,
                        'availability': station.availability,
                        // You may add additional fields if needed.
                      };
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Error loading stations:\n$error",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Force a reload by invalidating the provider.
                          ref.refresh(chargingStationViewModelProvider);
                        },
                        child: const Text("Retry"),
                      )
                    ],
                  ),
                );
              },
            ),

            // Top search bar.
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: "Search charging station...",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom horizontally scrolling list of station cards.
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: stationsAsync.when(
                data: (stations) {
                  final filteredStations = stations.where((station) {
                    return station.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  }).toList();

                  if (filteredStations.isEmpty) return const SizedBox();

                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredStations.length,
                      itemBuilder: (context, index) {
                        final station = filteredStations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChargerDetailsScreen(
                                  stationId: station.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 250,
                            margin: EdgeInsets.only(
                              left: index == 0 ? 16 : 8,
                              right:
                                  index == filteredStations.length - 1 ? 16 : 0,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  station.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.bolt,
                                      size: 16,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Fast Charging",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Status:",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                            station.availability == "available"
                                                ? Colors.green
                                                : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        station.availability,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
            ),

            // Optional: Bottom card for selected station when marker is tapped.
            if (_selectedStation != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: 180,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChargerDetailsScreen(
                          stationId: _selectedStation!['id'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row with station name and arrow.
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedStation!['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Additional details: availability, address, connector info.
                        Row(
                          children: [
                            const Icon(Icons.info_outline,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              "Availability: ${_selectedStation!['availability']}",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              _selectedStation!['address'] ??
                                  "No address provided",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.electrical_services,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              _selectedStation!['connector'] ??
                                  "Connector info not available",
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
