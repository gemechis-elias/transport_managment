import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/main.dart';
import 'package:transport_app/models/bus.dart';
import 'package:transport_app/models/data.dart';
import 'package:transport_app/models/queue_model.dart';

class DataService {
  static const String baseUrl =
      "https://api.horansoftware.com/api/public/api/updates";

  Future<void> fetchData() async {
    // hive box implementation
    // final Box<String> vehiclesBox = Hive.box<String>(vehiclesList);

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // String token = prefs.getString('access_token') ?? '';
    await Hive.openBox<String>(tokenHive);
    final String? token = Hive.box<String>(tokenHive).get('token');
    await Hive.close();
    print('ቶክኑ: $token');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == true) {
        final vehicleListJson =
            await responseData['data']['data'][0]['vehicle_list'];
        final destinationList =
            await responseData['data']['data'][0]['destination'];
        final departure = await responseData['data']['data'][0]['departure'];
        // Check if the response has a 'vehicle_list' key
        if (vehicleListJson != null) {
          // ==========  convert String to List<Vehicle>  ========== //
          List<Vehicle> carList = convertRegexToVehicleList(vehicleListJson);

          List<QueueModel> busQueueList = [];

          if (busQueueList.isEmpty) {
            for (Vehicle vehicle in carList) {
              // print('plate number: ${vehicle.plateNumber}');
              busQueueList.add(QueueModel(
                plateNumber: vehicle.plateNumber,
                date:
                    '${DateTime.now().month.toString()}/${DateTime.now().day.toString()}/${DateTime.now().year.toString()}',
                time:
                    "${TimeOfDay.now().hour.toString()}:${TimeOfDay.now().minute.toString()}",
              ));
            }

            // hive put
            // vehiclesBox.put('bus_queue',
            //     json.encode(busQueueList.map((bus) => bus.toJson()).toList()));

            // Save the updated list to SharedPreferences
            await prefs.setString(
              'bus_queue',
              json.encode(busQueueList.map((bus) => bus.toJson()).toList()),
            );
            await prefs.setString(
              'vehicle_list',
              json.encode(busQueueList.map((bus) => bus.toJson()).toList()),
            );
          }
        }
        // check if the response has Destination List and add to sharedpreference
        if (destinationList != null) {
          List<String> destination =
              convertRegexToDestinationList(destinationList);
          String destinationString = json.encode(destination);
          await prefs.setString('destination_list', destinationString);
        }
        // check departure add to sharedpreference
        if (departure != null) {
          // String departureString = json.encode(departure);
          await prefs.setString('departure', departure);
        }
      } else {
        print("error: *********> $responseData");
        final errorMessage =
            responseData['message'] as String? ?? 'Unknown error';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("error::++++++++++> $e");
      throw Exception('An error occurred: $e');
    }
  }
}

// Regex to extract plate numbers from the response
List<Vehicle> convertRegexToVehicleList(String regexString) {
  List<String> plateNumbers = [];

  // Extract plate numbers from the regex string
  RegExp plateNumberRegex = RegExp(r'"([^"]*)"');
  Iterable<Match> matches = plateNumberRegex.allMatches(regexString);

  for (Match match in matches) {
    plateNumbers.add(match.group(1)!);
  }
  // Create a list of Vehicle objects
  List<Vehicle> vehicleList = plateNumbers.map((plateNumber) {
    return Vehicle(
      plateNumber: plateNumber,
      totalCapacity: 20, // Set the default total capacity as needed
    );
  }).toList();

  return vehicleList;
}

List<String> convertRegexToDestinationList(String regexString) {
  List<String> destinations = [];

  // Extract plate numbers from the regex string
  RegExp destinationRegex = RegExp(r'"([^"]*)"');
  Iterable<Match> matches = destinationRegex.allMatches(regexString);

  for (Match match in matches) {
    destinations.add(match.group(1)!);
  }

  return destinations;
}
