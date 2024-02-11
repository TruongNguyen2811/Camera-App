import 'dart:convert';

import 'package:app_camera/res/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageScreenUint8 extends StatelessWidget {
  final List<Uint8List> imageBytes;
  final int initialIndex;

  FullScreenImageScreenUint8({
    required this.imageBytes,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: PhotoViewGallery.builder(
              itemCount: imageBytes.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(imageBytes[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                color: Colors.black,
              ),
              pageController: PageController(initialPage: initialIndex),
              onPageChanged: (index) {
                // Do something when the page changes
              },
            ),
          ),
          Positioned(
              left: 16,
              top: 40,
              child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: R.color.white,
                  ),
                  onPressed: () => Navigator.pop(
                        context,
                      )))
        ],
      ),
    );
  }
}
