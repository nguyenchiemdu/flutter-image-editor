import 'package:flutter/material.dart';
import 'package:image_editor/blocs/image_state.dart';
import 'package:image_editor/blocs/photo_edit_blocs.dart';
import 'package:image_editor/components/ImageFilterWidget.dart';
import 'package:image_editor/components/SignatureWidget.dart';
import 'package:image_editor/components/StackedWidgetComponent.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class PhotoPreview extends StatefulWidget {
  final bool mIsPenEnabled;
  final int index;
  final VoidCallback? getImageSize;
  const PhotoPreview(
      {Key? key,
      this.mIsPenEnabled = false,
      required this.index,
      this.getImageSize})
      : super(key: key);

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<PhotoEditBloC>().changeCurrentImageIndex(widget.index);
    widget.getImageSize?.call();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bloC = context.read<PhotoEditBloC>();

    return StreamBuilder<List<ImageState>>(
        stream: bloC.imageStatesStream,
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox();
          final imageStates = snap.data!;
          final imageState = imageStates[widget.index];
          log(widget.index);
          log(imageState.imageHeight);
          log(imageState.imageWidth);
          return Container(
            color: Colors.red,
            height: imageState.imageHeight,
            width: imageState.imageWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                (imageState.filter != null && imageState.filter!.matrix != null)
                    ? ColorFiltered(
                        colorFilter:
                            ColorFilter.matrix(imageState.filter!.matrix!),
                        child: Center(
                          child: ImageFilterWidget(
                            brightness: imageState.brightness,
                            saturation: imageState.saturation,
                            hue: imageState.hue,
                            contrast: imageState.contrast,
                            child: Image.file(imageState.croppedFile!,
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: imageState.outerBorderwidth,
                                    color: imageState.outerBorderColor)),
                            child: ImageFilterWidget(
                              brightness: imageState.brightness,
                              saturation: imageState.saturation,
                              hue: imageState.hue,
                              contrast: imageState.contrast,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.file(imageState.croppedFile!,
                                      fit: BoxFit.fitWidth,
                                      key: imageState.imageKey),
                                  Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: imageState.innerBorderColor
                                                  .withOpacity(0.5),
                                              width:
                                                  imageState.innerBorderwidth)))
                                ],
                              ),
                            ),
                          ),
                          if (imageState.filter != null &&
                              imageState.filter!.color != null)
                            Container(
                              height: imageState.imageHeight,
                              width: imageState.imageWidth,
                              color: Colors.black12,
                            ).withShaderMaskGradient(
                              LinearGradient(
                                  colors: imageState.filter!.color!,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              blendMode: BlendMode.srcOut,
                            ),
                        ],
                      ),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                        sigmaX: imageState.blur, sigmaY: imageState.blur),
                    child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey.withOpacity(0.1)),
                  ),
                ),
                /*(filter != null && filter!.color != null)
                                    ? Container(
                                        //height: context.height(),
                                        width: context.width(),
                                        color: Colors.black12,
                                        child: SizedBox(),
                                      ).withShaderMaskGradient(
                                        LinearGradient(colors: filter!.color!, begin: Alignment.topLeft, end: Alignment.bottomRight),
                                        blendMode: BlendMode.srcOut,
                                      )
                                    : SizedBox(),*/
                imageState.frame != null
                    ? Container(
                        color: Colors.black12,
                        child: Image.asset(imageState.frame!,
                            fit: BoxFit.fill,
                            height: context.height(),
                            width: context.width()),
                      )
                    : const SizedBox(),
                IgnorePointer(
                  ignoring: !widget.mIsPenEnabled,
                  child: SignatureWidget(
                    signatureController: imageState.signatureController,
                    points: imageState.points,
                    width: context.width(),
                    height: context.height() * 0.8,
                  ),
                ),
                StackedWidgetComponent(imageState.mStackedWidgetList),
              ],
            ).center(),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
