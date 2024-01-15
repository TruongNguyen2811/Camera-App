import 'dart:io';

import 'package:app_camera/page/chooseImage/media_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ChooseImage extends StatefulWidget {
  const ChooseImage({super.key});

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  List<AssetEntity> selectedAssetList = [];
  @override
  void initState() {
    // TODO: implement initState
    getImagesFromApp();
    super.initState();
  }

  Future pickAssets({
    required int maxCount,
    required RequestType requestType,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MediaPicker(maxCount, requestType, selectedAssetList);
        },
      ),
    );
    if (result?.isNotEmpty ?? false) {
      setState(() {
        selectedAssetList.addAll(result);
      });
    }
  }

  List<File> selectedFiles = [];
  String? mediaUrl = '';
  Future convertAssetsToFiles(List<AssetEntity> assetEntities) async {
    for (var i = 0; i < assetEntities.length; i++) {
      final File? file = await assetEntities[i].originFile;
      print(file?.path);
      setState(() {
        selectedFiles.add(file!);
      });
    }
  }

  getname(AssetEntity assetEntity) async {
    mediaUrl = await assetEntity.title;
    return mediaUrl;
  }

  @override
  Widget build(BuildContext context) {
    // convertAssetsToFiles(selectedAssetList);
    return SafeArea(
      child: Scaffold(
        body: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: selectedAssetList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            AssetEntity assetEntity = selectedAssetList[index];
            getname(assetEntity);
            return Padding(
              padding: const EdgeInsets.all(2),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AssetEntityImage(
                      assetEntity,
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(1000),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.error,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
                  if (assetEntity.type == AssetType.video)
                    const Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.video_collection_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  Container(
                    child: Text("${assetEntity.title}"),
                  )
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pickAssets(
              maxCount: 500,
              requestType: RequestType.image,
            );
          },
          child: const Icon(Icons.image),
        ),
      ),
    );
  }

  Future<List<AssetEntity>> getImagesFromApp() async {
    print('aaaa');
    final optionGroup = FilterOptionGroup(
      imageOption: const FilterOption(
        durationConstraint: DurationConstraint(max: Duration.zero),
        // sizeConstraint: SizeConstraint( 0),
        needTitle: true,
      ),
    );

    final pathList = await PhotoManager.getAssetPathList(onlyAll: true);
    if (pathList.isEmpty) {
      return [];
    }

    final galleryPath = pathList[0];

    final assetList = await galleryPath.getAssetListPaged(page: 0, size: 1000);
    print('check ${assetList.length}');
    for (var i in assetList) {
      print('check ${i.title}');
    }
    return assetList;
  }
}
