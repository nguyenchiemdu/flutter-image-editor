import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor/blocs/photo_edit_blocs.dart';
import 'package:image_editor/blocs/states/editor_state.dart';
import 'package:image_editor/blocs/states/image_state.dart';
import 'package:image_editor/components/blur_selector_bottom_sheet.dart';
import 'package:image_editor/components/bottom_bar_item_widget.dart';
import 'package:image_editor/components/color_selector_bottom_sheet.dart';
import 'package:image_editor/components/emoji_picker_bottom_sheet.dart';
import 'package:image_editor/components/filter_selection_widget.dart';
import 'package:image_editor/components/frame_selection_widget.dart';
import 'package:image_editor/components/sticker_picker_bottom_sheet.dart';
import 'package:image_editor/components/text_editor_dialog.dart';
import 'package:image_editor/components/text_template_picker_bottom_sheet.dart';
import 'package:image_editor/models/stacked_widget_model.dart';
import 'package:image_editor/screens/widgets/text_editor_tool_bar.dart';
import 'package:image_editor/utils/app_colors.dart';
import 'package:image_editor/utils/app_constants.dart';
import 'package:image_editor/utils/signature_lib_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class EditorBottomBar extends StatefulWidget {
  const EditorBottomBar(
      {required this.editorState, required this.scrollController, super.key});
  final EditorState editorState;
  final ScrollController scrollController;
  @override
  State<EditorBottomBar> createState() => _EditorBottomBarState();
}

class _EditorBottomBarState extends State<EditorBottomBar> {
  late final _bloC = context.read<PhotoEditBloC>();
  late final editorState = widget.editorState;
  late final scrollController = widget.scrollController;

  void onEraserClick() {
    showConfirmDialogCustom(context,
        title: 'Do you want to clear?',
        primaryColor: colorPrimary,
        positiveText: 'Yes',
        negativeText: 'No', onAccept: (_) {
      _bloC.clearAllChanges();
    });
  }

