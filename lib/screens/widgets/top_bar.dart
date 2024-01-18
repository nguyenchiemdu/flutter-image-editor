import 'package:flutter/material.dart';
import 'package:image_editor/blocs/photo_edit_blocs.dart';
import 'package:image_editor/blocs/states/editor_state.dart';
import 'package:image_editor/blocs/states/image_state.dart';
import 'package:image_editor/services/file_service.dart';
import 'package:image_editor/utils/app_permission_handler.dart';
import 'package:image_editor/utils/app_colors.dart';
import 'package:image_editor/utils/app_common.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class Topbar extends StatelessWidget {
  const Topbar(
      {required this.imageState,
      required this.editorState,
      required this.listScreenshotControllers,
      super.key});
  final ImageState imageState;
  final EditorState editorState;
  final List<ScreenshotController> listScreenshotControllers;

  Future<void> checkPermissionAndCaptureImage(
      BuildContext context, PhotoEditBloC bloC) async {
    checkPermission(context, func: () {
      _capture(bloC).whenComplete(() => log("done"));
    });
  }

  Future<void> _capture(PhotoEditBloC bloC) async {
    bloC.onEditorCapture();
    final currentIndex = bloC.currentImageIndex.value;
    await listScreenshotControllers[currentIndex]
        .captureAndSave(await getFileSavePath(), delay: 1.seconds)
        .then((value) async {
      log('Saved : $value');

      //save in gallery
      // final bytes = await File(value!).readAsBytes();
      // await ImageGallerySaver.saveImage(bytes.buffer.asUint8List(), name: fileName(value));
      await ImageGallerySaver.saveFile(value!, name: fileName(value));
      toast('Saved');
    }).catchError((e) {
      log(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloC = context.read<PhotoEditBloC>();
    return Container(
      height: imageState.topWidgetHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _closeButton(context, bloC.closeTextEditor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              0.width,
              GestureDetector(
                onTap: () => log('tap'),
                onTapDown: (v) {
                  bloC.showBeforeImage();
                },
                onTapUp: (v) {
                  bloC.unShowBeforeImage();
                },
                onTapCancel: () {
                  bloC.unShowBeforeImage();
                },
                child: const Icon(Icons.compare_rounded).paddingAll(0),
              ),
              Text(editorState.mIsText ? 'Done' : 'Save',
                      style: boldTextStyle(color: colorPrimary))
                  .paddingSymmetric(horizontal: 16, vertical: 8)
                  .withShaderMaskGradient(const LinearGradient(
                      colors: [itemGradient1, itemGradient2]))
                  .onTap(() async {
                editorState.mIsText
                    ? bloC.onTextEditorDone()
                    : checkPermissionAndCaptureImage(context, bloC);
              }, borderRadius: radius())
            ],
          ),
        ],
      ).paddingTop(0),
    );
  }

  Widget _closeButton(BuildContext context, VoidCallback onClose) => IconButton(
        onPressed: () {
          showConfirmDialogCustom(context,
              title: 'Your edited image will be lost',
              primaryColor: colorPrimary,
              positiveText: 'Ok',
              negativeText: 'Cancel', onAccept: (BuildContext context) async {
            onClose.call();
            Navigator.pop(context);
          });
        },
        icon: const Icon(Icons.close),
      );
}
