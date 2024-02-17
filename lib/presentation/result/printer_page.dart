import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/models/queue_model.dart';
import 'package:transport_app/models/report.dart';
import 'package:transport_app/models/ticket.dart';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:transport_app/presentation/buy_tickets/buy_ticket.dart';
import 'package:transport_app/presentation/result/queue_printer.dart';

class PrinterPage extends StatefulWidget {
  final int totalCapacity;
  final int numberOfTickets;
  final Ticket ticket;
  const PrinterPage(
      {super.key,
      required this.ticket,
      required this.numberOfTickets,
      required this.totalCapacity});
  @override
  _PrinterPageState createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;

            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  // === Method that used to print multiple ticket ====
  List<LineText> generateTicketContent() {
    List<LineText> list = [];
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '**********************************************',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'BUS TICKET',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      fontZoom: 2,
      linefeed: 1,
    ));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '----------Ticket--------------',
      weight: 1,
      align: LineText.ALIGN_CENTER,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Ticket No:- ....... ${widget.ticket.uniqueId}',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 40,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Plate Number:- .... ${widget.ticket.plate}',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 60,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: "Tailer:- ....... ${widget.ticket.tailure}",
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 80,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content:
          'Date:- ........ ${widget.ticket.date.day}-${widget.ticket.date.month}-${widget.ticket.date.year}',
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 100,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Departure:- ........ ${widget.ticket.departure}',
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 120,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Destination:- ........ ${widget.ticket.destination}',
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 140,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Level:- ............ ${widget.ticket.level}',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 160,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Tariff: .............. ${widget.ticket.tariff}',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 180,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Service charge:- ......${widget.ticket.charge}',
      weight: 1,
      align: LineText.ALIGN_LEFT,
      x: 0,
      y: 200,
      relativeX: 0,
      linefeed: 1,
    ));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(
      LineText(
        type: LineText.TYPE_BARCODE,
        align: LineText.ALIGN_CENTER,
        size: 10,
        x: 10,
        y: 230,
        content: '${widget.ticket.uniqueId}\n',
      ),
    );
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '**********************************************',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    return list;
  }

  Future<void> printMultipleTickets(int numberOfTickets) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tailorpref = prefs.getString('username') ?? '[]';
    Map<String, dynamic> config = Map();

    for (int i = 0; i < numberOfTickets; i++) {
      List<LineText> ticketContent = generateTicketContent();
      await printTicket(config, ticketContent);   // <<======== uncomment this to print

      // Store vehicle ticket count
      String plateNumber = widget.ticket.plate;
      int currentCount = prefs.getInt(plateNumber) ?? 0;
      prefs.setInt(plateNumber, currentCount + 1);

      int count = prefs.getInt(widget.ticket.plate) ?? 0;
      print('Selected vehicle ticket current count ========>$count');

      if (widget.totalCapacity == count) {
        String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
        // Create a ReportModel
        ReportModel report = ReportModel(
          name: tailorpref, // Add the actual name
          amount: count, // Add the actual amount
          date: currentDate, // Add the actual date
          plate: plateNumber,
        );
        // Save the ReportModel locally using shared_preferences
        _saveReportLocally(report);

        // prefs.remove(plateNumber);
        _removeBusFromQueueByPlateNumber(plateNumber);
        prefs.setInt(plateNumber, 0);

        // === > go to queue print page
        // ignore: use_build_context_synchronously
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => QueuePrinter(
        //       arrivalTime: '',
        //       departureTime: '',
        //       plate: plateNumber,
        //       route: widget.ticket.destination,
        //       departure: widget.ticket.destination,
        //       distance: ,
        //     ),
        //   ),
        // );
      }
    }
  }

  void _saveReportLocally(ReportModel report) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> reportsJson = prefs.getStringList('reports') ?? [];
    reportsJson.add(jsonEncode(report.toJson()));
    prefs.setStringList('reports', reportsJson);
  }

  void _removeBusFromQueueByPlateNumber(String plateNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String busQueueJson = prefs.getString('bus_queue') ?? '[]';
    List<dynamic> busQueueJsonList = json.decode(busQueueJson);
    List<QueueModel> _busQueueList =
        busQueueJsonList.map((json) => QueueModel.fromJson(json)).toList();

    // Find the bus in the list with the specified plateNumber
    QueueModel? busToRemove = _busQueueList.firstWhere(
      (bus) => bus.plateNumber == plateNumber,
      orElse: () => throw StateError('Bus not found'),
    );

    // If the bus is found, remove it from the list
    if (busToRemove != null) {
      _busQueueList.remove(busToRemove);

      // Save the updated list to SharedPreferences
      await prefs.setString(
        'bus_queue',
        json.encode(_busQueueList.map((bus) => bus.toJson()).toList()),
      );

      // Refresh the UI
      setState(() {});
    }
  }

  Future<void> printTicket(
    Map<String, dynamic> config,
    List<LineText> ticketContent,
  ) async {
    await bluetoothPrint.printReceipt(config, ticketContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BuyTicket(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        title: const Text('Printing Page'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(tips),
                  ),
                ],
              ),
              const Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (d) => ListTile(
                          title: Text(d.name ?? ''),
                          subtitle: Text(d.address ?? ''),
                          onTap: () async {
                            setState(() {
                              _device = d;
                            });
                          },
                          trailing:
                              _device != null && _device!.address == d.address
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                        ),
                      )
                      .toList(),
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_device != null &&
                                      _device!.address != null) {
                                    setState(() {
                                      tips = 'connecting...';
                                    });
                                    await bluetoothPrint.connect(_device!);
                                  } else {
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                    print('please select device');
                                  }
                                },
                          child: const Text('connect'),
                        ),
                        const SizedBox(width: 10.0),
                        OutlinedButton(
                          onPressed: _connected
                              ? () async {
                                  setState(() {
                                    tips = 'disconnecting...';
                                  });
                                  await bluetoothPrint.disconnect();
                                }
                              : null,
                          child: const Text('disconnect'),
                        ),
                      ],
                    ),
                    const Divider(),
                    OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              Map<String, dynamic> config = Map();
                              List<LineText> list = [];
                              // await bluetoothPrint.printReceipt(config, list);
                              await printMultipleTickets(
                                  widget.numberOfTickets);
                            }
                          : null,
                      child: const Text('print receipt'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data == true) {
            return FloatingActionButton(
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              child: const Icon(Icons.search),
              onPressed: () =>
                  bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
            );
          }
        },
      ),
    );
  }
}
