
import 'package:flutter/material.dart';
import 'dart:io';

class StackedWidgetModel {
  StackedWidgetType? widgetType;
  String? imageName;
  String? value;
  Offset? offset;
  double? size;
  FontStyle? fontStyle;
  File? file;
  BoxShape? shape;

  // Text Widget Properties
  Color? textColor;
  Color? backgroundColor;
  String? fontFamily;
  double? fontSize;

  StackedWidgetModel({
    this.widgetType,
    this.value,
    this.offset,
    this.size,
    this.textColor,
    this.backgroundColor,
    this.fontStyle,
    this.fontFamily,
    this.file,
    this.shape,
    this.imageName,
    this.fontSize,
  });

  bool get isText => widgetType == StackedWidgetType.text;
  bool get isEmoji => widgetType == StackedWidgetType.emoji;
  bool get isNeon => widgetType == StackedWidgetType.neon;
  bool get isSticker => widgetType == StackedWidgetType.sticker;
  bool get isImage => widgetType == StackedWidgetType.image;
  bool get isContainer => widgetType == StackedWidgetType.container;
  bool get isTextTemplate => widgetType == StackedWidgetType.textTemplate;
}

enum StackedWidgetType {
  text,
  emoji,
  neon,
  sticker,
  image,
  container,
  textTemplate,
}
