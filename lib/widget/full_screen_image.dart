import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullscreenImagePage extends StatefulWidget {
  final List<String> imageUrls;
  final bool isNetwork;
  final int initialPosition;

  const FullscreenImagePage(
      {Key? key,
      required this.imageUrls,
      this.isNetwork = true,
      this.initialPosition = 0})
      : super(key: key);

  @override
  _FullscreenImagePageState createState() => _FullscreenImagePageState();
}

class _FullscreenImagePageState extends State<FullscreenImagePage> {
  late ExtendedPageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController =
        ExtendedPageController(initialPage: widget.initialPosition);
    // SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: ExtendedImageGesturePageView.builder(
              itemCount: widget.imageUrls.length,
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => ExtendedImage.file(
                File(widget.imageUrls[index]),
                fit: BoxFit.contain,
                enableLoadState: true,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (state) => GestureConfig(
                    inPageView: true, initialScale: 1.0, cacheGesture: false),
              ),
            ),
          ),
          Positioned(
              left: 16,
              top: 30,
              child: IconButton(
                  icon: const Icon(CupertinoIcons.xmark),
                  onPressed: () => Navigator.pop(
                        context,
                      )))
        ],
      ),
    );
  }
}
