import 'dart:convert';

import 'package:app_camera/res/R.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class FullScreenImageScreen extends StatelessWidget {
  final List<String> base64Strings;
  final int initialIndex;

  FullScreenImageScreen({
    required this.base64Strings,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: PhotoViewGallery.builder(
              itemCount: base64Strings.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(
                    base64Decode(base64Strings[index]),
                  ),
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
                    CupertinoIcons.xmark,
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
