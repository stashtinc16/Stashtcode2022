import 'dart:io';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:stasht/utils/constants.dart';

class MemoriesController extends GetxController {
  RxBool showNext = false.obs;
  var mediaPages = List.empty(growable: true).obs;
  var memoriesList = List.empty(growable: true).obs;
  RxList selectionList = List.empty(growable: true).obs;
  RxList selectedIndexList = List.empty(growable: true).obs;
  final titleController = TextEditingController();
  List<Medium> selectedList = List.empty(growable: true);
  int pageCount = 50;
  int totalCount = 0;
  int skip = 0;
  RxInt selectedCount = 0.obs;
  ScrollController controller = ScrollController();
  List<String> imageUrls = List.empty(growable: true);
  int uploadCount = 0;
  RxBool myMemoriesExpand = false.obs;
  UserModel? userModel;

  @override
  void onInit() {
    super.onInit();
    _promptPermissionSetting();
    getMyMemories();
  }

  @override
  void onReady() {
    super.onReady();
    // getMyMemories();
  }

  void getMyMemories() {
    memoriesList.clear();
    print('userId $userId');
    memoriesRef.get().then((value) => {
          print('value $userId => ${value.docs.length}'),
          value.docs.forEach((element) {
            print('CreatedBy ${element.data().createdBy!} => $userId');
            if (element.data().createdBy! == userId) {
              if (userModel == null) {
                getUserData(element.data().createdBy!);
              }
              MemoriesModel memoriesModel = element.data();
              memoriesModel.memoryId = element.id;
              memoriesList.add(memoriesModel);
            }
          })
        });
  }

  final memoriesRef = FirebaseFirestore.instance
      .collection('memories')
      .withConverter<MemoriesModel>(
        fromFirestore: (snapshots, _) =>
            MemoriesModel.fromJson(snapshots.data()!),
        toFirestore: (memories, _) => memories.toJson(),
      );

  final usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (users, _) => users.toJson(),
      );

  getUserData(String userId) async {
    print('userId $userId');
    await usersRef.doc(userId).get().then((value) => userModel = value.data()!);
  }

  Future<bool> _promptPermissionSetting() async {
    if (Platform.isIOS &&
            await Permission.storage.request().isGranted &&
            await Permission.photos.request().isGranted ||
        Platform.isAndroid && await Permission.storage.request().isGranted) {
      getAlbums();
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
        print('imageAlbums[i] ${imageAlbums[i]}');
        getListData(imageAlbums[i]);
        // paginationData(imageAlbums[i]);
      }
    }
  }

  void paginationData(Album album) {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        if (album.name == "All" || album.name == "Recent") {
          if (skip < totalCount) {
            skip = skip + pageCount;
            getListData(album);
          }

          // pageCount+=50;
        }
      }
    });
  }

  // get Images from albums
  void getListData(Album album) async {
    MediaPage imagePage = await album.listMedia(
      newest: true,
    );

    totalCount = imagePage.total;
    selectionList = List.filled(totalCount, false).obs;
    mediaPages.value.addAll(imagePage.items);
  }

  // Get Total count of selected items
  void getSelectedCount() {
    selectedCount.value = 0;
    selectionList.fold(
        false,
        (previousValue, element) => {
              if (element)
                {
                  print(
                      'element $element <==> ${selectionList.indexOf(element)}'),
                  selectedCount.value += 1,
                  // selectedIndexList.add(selectionList.indexOf(element))
                }
            });
  }

  void addIndex(int index, bool selected) {
    if (selected) {
      selectedIndexList.add(index);
    } else {
      selectedIndexList.remove(index);
    }
  }

  Future<void> uploadImagesToMemories(int imageIndex) async {
    if (selectedIndexList.length > 0) {
      if (imageIndex == 0) {
        EasyLoading.show(status: 'Uploading...');
      }
      //selectedIndexList = index of selected items from main photos list
      final dir = await path_provider.getTemporaryDirectory();

      final File file =
          await mediaPages[selectedIndexList[imageIndex]].getFile();
      final targetPath =
          dir.absolute.path + "/temp${DateTime.now().millisecond}.jpg";

      final File? newFile = await testCompressAndGetFile(file, targetPath);
      final UploadTask? uploadTask = await uploadFile(
          newFile!, mediaPages[selectedIndexList[imageIndex]].filename);
    } else {
      Get.snackbar('Error', "Please select images");
    }
  }

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask?> uploadFile(File file, String fileName) async {
    UploadTask uploadTask;
    print('fileName $fileName');
    // Create a Reference to the file
    Reference ref =
        FirebaseStorage.instance.ref().child('memories').child('/$fileName');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );

    print('metaData ${metadata.customMetadata}');

    uploadTask = ref.putFile(io.File(file.path), metadata);
    uploadTask.whenComplete(() => {
          uploadTask.snapshot.ref.getDownloadURL().then((value) => {
                print('URl $value'),
                imageUrls.add(value),
                if (imageUrls.length < selectedIndexList.length)
                  {
                    uploadCount += 1,
                    uploadImagesToMemories(uploadCount),
                  }
                else
                  {EasyLoading.dismiss(), createMemories()}
              })
        });

    return Future.value(uploadTask);
  }

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    print("testCompressAndGetFile ${file.path}");
    print('Exists ${file.lengthSync()}');
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
      minWidth: 600,
      minHeight: 600,
    );

    return result;
  }

  // Create memories to Firebase
  void createMemories() {
    EasyLoading.show(status: 'Creating Memory');
    MemoriesModel memoriesModel = MemoriesModel(
        caption: "",
        title: titleController.text.toString(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: userId,
        images: imageUrls,
        inviteLink: "",
        published: false,
        users: []);
    memoriesRef
        .add(memoriesModel)
        .then((value) => {
              EasyLoading.dismiss(),
              Get.snackbar('Success', 'Memory folder created successfully'),
              Get.offAllNamed(AppRoutes.memories)
            })
        .onError((error, stackTrace) => {EasyLoading.dismiss()});
  }
}
