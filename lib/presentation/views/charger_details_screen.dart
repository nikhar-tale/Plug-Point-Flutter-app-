// lib/presentation/views/charger_details_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/usecases/get_charger_details.dart';
import '../../data/repositories/charging_station_repository_impl.dart';

class ChargerDetailsScreen extends StatefulWidget {
  final String stationId;
  const ChargerDetailsScreen({Key? key, required this.stationId})
      : super(key: key);

  @override
  _ChargerDetailsScreenState createState() => _ChargerDetailsScreenState();
}

class _ChargerDetailsScreenState extends State<ChargerDetailsScreen> {
  Map<String, dynamic>? stationDetails;
  bool isLoading = true;
  String? errorMessage;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchStationDetails();
    // Poll every 30 seconds for updates.
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchStationDetails();
    });
  }

  Future<void> _fetchStationDetails() async {
    try {
      final getChargerDetails =
          GetChargerDetails(ChargingStationRepositoryImpl());
      final details = await getChargerDetails(widget.stationId);
      setState(() {
        stationDetails = {
          'name': details.name,
          'address': details.address,
          'imageUrl': details.imageUrl,
          'chargePower': details.chargePower,
          'openHours': details.openHours,
          'distance': details.distance,
          'plugAvailable': details.plugAvailable,
          'availability': details.availability,
          'details': details.details,
        };
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching details: $e";
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: errorMessage != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = null;
                      });
                      _fetchStationDetails();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top image
                  _buildStationImage(),
                  const SizedBox(height: 16),
                  // Station name and address
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stationDetails!['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stationDetails!['address'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Facilities section title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Facilities Available",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Facility items
                  _buildFacilityItem(
                    icon: Icons.flash_on,
                    label: "Charge Power",
                    value: stationDetails!['chargePower'] ?? "N/A",
                  ),
                  _buildFacilityItem(
                    icon: Icons.access_time,
                    label: "Open Hours",
                    value: stationDetails!['openHours'] ?? "N/A",
                  ),
                  _buildFacilityItem(
                    icon: Icons.directions_walk,
                    label: "Distance",
                    value: stationDetails!['distance'] ?? "N/A",
                  ),
                  _buildFacilityItem(
                    icon: Icons.power_outlined,
                    label: "Plug Available",
                    value: stationDetails!['plugAvailable'] ?? "N/A",
                  ),
                  const SizedBox(height: 20),
                  // "Get directions" button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Implement directions action here.
                        },
                        child: const Text(
                          "Get directions",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        "Back",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: false,
    );
  }

  Widget _buildStationImage() {
    final imageUrl = stationDetails!['imageUrl'];
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: Image.asset(
        'assets/images/charger_placeholder.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFacilityItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
