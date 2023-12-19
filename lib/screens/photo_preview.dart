import 'package:flutter/material.dart';
import 'package:image_editor/blocs/image_state.dart';
import 'package:image_editor/blocs/photo_edit_blocs.dart';
import 'package:image_editor/components/ImageFilterWidget.dart';
import 'package:image_editor/components/SignatureWidget.dart';
import 'package:image_editor/components/StackedWidgetComponent.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class PhotoPreview extends StatelessWidget {
  final bool mIsPenEnabled;

  const PhotoPreview({Key? key, this.mIsPenEnabled = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloC = context.read<PhotoEditBloC>();

    return StreamBuilder<ImageState>(
        stream: bloC.imageStateStream,
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox();
          final imageState = snap.data!;
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
                  ignoring: !mIsPenEnabled,
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
}
