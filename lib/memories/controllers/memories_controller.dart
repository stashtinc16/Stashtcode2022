import 'dart:io';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stasht/routes/app_routes.dart';

class MemoriesController extends GetxController {
  RxBool showNext = false.obs;
  RxList mediaPages = List.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    _promptPermissionSetting();
    getAlbums();
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      return true;
    }
    return false;
  }

// Go To Step 1
  void createMemoriesStep1() {
    Get.toNamed(AppRoutes.memoriesStep1);
  }

//Get Media from Albums
  Future<void> getAlbums() async {
    final List<Album> imageAlbums =
        await PhotoGallery.listAlbums(mediumType: MediumType.image);
    for (int i = 0; i < imageAlbums.length; i++) {
      if (imageAlbums[i].name == "All" || imageAlbums[i].name == "Recent") {
        final MediaPage imagePage =
            await imageAlbums[i].listMedia(newest: true);
        print('imagePage $imagePage');
        print(
            'controller.mediaPages[index].filename ${imagePage.items[0].filename}');
        mediaPages.value = imagePage.items;
      }
    }
  }
}
