import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transport_app/core/my_colors.dart';
import 'package:transport_app/core/my_text.dart';
import 'package:transport_app/models/queue_model.dart';
import 'package:transport_app/presentation/result/queue_printer.dart';

class BusDetailsPopup extends StatelessWidget {
  final QueueModel busDetails;

  BusDetailsPopup({required this.busDetails});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(Icons.directions_bus),
      title: Text('Queue Details'.tr()),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Plate No: ${busDetails.plateNumber}'),
         
          Text('Date: ${busDetails.date}'),
          Text('Time: ${busDetails.time}'),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primary, elevation: 0),
            child: Text("Print".tr(),
                style: MyText.subhead(context)!.copyWith(color: Colors.white)),
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => QueuePrinter(
                    arrivalTime: '6/4/2023 12:18:16PM',
                    departureTime: '6/4/2023 12:18:16PM',
                    plate: 'ET 1234',
                    route: 'Adama Peacock Station',
                    departure: 'Addis Ababa',
                    distance: 77.0,
                  ), //
                ),
              );
            },
          ),
        ),
        // TextButton(
        //   onPressed: () {
        //     Navigator.of(context).pop(); // Close the popup
        //   },
        //   child: Text('Close'),
        // ),
      ],
    );
  }
}
