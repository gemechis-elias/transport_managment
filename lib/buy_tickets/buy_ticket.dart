import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/my_colors.dart';
import '../core/my_text.dart';
import '../models/bus.dart';
import '../models/ticket.dart';
import '../result/ticket_result.dart';

class BuyTicket extends StatefulWidget {
  // const BuyTicket({super.key});

  @override
  BuyTicketState createState() => BuyTicketState();
}

class BuyTicketState extends State<BuyTicket> {
  final TextEditingController Tailure = TextEditingController();
  final TextEditingController level = TextEditingController();
  final TextEditingController plateNumber = TextEditingController();
  final TextEditingController bus_no = TextEditingController();
  final TextEditingController destination = TextEditingController();
  final TextEditingController departure = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController tariff = TextEditingController();
  final TextEditingController serviceCharge = TextEditingController();

  List<String> sampleDestinations = [
    'Addis Ababa',
    'Bahir Dar',
    'Gondar',
    'Axum',
    'Lalibela',
    'Harar',
    // Add more destinations as needed
  ];
  List<String> Departure = [
    'Addis Ababa',
    'Adama',
    'Bahir Dar',
    'Gondar',
    'Axum',
    'Lalibela',
    'Harar',
    // Add more destinations as needed
  ];
  String selectedDestination = 'Addis Ababa';
  String selectedDeparture = 'Adama';
  String selectedBusNumber = 'ET 1234';
  List<String> busList = [
    'ET 1234',
    'ET 2345',
    'ET 3456',
    'ET 4567',
  ];

  Future<void> _loadBusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String busJson = prefs.getString('bus_info') ?? '[]';
    List<dynamic> busData = json.decode(busJson);
    // List<BusInfo> buses =
    //     busData.map((data) => BusInfo.fromJson(data)).toList();

    // Sort the list of buses by current capacity in descending order
    // buses.sort((a, b) => b.currentCapacity.compareTo(a.currentCapacity));

