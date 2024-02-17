// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/data/bus_data.dart';
import 'package:transport_app/main.dart';
import 'package:transport_app/services/fetch_data.dart';
import 'package:transport_app/models/queue_model.dart';
import 'package:transport_app/presentation/widgets/bus_queue_card.dart';

import '../../core/my_colors.dart';
import '../../models/bus.dart';

class BusQueue extends StatefulWidget {
  const BusQueue({Key? key});

  @override
  BusQueueState createState() => BusQueueState();
}

class BusQueueState extends State<BusQueue> {
  List<Vehicle> _busList = [];
  List<QueueModel> _busQueueList = [];
  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    loadBusQueueList();
    print(selectedVehicle?.plateNumber);
  }

  void loadBusQueueList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // for vehicle dropdown
    String vehicleDropdownJson = prefs.getString('vehicle_list') ?? '[]';
    List<dynamic> vehicledropJsonList = json.decode(vehicleDropdownJson);
    _busList = vehicledropJsonList.map((json) => Vehicle.fromJson(json)).toList();

    // for vehicle queue
    String busQueueJson = prefs.getString('bus_queue') ?? '[]';
    List<dynamic> busQueueJsonList = json.decode(busQueueJson);
    _busQueueList = busQueueJsonList.map((json) => QueueModel.fromJson(json)).toList();

    if (_busList.isNotEmpty) {
      selectedVehicle = _busList[0];
      }
      setState(() {});
    }

    void _saveBusToQueue(Vehicle vehicle) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check if the bus is not already in the queue
      if (!_busQueueList.any((bus) => bus.plateNumber == vehicle.plateNumber)) {
        QueueModel newBus = QueueModel(
          plateNumber: vehicle.plateNumber,
          date: DateTime.now().month.toString() +
              '/' +
              DateTime.now().day.toString() +
              '/' +
              DateTime.now().year.toString(),
          time: TimeOfDay.now().format(context),
        );

        _busQueueList.add(newBus);

        // Save the updated list to SharedPreferences
        await prefs.setString('bus_queue',
            json.encode(_busQueueList.map((bus) => bus.toJson()).toList()));

        // Refresh the UI
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Success'.tr()),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        });
      } else {
        // Show a Snackbar if the bus is already in the queue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('failure'.tr()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Future<bool?> showConfirmationDialog() async {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Deletion'.tr()),
            content: Text('Are you sure?'.tr()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(false); // User canceled the deletion
                },
                child: Text('Cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // User confirmed the deletion
                },
                child: Text(
                  'Delete'.tr(),
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    void _removeBusFromQueue(QueueModel bus) async {
      bool? confirmed = await showConfirmationDialog();
      if (confirmed != null && confirmed) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Remove the bus from the list
        _busQueueList.remove(bus);

        // Save the updated list to SharedPreferences
        await prefs.setString('bus_queue',
            json.encode(_busQueueList.map((bus) => bus.toJson()).toList()));

        // Refresh the UI
        setState(() {});
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primary,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Bus Queue'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width * 0.95,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.add_circle,
                    size: 40,
                    color: MyColors.primary,
                  ),
                  const SizedBox(width: 15),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'Select Bus'.tr(),
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Expanded(
                    child: DropdownButton<Vehicle>(
                      value: selectedVehicle,
                      items: _busList.map((Vehicle vehicle) {
                        return DropdownMenuItem<Vehicle>(
                          value: vehicle,
                          child: Text(
                            vehicle.plateNumber,
                          ),
                        );
                      }).toList(),
                      onChanged: (Vehicle? newValue) {
                        setState(() {
                          selectedVehicle = newValue;
                          _saveBusToQueue(selectedVehicle!);
                        });
                      },
                      underline: Container(),
                    ),
                  ),
                ],
              ), // Handle the case when busList is empty
            ),
            const SizedBox(
              height: 20,
            ),
            // Bus Queue Order
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: MyColors.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Vehicle Order'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        _busQueueList.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: _busQueueList.isEmpty
                  ? Center(
                      child: Text(
                        'No Bus in Queue'.tr(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _busQueueList.length,
                      itemBuilder: (context, index) {
                        return BusQueueCardWidget(
                          plateNo: _busQueueList[index].plateNumber,
                          date: _busQueueList[index].date,
                          time: _busQueueList[index].time,
                          onRemove: () =>
                              _removeBusFromQueue(_busQueueList[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    }
  }