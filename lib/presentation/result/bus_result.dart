import 'package:flutter/material.dart';
import 'package:transport_app/models/bus.dart';
import '../../core/my_colors.dart';
import '../../core/my_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BusResult extends StatefulWidget {
  final Vehicle car;
  const BusResult({required this.car});

  @override
  BusResultState createState() => BusResultState();
}

class BusResultState extends State<BusResult> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.grey_5,
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 25, 210, 96),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text("Result",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.print,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ]),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            scrollDirection: Axis.vertical,
            child: Container(
                child: Column(
              children: [
                // BusInfo infomration Name: name, Phone: phone, Bus Number: busNumber and Seat Number: seatNumber
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text("Bus Exit Pass",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Bus Plate Number: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(widget.car.plateNumber,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     const Text("Destination: ",
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.bold)),
                      //     Text(widget.car.destination,
                      //         style: const TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.normal)),
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     const Text("Total Passengers: ",
                      //         style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.bold)),
                      //     Text(widget.car.currentCapacity.toString(),
                      //         style: const TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.normal)),
                      //   ],
                      // ),
                      Row(
                        children: [
                          const Text("Total Capacity: ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(widget.car.totalCapacity.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ],
                  ),
                ),

                // QR Code
                const SizedBox(height: 20),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 40, bottom: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: QrImageView(
                        data: widget.car.plateNumber.toString(),
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    )),

                const SizedBox(height: 10),

                // Bon Voyage Text
              ],
            ))));
  }
}
