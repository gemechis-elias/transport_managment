import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/data/bus_data.dart';
import '../../core/my_colors.dart';
import '../../core/my_text.dart';
import '../../models/bus.dart';
import '../../models/ticket.dart';
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
  final TextEditingController no_of_ticket = TextEditingController();

  String? TicketTailer;
  int totalCapacity = carlist[0].totalCapacity;
  List<Vehicle> _busList = [];
  List<String> destinationList = [];
  List<String> departureList = [];
  // intial value variables
  Vehicle? selectedVehicle;
  String? selectedDestination;
  String? selectedDeparture;
  

  // Future<void> _loadBusList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String busJson = prefs.getString('bus_info') ?? '[]';
  //   List<dynamic> busData = json.decode(busJson);
  // List<BusInfo> buses =
  //     busData.map((data) => BusInfo.fromJson(data)).toList();

  // Sort the list of buses by current capacity in descending order
  // buses.sort((a, b) => b.currentCapacity.compareTo(a.currentCapacity));

  // setState(() {
  //   busList = buses;
  // });
  // }

  @override
  void initState() {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    super.initState();
    level.text = "Level 2";
    _loadBusQueueList();
    _loadDestinationList();
    _loadDepartureList();
    _loadTailerData();
    date.text = currentDate;
  }
  void _loadTailerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tailorpref = prefs.getString('username') ?? '[]';


    if (tailorpref.isNotEmpty) {
      Tailure.text = tailorpref!;
    } else {
      print('desparture list is empty');
    }
    setState(() {});
  }


  void _loadDepartureList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String departurepref = prefs.getString('departure') ?? '[]';

    print('departurepref:==== $departurepref');

    if (departurepref.isNotEmpty) {
      selectedDeparture = departurepref;
      departure.text = selectedDeparture!;
    } else {
      print('desparture list is empty');
    }
    setState(() {});
  }

  void _loadBusQueueList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String busQueueJson = prefs.getString('bus_queue') ?? '[]';
    List<dynamic> busQueueJsonList = json.decode(busQueueJson);
    _busList = busQueueJsonList.map((json) => Vehicle.fromJson(json)).toList();

    if (_busList.isNotEmpty) {
      selectedVehicle = _busList[0];
      plateNumber.text = _busList[0].plateNumber;
    }
    setState(() {});
  }

  void _loadDestinationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String destinationpref = prefs.getString('destination_list') ?? '[]';
    List<dynamic> decodedList = json.decode(destinationpref);
    destinationList.addAll(decodedList.cast<String>());

    if (destinationList.isNotEmpty) {
      selectedDestination = destinationList[0];
      destination.text = destinationList[0];
    } else {
      print('destination list is empty');
    }
    setState(() {});
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
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tailor".tr(),
                        style: const TextStyle(
                          color: MyColors.grey_60,
                          fontSize: 14,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: const EdgeInsets.all(0),
                        elevation: 0,
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.topRight,
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
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: [
                       Text(
                        "No of ticket".tr(),
                        style: const TextStyle(
                          color: MyColors.grey_60,
                          fontSize: 14,
                          fontFamily: 'Poppins-Light',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        margin: const EdgeInsets.all(0),
                        elevation: 0,
                        child: Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: no_of_ticket,
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
                    ],
                  ),
                ],
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
                                  child: DropdownButton<Vehicle>(
                                    value: selectedVehicle,
                                    items: _busList.map((Vehicle vehicle) {
                                      return DropdownMenuItem<Vehicle>(
                                        value: vehicle,
                                        child: Text(
                                          vehicle.plateNumber,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Poppins-Light',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (Vehicle? newValue) {
                                      setState(() {
                                        selectedVehicle = newValue;
                                        plateNumber.text =
                                            selectedVehicle!.plateNumber;
                                        totalCapacity =
                                            selectedVehicle!.totalCapacity;
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
                  width: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLines: 1,
                    controller: departure,
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
                          items: destinationList.map((String destination) {
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
                    print(
                        'Selected vehicle capacity is  ========>$totalCapacity');
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
                    Vehicle busInfo = Vehicle(
                      plateNumber: 'ET 1234',
                      totalCapacity: 50,
                    );

                    // Retrieve existing user list from SharedPreferences
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String userJson = prefs.getString('user_registration') ?? '[]';

                    // Parse the JSON string to a List of Users
                    List<Ticket> ticketList =
                        (json.decode(userJson) as List<dynamic>)
                            .map((item) => Ticket.fromJson(item)).toList();

                    // Add the new user to the list
                    ticketList.add(ticket);

                    // Store the updated user list back to SharedPreferences
                    prefs.setString('user_registration', json.encode(ticketList));

                    // ----------------==============================================
                    // Retrieve existing bus list from SharedPreferences
                    String busJson = prefs.getString('bus_info') ?? '[]';

                    // Parse the JSON string to a List of Buses
                    List<Vehicle> busList =
                        (json.decode(busJson) as List<dynamic>)
                            .map((item) => Vehicle.fromJson(item)).toList();

                    // Update the current capacity of the appropriate bus (you need to implement logic to find the correct bus to update)

                    // Add the updated bus back to the list

                    // Assuming you have some logic to find the appropriate bus to update
                    String busNumberToUpdate = bus_no
                        .text; // Replace this with your logic to find the correct bus number to update
                    Vehicle? busToUpdate = busList.firstWhere(
                      (bus) => bus.plateNumber == busNumberToUpdate,
                      orElse: () => Vehicle(
                        plateNumber: bus_no.text,
                        totalCapacity: 50,
                      ),
                    );

                    if (busToUpdate != null) {
                      // Update the current capacity of the appropriate bus
                      // busToUpdate.currentCapacity++;

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

                    //=======  Check if there is available space left for the selelected Vehicle =======//
                    int previousTicketCount = prefs.getInt(ticket.plate) ?? 0;
                    print(
                        'Selected vehicle Previous Ticket sold is  ========>$previousTicketCount');
                    int currentTicketCount =
                        previousTicketCount + int.parse(no_of_ticket.text);

                    if (currentTicketCount <= totalCapacity) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            numberOfTickets: int.parse(no_of_ticket.text),
                            ticket: ticket,
                            totalCapacity: totalCapacity,
                          ),
                        ),
                      );
                    } else {
                      print('=========> currentTicketCount');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "You only left with ${totalCapacity - previousTicketCount} available"),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
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
