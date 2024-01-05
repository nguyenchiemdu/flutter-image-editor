import 'package:flutter/material.dart';
import 'package:image_editor/blocs/states/image_state.dart';
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
  const PhotoPreview({
    Key? key,
    this.mIsPenEnabled = false,
    required this.index,
  }) : super(key: key);

  @override
  State<PhotoPreview> createState() => _PhotoPreviewState();
}

class _PhotoPreviewState extends State<PhotoPreview>
    with AutomaticKeepAliveClientMixin {
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
          return SizedBox(
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
                          ImageFilterWidget(
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
                              ],
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
                imageState.frame != null
                    ? Container(
                        color: Colors.black12,
                        child: Image.asset(imageState.frame!,
                            fit: BoxFit.fill,
                            height: context.height(),
                            width: context.width()),
                      )
                    : const SizedBox(),
                if (imageState.imageWidth != null &&
                    imageState.imageHeight != null)
                  IgnorePointer(
                    ignoring: !widget.mIsPenEnabled,
                    child: SignatureWidget(
                      signatureController: imageState.signatureController,
                      points: imageState.points,
                      width: imageState.imageWidth,
                      height: imageState.imageHeight,
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
