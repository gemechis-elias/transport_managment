// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:qr_flutter/qr_flutter.dart';

import 'package:transport_app/models/ticket.dart';

class QueuePrinter extends StatefulWidget {
  String arrivalTime;
  String departureTime;
  String plate;
  String route;
  String departure;
  double distance;
  QueuePrinter({
    Key? key,
    required this.arrivalTime,
    required this.departureTime,
    required this.plate,
    required this.route,
    required this.departure,
    required this.distance,
  }) : super(key: key);

  @override
  _QueuePrinterState createState() => _QueuePrinterState();
}

class _QueuePrinterState extends State<QueuePrinter> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Queue Printer'),
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
                            setState(
                              () {
                                _device = d;
                              },
                            );
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
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
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
                                    setState(
                                      () {
                                        tips = 'connecting...';
                                      },
                                    );
                                    await bluetoothPrint.connect(_device!);
                                  } else {
                                    setState(
                                      () {
                                        tips = 'please select device';
                                      },
                                    );
                                    print('please select device');
                                  }
                                },
                          child: const Text('connect'),
                        ),
                        const SizedBox(width: 10.0),
                        OutlinedButton(
                          onPressed: _connected
                              ? () async {
                                  setState(
                                    () {
                                      tips = 'disconnecting...';
                                    },
                                  );
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
                              List<LineText> list1 = [];

                              list.add(
                                LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '================================',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1,
                                ),
                              );
                              list.add(
                                LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'Tikeetii Bahumsaa/ Exit Ticket',
                                  weight: 2,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1,
                                ),
                              );

                              list.add(LineText(linefeed: 1));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    "Arrival Time/Sa'aatii itti seene: ${widget.arrivalTime}",
                                weight: 1,
                                align: LineText.ALIGN_CENTER,
                                linefeed: 1,
                              ));

                              list.add(
                                LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      "Departure Time/Sa'aatii itti bahe: ${widget.departureTime}",
                                  weight: 1,
                                  align: LineText.ALIGN_LEFT,
                                  x: 0,
                                  y: 40,
                                  relativeX: 0,
                                  linefeed: 1,
                                ),
                              );
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content:
                                    'Plate/ Lakkoofsa Gabatee: ${widget.plate}',
                                weight: 1,
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 60,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: "Route/ Buufata: ${widget.route}",
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
                                    'Arrival/ Magaalaa Gahumsaa: ${widget.departure}',
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 100,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'Distance/Fageenya: ${widget.distance} KM',
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 120,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(
                                LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: '==============================',
                                  align: LineText.ALIGN_LEFT,
                                  x: 0,
                                  y: 140,
                                  relativeX: 0,
                                  linefeed: 0,
                                ),
                              );
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(linefeed: 1));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'Huubachiisa:Tikeetin kun emala yeroo',
                                weight: 1,
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 160,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'tokkoo qofaaf tajaajila!',
                                weight: 1,
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 180,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(
                                LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'Note: This exit ticket is for one trip only',
                                  weight: 1,
                                  align: LineText.ALIGN_LEFT,
                                  x: 0,
                                  y: 200,
                                  relativeX: 0,
                                  linefeed: 1,
                                ),
                              );

                              list.add(LineText(linefeed: 1));
                              list.add(LineText(linefeed: 1));

                              await bluetoothPrint.printReceipt(config, list1);
                            }
                          : null,
                      child: const Text('print receipt'),
                    ),
                  ],
                ),
              )
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
