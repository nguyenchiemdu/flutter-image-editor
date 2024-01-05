import 'package:flutter/material.dart';
import '../utils/color_filter_generator.dart';

class ImageFilterWidget extends StatelessWidget {
  final double? brightness;
  final double? saturation;
  final double? hue;
  final double? contrast;
  final Widget? child;

  const ImageFilterWidget(
      {super.key,
      this.brightness,
      this.saturation,
      this.hue,
      this.contrast,
      this.child});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: brightness != 0.0
          ? ColorFilter.matrix(
              ColorFilterGenerator.brightnessAdjustMatrix(value: brightness!))
          : const ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
      child: ColorFiltered(
        colorFilter: saturation != 0.0
            ? ColorFilter.matrix(
                ColorFilterGenerator.saturationAdjustMatrix(value: saturation!))
            : const ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
        child: ColorFiltered(
          colorFilter: hue != 0.0
              ? ColorFilter.matrix(
                  ColorFilterGenerator.hueAdjustMatrix(value: hue!))
              : const ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
          child: ColorFiltered(
            colorFilter: contrast != 0.0
                ? ColorFilter.matrix(
                    ColorFilterGenerator.contrastAdjustMatrix(value: contrast!))
                : const ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
            child: child,
          ),
        ),
      ),
    );
  }
}
