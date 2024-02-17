// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:blue_print_pos/blue_print_pos.dart';
import 'package:blue_print_pos/models/models.dart';
import 'package:blue_print_pos/receipt/receipt.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final BluePrintPos _bluePrintPos = BluePrintPos.instance;
  List<BlueDevice> _blueDevices = <BlueDevice>[];
  BlueDevice? _selectedDevice;
  bool _isLoading = false;
  int _loadingAtIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'መውጫ ቲኬት ማተሚያ',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading && _blueDevices.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              )
            : _blueDevices.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: List<Widget>.generate(_blueDevices.length,
                              (int index) {
                            return Row(
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _blueDevices[index].address ==
                                            (_selectedDevice?.address ?? '')
                                        ? _onDisconnectDevice
                                        : () => _onSelectDevice(index),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _blueDevices[index].name,
                                            style: TextStyle(
                                              color: _selectedDevice?.address ==
                                                      _blueDevices[index]
                                                          .address
                                                  ? Colors.blue
                                                  : Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            _blueDevices[index].address,
                                            style: TextStyle(
                                              color: _selectedDevice?.address ==
                                                      _blueDevices[index]
                                                          .address
                                                  ? Colors.blueGrey
                                                  : Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if (_loadingAtIndex == index && _isLoading)
                                  Container(
                                    height: 24.0,
                                    width: 24.0,
                                    margin: const EdgeInsets.only(right: 8.0),
                                    child: const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue,
                                      ),
                                    ),
                                  ),
                                if (!_isLoading &&
                                    _blueDevices[index].address ==
                                        (_selectedDevice?.address ?? ''))
                                  TextButton(
                                    onPressed: _onPrintReceipt,
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          if (states.contains(
                                              MaterialState.pressed)) {
                                            return Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.5);
                                          }
                                          return Theme.of(context).primaryColor;
                                        },
                                      ),
                                    ),
                                    child: Container(
                                      color: _selectedDevice == null
                                          ? Colors.grey
                                          : Colors.blue,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Print'.tr(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          'Scan bluetooth device',
                          style: TextStyle(fontSize: 24, color: Colors.blue),
                        ),
                        Text(
                          'Press button scan',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _onScanPressed,
        child: const Icon(Icons.search),
        backgroundColor: _isLoading ? Colors.grey : Colors.blue,
      ),
    );
  }

  Future<void> _onScanPressed() async {
    setState(() => _isLoading = true);
    _bluePrintPos.scan().then((List<BlueDevice> devices) {
      if (devices.isNotEmpty) {
        setState(() {
          _blueDevices = devices;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    });
  }

  void _onDisconnectDevice() {
    _bluePrintPos.disconnect().then((ConnectionStatus status) {
      if (status == ConnectionStatus.disconnect) {
        setState(() {
          _selectedDevice = null;
        });
      }
    });
  }

  void _onSelectDevice(int index) {
    setState(() {
      _isLoading = true;
      _loadingAtIndex = index;
    });
    final BlueDevice blueDevice = _blueDevices[index];
    _bluePrintPos.connect(blueDevice).then((ConnectionStatus status) {
      if (status == ConnectionStatus.connected) {
        setState(() => _selectedDevice = blueDevice);
      } else if (status == ConnectionStatus.timeout) {
        _onDisconnectDevice();
      } else {
        print('$runtimeType - something wrong');
      }
      setState(() => _isLoading = false);
    });
  }

  Future<void> _onPrintReceipt() async {
    /// Example for Print Text
    final ReceiptSectionText receiptText = ReceiptSectionText();

    receiptText.addSpacer();
    receiptText.addText(
      'Tikeetii Bahumsaa/የመውጫ ቲኬት',
      size: ReceiptTextSizeType.large,
      style: ReceiptTextStyleType.bold,
      alignment: ReceiptAlignment.center,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
      "የገባበት ሰዓት/sa'aatii itti seene",
      "${widget.arrivalTime}",
      leftSize: ReceiptTextSizeType.medium,
      rightSize: ReceiptTextSizeType.medium,
    );
    receiptText.addLeftRightText(
      "የወጣበት ሰዓት/sa'aatii itti bahe",
      "${widget.departureTime}",
      leftSize: ReceiptTextSizeType.medium,
      rightSize: ReceiptTextSizeType.medium,
    );
    receiptText.addLeftRightText(
      "ታርጋ/Lakkoofa:",
      "${widget.plate}",
      leftSize: ReceiptTextSizeType.medium,
      rightSize: ReceiptTextSizeType.medium,
    );
    receiptText.addLeftRightText(
      "ስምሪት/Buufata:",
      "${widget.route}",
      leftSize: ReceiptTextSizeType.medium,
      rightSize: ReceiptTextSizeType.medium,
    );
    receiptText.addLeftRightText(
      "መዳረሻ ከተማ/Magaalaa Gahumsaa:",
      "${widget.departure}",
      leftSize: ReceiptTextSizeType.medium,
      rightSize: ReceiptTextSizeType.medium,
    );
    receiptText.addLeftRightText(
      "ርቀት/Fageenya:",
      "${widget.distance.toString()}",
      leftSize: ReceiptTextSizeType.medium,
      rightSize: ReceiptTextSizeType.medium,
    );
    receiptText.addSpacer(useDashed: true);
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
        "Huubachiisa:", "Tikeetiin kun emala yeroo tokkoo qofaaf tajaajila");
    receiptText.addSpacer(useDashed: true);
    receiptText.addSpacer(useDashed: true);
    receiptText.addLeftRightText(
        "ማሳሰቢያ:", "ይህ የመውጫ ትኬት ለአንድ ጉዞ ብቻ የሚያገለግል ነው!");
    receiptText.addText('Powered by Dalex Import',
        size: ReceiptTextSizeType.small);
    await _bluePrintPos.printReceiptText(receiptText);
  }
}
