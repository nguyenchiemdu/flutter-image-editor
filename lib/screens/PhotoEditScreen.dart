import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor/blocs/image_state.dart';
import 'package:image_editor/blocs/photo_edit_blocs.dart';
import 'package:image_editor/screens/photo_preview.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../components/BlurSelectorBottomSheet.dart';
import '../../components/BottomBarItemWidget.dart';
import '../../components/ColorSelectorBottomSheet.dart';
import '../../components/EmojiPickerBottomSheet.dart';
import '../../components/FilterSelectionWidget.dart';
import '../../components/FrameSelectionWidget.dart';
import '../../components/StickerPickerBottomSheet.dart';
import '../../components/TextEditorDialog.dart';
import '../../models/StackedWidgetModel.dart';
import '../../services/FileService.dart';
import '../../utils/Colors.dart';
import '../../utils/Constants.dart';
import '../../utils/SignatureLibWidget.dart';
import '../components/TextTemplatePickerBottomSheet.dart';
import '../utils/AppPermissionHandler.dart';
import '../utils/Common.dart';

class PhotoEditScreen extends StatefulWidget {
  static String tag = '/PhotoEditScreen';
  final List<File> files;

  const PhotoEditScreen({super.key, required this.files});

  @override
  PhotoEditScreenState createState() => PhotoEditScreenState();
}

class PhotoEditScreenState extends State<PhotoEditScreen> {
  late final _bloC = context.read<PhotoEditBloC>();
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey key = GlobalKey<PhotoEditScreenState>();
  final ScrollController scrollController = ScrollController();

  DateTime? currentBackPressTime;

  bool mIsImageSaved = false;

  /// Used to save edited image on storage
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey screenshotKey = GlobalKey();
  final GlobalKey galleryKey = GlobalKey();

  /// Used to draw on image
  // SignatureController signatureController =
  //     SignatureController(penStrokeWidth: 5, penColor: Colors.green);

  // List<UndoModel> appStore.mStackedWidgetListundo1 = [];
  // List<UndoModel> mStackedWidgetListundo = [];

  /// Variables used to show or hide bottom widgets
  bool mIsPenColorVisible = false,
      mIsFilterViewVisible = false,
      mIsBlurVisible = false,
      mIsFrameVisible = false;
  bool mIsBrightnessSliderVisible = false,
      mIsSaturationSliderVisible = false,
      mIsHueSliderVisible = false,
      mIsContrastSliderVisible = false;
  bool mIsTextstyle = false;
  bool mIsTextColor = false;
  bool mIsTextBgColor = false;
  bool mIsTextSize = false;
  bool mIsMoreConfigWidgetVisible = true;
  bool mIsPenEnabled = false;
  bool mShowBeforeImage = false;
  bool mIsPremium = false;
  bool mIsText = false;
  bool mIsBorderSliderVisible = false;

  void pickImageSource(ImageSource imageSource) {
    // pickImage(imageSource: imageSource).then((value) async {
    //   mStackedWidgetList.add(
    //     StackedWidgetModel(
    //         file: value,
    //         widgetType: WidgetTypeImage,
    //         offset: Offset(100, 100),
    //         size: 100),
    //   );
    //   appStore.addUndoList(
    //     undoModel: UndoModel(
    //       type: 'mStackedWidgetList',
    //       widget: StackedWidgetModel(
    //           file: value,
    //           widgetType: WidgetTypeImage,
    //           offset: Offset(100, 100),
    //           size: 100),
    //     ),
    //   );
    //   RemoveBackgroundScreen(file: value).launch(context);
    //   setState(() {});
    // }).catchError((e) {
    //   log(e.toString());
    // });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getImageSize());
    setState(() {});

    super.initState();
    init();
  }

  Future<void> getImageSize() async {
    await Future.delayed(const Duration(seconds: 2));
    final imageState = _bloC.currentImageState();
    imageState.imageHeight = imageState.imageKey.currentContext!.size!.height;
    imageState.imageWidth = imageState.imageKey.currentContext!.size!.width;

    if (!mounted) return;
    if ((imageState.imageHeight ?? 0).toInt() == 0) {
      imageState.imageHeight = context.height();
    }
    if ((imageState.imageWidth ?? 0).toInt() == 0) {
      imageState.imageWidth = context.width();
    }
    setState(() {});
    // log(imageState.imageHeight);
    // log(imageState.imageWidth);
    _bloC.updateImageState(imageState);
  }