    // setState(() {
    //   busList = buses;
    // });
  }

  @override
  void initState() {
    super.initState();
    Tailure.text = "Gemechis";
    level.text = "Level 2";
    plateNumber.text = "ET 1234";
    departure.text = "Adama";
    destination.text = "Addis Ababa";

    _loadBusList();
    // selectedBusNumber = busList.isNotEmpty ? busList[0].plateNumber : '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2024),
    );

    if (picked != null && picked != DateTime.now()) {
      // Save only month and year to the text field
      final String formattedDate =
          "${picked.day}/${picked.month}/${picked.year}";
      date.text = formattedDate;
    }
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
          title: Text(
            "Buy Ticket".tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins-Regular',
              fontWeight: FontWeight.bold,
            ),
          ),
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
              Text(
                "Tailor".tr(),
                style: const TextStyle(
                  color: MyColors.grey_60,
                  fontSize: 14,
                  fontFamily: 'Poppins-Light',
                  fontWeight: FontWeight.bold,
                ),
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
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: Tailure,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text(
                "Level".tr(),
                style: const TextStyle(
                  color: MyColors.grey_60,
                  fontSize: 14,
                  fontFamily: 'Poppins-Light',
                  fontWeight: FontWeight.bold,
                ),
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
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: level,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Bus Plate Number".tr(),
                          style: const TextStyle(
                            color: MyColors.grey_60,
                            fontSize: 14,
                            fontFamily: 'Poppins-Light',
                            fontWeight: FontWeight.bold,
                          ),
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
                            height: 50,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: <Widget>[
                                Container(width: 15),
                                Expanded(
                                  child: DropdownButton<String>(
                                    value: selectedBusNumber,
                                    items: busList.map((String plateNumber) {
                                      return DropdownMenuItem<String>(
                                        value: plateNumber,
                                        child: Text(
                                          plateNumber,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins-Light',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedBusNumber = newValue ?? '';
                                        plateNumber.text = newValue!;
                                      });
                                    },
                                    underline: Container(),
                                  ),
                                ),
                              ],
                            ), // Handle the case when busList is empty
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Date".tr(),
                          style: const TextStyle(
                            color: MyColors.grey_60,
                            fontSize: 14,
                            fontFamily: 'Poppins-Light',
                            fontWeight: FontWeight.bold,
                          ),
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
                            height: 50,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              maxLines: 1,
                              // keyboardType: TextInputType.phone,
                              controller: date,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins-Light',
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed: () => _selectDate(context),
                                  color: Color(0xffB2B5BB),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Container(height: 15),
              Text(
                "Departure".tr(),
                style: const TextStyle(
                  color: MyColors.grey_60,
                  fontSize: 14,
                  fontFamily: 'Poppins-Light',
                  fontWeight: FontWeight.bold,
                ),
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
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    children: <Widget>[
                      Container(width: 15),
                      Expanded(
                        child: DropdownButton<String>(
                          value: selectedDeparture,
                          items: Departure.map((String departure) {
                            return DropdownMenuItem<String>(
                              value: departure,
                              child: Text(
                                departure,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDeparture = newValue ?? '';
                              departure.text = newValue!;
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
              Text(
                "Destination".tr(),
                style: const TextStyle(
                  color: MyColors.grey_60,
                  fontSize: 14,
                  fontFamily: 'Poppins-Light',
                  fontWeight: FontWeight.bold,
                ),
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
                  height: 50,
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
                              child: Text(
                                destination,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins-Light',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDestination = newValue ?? '';
                              destination.text = newValue!;
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
              Text(
                "Tariff".tr(),
                style: const TextStyle(
                  color: MyColors.grey_60,
                  fontSize: 14,
                  fontFamily: 'Poppins-Light',
                  fontWeight: FontWeight.bold,
                ),
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
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: tariff,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text(
                "Service Charge".tr(),
                style: const TextStyle(
                  color: MyColors.grey_60,
                  fontSize: 14,
                  fontFamily: 'Poppins-Light',
                  fontWeight: FontWeight.bold,
                ),
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
                  height: 50,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: serviceCharge,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins-Light',
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
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
                  child: Text(
                    "SUBMIT".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins-Regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    //
                    print('Submit button pressed.');
                    print('Plate Number: ${plateNumber.text}');
                    print('departure: ${departure.text}');
                    print('destiation: ${destination.text}');
                    Ticket ticket = Ticket(
                      tailure: Tailure.text,
                      level: level.text,
                      plate: plateNumber.text,
                      date: DateTime.now(),
                      destination: destination.text,
                      departure: departure.text,
                      uniqueId: Random().nextInt(10000000),
                      tariff: double.parse(tariff.text),
                      charge: double.parse(serviceCharge.text),
                    );
                    BusInfo busInfo = BusInfo(
                      plateNumber: 'ET 1234',
                      totalCapacity: 50,
                      currentCapacity: 20,
                      destination: destination.text,
                    );

                    // Retrieve existing user list from SharedPreferences
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String userJson =
                        prefs.getString('user_registration') ?? '[]';

                    // Parse the JSON string to a List of Users
                    List<Ticket> ticketList =
                        (json.decode(userJson) as List<dynamic>)
                            .map((item) => Ticket.fromJson(item))
                            .toList();

                    // Add the new user to the list
                    ticketList.add(ticket);

                    // Store the updated user list back to SharedPreferences
                    prefs.setString(
                        'user_registration', json.encode(ticketList));

                    // ----------------==============================================
                    // Retrieve existing bus list from SharedPreferences
                    String busJson = prefs.getString('bus_info') ?? '[]';

                    // Parse the JSON string to a List of Buses
                    List<BusInfo> busList =
                        (json.decode(busJson) as List<dynamic>)
                            .map((item) => BusInfo.fromJson(item))
                            .toList();

                    // Update the current capacity of the appropriate bus (you need to implement logic to find the correct bus to update)

                    // Add the updated bus back to the list

                    // Assuming you have some logic to find the appropriate bus to update
                    String busNumberToUpdate = bus_no
                        .text; // Replace this with your logic to find the correct bus number to update
                    BusInfo? busToUpdate = busList.firstWhere(
                      (bus) => bus.plateNumber == busNumberToUpdate,
                      orElse: () => BusInfo(
                          plateNumber: bus_no.text,
                          totalCapacity: 50,
                          currentCapacity: 0,
                          destination: destination.text),
                    );

                    if (busToUpdate != null) {
                      // Update the current capacity of the appropriate bus
                      busToUpdate.currentCapacity++;

                      // Add the updated bus back to the list
                      busList.removeWhere(
                          (bus) => bus.plateNumber == busNumberToUpdate);
                      busList.add(busToUpdate);

                      // Store the updated bus list back to SharedPreferences
                      prefs.setString('bus_info', json.encode(busList));
                    } else {
                      print('Bus with number $busNumberToUpdate not found.');
                    }

                    // Store the updated bus list back to SharedPreferences
                    prefs.setString('bus_info', json.encode(busList));

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          ticket: ticket,
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
