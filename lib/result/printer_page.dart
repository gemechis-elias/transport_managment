import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transport_app/models/user.dart';
import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';

class PrinterPage extends StatefulWidget {
  final User user;
  const PrinterPage({super.key, required this.user});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      '**********************************************',
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
                                content:
                                    'For:- ${widget.user.firstName} ${widget.user.lastName}',
                                weight: 1,
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 20,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: "Tailer:- Abel Abebe",
                                weight: 1,
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 40,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'phone No:- ${widget.user.phone}',
                                weight: 1,
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 60,
                                relativeX: 0,
                                linefeed: 1,
                              ));

                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'Bus No:- ${widget.user.busNumber}',
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 80,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'Date:- ${widget.user.date}',
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 100,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: 'Unique No:- ${widget.user.uniqueId}',
                                align: LineText.ALIGN_LEFT,
                                x: 0,
                                y: 120,
                                relativeX: 0,
                                linefeed: 1,
                              ));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      'Destination:- ${widget.user.destination}',
                                  align: LineText.ALIGN_LEFT,
                                  x: 0,
                                  y: 140,
                                  relativeX: 0,
                                  linefeed: 0));

                              //  converting user ticket id into base64Image
                              // List<int> bytes = utf8.encode('${widget.user.uniqueId}');
                              // ByteData byteData = ByteData.view(Uint8List.fromList(bytes).buffer);
                              // List<int> imageBytes = byteData.buffer.asUint8List(byteData.offsetInBytes,byteData.lengthInBytes);
                              // String base64Image = base64Encode(imageBytes);
                              // List<int> bytes =
                              //     utf8.encode('${widget.user.uniqueId}');
                              // String qrCodeData = utf8.decode(bytes);
                              list.add(
                                LineText(
                                  type: LineText.TYPE_BARCODE,
                                  align: LineText.ALIGN_CENTER,
                                  x: 10,
                                  y: 190,
                                  content: '${widget.user.uniqueId}\n',
                                ),
                              );
                              list.add(LineText(
                                type: LineText.TYPE_QRCODE,
                                content: '${widget.user.uniqueId}\n',
                                align: LineText.ALIGN_CENTER,
                                x: 0,
                                y: 200,
                                size: 10,
                              ));

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      '**********************************************',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));
                              list.add(LineText(linefeed: 1));

                              await bluetoothPrint.printReceipt(config, list);
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