  Future<void> init() async {
    final List<ImageState> imageStateList = [];

    for (var file in widget.files) {
      final ImageState imageState =
          ImageState(imageKey: GlobalKey(), file: file);

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          mIsMoreConfigWidgetVisible = false;
        } else {
          mIsMoreConfigWidgetVisible = true;
        }

        setState(() {});
      });
      imageStateList.add(imageState);
    }
    _bloC.listimageStatesCtrl.add(imageStateList);
  }

  Future<void> checkPermissionAndCaptureImage() async {
    checkPermission(context, func: () {
      capture().whenComplete(() => log("done"));
    });
  }

  Future<void> capture() async {
    // appStore.setLoading(true);

    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    setState(() {});

    await screenshotController
        .captureAndSave(await getFileSavePath(), delay: 1.seconds)
        .then((value) async {
      log('Saved : $value');

      //save in gallery
      // final bytes = await File(value!).readAsBytes();
      // await ImageGallerySaver.saveImage(bytes.buffer.asUint8List(), name: fileName(value));
      await ImageGallerySaver.saveFile(value!, name: fileName(value));
      toast('Saved');
      mIsImageSaved = true;
    }).catchError((e) {
      log(e);
    });

    // appStore.setLoading(false);
    // pop();
    // DashboardScreen().launch(context, isNewTask: true);
  }

  void onEraserClick() {
    showConfirmDialogCustom(context,
        title: 'Do you want to clear?',
        primaryColor: colorPrimary,
        positiveText: 'Yes',
        negativeText: 'No', onAccept: (context) {
      mIsBlurVisible = false;
      mIsFilterViewVisible = false;
      mIsFrameVisible = false;
      mIsPenColorVisible = false;
      mIsBrightnessSliderVisible = false;
      mIsSaturationSliderVisible = false;
      mIsHueSliderVisible = false;
      mIsContrastSliderVisible = false;
      mIsBorderSliderVisible = false;

      _bloC.clearAllChanges();

      // appStore.mStackedWidgetListundo = [];
      // appStore.mStackedWidgetListundo1 = [];
    });
  }

  Future<void> onTextClick() async {
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsText = true;
    // appStore.isText = true;
    mIsBorderSliderVisible = false;

    setState(() {});

    String? text =
        await showInDialog(context, builder: (_) => const TextEditorDialog());

    if (text.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
        value: text,
        widgetType: WidgetTypeText,
        offset: const Offset(100, 100),
        size: 20,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
      );
      _bloC.addText(stackedWidgetModel);
      // appStore.addUndoList(
      //     undoModel: UndoModel(
      //         type: 'mStackedWidgetList', widget: stackedWidgetModel));

      setState(() {});
    } else {
      mIsText = false;
      // appStore.isText = false;
      setState(() {});
    }
  }

  Future<void> onNeonLightClick() async {
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsText = true;
    // appStore.isText = true;
    mIsBorderSliderVisible = false;

    setState(() {});

    String? text =
        await showInDialog(context, builder: (_) => const TextEditorDialog());

    if (text.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
        value: text,
        widgetType: WidgetTypeNeon,
        offset: const Offset(100, 100),
        size: 40,
        backgroundColor: Colors.transparent,
        textColor: getColorFromHex('#FF7B00AB'),
      );
      _bloC.addText(stackedWidgetModel);
      // appStore.addUndoList(
      //     undoModel: UndoModel(
      //         type: 'mStackedWidgetList', widget: stackedWidgetModel));
      setState(() {});
    }
  }

  Future<void> onEmojiClick() async {
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    setState(() {});

    // appStore.setLoading(true);
    await 300.milliseconds.delay;
    if (!mounted) return;
    String? emoji = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const EmojiPickerBottomSheet());

    if (emoji.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
        value: emoji,
        widgetType: WidgetTypeEmoji,
        offset: const Offset(100, 100),
        size: 50,
      );
      _bloC.addText(stackedWidgetModel);
      // appStore.addUndoList(
      //     undoModel: UndoModel(
      //         type: 'mStackedWidgetList', widget: stackedWidgetModel));

      setState(() {});
    }
  }

  Future<void> onStickerClick() async {
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    setState(() {});

    // appStore.setLoading(true);
    await 300.milliseconds.delay;
    if (!mounted) return;
    String? sticker = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const StickerPickerBottomSheet());

    if (sticker.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
          value: sticker,
          widgetType: WidgetTypeSticker,
          offset: const Offset(100, 100),
          size: 100);
      _bloC.addText(stackedWidgetModel);
      // appStore.addUndoList(
      //     undoModel: UndoModel(
      //         type: 'mStackedWidgetList', widget: stackedWidgetModel));
      setState(() {});
    }
  }

  Future<void> onImageClick() async {
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    setState(() {});

    // appStore.setLoading(true);
    await 300.milliseconds.delay;
    if (!mounted) return;
    showInDialog(context, contentPadding: EdgeInsets.zero, builder: (context) {
      return Container(
        width: context.width(),
        padding: const EdgeInsets.all(8),
        decoration: boxDecorationWithShadow(borderRadius: radius(8)),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                finish(context);

                pickImageSource(ImageSource.gallery);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  8.height,
                  const Icon(Ionicons.image_outline,
                      color: Colors.black, size: 32),
                  Text('Gallery', style: primaryTextStyle(color: Colors.black))
                      .paddingAll(16),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                finish(context);
                pickImageSource(ImageSource.camera);
                //var image = ImageSource.camera;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  8.height,
                  const Icon(Ionicons.camera_outline,
                      color: Colors.black, size: 32),
                  Text('Camera', style: primaryTextStyle(color: Colors.black))
                      .paddingAll(16),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void onTextStyle() {
    mIsTextstyle = !mIsTextstyle;
    mIsTextColor = false;
    mIsTextBgColor = false;
    mIsTextSize = false;
    setState(() {});
  }

  void onPenClick() {
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    mIsPenColorVisible = !mIsPenColorVisible;
    setState(() {});
  }

  void onBlurClick() {
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    mIsBlurVisible = !mIsBlurVisible;

    setState(() {});
  }

  Future<void> onFilterClick() async {
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    mIsFilterViewVisible = !mIsFilterViewVisible;

    setState(() {});
  }

  Future<void> onShapeClick() async {
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsFilterViewVisible = false;
    mIsBorderSliderVisible = false;

    var stackedWidgetModel = StackedWidgetModel(
        widgetType: WidgetTypeContainer,
        offset: const Offset(100, 100),
        size: 120,
        shape: BoxShape.circle);
    _bloC.addText(stackedWidgetModel);
    // appStore.addUndoList(
    //     undoModel:
    //         UndoModel(type: 'mStackedWidgetList', widget: stackedWidgetModel));

    setState(() {});
  }

  Future<void> onTextTemplet() async {
    mIsFrameVisible = false;
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsFilterViewVisible = false;
    mIsBorderSliderVisible = false;

    String? textTamplet = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const TextTemplatePickerBottomSheet());
    if (textTamplet.validate().isNotEmpty) {
      if (!mounted) return;
      String? text =
          await showInDialog(context, builder: (_) => const TextEditorDialog());
      var stackedWidgetModel = StackedWidgetModel(
          widgetType: WidgetTypeTextTemplate,
          imageName: textTamplet,
          offset: const Offset(100, 100),
          size: 120,
          fontSize: 16,
          value: text);
      _bloC.addText(stackedWidgetModel);
      // appStore.addUndoList(
      //     undoModel: UndoModel(
      //         type: 'mStackedWidgetList', widget: stackedWidgetModel));
    }
    setState(() {});
  }

  Future<void> onBorderSliderClick() async {
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsBorderSliderVisible = !mIsBorderSliderVisible;

    setState(() {});
  }

  Future<void> onFrameClick() async {
    if (!getBoolAsync(IS_FRAME_REWARDED)) {
      mIsPenColorVisible = false;
      mIsBlurVisible = false;
      mIsFilterViewVisible = false;
      mIsBrightnessSliderVisible = false;
      mIsSaturationSliderVisible = false;
      mIsHueSliderVisible = false;
      mIsContrastSliderVisible = false;
      mIsFrameVisible = !mIsFrameVisible;

      setState(() {});
    } else {
      /*if (rewardedAd != null && await rewardedAd.isLoaded()) {
        rewardedAd.show();

        toast('Showing reward ad');
      }*/
    }
  }

  Future<void> onBrightnessSliderClick() async {
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    mIsBrightnessSliderVisible = !mIsBrightnessSliderVisible;

    setState(() {});
  }

  Future<void> onSaturationSliderClick() async {
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    mIsSaturationSliderVisible = !mIsSaturationSliderVisible;

    setState(() {});
  }

  Future<void> onHueSliderClick() async {
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsContrastSliderVisible = false;
    mIsBorderSliderVisible = false;

    mIsHueSliderVisible = !mIsHueSliderVisible;

    setState(() {});
  }

  Future<void> onContrastSliderClick() async {
    mIsPenColorVisible = false;
    mIsBlurVisible = false;
    mIsFilterViewVisible = false;
    mIsFrameVisible = false;
    mIsBrightnessSliderVisible = false;
    mIsSaturationSliderVisible = false;
    mIsHueSliderVisible = false;
    mIsBorderSliderVisible = false;

    mIsContrastSliderVisible = !mIsContrastSliderVisible;

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast('Your edited image will be lost\nPress back again to go back');
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<List<ImageState>>(
            stream: _bloC.imageStatesStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final imageStates = snapshot.data!;
              final currentIndex = _bloC.currentImageIndex.value;
              final imageState = imageStates[currentIndex];
              return Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: imageState.topWidgetHeight,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _closeButton(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                0.width,
                                GestureDetector(
                                  onTap: () => log('tap'),
                                  onTapDown: (v) {
                                    mShowBeforeImage = true;
                                    setState(() {});
                                  },
                                  onTapUp: (v) {
                                    mShowBeforeImage = false;
                                    setState(() {});
                                  },
                                  onTapCancel: () {
                                    mShowBeforeImage = false;
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.compare_rounded)
                                      .paddingAll(0),
                                ),
                                // 16.width,
                                Text(mIsText ? 'Done' : 'Save',
                                        style:
                                            boldTextStyle(color: colorPrimary))
                                    .paddingSymmetric(
                                        horizontal: 16, vertical: 8)
                                    .withShaderMaskGradient(
                                        const LinearGradient(colors: [
                                      itemGradient1,
                                      itemGradient2
                                    ]))
                                    .onTap(() async {
                                  mIsText
                                      ? setState(() {
                                          mIsText = false;
                                          // appStore.isText = false;
                                          // appStore.isText = false;
                                          mIsTextstyle = false;
                                          mIsTextColor = false;
                                          mIsTextBgColor = false;
                                          mIsTextSize = false;
                                        })
                                      : checkPermissionAndCaptureImage();
                                }, borderRadius: radius())
                              ],
                            ),
                          ],
                        ).paddingTop(0),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          // This widget will be saved as edited Image
                          Screenshot(
                              controller: screenshotController,
                              key: screenshotKey,
                              child: SizedBox(
                                height: imageState.imageHeight,
                                width: imageState.imageWidth,
                                child: PageView.builder(
                                    onPageChanged: (index) {
                                      getImageSize();
                                    },
                                    itemCount: widget.files.length,
                                    itemBuilder: (ctx, index) {
                                      return PhotoPreview(
                                        mIsPenEnabled: mIsPenEnabled,
                                        index: index,
                                        getImageSize: getImageSize,
                                      );
                                    }),
                              )),

                          /// Show preview of edited image before save
                          Image.file(imageState.croppedFile!, fit: BoxFit.cover)
                              .visible(true)
                              .visible(mShowBeforeImage),
                        ],
                      ).expand(),
                      _editorBottomBar()
                    ],
                  ).paddingTop(context.statusBarHeight),
                  // Observer(builder: (_) => Loader().visible(appStore.isLoading)),
                ],
              );
            }),
      ),
    );
  }

  Widget _editorBottomBar() => StreamBuilder<List<ImageState>>(
      stream: _bloC.listimageStatesCtrl,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }
        final imageStates = snapshot.data!;
        final currentIndex = _bloC.currentImageIndex.value;
        final imageState = imageStates[currentIndex];
        return Column(
          children: [
            if (mIsBrightnessSliderVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: mIsBrightnessSliderVisible ? 60 : 0,
                width: context.width(),
                color: Colors.grey.shade100,
                child: Container(
                  color: Colors.white38,
                  height: 60,
                  child: Row(
                    children: [
                      8.width,
                      const Text('Brightness'),
                      8.width,
                      Slider(
                        min: 0.0,
                        max: 1.0,
                        onChanged: _bloC.updateBrightness,
                        value: imageState.brightness,
                        onChangeEnd: (d) {
                          // appStore.addUndoList(
                          //     undoModel: UndoModel(
                          //         type: 'brightness', number: d));
                          setState(() {});
                        },
                      ).expand(),
                    ],
                  ),
                ),
              ),
            if (mIsPenColorVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: mIsPenColorVisible ? 60 : 0,
                color: Colors.grey.shade100,
                width: context.width(),
                child: Row(
                  children: [
                    Switch(
                      value: mIsPenEnabled,
                      onChanged: (b) {
                        mIsPenEnabled = b;
                        mIsPenColorVisible = false;
                        setState(() {});
                      },
                    ),
                    ColorSelectorBottomSheet(
                      list: penColors,
                      onColorSelected: (Color color) {
                        List<Point> tempPoints =
                            imageState.signatureController.points;
                        final signatureController = SignatureController(
                            penStrokeWidth: 4, penColor: color);

                        for (var element in tempPoints) {
                          signatureController.addPoint(element);
                        }
                        _bloC.changeSignatureController(signatureController);

                        mIsPenColorVisible = false;
                        mIsPenEnabled = true;

                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            if (mIsTextColor)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                color: Colors.grey.shade100,
                width: context.width(),
                child: Row(
                  children: [
                    ColorSelectorBottomSheet(
                      list: textColors,
                      selectedColor:
                          imageState.mStackedWidgetList.last.textColor,
                      onColorSelected: _bloC.changeLastTextColor,
                    ),
                  ],
                ),
              ),
            if (mIsTextBgColor)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                width: context.width(),
                child: Row(
                  children: [
                    ColorSelectorBottomSheet(
                      list: textColors,
                      selectedColor:
                          imageState.mStackedWidgetList.last.backgroundColor,
                      onColorSelected: _bloC.changeLastTextBackgroundColor,
                    ),
                  ],
                ),
              ),
            if (mIsTextSize)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(left: 16, bottom: 8),
                height: 30,
                color: Colors.grey.shade100,
                width: context.width(),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Slider(
                      value: imageState.mStackedWidgetList.last.size
                          .validate(value: 16),
                      min: 10.0,
                      max: 100.0,
                      onChangeEnd: _bloC.changeLastTextSize,
                      onChanged: _bloC.changeLastTextSize,
                    ).paddingLeft(16),
                    Text('${imageState.mStackedWidgetList.last.size!.toInt()}'
                        '%'),
                  ],
                ),
              ),
            if (mIsTextstyle)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 40,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 16),
                width: context.width(),
                color: Colors.white,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration:
                          imageState.mStackedWidgetList.last.fontStyle ==
                                  FontStyle.normal
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black))
                              : null,
                      child: Text('Normal', style: boldTextStyle()).onTap(() {
                        _bloC.changeLastTextFontStyle(FontStyle.normal);
                        mIsTextstyle = false;
                        setState(() {});
                      }),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration:
                          imageState.mStackedWidgetList.last.fontStyle ==
                                  FontStyle.italic
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black))
                              : null,
                      child: Text('Italic',
                              style: boldTextStyle(fontStyle: FontStyle.italic))
                          .onTap(() {
                        _bloC.changeLastTextFontStyle(FontStyle.italic);
                        mIsTextstyle = false;
                        setState(() {});
                      }),
                    ),
                  ],
                ),
              ),
            if (mIsBorderSliderVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: (imageState.outerBorderwidth != 0 ||
                        imageState.innerBorderwidth != 0)
                    ? 130
                    : 84,
                width: context.width(),
                color: Colors.grey.shade100,
                child: Container(
                  color: Colors.white38,
                  child: Column(
                    children: [
                      6.height.visible(imageState.outerBorderwidth != 0.0),
                      ColorSelectorBottomSheet(
                        list: textColors,
                        selectedColor: imageState.isOuterBorder
                            ? imageState.outerBorderColor
                            : imageState.innerBorderColor,
                        onColorSelected: (c) {
                          imageState.isOuterBorder
                              ? imageState.outerBorderColor = c
                              : imageState.innerBorderColor = c;
                          setState(() {});
                          // appStore.addUndoList(
                          //     undoModel: UndoModel(
                          //         type: 'border',
                          //         border: BorderModel(
                          //             type: isOuterBorder
                          //                 ? 'outer'
                          //                 : 'inner',
                          //             width: isOuterBorder
                          //                 ? outerBorderwidth
                          //                 : innerBorderwidth,
                          //             borderColor: c)));
                        },
                      ).visible(imageState.outerBorderwidth != 0 ||
                          imageState.innerBorderwidth != 0),
                      (imageState.outerBorderwidth != 0 ||
                              imageState.innerBorderwidth != 0)
                          ? 16.height
                          : 6.height,
                      Row(children: [
                        8.width,
                        InkWell(
                            onTap: () => _bloC.changeOuterBorder(true),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: imageState.isOuterBorder
                                        ? Colors.lightBlueAccent
                                            .withOpacity(0.5)
                                        : null),
                                child:
                                    Text("Outer", style: primaryTextStyle()))),
                        16.width,
                        InkWell(
                            onTap: () => _bloC.changeOuterBorder(false),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: imageState.isOuterBorder == false
                                        ? Colors.lightBlueAccent
                                            .withOpacity(0.5)
                                        : null),
                                child:
                                    Text("Inner", style: primaryTextStyle())))
                      ]),
                      Row(
                        children: [
                          8.width,
                          const Text('Border'),
                          8.width,
                          Slider(
                            min: 0.0,
                            max: 50,
                            onChanged: _bloC.changeBorder,
                            value: imageState.isOuterBorder
                                ? imageState.outerBorderwidth
                                : imageState.innerBorderwidth,
                            onChangeEnd: (d) {
                              // appStore.addUndoList(
                              //     undoModel: UndoModel(
                              //         type: 'border',
                              //         border: BorderModel(
                              //             type: isOuterBorder
                              //                 ? 'outer'
                              //                 : 'inner',
                              //             width: d,
                              //             borderColor: isOuterBorder
                              //                 ? outerBorderColor
                              //                 : innerBorderColor)));
                              // setState(() {});
                              // appStore.mStackedWidgetListundo1
                              //     .forEach((element) {});
                            },
                          ).expand(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (mIsContrastSliderVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: mIsContrastSliderVisible ? 60 : 0,
                width: context.width(),
                color: Colors.grey.shade100,
                child: Container(
                  color: Colors.white38,
                  height: 60,
                  child: Row(
                    children: [
                      8.width,
                      const Text('Contrast'),
                      8.width,
                      Slider(
                        min: 0.0,
                        max: 1.0,
                        onChanged: _bloC.updateContrast,
                        value: imageState.contrast,
                        onChangeEnd: (d) {
                          // appStore.addUndoList(
                          //     undoModel: UndoModel(
                          //         type: 'contrast', number: d));
                          setState(() {});
                        },
                      ).expand(),
                    ],
                  ),
                ),
              ),
            if (mIsSaturationSliderVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: mIsSaturationSliderVisible ? 60 : 0,
                width: context.width(),
                color: Colors.grey.shade100,
                child: Container(
                  color: Colors.white38,
                  height: 60,
                  child: Row(
                    children: [
                      8.width,
                      const Text('Saturation'),
                      8.width,
                      Slider(
                        min: 0.0,
                        max: 1.0,
                        onChanged: _bloC.updateSaturation,
                        value: imageState.saturation,
                        onChangeEnd: (d) {
                          // appStore.addUndoList(
                          //     undoModel: UndoModel(
                          //         type: 'saturation', number: d));
                          setState(() {});
                        },
                      ).expand(),
                    ],
                  ),
                ),
              ),
            if (mIsHueSliderVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: mIsHueSliderVisible ? 60 : 0,
                width: context.width(),
                color: Colors.grey.shade100,
                child: Container(
                  color: Colors.white38,
                  height: 60,
                  child: Row(
                    children: [
                      8.width,
                      const Text('Hue'),
                      8.width,
                      Slider(
                        min: 0.0,
                        max: 1.0,
                        onChanged: _bloC.updateHue,
                        value: imageState.hue,
                        onChangeEnd: (d) {
                          // appStore.addUndoList(
                          //     undoModel:
                          //         UndoModel(type: 'hue', number: d));
                          // setState(() {});
                        },
                      ).expand(),
                    ],
                  ),
                ),
              ),
            if (mIsFilterViewVisible)
              AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: mIsFilterViewVisible ? 120 : 0,
                  width: context.width(),
                  child: FilterSelectionWidget(
                    image: imageState.croppedFile,
                    freeImage: imageState.croppedFileFree,
                    onSelect: _bloC.updateFilter,
                  )),
            if (mIsFrameVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: mIsFrameVisible ? 120 : 0,
                width: context.width(),
                child: FrameSelectionWidget(onSelect: (v) {
                  _bloC.changeFrame(v);
                  // appStore.addUndoList(
                  //     undoModel: UndoModel(type: 'frame', data: v));
                }),
              ),
            if (mIsBlurVisible)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: mIsBlurVisible ? 120 : 0,
                color: Colors.white38,
                width: context.width(),
                child: BlurSelectorBottomSheet(
                  sliderValue: imageState.blur,
                  onColorSelected: _bloC.updateBlur,
                  onColorSelectedEnd: (p0) {
                    // appStore.addUndoList(
                    //     undoModel: UndoModel(type: 'blur', number: p0));
                    // setState(() {});
                  },
                ),
              ),
            Container(
              height: imageState.bottomWidgetHeight,
              color: Colors.white12,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      BottomBarItemWidget(
                          title: 'Eraser',
                          icons: const Icon(FontAwesomeIcons.eraser).icon,
                          onTap: () => onEraserClick()),
                      BottomBarItemWidget(
                          title: 'Text',
                          icons: const Icon(Icons.text_fields_rounded).icon,
                          onTap: () => onTextClick()),
                      BottomBarItemWidget(
                          title: 'Neon',
                          icons: const Icon(Icons.text_fields_rounded).icon,
                          onTap: () => onNeonLightClick()),
                      BottomBarItemWidget(
                          title: 'Emoji',
                          icons: const Icon(FontAwesomeIcons.faceSmile).icon,
                          onTap: () => onEmojiClick()),
                      BottomBarItemWidget(
                          title: 'Stickers',
                          icons:
                              const Icon(FontAwesomeIcons.faceSmileWink).icon,
                          onTap: () {
                            setState(() {
                              onStickerClick();
                            });
                          }),
                      BottomBarItemWidget(
                          title: 'Add Image',
                          icons: const Icon(Icons.image_outlined).icon,
                          onTap: () {
                            setState(() {
                              onImageClick();
                            });
                          }),

                      /// Will be added in next update due to multiple finger bug
                      BottomBarItemWidget(
                          title: 'Pen',
                          icons: const Icon(FontAwesomeIcons.penFancy).icon,
                          onTap: () => onPenClick()),
                      BottomBarItemWidget(
                          title: 'Brightness',
                          icons: const Icon(Icons.brightness_2_outlined).icon,
                          onTap: () => onBrightnessSliderClick()),
                      BottomBarItemWidget(
                          title: 'Contrast',
                          icons: const Icon(Icons.brightness_4_outlined).icon,
                          onTap: () => onContrastSliderClick()),
                      BottomBarItemWidget(
                          title: 'Saturation',
                          icons: const Icon(Icons.brightness_4_sharp).icon,
                          onTap: () => onSaturationSliderClick()),
                      BottomBarItemWidget(
                          title: 'Hue',
                          icons: const Icon(Icons.brightness_medium_sharp).icon,
                          onTap: () => onHueSliderClick()),
                      BottomBarItemWidget(
                          title: 'Blur',
                          icons: const Icon(MaterialCommunityIcons.blur).icon,
                          onTap: () => onBlurClick()),
                      BottomBarItemWidget(
                          title: 'Filter',
                          icons: const Icon(Icons.photo).icon,
                          onTap: () => onFilterClick()),
                      // BottomBarItemWidget(title: 'Shape', icons: Icon(Icons.format_shapes_sharp).icon, onTap: () => onShapeClick()),
                      BottomBarItemWidget(
                          title: 'Add Text Templet',
                          icons: const Icon(Icons.format_shapes_sharp).icon,
                          onTap: () => onTextTemplet()),
                      BottomBarItemWidget(
                          title: 'Border',
                          icons: const Icon(Icons.format_shapes_sharp).icon,
                          onTap: () => onBorderSliderClick()),
                      BottomBarItemWidget(
                          title: 'Frame',
                          icons: !getBoolAsync(IS_FRAME_REWARDED)
                              ? const Icon(Icons.filter_frames).icon
                              : const Icon(Icons.lock_outline_rounded).icon,
                          onTap: () => onFrameClick()),
                    ],
                  ).visible(mIsText == false
                      //  && appStore.isText == false
                      ),
                  ListView(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      BottomBarItemWidget(
                        title: 'Edit',
                        icons: const Icon(Icons.edit).icon,
                        onTap: () => (setState(() async {
                          String? text = await showInDialog(context,
                              builder: (_) => TextEditorDialog(
                                    text: imageState
                                        .mStackedWidgetList.last.value,
                                  ));
                          _bloC.changeLastTextValue(text);
                        })),
                      ),
                      BottomBarItemWidget(
                          title: 'Font Family',
                          icons: const Icon(Icons.text_fields_rounded).icon,
                          onTap: () => onTextStyle()),
                      BottomBarItemWidget(
                        title: 'Font Size',
                        icons: const Icon(Icons.font_download_outlined).icon,
                        onTap: () => (setState(() {
                          mIsTextSize = !mIsTextSize;
                          mIsTextColor = false;
                          mIsTextstyle = false;
                          mIsTextBgColor = false;
                        })),
                      ),
                      BottomBarItemWidget(
                        title: 'Bg Color',
                        icons: const Icon(Icons.color_lens_outlined).icon,
                        onTap: () => (setState(() {
                          mIsTextBgColor = !mIsTextBgColor;
                          mIsTextColor = false;
                          mIsTextstyle = false;
                          mIsTextSize = false;
                        })),
                      ),
                      BottomBarItemWidget(
                        title: 'Text Color',
                        icons: const Icon(Icons.format_color_fill).icon,
                        onTap: () => (setState(() {
                          mIsTextColor = !mIsTextColor;
                          mIsTextstyle = false;
                          mIsTextBgColor = false;
                          mIsTextSize = false;
                        })),
                      ),
                      BottomBarItemWidget(
                        title: 'Remove',
                        icons: const Icon(Icons.delete_outline_outlined).icon,
                        onTap: () => (setState(
                          () {
                            mIsTextColor = false;
                            mIsTextstyle = false;
                            mIsTextBgColor = false;
                            mIsTextSize = false;
                            _bloC.removeLastText();
                            // appStore.removeUndoList();
                            // appStore.mStackedWidgetListundo1
                            //     .removeLast();
                            // mIsText = false;
                            // appStore.isText = false;
                          },
                        )),
                      ),
                    ],
                  ).visible(mIsText
                      // || appStore.isText
                      ),
                  // Positioned(
                  //   child: AnimatedCrossFade(
                  //       firstChild: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                  //       secondChild: Offstage(),
                  //       crossFadeState: mIsMoreConfigWidgetVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  //       duration: 700.milliseconds),
                  //   right: 8,
                  // ),
                ],
              ),
            ),
          ],
        );
      });
  Widget _closeButton() => IconButton(
        onPressed: () {
          showConfirmDialogCustom(context,
              title: 'You edited image will be lost',
              primaryColor: colorPrimary,
              positiveText: 'Ok',
              negativeText: 'Cancel', onAccept: (BuildContext context) async {
            mIsText = false;
            // appStore.isText = false;
            Navigator.pop(context);
          });
        },
        icon: const Icon(Icons.close),
      );
}
