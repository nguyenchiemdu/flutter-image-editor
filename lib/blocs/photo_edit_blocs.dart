import 'dart:ui';

import 'package:image_editor/blocs/image_state.dart';
import 'package:image_editor/models/ColorFilterModel.dart';
import 'package:image_editor/models/StackedWidgetModel.dart';
import 'package:image_editor/utils/SignatureLibWidget.dart';
import 'package:rxdart/subjects.dart';

class PhotoEditBloC {
  final BehaviorSubject<List<ImageState>> listimageStatesCtrl =
      BehaviorSubject<List<ImageState>>();
  Stream<List<ImageState>> get imageStatesStream => listimageStatesCtrl.stream;
  final BehaviorSubject<int> currentImageIndex = BehaviorSubject<int>()..add(0);
  void updateImageState(ImageState newState) {
    final currentIndex = currentImageIndex.value;
    final imageStates = listimageStatesCtrl.value;
    imageStates[currentIndex] = newState;
    listimageStatesCtrl.add(imageStates);
  }

  void changeCurrentImageIndex(int index) {
    currentImageIndex.add(index);
  }

  ImageState currentImageState() {
    final currentIndex = currentImageIndex.value;
    final imageStates = listimageStatesCtrl.value;
    return imageStates[currentIndex];
  }

  void _clearBrightnessContrastSaturationHue() {
    final imageState = currentImageState();
    imageState
      ..brightness = 0.0
      ..saturation = 0.0
      ..hue = 0.0
      ..contrast = 0.0;

    updateImageState(imageState);
  }

  void updateContrast(double value) {
    final imageState = currentImageState();
    imageState.contrast = value;

    updateImageState(imageState);
  }

  void updateBrightness(double value) {
    final imageState = currentImageState();
    imageState.brightness = value;

    updateImageState(imageState);
  }

  void updateSaturation(double value) {
    final imageState = currentImageState();
    imageState.saturation = value;

    updateImageState(imageState);
  }

  void updateHue(double value) {
    final imageState = currentImageState();
    imageState.hue = value;

    updateImageState(imageState);
  }

  void updateBlur(double value) {
    final imageState = currentImageState();
    imageState.blur = value;

    updateImageState(imageState);
  }

  void updateFilter(ColorFilterModel filter) {
    final imageState = currentImageState();
    imageState.filter = filter;

    updateImageState(imageState);
  }

  /// Clear blur effect
  void _clearBlur() {
    final imageState = currentImageState();
    imageState.blur = 0;

    updateImageState(imageState);
  }

  /// Clear signature
  void _clearSignature() {
    final imageState = currentImageState();
    imageState.signatureController.clear();
    imageState.points.clear();

    updateImageState(imageState);
  }

  /// Clear stacked widgets
  void _clearStackedWidgets() {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.clear();

    updateImageState(imageState);
  }

  /// Clear filter
  void _clearFilter() {
    final imageState = currentImageState();
    imageState.filter = null;

    updateImageState(imageState);
  }

  /// Border
  void _clearBorder() {
    final imageState = currentImageState();
    imageState.outerBorderwidth = 0.0;
    imageState.innerBorderwidth = 0.0;

    updateImageState(imageState);
  }

  void changeBorder(double d) {
    final imageState = currentImageState();
    imageState.isOuterBorder
        ? imageState.outerBorderwidth = d
        : imageState.innerBorderwidth = d;

    updateImageState(imageState);
  }

  void changeOuterBorder(bool isOuterBorder) {
    final imageState = currentImageState();
    imageState.isOuterBorder = isOuterBorder;

    updateImageState(imageState);
  }

  //  Text
  void addText(StackedWidgetModel stackedWidgetModel) {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.add(stackedWidgetModel);

    updateImageState(imageState);
  }

  void changeLastTextColor(Color color) {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.last.textColor = color;

    updateImageState(imageState);
  }

  void changeLastTextBackgroundColor(Color color) {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.last.backgroundColor = color;

    updateImageState(imageState);
  }

  void changeLastTextSize(double size) {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.last.size = size;

    updateImageState(imageState);
  }

  void changeLastTextFontStyle(FontStyle fontStyle) {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.last.fontStyle = fontStyle;

    updateImageState(imageState);
  }

  void changeLastTextValue(String? value) {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.last.value = value;

    updateImageState(imageState);
  }

  void removeLastText() {
    final imageState = currentImageState();
    imageState.mStackedWidgetList.removeLast();

    updateImageState(imageState);
  }

  /// Paint
  void changeSignatureController(SignatureController signatureController) {
    final imageState = currentImageState();
    imageState.signatureController = signatureController;

    updateImageState(imageState);
  }

  /// Frame
  void _clearFrame() {
    final imageState = currentImageState();
    imageState.frame = null;

    updateImageState(imageState);
  }

  void changeFrame(String frame) {
    final imageState = currentImageState();
    imageState.frame = frame.isEmpty ? null : frame;

    updateImageState(imageState);
  }

  void clearAllChanges() {
    final imageState = currentImageState();
    imageState.resetValues();

    updateImageState(imageState);
  }

  void dispose() {
    listimageStatesCtrl.close();
    currentImageIndex.close();

    for (var e in listimageStatesCtrl.value) {
      e.signatureController.dispose();
    }
  }
}
