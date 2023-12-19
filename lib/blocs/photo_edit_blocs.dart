import 'dart:ui';

import 'package:image_editor/blocs/image_state.dart';
import 'package:image_editor/models/ColorFilterModel.dart';
import 'package:image_editor/models/StackedWidgetModel.dart';
import 'package:image_editor/utils/SignatureLibWidget.dart';
import 'package:rxdart/subjects.dart';

class PhotoEditBloC {
  final BehaviorSubject<ImageState> imageStateCtrl =
      BehaviorSubject<ImageState>();
  Stream<ImageState> get imageStateStream => imageStateCtrl.stream;

  void updateImageState(ImageState newState) {
    imageStateCtrl.add(newState);
  }

  void clearBrightnessContrastSaturationHue() {
    final imageState = imageStateCtrl.value;
    imageState
      ..brightness = 0.0
      ..saturation = 0.0
      ..hue = 0.0
      ..contrast = 0.0;

    updateImageState(imageState);
  }

  void updateContrast(double value) {
    final imageState = imageStateCtrl.value;
    imageState.contrast = value;

    updateImageState(imageState);
  }

  void updateBrightness(double value) {
    final imageState = imageStateCtrl.value;
    imageState.brightness = value;

    updateImageState(imageState);
  }

  void updateSaturation(double value) {
    final imageState = imageStateCtrl.value;
    imageState.saturation = value;

    updateImageState(imageState);
  }

  void updateHue(double value) {
    final imageState = imageStateCtrl.value;
    imageState.hue = value;

    updateImageState(imageState);
  }

  void updateBlur(double value) {
    final imageState = imageStateCtrl.value;
    imageState.blur = value;

    updateImageState(imageState);
  }

  void updateFilter(ColorFilterModel filter) {
    final imageState = imageStateCtrl.value;
    imageState.filter = filter;

    updateImageState(imageState);
  }

  /// Clear blur effect
  void clearBlur() {
    final imageState = imageStateCtrl.value;
    imageState.blur = 0;

    updateImageState(imageState);
  }

  /// Clear signature
  void clearSignature() {
    final imageState = imageStateCtrl.value;
    imageState.signatureController.clear();
    imageState.points.clear();

    updateImageState(imageState);
  }

  /// Clear stacked widgets
  void clearStackedWidgets() {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.clear();

    updateImageState(imageState);
  }

  /// Clear filter
  void clearFilter() {
    final imageState = imageStateCtrl.value;
    imageState.filter = null;

    updateImageState(imageState);
  }

  /// Border
  void clearBorder() {
    final imageState = imageStateCtrl.value;
    imageState.outerBorderwidth = 0.0;
    imageState.innerBorderwidth = 0.0;

    updateImageState(imageState);
  }

  void changeBorder(double d) {
    final imageState = imageStateCtrl.value;
    imageState.isOuterBorder
        ? imageState.outerBorderwidth = d
        : imageState.innerBorderwidth = d;

    updateImageState(imageState);
  }

  void changeOuterBorder(bool isOuterBorder) {
    final imageState = imageStateCtrl.value;
    imageState.isOuterBorder = isOuterBorder;

    updateImageState(imageState);
  }

  //  Text
  void addText(StackedWidgetModel stackedWidgetModel) {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.add(stackedWidgetModel);

    updateImageState(imageState);
  }

  void changeLastTextColor(Color color) {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.last.textColor = color;

    updateImageState(imageState);
  }

  void changeLastTextBackgroundColor(Color color) {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.last.backgroundColor = color;

    updateImageState(imageState);
  }

  void changeLastTextSize(double size) {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.last.size = size;

    updateImageState(imageState);
  }

  void changeLastTextFontStyle(FontStyle fontStyle) {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.last.fontStyle = fontStyle;

    updateImageState(imageState);
  }

  void changeLastTextValue(String? value) {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.last.value = value;

    updateImageState(imageState);
  }

  void removeLastText() {
    final imageState = imageStateCtrl.value;
    imageState.mStackedWidgetList.removeLast();

    updateImageState(imageState);
  }

  /// Paint
  void changeSignatureController(SignatureController signatureController) {
    final imageState = imageStateCtrl.value;
    imageState.signatureController = signatureController;

    updateImageState(imageState);
  }

  /// Frame
  void clearFrame() {
    final imageState = imageStateCtrl.value;
    imageState.frame = null;

    updateImageState(imageState);
  }

  void changeFrame(String frame) {
    final imageState = imageStateCtrl.value;
    imageState.frame = frame.isEmpty ? null : frame;

    updateImageState(imageState);
  }

  void dispose() {
    imageStateCtrl.close();
    imageStateCtrl.value.signatureController.dispose();
  }
}
