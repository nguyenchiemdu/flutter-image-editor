import 'dart:ui';

import 'package:image_editor/blocs/states/editor_state.dart';
import 'package:image_editor/blocs/states/image_state.dart';
import 'package:image_editor/models/color_filter_model.dart';
import 'package:image_editor/models/stacked_widget_model.dart';
import 'package:image_editor/utils/app_constants.dart';
import 'package:image_editor/utils/signature_lib_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:rxdart/subjects.dart';

class PhotoEditBloC {
  final BehaviorSubject<List<ImageState>> listimageStatesCtrl =
      BehaviorSubject<List<ImageState>>();
  Stream<List<ImageState>> get imageStatesStream => listimageStatesCtrl.stream;

  final BehaviorSubject<int> currentImageIndex = BehaviorSubject<int>()..add(0);

  final BehaviorSubject<EditorState> _editorStateCtrl =
      BehaviorSubject<EditorState>()..add(EditorState());
  Stream<EditorState> get editorStateStream => _editorStateCtrl.stream;

  EditorState get editorState => _editorStateCtrl.value;

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

    editorState.mIsTextstyle = false;

    _editorStateCtrl.add(editorState);
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

    editorState.mIsPenEnabled = true;
    editorState.mIsPenColorVisible = false;

    _editorStateCtrl.add(editorState);
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
    editorState
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false;

