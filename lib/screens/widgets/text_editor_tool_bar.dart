import 'package:flutter/material.dart';
import 'package:image_editor/blocs/photo_edit_blocs.dart';
import 'package:image_editor/blocs/states/editor_state.dart';
import 'package:image_editor/components/bottom_bar_item_widget.dart';
import 'package:image_editor/components/text_editor_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class TextEditorToolBar extends StatefulWidget {
  const TextEditorToolBar(
      {required this.editorState, required this.scrollController, super.key});
  final ScrollController scrollController;
  final EditorState editorState;

  @override
  State<TextEditorToolBar> createState() => _TextEditorToolBarState();
}

class _TextEditorToolBarState extends State<TextEditorToolBar> {
  late final _bloC = context.read<PhotoEditBloC>();
  late final EditorState editorState = widget.editorState;

  onTextEditClick() async {
    final imageState = _bloC.currentImageState();
    String? text = await showInDialog(context,
        builder: (_) => TextEditorDialog(
              text: imageState.mStackedWidgetList.last.value,
            ));
    _bloC.changeLastTextValue(text);
  }

  late List<Map<String, dynamic>> listButton = [
    {
      "title": "Edit",
      "icons": const Icon(Icons.edit).icon,
      "onTap": onTextEditClick,
    },
    {
      "title": "Font Family",
      "icons": const Icon(Icons.text_fields_rounded).icon,
      "onTap": _bloC.onTextStyle,
    },
    {
      "title": "Font Size",
      "icons": const Icon(Icons.font_download_outlined).icon,
      "onTap": _bloC.onTextFontSizeTap,
    },
    {
      "title": "Bg Color",
      "icons": const Icon(Icons.color_lens_outlined).icon,
      "onTap": _bloC.onTextBgColorTap,
    },
    {
      "title": "Text Color",
      "icons": const Icon(Icons.format_color_fill).icon,
      "onTap": _bloC.onTextColorTap,
    },
    {
      "title": "Remove",
      "icons": const Icon(Icons.delete_outline_outlined).icon,
      "onTap": _bloC.onTextRemoveTap,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.scrollController,
      scrollDirection: Axis.horizontal,
      children: [
        ...listButton.map((e) {
          return BottomBarItemWidget(
            title: e['title'],
            icons: e['icons'],
            onTap: e['onTap'],
          );
        }).toList(),
      ],
    ).visible(editorState.mIsText);
  }
}
