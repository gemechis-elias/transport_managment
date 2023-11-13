import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/result/bus_result.dart';
import '../core/my_colors.dart';
import '../core/my_text.dart';
import '../models/bus.dart';
import '../models/user.dart';
import '../result/ticket_result.dart';

class AddBus extends StatefulWidget {
  // const AddBus({super.key});

  @override
  AddBusState createState() => AddBusState();
}

class AddBusState extends State<AddBus> {
  final TextEditingController busNumber = TextEditingController();
  final TextEditingController totalCapacity = TextEditingController();
  final TextEditingController destination = TextEditingController();
  final TextEditingController currentCapacity = TextEditingController();
  List<String> sampleDestinations = [
    'Addis Ababa',
    'Bahir Dar',
    'Gondar',
    'Axum',
    'Lalibela',
    'Harar',
    // Add more destinations as needed
  ];
  String selectedDestination = 'Addis Ababa';
  List<BusInfo> _busList = [];

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
  void initState() {
    super.initState();
    _loadBusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
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
          title: const Text("Add Bus",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("BUS NUMBER",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: busNumber,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("TOTAL CAPACITY",
                  style:
                      MyText.body1(context)!.copyWith(color: MyColors.grey_60)),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: totalCapacity,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text(
                "DESTINATION",
                style: MyText.body1(context)!.copyWith(color: MyColors.grey_60),
              ),
              Container(height: 5),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: const EdgeInsets.all(0),
                elevation: 0,
                child: Container(
                  height: 40,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Container(width: 15),
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedDestination,
                          items: sampleDestinations.map((String destination) {
                            return DropdownMenuItem<String>(
                              value: destination,
                              child: Text(destination),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDestination = newValue ?? '';
                            });
                          },
                          underline: Container(), // Removes the underline
                        ),
                      ),
                      // const Icon(Icons.expand_more, color: MyColors.grey_40),
                    ],
                  ),
                ),
              ),
              Container(height: 15),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary, elevation: 0),
                  child: Text("SUBMIT",
                      style: MyText.subhead(context)!
                          .copyWith(color: Colors.white)),
                  onPressed: () async {
                    //

                    BusInfo busInfo = BusInfo(
                      busNumber: busNumber.text,
                      totalCapacity: int.parse(totalCapacity.text),
                      currentCapacity: 0,
                      destination: selectedDestination,
                    );

                    // Retrieve existing user list from SharedPreferences
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    String busJson = prefs.getString('bus_info') ?? '[]';

// Parse the JSON string to a List of Buses
                    List<BusInfo> busList =
                        (json.decode(busJson) as List<dynamic>)
                            .map((item) => BusInfo.fromJson(item))
                            .toList();

                    busList.add(busInfo);

                    // Store the updated bus list back to SharedPreferences
                    prefs.setString('bus_info', json.encode(busList));

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusResult(
                          bus: busInfo,
                        ), //
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
