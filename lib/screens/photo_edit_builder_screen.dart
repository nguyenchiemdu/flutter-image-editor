import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_editor/blocs/states/editor_state.dart';
import 'package:image_editor/blocs/states/image_state.dart';
import 'package:image_editor/blocs/photo_edit_blocs.dart';
import 'package:image_editor/screens/photo_preview.dart';
import 'package:image_editor/screens/widgets/editor_bottom_bar.dart';
import 'package:image_editor/screens/widgets/top_bar.dart';
import 'package:image_editor/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class PhotoEditBuilderScreen extends StatefulWidget {
  final List<File> files;
  final Color? backgroundColor;
  final Topbar Function(
    ImageState imageState,
    EditorState editorState,
    List<ScreenshotController> listScreenshotControllers,
  )? topbarBuilder;
  final EditorBottomBar Function(
    EditorState editorState,
    ImageState imageState,
    ScrollController scrollController,
  )? editorBottomBarBuilder;
  const PhotoEditBuilderScreen(
      {this.topbarBuilder,
      this.editorBottomBarBuilder,
      this.backgroundColor,
      super.key,
      required this.files});

  @override
  PhotoEditBuilderScreenState createState() => PhotoEditBuilderScreenState();
}

class PhotoEditBuilderScreenState extends State<PhotoEditBuilderScreen> {
  late final _bloC = context.read<PhotoEditBloC>();
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey key = GlobalKey<PhotoEditBuilderScreenState>();
  final ScrollController scrollController = ScrollController();

  DateTime? currentBackPressTime;

  /// Used to save edited image on storage
  late List<ScreenshotController> listScreenshotControllers =
      List.generate(widget.files.length, (index) => ScreenshotController());
  final GlobalKey screenshotKey = GlobalKey();
  final GlobalKey galleryKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getImagesSize());
    super.initState();
    init();
  }

  Future<void> getImagesSize() async {
    final states = _bloC.listimageStatesCtrl.value;
    final newStates = <ImageState>[];
    final screenWidth = MediaQuery.of(context).size.width;

    await Future.wait(states.map((imageState) async {
      final size =
          await ImageUtil.calculateImageDimension(imageState.originalFile!);
      imageState.imageWidth = screenWidth;
      imageState.imageHeight = (screenWidth * size.height) / size.width;
      newStates.add(imageState);
    }));
    _bloC.listimageStatesCtrl.add(newStates);
  }

  Future<void> init() async {
    final List<ImageState> imageStateList = [];

    for (var file in widget.files) {
      final ImageState imageState =
          ImageState(imageKey: GlobalKey(), file: file);

      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          _bloC.changeMoreConfigWidgetVisible(false);
        } else {
          _bloC.changeMoreConfigWidgetVisible(true);
        }
      });
      imageStateList.add(imageState);
    }
    _bloC.listimageStatesCtrl.add(imageStateList);
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toast('Your edited image will be lost\nPress back again to go back');
      return Future.value(false);
    }
    return Future.value(true);
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
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: _streamBuilderWrapper(({
          required EditorState editorState,
          required ImageState imageState,
        }) {
          return Stack(
            children: [
              Column(
                children: [
                  widget.topbarBuilder?.call(
                          imageState, editorState, listScreenshotControllers) ??
                      Topbar(
                        imageState: imageState,
                        editorState: editorState,
                        listScreenshotControllers: listScreenshotControllers,
                      ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      // This widget will be saved as edited Image
                      PageView.builder(
                          onPageChanged: (index) {
                            context.read<PhotoEditBloC>()
                              ..changeCurrentImageIndex(index)
                              ..onTextEditorDone();
                          },
                          itemCount: widget.files.length,
                          itemBuilder: (ctx, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Screenshot(
                                  controller: listScreenshotControllers[index],
                                  child: PhotoPreview(
                                    mIsPenEnabled: editorState.mIsPenEnabled,
                                    index: index,
                                  ),
                                ),
                              ],
                            );
                          }),

                      /// Show preview of edited image before save
                      Image.file(imageState.croppedFile!, fit: BoxFit.cover)
                          .visible(true)
                          .visible(editorState.mShowBeforeImage),
                    ],
                  ).expand(),
                  StreamBuilder<List<ImageState>>(
                      stream: _bloC.imageStatesStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox();
                        }
                        final imageStates = snapshot.data!;
                        final currentIndex = _bloC.currentImageIndex.value;
                        final imageState = imageStates[currentIndex];
                        return widget.editorBottomBarBuilder?.call(
                                editorState, imageState, scrollController) ??
                            EditorBottomBar(
                              editorState: editorState,
                              imageState: imageState,
                              scrollController: scrollController,
                            );
                      })
                ],
              ).paddingTop(context.statusBarHeight),
            ],
          );
        }),
      ),
    );
  }

  Widget _streamBuilderWrapper(
      Widget Function(
              {required ImageState imageState,
              required EditorState editorState})
          callback) {
    return StreamBuilder<EditorState>(
        stream: _bloC.editorStateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final editorState = snapshot.data!;
          return StreamBuilder<int>(
              stream: _bloC.currentImageIndex.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final currentIndex = snapshot.data!;
                return StreamBuilder<List<ImageState>>(
                    stream: _bloC.imageStatesStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();
                      final imageStates = snapshot.data!;
                      final imageState = imageStates[currentIndex];
                      return callback(
                        imageState: imageState,
                        editorState: editorState,
                      );
                    });
              });
        });
  }
}
