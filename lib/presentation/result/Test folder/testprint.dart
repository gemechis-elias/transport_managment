import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:transport_app/presentation/result/Test%20folder/printerenum.dart';

///Test printing
class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Future<Uint8List> textToImage(String text) async {
    final ByteData fontData = await rootBundle.load("assets/fonts/sabaean.ttf");
    final List<int> fontBytes = fontData.buffer.asUint8List();
    // final font = img.arial14;
    final image = img.Image(width: 200, height: 40);

    // Fill the image with white color
    img.fill(image, color: img.ColorFloat64.from(img.ColorFloat64.rgb(255, 255, 255)));

    // Draw the text onto the image
    img.drawString(image,text, font: img.arial14);

    // Encode the image to PNG format
    final pngBytes = img.encodePng(image);

    return Uint8List.fromList(pngBytes);
  }

  sample() async {
    final text = "አቤል";
    final imageBytes = await textToImage(text);


    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printImageBytes(imageBytes);

        bluetooth.paperCut();
      }
    });
  }
}
