import 'package:flutter/material.dart';
import 'package:transport_app/result/printer_page.dart';
import '../core/my_colors.dart';
import '../core/my_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/user.dart';

class ResultPage extends StatefulWidget {
  final User user;
  const ResultPage({required this.user});

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.grey_5,
      appBar: AppBar(
          backgroundColor: Colors.green,
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrinterPage(user: widget.user),
                  ),
                );
              },
            ),
          ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            children: [
              // User infomration Name: name, Phone: phone, Bus Number: busNumber and Seat Number: seatNumber
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
                        Text("Passenger Information",
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
                        const Text("Name: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.user.firstName + " " + widget.user.lastName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Phone: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.user.phone,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Bus Number: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.user.busNumber,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                    const Row(
                      children: [
                        Text("Seat Number: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text("10",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Unique ID: ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(widget.user.uniqueId.toString(),
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
                      data: widget.user.uniqueId.toString(),
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  )),

              const SizedBox(height: 10),

              // Bon Voyage Text
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _printPdf() async {
  //   final PdfPageFormat format = PdfPageFormat.a4;
  //   final Uint8List pdfBytes = await generatePdf(format, widget.user);

  //   // Use the Printing class to send the PDF to the printer
  //   await Printing.layoutPdf(
  //     onLayout: (PdfPageFormat format) async => pdfBytes,
  //     name: 'Your_Print_Job_Name', // Give your print job a name
  //   );
  // }
}
