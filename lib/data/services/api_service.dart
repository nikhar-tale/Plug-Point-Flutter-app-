// lib/data/services/api_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class ApiService {
  static Future<List<dynamic>> fetchChargingStations() async {
    final response = await http.get(Uri.parse('$backendUrl/chargingStations'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      // print(
      //     'Failed to load charging stations from backend, loading from local');
      // return await loadChargingStations();
      throw Exception('Failed to load charging stations');
    }
  }

  static Future<Map<String, dynamic>> fetchChargerDetails(String id) async {
    final response =
        await http.get(Uri.parse('$backendUrl/chargingStations/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // print(
      //     'Failed to load charging stations with id $id from backend, loading from local');
      // return await loadChargingStations(id: id);
      throw Exception('Error fetching station details');
    }
  }

  static Future<dynamic> loadChargingStations({String? id}) async {
    final String response =
        await rootBundle.loadString('assets/charging_stations.json');
    final List<dynamic> data = json.decode(response);

    if (id != null) {
      // Return the matched object or null if not found
      return data.firstWhere((station) => station['id'] == id,
          orElse: () => null);
    }

    // If id is null, return the whole list
    return data;
  }
}
