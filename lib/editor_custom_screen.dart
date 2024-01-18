import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_editor/screens/photo_edit_builder_screen.dart';
import 'package:image_editor/screens/widgets/editor_bottom_bar.dart';
import 'package:image_editor/screens/widgets/text_editor_tool_bar.dart';
import 'package:image_editor/screens/widgets/top_bar.dart';

class EditorCustomScreen extends StatelessWidget {
  const EditorCustomScreen({required this.files, super.key});
  final List<File> files;
  @override
  Widget build(BuildContext context) {
    return PhotoEditBuilderScreen(
      backgroundColor: Colors.black,
      files: files,
      topbarBuilder: (imageState, editorState, listScreenshotControllers) =>
          CustomTopbar(
        imageState: imageState,
        editorState: editorState,
        listScreenshotControllers: listScreenshotControllers,
      ),
      editorBottomBarBuilder: (editorState, imageState, scrollController) =>
          CustomEditorBottomBar(
        editorState: editorState,
        imageState: imageState,
        scrollController: scrollController,
      ),
    );
  }
}

class CustomTopbar extends Topbar {
  const CustomTopbar({
    super.key,
    required super.imageState,
    required super.editorState,
    required super.listScreenshotControllers,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
      ],
    );
  }
}

class CustomEditorBottomBar extends EditorBottomBar {
  const CustomEditorBottomBar({
    super.key,
    required super.editorState,
    required super.imageState,
    required super.scrollController,
  });

  @override
  State<CustomEditorBottomBar> createState() => _CustomEditorBottomBarState();
}

class _CustomEditorBottomBarState extends State<CustomEditorBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                // widget.editorState.rotateImage(90);
              },
              icon: const Icon(
                Icons.rotate_left,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                // widget.editorState.rotateImage(-90);
              },
              icon: const Icon(
                Icons.rotate_right,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                // widget.editorState.flipImage(true);
              },
              icon: const Icon(
                Icons.flip,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                // widget.editorState.flipImage(false);
              },
              icon: const Icon(
                Icons.flip,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}

class CustomTextEditorToolBar extends TextEditorToolBar {
  const CustomTextEditorToolBar(
      {super.key, required super.editorState, required super.scrollController});

  @override
  State<CustomTextEditorToolBar> createState() =>
      _CustomTextEditorToolBarState();
}

class _CustomTextEditorToolBarState extends State<CustomTextEditorToolBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                // widget.editorState.rotateImage(90);
              },
              icon: const Icon(
                Icons.rotate_left,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                // widget.editorState.rotateImage(-90);
              },
              icon: const Icon(
                Icons.rotate_right,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                // widget.editorState.flipImage(true);
              },
              icon: const Icon(
                Icons.flip,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                // widget.editorState.flipImage(false);
              },
              icon: const Icon(
                Icons.flip,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
