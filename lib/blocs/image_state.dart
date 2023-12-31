import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/models/ColorFilterModel.dart';
import 'package:image_editor/utils/SignatureLibWidget.dart';
import '../models/StackedWidgetModel.dart';

class ImageState {
  GlobalKey imageKey = GlobalKey();

  /// Image file picked from previous screen
  File? originalFile;
  File? croppedFile;

  /// Image file picked from previous screen
  String? originalFileFree;
  String? croppedFileFree;

  /// Used to draw on image
  SignatureController signatureController =
      SignatureController(penStrokeWidth: 5, penColor: Colors.green);
  List<Offset> points = [];

  /// Texts on image
  List<StackedWidgetModel> mStackedWidgetList = [];

  /// Selected color filter
  ColorFilterModel? filter;

  double brightness = 0.0, saturation = 0.0, hue = 0.0, contrast = 0.0;
  double topWidgetHeight = 50, bottomWidgetHeight = 80, blur = 0;

  ///Border
  bool isOuterBorder = true;
  double outerBorderwidth = 0.0;
  Color outerBorderColor = Colors.black;
  double innerBorderwidth = 0.0;
  Color innerBorderColor = Colors.black;

  /// Selected frame
  String? frame;

  double? imageHeight;
  double? imageWidth;
}
