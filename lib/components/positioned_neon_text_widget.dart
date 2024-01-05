import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../models/stacked_widget_model.dart';
import '../utils/app_constants.dart';

class PositionedNeonTextWidget extends StatefulWidget {
  final double? left;
  final double? top;
  final Function? onTap;
  final Function(DragUpdateDetails)? onPanUpdate;
  final double? fontSize;
  final String? value;
  final TextAlign? align;

  final StackedWidgetModel? stackedWidgetModel;

  const PositionedNeonTextWidget(
      {super.key,
      this.left,
      this.top,
      this.onTap,
      this.onPanUpdate,
      this.fontSize,
      this.value,
      this.align,
      this.stackedWidgetModel});

  @override
  PositionedTextViewWidgetState createState() =>
      PositionedTextViewWidgetState();
}

class PositionedTextViewWidgetState extends State<PositionedNeonTextWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
        onTap: widget.onTap as void Function()?,
        onPanUpdate: widget.onPanUpdate,
        child: Container(
          decoration: BoxDecoration(borderRadius: radius()),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            widget.value!,
            textAlign: widget.align,
            style: TextStyle(
              fontStyle:
                  widget.stackedWidgetModel?.fontStyle ?? FontStyle.normal,
              fontSize: widget.fontSize,
              color: widget.stackedWidgetModel?.textColor ?? Colors.deepPurple,
              fontFamily: fontNeonLights,
              letterSpacing: 5.0,
              shadows: [
                BoxShadow(
                    color: widget.stackedWidgetModel!.backgroundColor!,
                    blurRadius: 1.0,
                    spreadRadius: 1.0),
                BoxShadow(
                    color: widget.stackedWidgetModel!.backgroundColor!,
                    blurRadius: 30.0,
                    spreadRadius: 30.0),
                BoxShadow(
                    color: widget.stackedWidgetModel!.backgroundColor!,
                    blurRadius: 30.0,
                    spreadRadius: 2.0),
                BoxShadow(
                    color: widget.stackedWidgetModel!.backgroundColor!,
                    blurRadius: 200.0,
                    spreadRadius: 200.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
