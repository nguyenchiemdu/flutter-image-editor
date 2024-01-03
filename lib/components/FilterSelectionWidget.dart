import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../models/ColorFilterModel.dart';
import '../../utils/DataProvider.dart';

class FilterSelectionWidget extends StatefulWidget {
  static String tag = '/FilterSelectionWidget';
  final Function(ColorFilterModel)? onSelect;
  final File? image;
  final bool isAssets;
  final String? freeImage;
  final String? assetPath;

  const FilterSelectionWidget(
      {super.key,
      this.onSelect,
      this.image,
      this.isAssets = false,
      this.freeImage,
      this.assetPath});

  @override
  FilterSelectionWidgetState createState() => FilterSelectionWidgetState();
}

class FilterSelectionWidgetState extends State<FilterSelectionWidget> {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: getFilters().map((e) {
        return Container(
          height: 60,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: radius()),
          margin: const EdgeInsets.all(2),
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.isAssets
                  ? Image.asset(widget.assetPath.validate(), fit: BoxFit.cover)
                      .cornerRadiusWithClipRRect(defaultRadius)
                  : Image.file(widget.image!, fit: BoxFit.cover)
                      .cornerRadiusWithClipRRect(defaultRadius),
              if (e.color != null)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: radius(),
                    gradient: LinearGradient(colors: e.color!),
                  ),
                ),
              if (e.matrix != null)
                ColorFiltered(
                  colorFilter: ColorFilter.matrix(e.matrix!),
                  child: widget.isAssets
                      ? Image.asset(widget.assetPath.validate(),
                              fit: BoxFit.cover)
                          .cornerRadiusWithClipRRect(defaultRadius)
                      : Image.file(widget.image!, fit: BoxFit.cover)
                          .cornerRadiusWithClipRRect(defaultRadius),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  e.name.validate(),
                  style: primaryTextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ).onTap(() {
          widget.onSelect?.call(e);
        });
      }).toList(),
    );
  }
}