    _editorStateCtrl.add(editorState);
    updateImageState(imageState);
  }

  /// Editor state change

  onPenEnableChange(bool status) {
    editorState.mIsPenEnabled = status;
    editorState.mIsPenColorVisible = false;

    _editorStateCtrl.add(editorState);
  }

  showBeforeImage() {
    editorState.mShowBeforeImage = true;

    _editorStateCtrl.add(editorState);
  }

  unShowBeforeImage() {
    editorState.mShowBeforeImage = false;

    _editorStateCtrl.add(editorState);
  }

  onContrastSliderClick() {
    editorState.mIsPenColorVisible = false;
    editorState.mIsBlurVisible = false;
    editorState.mIsFilterViewVisible = false;
    editorState.mIsFrameVisible = false;
    editorState.mIsBrightnessSliderVisible = false;
    editorState.mIsSaturationSliderVisible = false;
    editorState.mIsHueSliderVisible = false;
    editorState.mIsBorderSliderVisible = false;
    editorState.mIsContrastSliderVisible =
        !editorState.mIsContrastSliderVisible;

    _editorStateCtrl.add(editorState);
  }

  onHueSliderClick() {
    editorState.mIsPenColorVisible = false;
    editorState.mIsBlurVisible = false;
    editorState.mIsFilterViewVisible = false;
    editorState.mIsFrameVisible = false;
    editorState.mIsBrightnessSliderVisible = false;
    editorState.mIsSaturationSliderVisible = false;
    editorState.mIsContrastSliderVisible = false;
    editorState.mIsBorderSliderVisible = false;
    editorState.mIsHueSliderVisible = !editorState.mIsHueSliderVisible;

    _editorStateCtrl.add(editorState);
  }

  onSaturationSliderClick() {
    editorState
      ..mIsPenColorVisible = false
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false
      ..mIsSaturationSliderVisible = !editorState.mIsSaturationSliderVisible;

    _editorStateCtrl.add(editorState);
  }

  onBrightnessSliderClick() {
    editorState
      ..mIsPenColorVisible = false
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false
      ..mIsBrightnessSliderVisible = !editorState.mIsBrightnessSliderVisible;

    _editorStateCtrl.add(editorState);
  }

  onFrameClick() {
    if (!getBoolAsync(isFrameRewarded)) {
      editorState
        ..mIsPenColorVisible = false
        ..mIsBlurVisible = false
        ..mIsFilterViewVisible = false
        ..mIsBrightnessSliderVisible = false
        ..mIsSaturationSliderVisible = false
        ..mIsHueSliderVisible = false
        ..mIsContrastSliderVisible = false
        ..mIsFrameVisible = !editorState.mIsFrameVisible;

      _editorStateCtrl.add(editorState);
    } else {
      /*if (rewardedAd != null && await rewardedAd.isLoaded()) {
        rewardedAd.show();

        toast('Showing reward ad');
      }*/
    }
  }

  onBorderSliderClick() {
    editorState
      ..mIsPenColorVisible = false
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsBorderSliderVisible = !editorState.mIsBorderSliderVisible;

    _editorStateCtrl.add(editorState);
  }

  onTextTemplet() {
    editorState
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBlurVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsFilterViewVisible = false
      ..mIsBorderSliderVisible = false;

    _editorStateCtrl.add(editorState);
  }

  onShapeClick(StackedWidgetModel model) {
    editorState
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBlurVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsFilterViewVisible = false
      ..mIsBorderSliderVisible = false;

    _editorStateCtrl.add(editorState);
    addText(model);
  }

  onFilterClick() {
    editorState
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBlurVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false
      ..mIsFilterViewVisible = !editorState.mIsFilterViewVisible;

    _editorStateCtrl.add(editorState);
  }

  onBlurClick() {
    editorState
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false
      ..mIsBlurVisible = !editorState.mIsBlurVisible;

    _editorStateCtrl.add(editorState);
  }

  void onPenClick() {
    editorState
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false
      ..mIsPenColorVisible = !editorState.mIsPenColorVisible;

    _editorStateCtrl.add(editorState);
  }

  void onEditorStickerClick() {
    editorState
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false;

    _editorStateCtrl.add(editorState);
  }

  void onEditorEmojiClick() {
    editorState
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsBorderSliderVisible = false;

    _editorStateCtrl.add(editorState);
  }

  void onEditorNeonLightClick() {
    editorState
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsText = true
      ..mIsBorderSliderVisible = false;

    _editorStateCtrl.add(editorState);
  }

  void onEditorTextClick() {
    editorState
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false
      ..mIsText = true
      ..mIsBorderSliderVisible = false;

    _editorStateCtrl.add(editorState);
  }

  onEditorCapture() {
    editorState
      ..mIsBlurVisible = false
      ..mIsFilterViewVisible = false
      ..mIsFrameVisible = false
      ..mIsPenColorVisible = false
      ..mIsBrightnessSliderVisible = false
      ..mIsSaturationSliderVisible = false
      ..mIsHueSliderVisible = false
      ..mIsContrastSliderVisible = false;

    _editorStateCtrl.add(editorState);
  }

  changeMoreConfigWidgetVisible(bool status) {
    editorState.mIsMoreConfigWidgetVisible = status;

    _editorStateCtrl.add(editorState);
  }

  //Text Editor state
  onTextStyle() {
    editorState.mIsTextstyle = !editorState.mIsTextstyle;
    editorState.mIsTextColor = false;
    editorState.mIsTextBgColor = false;
    editorState.mIsTextSize = false;

    _editorStateCtrl.add(editorState);
  }

  onTextFontSizeTap() {
    editorState.mIsTextSize = !editorState.mIsTextSize;
    editorState.mIsTextColor = false;
    editorState.mIsTextstyle = false;
    editorState.mIsTextBgColor = false;

    _editorStateCtrl.add(editorState);
  }

  onTextBgColorTap() {
    editorState.mIsTextBgColor = !editorState.mIsTextBgColor;
    editorState.mIsTextColor = false;
    editorState.mIsTextstyle = false;
    editorState.mIsTextSize = false;

    _editorStateCtrl.add(editorState);
  }

  onTextColorTap() {
    editorState.mIsTextColor = !editorState.mIsTextColor;
    editorState.mIsTextBgColor = false;
    editorState.mIsTextstyle = false;
    editorState.mIsTextSize = false;

    _editorStateCtrl.add(editorState);
  }

  onTextRemoveTap() {
    editorState.mIsTextColor = false;
    editorState.mIsTextBgColor = false;
    editorState.mIsTextstyle = false;
    editorState.mIsTextSize = false;

    _editorStateCtrl.add(editorState);
  }

  closeTextEditor() {
    editorState.mIsText = false;
    _editorStateCtrl.add(editorState);
  }

  onTextEditorDone() {
    editorState.mIsText = false;
    editorState.mIsTextstyle = false;
    editorState.mIsTextColor = false;
    editorState.mIsTextBgColor = false;
    editorState.mIsTextSize = false;

    _editorStateCtrl.add(editorState);
  }

  void dispose() {
    listimageStatesCtrl.close();
    currentImageIndex.close();
    _editorStateCtrl.close();

    for (var e in listimageStatesCtrl.value) {
      e.signatureController.dispose();
    }
  }
}
