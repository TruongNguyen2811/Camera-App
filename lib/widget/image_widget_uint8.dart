import 'dart:typed_data';
import 'package:flutter/material.dart';

class Uint8ListImageWidget extends StatefulWidget {
  final double height;
  final double width;
  final BoxFit fit;
  final Uint8List? imageBytes; // Make it nullable
  final double loadingIndicatorHeight;

  Uint8ListImageWidget({
    required this.height,
    required this.width,
    required this.fit,
    required this.imageBytes,
    this.loadingIndicatorHeight =
        100.0, // Default height for the loading indicator
  });

  @override
  State<Uint8ListImageWidget> createState() => _Uint8ListImageWidgetState();
}

class _Uint8ListImageWidgetState extends State<Uint8ListImageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: image(context),
    );
  }

  Widget _buildErrorWidget() {
    return Icon(
      Icons.error,
      color: Colors.red,
      size: widget.height > widget.width ? widget.height / 2 : widget.width / 2,
    );
  }

  Widget image(BuildContext context) {
    if (widget.imageBytes == null || widget.imageBytes!.isEmpty) {
      return _buildErrorWidget();
    } else {
      return Image.memory(
        widget.imageBytes!,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
        // frameBuilder: (BuildContext context, Widget child, int? frame,
        //     bool wasSynchronouslyLoaded) {
        //   if (wasSynchronouslyLoaded) {
        //     return child;
        //   } else {
        //     return const SizedBox(
        //       height: 10,
        //       width: 10,
        //       child: CircularProgressIndicator(),
        //     );
        //   }
        // },
      );
    }
  }
}
