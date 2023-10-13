import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/my_colors.dart';
import '../core/my_text.dart';
import '../models/bus.dart';
import '../models/user.dart';
import '../result/ticket_result.dart';

class BuyTicket extends StatefulWidget {
  const BuyTicket({super.key});

  @override
  BuyTicketState createState() => BuyTicketState();
}

class BuyTicketState extends State<BuyTicket> {
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController bus_no = TextEditingController();
  final TextEditingController destination = TextEditingController();
  final TextEditingController date = TextEditingController();
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
  String selectedBusNumber = 'ET 1234';
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
    firstname.text = "Gemechis";
    lastname.text = "Elias";
    phone.text = "0912345678";
    bus_no.text = "ET 1234";
    destination.text = "Addis Ababa";
    date.text = "2021-10-10";
    _loadBusList();
    selectedBusNumber = _busList.isNotEmpty ? _busList[0].busNumber : 'ET 1234';
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
          title: const Text("Buy Ticket",
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
              Text("FIRST NAME",
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
                    controller: firstname,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("LAST NAME",
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
                    controller: lastname,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(-12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(height: 15),
              Text("PHONE",
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
                    keyboardType: TextInputType.phone,
                    controller: phone,
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
                        Text("BUS NUMBER",
                            style: MyText.body1(context)!
                                .copyWith(color: MyColors.grey_60)),
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
                                    value: selectedBusNumber,
                                    items: _busList.map((BusInfo bus) {
                                      return DropdownMenuItem<String>(
                                        value: bus.busNumber,
                                        child: Text(bus.busNumber),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedBusNumber = newValue ?? '';
                                      });
                                    },
                                    underline:
                                        Container(), // Removes the underline
                                  ),
                                ),
                                // const Icon(Icons.expand_more,
                                //     color: MyColors.grey_40),
                              ],
                            ),
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
                        Text("Date",
                            style: MyText.body1(context)!
                                .copyWith(color: MyColors.grey_60)),
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
                              keyboardType: TextInputType.phone,
                              controller: date,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(-12),
                                border: InputBorder.none,
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
                    User user = User(
                      firstName: firstname.text,
                      lastName: lastname.text,
                      phone: phone.text,
                      date: DateTime.now(),
                      destination: destination.text,
                      busNumber: bus_no.text,
                      uniqueId: Random().nextInt(100000),
                    );
                    BusInfo busInfo = BusInfo(
                      busNumber: 'ET 1234',
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
                    List<User> userList =
                        (json.decode(userJson) as List<dynamic>)
                            .map((item) => User.fromJson(item))
                            .toList();

// Add the new user to the list
                    userList.add(user);

// Store the updated user list back to SharedPreferences
                    prefs.setString('user_registration', json.encode(userList));

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
                      (bus) => bus.busNumber == busNumberToUpdate,
                      orElse: () => BusInfo(
                          busNumber: bus_no.text,
                          totalCapacity: 50,
                          currentCapacity: 0,
                          destination: destination.text),
                    );

                    if (busToUpdate != null) {
                      // Update the current capacity of the appropriate bus
                      busToUpdate.currentCapacity++;

                      // Add the updated bus back to the list
                      busList.removeWhere(
                          (bus) => bus.busNumber == busNumberToUpdate);
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
                          user: user,
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
