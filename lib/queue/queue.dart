import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/bus.dart';

class BusQueue extends StatefulWidget {
  const BusQueue({Key? key});

  @override
  BusQueueState createState() => BusQueueState();
}

class BusQueueState extends State<BusQueue> {
  List<BusInfo> _busList = [];

  @override
  void initState() {
    super.initState();
    _loadBusList();
  }

  Future<void> _loadBusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String busJson = prefs.getString('bus_info') ?? '[]';
    List<dynamic> busData = json.decode(busJson);
    List<BusInfo> buses =
        busData.map((data) => BusInfo.fromJson(data)).toList();

    // Sort the list of buses by current capacity in descending order
    buses.sort((a, b) => b.currentCapacity.compareTo(a.currentCapacity));

    setState(() {
      _busList = buses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Queue'),
      ),
      body: _busList.isEmpty
          ? const Center(
              child: Text('No buses available.'),
            )
          : ListView.builder(
              itemCount: _busList.length,
              itemBuilder: (context, index) {
                BusInfo bus = _busList[index];
                return ListTile(
                  title: Text('Bus Number: ${bus.busNumber}'),
                  subtitle: Text(
                      'Current Capacity: ${bus.currentCapacity}/${bus.totalCapacity}'),
                  // Add more details here if needed
                );
              },
            ),
    );
  }
}