  Future<void> onTextClick() async {
    String? text =
        await showInDialog(context, builder: (_) => const TextEditorDialog());

    if (text.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
        value: text,
        widgetType: StackedWidgetType.text,
        offset: const Offset(100, 100),
        size: 20,
        backgroundColor: Colors.transparent,
        textColor: Colors.white,
      );
      _bloC.addText(stackedWidgetModel);
    } else {
      _bloC.closeTextEditor();
    }
  }

  Future<void> onNeonLightClick() async {
    _bloC.onEditorNeonLightClick();

    String? text =
        await showInDialog(context, builder: (_) => const TextEditorDialog());

    if (text.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
        value: text,
        widgetType: StackedWidgetType.neon,
        offset: const Offset(100, 100),
        size: 40,
        backgroundColor: Colors.transparent,
        textColor: getColorFromHex('#FF7B00AB'),
      );
      _bloC.addText(stackedWidgetModel);
    }
  }

  Future<void> onEmojiClick() async {
    _bloC.onEditorEmojiClick();
    await 300.milliseconds.delay;

    if (!mounted) return;
    String? emoji = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const EmojiPickerBottomSheet());

    if (emoji.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
        value: emoji,
        widgetType: StackedWidgetType.emoji,
        offset: const Offset(100, 100),
        size: 50,
      );
      _bloC.addText(stackedWidgetModel);
    }
  }

  Future<void> onStickerClick() async {
    _bloC.onEditorStickerClick();

    await 300.milliseconds.delay;

    if (!mounted) return;
    String? sticker = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const StickerPickerBottomSheet());

    if (sticker.validate().isNotEmpty) {
      var stackedWidgetModel = StackedWidgetModel(
          value: sticker,
          widgetType: StackedWidgetType.sticker,
          offset: const Offset(100, 100),
          size: 100);
      _bloC.addText(stackedWidgetModel);
    }
  }

  Future<void> onTextTemplet() async {
    _bloC.onTextTemplet();

    String? textTamplet = await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => const TextTemplatePickerBottomSheet());
    if (textTamplet.validate().isNotEmpty) {
      if (!mounted) return;
      String? text =
          await showInDialog(context, builder: (_) => const TextEditorDialog());
      var stackedWidgetModel = StackedWidgetModel(
          widgetType: StackedWidgetType.textTemplate,
          imageName: textTamplet,
          offset: const Offset(100, 100),
          size: 120,
          fontSize: 16,
          value: text);
      _bloC.addText(stackedWidgetModel);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ImageState>>(
        stream: _bloC.imageStatesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }
          final imageStates = snapshot.data!;
          final currentIndex = _bloC.currentImageIndex.value;
          final imageState = imageStates[currentIndex];
          return Column(
            children: [
              if (editorState.mIsBrightnessSliderVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: editorState.mIsBrightnessSliderVisible ? 60 : 0,
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
              if (editorState.mIsPenColorVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: editorState.mIsPenColorVisible ? 60 : 0,
                  color: Colors.grey.shade100,
                  width: context.width(),
                  child: Row(
                    children: [
                      Switch(
                        value: editorState.mIsPenEnabled,
                        onChanged: _bloC.onPenEnableChange,
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
                        },
                      ),
                    ],
                  ),
                ),
              if (editorState.mIsTextColor)
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
              if (editorState.mIsTextBgColor)
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
              if (editorState.mIsTextSize)
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
              if (editorState.mIsTextstyle)
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
                                style:
                                    boldTextStyle(fontStyle: FontStyle.italic))
                            .onTap(() {
                          _bloC.changeLastTextFontStyle(FontStyle.italic);
                        }),
                      ),
                    ],
                  ),
                ),
              if (editorState.mIsBorderSliderVisible)
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
                                  child: Text("Outer",
                                      style: primaryTextStyle()))),
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
              if (editorState.mIsContrastSliderVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: editorState.mIsContrastSliderVisible ? 60 : 0,
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
              if (editorState.mIsSaturationSliderVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: editorState.mIsSaturationSliderVisible ? 60 : 0,
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
              if (editorState.mIsHueSliderVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: editorState.mIsHueSliderVisible ? 60 : 0,
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
              if (editorState.mIsFilterViewVisible)
                AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: editorState.mIsFilterViewVisible ? 120 : 0,
                    width: context.width(),
                    child: FilterSelectionWidget(
                      image: imageState.croppedFile,
                      freeImage: imageState.croppedFileFree,
                      onSelect: _bloC.updateFilter,
                    )),
              if (editorState.mIsFrameVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: editorState.mIsFrameVisible ? 120 : 0,
                  width: context.width(),
                  child: FrameSelectionWidget(onSelect: (v) {
                    _bloC.changeFrame(v);
                    // appStore.addUndoList(
                    //     undoModel: UndoModel(type: 'frame', data: v));
                  }),
                ),
              if (editorState.mIsBlurVisible)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: editorState.mIsBlurVisible ? 120 : 0,
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

                        /// Will be added in next update due to multiple finger bug
                        BottomBarItemWidget(
                            title: 'Pen',
                            icons: const Icon(FontAwesomeIcons.penFancy).icon,
                            onTap: _bloC.onPenClick),
                        BottomBarItemWidget(
                            title: 'Brightness',
                            icons: const Icon(Icons.brightness_2_outlined).icon,
                            onTap: _bloC.onBrightnessSliderClick),
                        BottomBarItemWidget(
                            title: 'Contrast',
                            icons: const Icon(Icons.brightness_4_outlined).icon,
                            onTap: _bloC.onContrastSliderClick),
                        BottomBarItemWidget(
                            title: 'Saturation',
                            icons: const Icon(Icons.brightness_4_sharp).icon,
                            onTap: _bloC.onSaturationSliderClick),
                        BottomBarItemWidget(
                            title: 'Hue',
                            icons:
                                const Icon(Icons.brightness_medium_sharp).icon,
                            onTap: _bloC.onHueSliderClick),
                        BottomBarItemWidget(
                            title: 'Blur',
                            icons: const Icon(MaterialCommunityIcons.blur).icon,
                            onTap: _bloC.onBlurClick),
                        BottomBarItemWidget(
                            title: 'Filter',
                            icons: const Icon(Icons.photo).icon,
                            onTap: _bloC.onFilterClick),
                        BottomBarItemWidget(
                            title: 'Add Text Templet',
                            icons: const Icon(Icons.format_shapes_sharp).icon,
                            onTap: () => onTextTemplet()),
                        BottomBarItemWidget(
                            title: 'Border',
                            icons: const Icon(Icons.format_shapes_sharp).icon,
                            onTap: _bloC.onBorderSliderClick),
                        BottomBarItemWidget(
                          title: 'Frame',
                          icons: !getBoolAsync(isFrameRewarded)
                              ? const Icon(Icons.filter_frames).icon
                              : const Icon(Icons.lock_outline_rounded).icon,
                          onTap: _bloC.onFrameClick,
                        )
                      ],
                    ).visible(!editorState.mIsText),
                    TextEditorToolBar(
                      scrollController: scrollController,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
