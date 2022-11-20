import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

double convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}

Future<Uint8List> getBytesFromCanvas(String text, Uint8List markerIcon) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint whitePaint = Paint()
    ..color = Colors.white;

  final Paint shadowPaint = Paint()
    ..color = Colors.black.withAlpha(127)
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(3));

  TextPainter painter = TextPainter(textDirection: TextDirection.ltr);

  var imageDiff = 15;
  var size = 100;
  var fontSize = size / 3;
  painter.text = TextSpan(
    text: text, //you can write your own text here or take from parameter
    style: TextStyle(fontSize: fontSize, color: Colors.black, fontWeight: FontWeight.bold),
  );
  painter.layout();

  var overallWidth = painter.width.ceil();

  canvas.drawRect(Rect.fromCenter(center: Offset((overallWidth / 2), size.toDouble() + fontSize * 0.6 + imageDiff), width: overallWidth.toDouble() + 100, height: fontSize * 1.5), shadowPaint);
  canvas.drawRect(Rect.fromCenter(center: Offset((overallWidth / 2), size.toDouble() + fontSize * 0.6 + imageDiff), width: overallWidth.toDouble() + 100, height: fontSize * 1.5), whitePaint);

  painter.paint(
    canvas,
    Offset(25, size.toDouble() + imageDiff),
  );

  var imageSize = 100;
  canvas.drawImage(await loadImage(Uint8List.view(markerIcon.buffer)), Offset((overallWidth / 2) - (imageSize / 2) + 25, 0), whitePaint);

  final img = await pictureRecorder.endRecording().toImage(overallWidth + 50, 150 + imageDiff);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);

  if (data == null) {
    throw 'Icon image data is null';
  }

  return data.buffer.asUint8List();
}

Future<ui.Image> loadImage(Uint8List img) async {
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(img, (img) => completer.complete(img));
  return completer.future;
}
