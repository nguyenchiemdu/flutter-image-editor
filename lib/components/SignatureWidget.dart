import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../utils/SignatureLibWidget.dart';

// ignore: must_be_immutable
class SignatureWidget extends StatefulWidget {
  final SignatureController? signatureController;
  final double? height;
  final double? width;

  List<Offset?>? points;

  SignatureWidget(
      {super.key,
      this.signatureController,
      this.points,
      this.height,
      this.width});

  @override
  SignatureWidgetState createState() => SignatureWidgetState();
}

class SignatureWidgetState extends State<SignatureWidget> {
  @override
  void initState() {
    super.initState();
    widget.signatureController!.addListener(() => log('Value changed'));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox object = context.findRenderObject() as RenderBox;
          var localPosition = object.globalToLocal(details.globalPosition);
          widget.points = List.from(widget.points!)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) {
        widget.points!.add(null);
      },
      child: Signature(
        controller: widget.signatureController,
        height: widget.height,
        width: widget.width,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
