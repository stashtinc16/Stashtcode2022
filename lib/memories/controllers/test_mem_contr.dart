// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exif/exif.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stasht/imagePicker/selected_assets_list_view.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/notifications/domain/notification_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/splash/domain/share_links_model.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/constants.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MemoriesController extends GetxController {
  RxBool showNext = false.obs;
  RxBool showPermission = false.obs;
  var mediaPages = List.empty(growable: true).obs;
  var memoriesList = [].obs;
  var noData = true.obs;
  RxList publishMemoryList = [].obs;
  RxList sharedMemoriesList = [].obs;
  RxList selectionList = List.empty(growable: true).obs;
  RxList selectedIndexList = List.empty(growable: true).obs;
  final titleController = TextEditingController();
  List<Medium> selectedList = List.empty(growable: true);
  ScrollController scrollController = ScrollController();
  MemoriesModel? detailMemoryModel;

  int pageCount = 50;
  int totalCount = 0;
  int skip = 0;
  RxInt selectedCount = 0.obs;
  List<ImagesCaption> imageCaptionUrls = List.empty(growable: true);
  int uploadCount = 0;
  RxBool myMemoriesExpand = false.obs;
  RxBool showPermissions = false.obs;
  RxBool sharedMemoriesExpand = false.obs;
  RxBool publishMemoriesExpand = false.obs;
  RxBool allowBackPress = true.obs;
  RxInt hasMemory = 0.obs;
  Rx<PermissionStatus> permissionStatus = PermissionStatus.denied.obs;
  RxBool hasFocus = false.obs;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  List<Asset> images = List<Asset>.empty(growable: true).obs;
  RxBool isPageOpened = true.obs;
  String URI_PREFIX_FIREBASE = "https://stasht2.page.link";
  String DEFAULT_FALLBACK_URL_ANDROID = "https://stasht2.page.link";
  List<Asset> resultList = List<Asset>.empty(growable: true);
  List<AssetEntity> resultgetList = List<AssetEntity>.empty(growable: true);
  Rx<Uri> shareLink = Uri().obs;
  List<AssetEntity> assets = List<AssetEntity>.empty(growable: true);
  int get maxAssetsCount => 10;
  bool isChanged = true;
  @override
  void onInit() {
    super.onInit();
    // promptPermissionSetting();
    sharedMemoriesExpand.value = fromShare;

    getMyMemories();
    getSharedMemories();
    getPublishedMemories();
    // getUsers();
  }

  void getUsers() {
    bool shouldCall = false;
    usersRef.snapshots().listen((event) {
      shouldCall = false;
    }).onData((data) {
      // shouldCall = true;
      memoriesRef.snapshots().listen((event) {}).onData((data) {
        shouldCall = false;
      });
      if (!shouldCall) {
        // getMyMemories();
        // getSharedMemories();
        // getPublishedMemories();
        shouldCall = true;
      }
    });
  }

  // get Published memories list
  void getPublishedMemories() {
    publishMemoryList.clear();
    memoriesRef
        .where("created_by", isEqualTo: userId)
        .where("published", isEqualTo: true)
        .orderBy("published_created_at", descending: true)
        .snapshots()
        .listen((publishElement) {
      publishMemoryList.clear();
      publishElement.docs.forEach((element) {
        if (userId.isNotEmpty) {
          usersRef.doc(userId).get().then(
            (userValue) {
              List<ImagesCaption> imagesList = List.empty(growable: true);
              MemoriesModel memoriesModel = element.data();
              memoriesModel.memoryId = element.id;
              memoriesModel.userModel = userValue.data()!;
              if (element.data().sharedWith != null) {
                element.data().sharedWith!.forEach((elementShare) {
                  if (elementShare.status == 1) {
                    memoriesModel.sharedWithCount =
                        memoriesModel.sharedWithCount! + 1;
                  }
                });
              }
              element.data().imagesCaption!.forEach((innerElement) async {
                await usersRef.doc(innerElement.userId).get().then((imageUser) {
                  if (imageUser.data() != null) {
                    ImagesCaption imagesCaption = innerElement;
                    imagesCaption.userModel = imageUser.data()!;
                    imagesList.add(imagesCaption);
                    if (imagesList.length ==
                        element.data().imagesCaption!.length) {
                      memoriesModel.imagesCaption = imagesList;
                      try {
                        memoriesModel.imagesCaption!.sort((first, second) {
                          return second.updatedAt!.compareTo(first.updatedAt!);
                        });
                      } catch (e) {}

                      updatePublishMemoriesWithData(
                          memoriesModel, element.id, publishElement);
                    }
                  }
                });
              });
            },
          );
        }
      });
    });
  }

  //get Shared memories
  void getSharedMemories() {
    sharedMemoriesList.clear();

    FirebaseFirestore.instance
        .collection(memoriesCollection)
        .withConverter<MemoriesModel>(
          fromFirestore: (snapshots, _) =>
              MemoriesModel.fromJson(snapshots.data()!),
          toFirestore: (memories, _) => memories.toJson(),
        )
        .where('shared_with', arrayContainsAny: [
          {'user_id': userId, 'status': 0},
          {'user_id': userId, 'status': 1}
        ])
        .orderBy('shared_created_at', descending: true)
        .snapshots()
        .listen((sharedValue) => {
              sharedMemoriesList.clear(),
              sharedValue.docs.forEach((element) {
                usersRef.doc(element.data().createdBy!).get().then((userValue) {
                  List<ImagesCaption> imagesList = List.empty(growable: true);
                  MemoriesModel memoriesModel = element.data();
                  memoriesModel.memoryId = element.id;
                  memoriesModel.userModel = userValue.data()!;

                  element.data().sharedWith!.forEach((elementShare) {
                    if (elementShare.status == 1) {
                      memoriesModel.sharedWithCount =
                          memoriesModel.sharedWithCount! + 1;
                    }
                  });

                  element.data().imagesCaption!.forEach((innerElement) async {
                    await usersRef
                        .doc(innerElement.userId)
                        .get()
                        .then((imageUser) {
                      ImagesCaption imagesCaption = innerElement;
                      if (imageUser.data() != null) {
                        imagesCaption.userModel = imageUser.data()!;
                        imagesList.add(imagesCaption);
                        if (imagesList.length ==
                            element.data().imagesCaption!.length) {
                          memoriesModel.imagesCaption = imagesList;
                          try {
                            memoriesModel.imagesCaption!.sort((first, second) {
                              return second.updatedAt!
                                  .compareTo(first.updatedAt!);
                            });
                          } catch (e) {}
                          if (sharedMemoriesList.length <
                              sharedValue.docs.length) {
                            sharedMemoriesList.add(memoriesModel);
                            sharedMemoryCount.value = sharedMemoriesList.length;
                            update();
                          }

                          if (sharedMemoriesList.length ==
                              sharedValue.docs.length) {
                            if (!myMemoriesExpand.value) {
                              expandShareMemory = true;
                              sharedMemoriesExpand.value = true;
                            }

                            update();
                          }
                        }
                      } else {}
                    });
                  });
                });
              }),
              if (sharedMemoriesList.isEmpty)
                {
                  sharedMemoryCount.value = 0,
                  sharedMemoriesExpand.value = false,
                  expandShareMemory = false
                },
              if (sharedValue.docs.isEmpty)
                {
                  sharedMemoriesList.clear(),
                  sharedMemoryCount.value = 0,
                  sharedMemoriesExpand.value = false,
                  expandShareMemory = false,
                  update()
                },
            })
        .onError((error, stackTrace) => {});
  }

  // delete memory images
  void deleteMemoryImages(String memoryId, int removeIndex,
      MemoriesModel memoriesModel, ImagesCaption imagesCaption) {
    List<int> removeItemList = List.empty(growable: true);
    removeItemList.add(removeIndex);
    MemoriesModel memoriesModels = memoriesModel;
    memoriesModels.imagesCaption!.removeAt(removeIndex);
    memoriesRef.doc(memoryId).update(memoriesModels.toJson()).then((value) => {
          memoriesList.remove(removeIndex),
          update(),
          if (memoriesModels.imagesCaption!.isEmpty)
            {
              deleteMemory(memoriesModel),
              Get.back(),
            }
        });
  }

  // delete a memory
  void deleteMemory(MemoriesModel memoriesModel) {
    memoriesRef.doc(memoriesModel.memoryId).delete().then((value) => {
          memoriesList.remove(memoriesModel),
          if (memoriesList.isEmpty) {myMemoriesExpand.value = false}
        });
  }

  // update memory invite status
  void updateJoinStatus(
      int isJoined, int mainIndex, int shareIndex, MemoriesModel model) {
    MemoriesModel memoriesModel = MemoriesModel();
    memoriesModel = model;
    memoriesModel.sharedWith![shareIndex].status = isJoined;
    memoriesModel.sharedWith![shareIndex].userId = userId;

    memoriesRef
        .doc(model.memoryId)
        .set(memoriesModel)
        .then((value) => {
              update(),
            })
        .onError((error, stackTrace) => {EasyLoading.dismiss()});
  }

  // update invite link to memory
  void updateInviteLink(MemoriesModel model, String inviteLink) {
    MemoriesModel memoriesModel = MemoriesModel();
    memoriesModel = model;
    memoriesModel.inviteLink = inviteLink;
    memoriesRef.doc(model.memoryId).set(memoriesModel).then((value) {
      // Get.back()
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
    });
  }

  // update notification count as 0
  void updateNotificationCount() {
    usersRef.doc(userId).update({"notification_count": 0});
  }

//get memory data for detail page
  void getMyMemoryData(memoryId) {
    memoriesRef.doc(memoryId).snapshots().listen((event) {
      List<SharedWith> shareWithList = List.empty(growable: true);
      if (event.data() != null && event.data()!.sharedWith != null) {
        for (var element in event.data()!.sharedWith!) {
          if (element.status == 1) {
            if (element.userId.isNotEmpty) {
              usersRef.doc(element.userId).get().then((value) {
                UserModel model = value.data()!;
                shareWithList.add(SharedWith(
                    userId: element.userId,
                    status: element.status,
                    sharedUser: model));
              });
            }
          }
        }
      }

      List<ImagesCaption> captionList = List.empty(growable: true);
      if (event.data() != null) {
        if (event.data()!.imagesCaption!.isEmpty) {
          Get.back();
        }
        for (var element in event.data()!.imagesCaption!) {
          usersRef.doc(element.userId).get().then((userValue) {
            ImagesCaption imagesCaption = element;
            imagesCaption.userModel = userValue.data();

            captionList.add(imagesCaption);

            if (captionList.length == event.data()!.imagesCaption!.length) {
              captionList.sort(((a, b) {
                return b.updatedAt!.compareTo(a.updatedAt!);
              }));

              usersRef.doc(event.data()!.createdBy).get().then((userValue) {
                detailMemoryModel = event.data()!;
                detailMemoryModel!.userModel = userValue.data()!;
                detailMemoryModel!.memoryId = event.id;
                detailMemoryModel!.imagesCaption = captionList;
                detailMemoryModel!.sharedWith = shareWithList;

                hasMemory.value = 2;
                update();
              });
            }
          });
        }
      } else {
        hasMemory.value = 1;
        update();
      }
    });
  }

// Get my memories list
  void getMyMemories() {
    memoriesList.clear();
    memoriesRef
        .where('created_by', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .where("published", isEqualTo: false)
        .snapshots()
        .listen((value) => {
              memoriesList.clear(),
              noData.value = value.docs.isNotEmpty,
              value.docs.forEach((element) {
                usersRef.doc(userId).get().then(
                  (userValue) {
                    List<ImagesCaption> imagesList = List.empty(growable: true);
                    MemoriesModel memoriesModel = element.data();
                    memoriesModel.memoryId = element.id;
                    memoriesModel.userModel = userValue.data()!;
                    if (element.data().sharedWith != null &&
                        element.data().sharedWith!.isNotEmpty) {
                      // if (element.data().sharedWith != null  {
                      element.data().sharedWith!.forEach((elementShare) {
                        if (elementShare.status == 1) {
                          memoriesModel.sharedWithCount =
                              memoriesModel.sharedWithCount! + 1;
                        }
                      });
                    }
                    // if(element.data().imagesCaption!.isNotEmpty)
                    element.data().imagesCaption!.forEach((innerElement) async {
                      await usersRef
                          .doc(innerElement.userId)
                          .get()
                          .then((imageUser) {
                        if (imageUser.data() != null) {
                          ImagesCaption imagesCaption = innerElement;
                          imagesCaption.userModel = imageUser.data()!;
                          imagesList.add(imagesCaption);
                          if (imagesList.length ==
                              element.data().imagesCaption!.length) {
                            memoriesModel.imagesCaption = imagesList;
                            try {
                              memoriesModel.imagesCaption!
                                  .sort((first, second) {
                                return second.updatedAt!
                                    .compareTo(first.updatedAt);
                              });
                            } catch (e) {}

                            updateMemoriesWithData(
                                memoriesModel, element.id, value);
                          }
                        }
                      });
                    });
                  },
                );
              })
            });
  }

  updateMemoriesWithData(MemoriesModel model, String memoryId,
      QuerySnapshot<MemoriesModel> value) {
    int index = 0;
    var notificationValue = memoriesList.where((p0) {
      index = memoriesList.indexOf(p0);
      return p0.memoryId == memoryId;
    });

    if (value.docs.isNotEmpty) {
      if (notificationValue.isNotEmpty) {
        memoriesList[index] = model;
      } else {
        if (memoriesList.length < value.docs.length) {
          memoriesList.add(model);
        }
      }
    } else {
      if (memoriesList.length < value.docs.length) {
        memoriesList.add(model);
      }
    }

    if (memoryId == value.docs[value.docs.length - 1].id) {
      memoriesList.sort(
        (a, b) {
          return b.updatedAt!.compareTo(a.updatedAt);
        },
      );
      if (memoriesList.isEmpty) {
        myMemoriesExpand.value = false;
      } else {
        myMemoriesExpand.value = true;
      }
      update();
    }
  }

  updatePublishMemoriesWithData(MemoriesModel model, String memoryId,
      QuerySnapshot<MemoriesModel> value) {
    int index = 0;
    var notificationValue = publishMemoryList.where((p0) {
      index = publishMemoryList.indexOf(p0);
      return p0.memoryId == memoryId;
    });

    if (value.docs.isNotEmpty) {
      if (notificationValue.isNotEmpty) {
        publishMemoryList[index] = model;
      } else {
        if (publishMemoryList.length < value.docs.length) {
          publishMemoryList.add(model);
        }
      }
    } else {
      if (publishMemoryList.length < value.docs.length) {
        publishMemoryList.add(model);
      }
    }

    if (publishMemoryList.length - 1 == value.docs.length - 1) {
      publishMemoryList.sort(
        (a, b) {
          return b.publishedCreatedAt!.compareTo(a.publishedCreatedAt);
        },
      );
      if (publishMemoryList.isEmpty) {
        publishMemoriesExpand.value = false;
      }
      update();
    }
  }

  void shareMemory(index) {
    List<SharedWith> sharedList = List.empty(growable: true);

    MemoriesModel memoriesModel = MemoriesModel();
    memoriesModel = memoriesList[index];
    sharedList = memoriesList[index].sharedWith;
    // sharedList.add(SharedWith(userId: ))

    // memoriesModel.sharedWith = caption;
    EasyLoading.show(status: 'Processing');
    memoriesRef
        .doc(memoriesList[index].memoryId)
        .set(memoriesModel)
        .then((value) => {EasyLoading.dismiss(), Get.back()})
        .onError((error, stackTrace) => {EasyLoading.dismiss()});
  }

// Create Dynamic Link
  Future<void> createDynamicLink(String memoryId, bool short, bool shouldShare,
      MemoriesModel memoriesModel, bool copy) async {
    // if(shareLink.value !=null){
    //   return;
    // }
    String link =
        "$DEFAULT_FALLBACK_URL_ANDROID?memory_id=$memoryId&timestamp=${DateTime.now().millisecondsSinceEpoch}";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: URI_PREFIX_FIREBASE,
      link: Uri.parse(link),
      androidParameters: const AndroidParameters(
        packageName: 'com.app.stasht',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.app.stasht2',
        minimumVersion: '1',
      ),
    );
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      shareLink.value = shortLink.shortUrl;
    } else {
      shareLink.value = await dynamicLinks.buildLink(parameters);
    }
    ShareLinkModel linkModel = ShareLinkModel(
        shareLink: link.toString(),
        linkUsed: false,
        memoryId: memoryId,
        inviteLink: shareLink.value.toString(),
        createdAt: Timestamp.now(),
        usedBy: userId);
    linkRef.add(linkModel).then((value) {});
    if (copy) {
      // copyShareLink(shareLink.value.toString(), memoriesModel.title!);
    } else {
      if (shouldShare) {
        share(
          memoriesModel,
          shareLink.value.toString(),
        );
      }
    }
  }

  // Pick Images from gallery
  Future<void> pickImages(
      String memoryId, context, MemoriesModel? memoriesModel) async {
    try {
      resultgetList = (await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          requestType: RequestType.image,
          maxAssets: maxAssetsCount,
          selectedAssets: assets,
          pickerTheme: ThemeData(
            buttonColor: AppColors.primaryColor,
            backgroundColor: Colors.white,
            accentColor: AppColors.primaryColor,
            bottomAppBarColor: Colors.white,
            primaryColor: Colors.white,
          ),
        ),
      ))!
          .cast<AssetEntity>();
    } catch (e) {
      if (permissionStatus.value == PermissionStatus.granted ||
          permissionStatus.value == PermissionStatus.limited) {
        showPermissions.value = true;
      } else {
        showPermissions.value = false;
      }
    }

    // images = resultList;
    if (resultgetList.isNotEmpty) {
      uploadCount = 0;
      uploadImagesToMemories(0, memoryId, memoriesModel);
    }
  }

  Future<String> getExifFromFile(File psh) async {
    if (psh == null) {
      return "";
    }

    var bytes = await psh.readAsBytes();
    var tags = await readExifFromFile(psh);
    var sb = StringBuffer();

    tags.forEach((k, v) {
      sb.write("$k: $v \n");
    });

    return sb.toString();
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List? bytess;
    await audioFile.readAsBytes().then((value) {
      bytess = Uint8List.fromList(value);
    }).catchError((onError) {});
    return bytess!;
  }

  checkIfLinkExpire(MemoriesModel memoriesModel, String shareText, bool copy) {
    linkRef
        .where("memory_id", isEqualTo: memoriesModel.memoryId)
        .where("link_used", isEqualTo: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        share(memoriesModel, shareText);
      } else {
        createDynamicLink(
            memoriesModel.memoryId!, true, true, memoriesModel, copy);
      }
    });
  }

  createLinkForDetail(MemoriesModel memoriesModel) {
    linkRef
        .where("memory_id", isEqualTo: memoriesModel.memoryId)
        .where("link_used", isEqualTo: false)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        createDynamicLink(
            memoriesModel.memoryId!, true, false, memoriesModel, false);
      } else {
        if (value.docs[0].data().inviteLink != null) {
          shareLink.value = Uri.parse(value.docs[0].data().inviteLink!);
        } else {
          createDynamicLink(
              memoriesModel.memoryId!, true, false, memoriesModel, false);
        }
      }
    });
  }

  // void copyShareLink(String link, String memoryTitle) {
  //   Clipboard.setData(ClipboardData(text: "$shareLink"));
  //   Get.snackbar(memoryTitle, "Link copied", colorText: Colors.white);
  // }

  // Share Dynamic Link
  Future<void> share(MemoriesModel memoriesModel, String shareText) async {
    await FlutterShare.share(
        title: memoriesModel.title!,
        linkUrl: shareText,
        chooserTitle: 'Share memory folder via..');
    updateInviteLink(memoriesModel, shareText);
  }

// Share publish link
  Future<void> sharePublishMemory(
      String memoryTitle, String publishLink) async {
    await FlutterShare.share(
        title: memoryTitle,
        linkUrl: publishLink,
        chooserTitle: 'Publish memory folder via..');
  }

  // copy PublishedLink
  void copyPublishLink(String title, String link) {
    Clipboard.setData(ClipboardData(text: link));
    Get.snackbar(title, "Link copied", colorText: Colors.white);
  }

  // Share Dynamic Link
  Future<void> publishMemory(String memoryTitle, String memoryId) async {
    String publishLink = "https://stasht-246819.web.app/?mId=$memoryId";
    Get.back();
    sharePublishMemory(memoryId, publishLink);

    memoriesRef.doc(memoryId).update({
      "published": true,
      "publish_link": publishLink,
      "published_created_at": Timestamp.now()
    }).then((value) {});
  }

  final memoriesRef = FirebaseFirestore.instance
      .collection(memoriesCollection)
      .withConverter<MemoriesModel>(
        fromFirestore: (snapshots, _) =>
            MemoriesModel.fromJson(snapshots.data()!),
        toFirestore: (memories, _) => memories.toJson(),
      );

  final notificationsRef = FirebaseFirestore.instance
      .collection(notificationsCollection)
      .withConverter<NotificationsModel>(
        fromFirestore: (snapshots, _) =>
            NotificationsModel.fromJson(snapshots.data()!),
        toFirestore: (notifications, _) => notifications.toJson(),
      );

  final usersRef = FirebaseFirestore.instance
      .collection(userCollection)
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (users, _) => users.toJson(),
      );

  final linkRef = FirebaseFirestore.instance
      .collection(shareLinkCollection)
      .withConverter<ShareLinkModel>(
        fromFirestore: (snapshots, _) =>
            ShareLinkModel.fromJson(snapshots.data()!),
        toFirestore: (shareLink, _) => shareLink.toJson(),
      );

  // Get User Data
  getUserData(String userId) async {
    return await usersRef.doc(userId).get();
  }

  void deleteCollaborator(String memoryId, MemoriesModel memoriesModel,
      int shareIndex, String type) {
    memoriesModel.sharedWith!.removeAt(shareIndex);
    memoriesRef
        .doc(memoryId)
        .set(memoriesModel)
        .then((value) => debugPrint('DeleteCollaborator'));
  }

  Future<void> acceptInviteNotification(MemoriesModel memoriesModel) async {
    var receiverToken = "";
    var db = await FirebaseFirestore.instance
        .collection("users")
        .withConverter<UserModel>(
          fromFirestore: (snapshots, _) =>
              UserModel.fromJson(snapshots.data()!),
          toFirestore: (users, _) => users.toJson(),
        )
        .doc(memoriesModel.createdBy)
        .get();
    receiverToken = db.data()!.deviceToken!;
    String title = "Invite Accepted";
    String description = "$userName has accepted your memory.";
    // String receiverToken = globalNotificationToken;
    var dataPayload = jsonEncode({
      'to': receiverToken,
      'data': {
        "type": "invite-accept",
        "priority": "high",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "senderId": userId,
        "memoryID": memoriesModel.memoryId,
        "memoryImage": ""
      },
      'notification': {
        'title': title,
        'body': description,
        "badge": "1",
        "sound": "default"
      },
    });
    sendPushMessage(receiverToken, dataPayload);
    saveNotificationData(memoriesModel.createdBy!, memoriesModel);
  }

  // add New photo Notification
  Future<void> addNewPhotoNotification(MemoriesModel memoriesModel) async {
    var receiverToken = "";
    var db = await FirebaseFirestore.instance
        .collection(userCollection)
        .withConverter<UserModel>(
          fromFirestore: (snapshots, _) =>
              UserModel.fromJson(snapshots.data()!),
          toFirestore: (users, _) => users.toJson(),
        )
        .doc(memoriesModel.createdBy)
        .get();
    receiverToken = db.data()!.deviceToken!;
    String title = "Photo Added";
    String description =
        "$userName  has added a new photo to ${memoriesModel.title}";
    // String receiverToken = globalNotificationToken;
    var dataPayload = jsonEncode({
      'to': receiverToken,
      'data': {
        "type": "photo-add",
        "priority": "high",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "senderId": userId,
        "memoryID": memoriesModel.memoryId,
        "memoryImage": ""
      },
      'notification': {
        'title': title,
        'body': description,
        "badge": "1",
        "sound": "default"
      },
    });
    sendPushMessage(receiverToken, dataPayload);
    saveAddPhotoNotificationData(memoriesModel.createdBy!, memoriesModel);
  }

  // Save Add Photo Notification data in DB
  void saveAddPhotoNotificationData(
      String receivedId, MemoriesModel memoriesModel) {
    String memoryCover = memoriesModel.imagesCaption!.isNotEmpty
        ? memoriesModel.imagesCaption![0].image!
        : "";
    NotificationsModel notificationsModel = NotificationsModel(
        memoryTitle: memoriesModel.title,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        isRead: false,
        memoryImage: "",
        description: " has added a new photo to your memory",
        type: 'photo-add',
        memoryCover: memoryCover,
        memoryId: memoriesModel.memoryId,
        receivedId: receivedId,
        receiverIds: [receivedId],
        userId: userId);
    notificationsRef.add(notificationsModel).then((value) {});
    usersRef.doc(receivedId).get().then((value) => {
          usersRef.doc(receivedId).update({
            "notification_count": value.data()!.notificationCount != null
                ? value.data()!.notificationCount! + 1
                : 1
          })
        });
  }

  // Save Notification data in DB
  void saveNotificationData(String receivedId, MemoriesModel memoriesModel) {
    String memoryCover = memoriesModel.imagesCaption!.isNotEmpty
        ? memoriesModel.imagesCaption![0].image!
        : "";
    NotificationsModel notificationsModel = NotificationsModel(
        memoryTitle: memoriesModel.title,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        isRead: false,
        memoryImage: "",
        description: " accepted your memory",
        type: 'invite-accept',
        memoryCover: memoryCover,
        memoryId: memoriesModel.memoryId,
        receivedId: receivedId,
        receiverIds: [receivedId],
        userId: userId);
    notificationsRef.add(notificationsModel).then((value) {});
    usersRef.doc(receivedId).get().then((value) => {
          usersRef.doc(receivedId).update({
            "notification_count": value.data()!.notificationCount != null
                ? value.data()!.notificationCount! + 1
                : 1
          })
        });
  }

  List<SharedWith> getSharedUsers(MemoriesModel memoriesModels) {
    List<SharedWith> sharedModels = List.empty(growable: true);
    if (memoriesModels.sharedWith!.isNotEmpty) {
      var itemToAdd;
      for (int i = 0; i < memoriesModels.sharedWith!.length; i++) {
        if (memoriesModels.sharedWith![i].status == 1) {
          sharedModels.add(memoriesModels.sharedWith![i]);
        }
      }
    }
    return sharedModels;
  }

  // Expire the shared link
  void expireSharedLink(MemoriesModel memoriesModel, int respondType,
      int mainIndex, int shareIndex) {
    linkRef
        .where("memory_id", isEqualTo: memoriesModel.memoryId)
        .where("link_used", isEqualTo: false)
        .get()
        .then((value) => {
              if (value.docs.isNotEmpty)
                {
                  if (respondType == 2)
                    {deleteInvite(memoriesModel, shareIndex), fromShare = false}
                  else
                    {
                      updateJoinStatus(1, mainIndex, shareIndex, memoriesModel),
                      acceptInviteNotification(memoriesModel),
                    },
                  linkRef.doc(value.docs.first.id).update(
                      {"link_used": true, "used_by": userId}).then((value) {})
                }
              else
                {
                  deleteInvite(memoriesModel, shareIndex),
                  Get.snackbar("Error", "This link has been expired!",
                      colorText: Colors.red)
                }
            });
  }

  // check and request permission
  Future<bool> promptPermissionSetting() async {
    var status;
    Permission permission;
    if (Platform.isIOS) {
      // permission = Permission.photos;
      permission = Permission.storage;
      if (await permission.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        status = await permission.status;
        // showPermissions.value = false;
        permissionStatus.value = status;
        // getAlbums();
        return true;
      } else if (await permission.isLimited) {
        // Either the permission was already granted before or the user just granted it.
        status = await permission.status;
        // showPermissions.value = false;
        permissionStatus.value = status;

        // getAlbums();
        return true;
      } else {
        status = await Permission.photos.status;
        permissionStatus.value = status;
        // getAlbums();
        return true;
      }
      // status = await Permission.photos.status;
    } else {
      permission = Permission.storage;
      status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        // showPermissions.value = false;
      }
      permissionStatus.value = status;
      return true;
    }
  }

  // check and request permission
  Future<bool> promptPermissionSettings() async {
    var status;
    Permission permission;
    if (Platform.isIOS) {
      // permission = Permission.photos;
      permission = Permission.storage;
      if (await permission.isGranted) {
        // Either the permission was already granted before or the user just granted it.
        status = await permission.status;
        showPermissions.value = false;
        permissionStatus.value = status;
        // getAlbums();
        return true;
      } else if (await permission.isLimited) {
        // Either the permission was already granted before or the user just granted it.
        status = await permission.status;
        showPermissions.value = false;
        permissionStatus.value = status;

        // getAlbums();
        return true;
      } else {
        status = await Permission.photos.status;
        permissionStatus.value = status;
        // getAlbums();
        return true;
      }
      // status = await Permission.photos.status;
    } else {
      permission = Permission.storage;
      status = await Permission.storage.status;
      if (status == PermissionStatus.granted) {
        showPermissions.value = false;
      } else {
        showPermissions.value = true;
      }
      permissionStatus.value = status;
      return true;
    }
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
        getListData(imageAlbums[i]);
        // paginationData(imageAlbums[i]);
      }
    }
  }

  // get Images from albums
  void getListData(Album album) async {
    mediaPages.value.clear();
    MediaPage imagePage = await album.listMedia(
      newest: true,
    );
    totalCount = imagePage.total;
    selectionList = List.filled(totalCount, false).obs;
    mediaPages.value.addAll(imagePage.items);
    update();
  }

  // Get Total count of selected items
  void getSelectedCount() {
    selectedCount.value = 0;
    selectionList.fold(
        false,
        (previousValue, element) => {
              if (element)
                {
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

  Future<void> uploadImagesToMemories(
      int imageIndex, String memoryId, MemoriesModel? memoriesModel) async {
    if (resultgetList.isNotEmpty) {
      if (imageIndex == 0) {
        EasyLoading.show(status: 'Uploading...');
        allowBackPress.value = false;
        imageCaptionUrls.clear();
      }
      //selectedIndexList = index of selected items from main photos list
      final dir = await path_provider.getTemporaryDirectory();
      final File? file = await resultgetList[imageIndex].file;
      var getDate = await resultgetList[imageIndex].createDateTime;
      // await getImageFileFromAssetsEntity(resultgetList[imageIndex]);
      String fileName = "/temp${DateTime.now().millisecond}.jpg";
      final targetPath = dir.absolute.path + fileName;
      final File? newFile = await testCompressAndGetFile(file!, targetPath);

      final UploadTask? uploadTask = await uploadNewFile(
          newFile!, fileName, memoryId, memoriesModel, getDate);
    } else {
      Get.snackbar('Error', "Please select images");
    }
  }

  Future<File> getImageFileFromAssetsEntity(AssetEntity assetEntity) async {
    // final byteData = await assetEntity.;
    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${assetEntity.title}");

    return tempFile;
  }

  /// The user selects a file, and the task is added to the list.
  Future<UploadTask?> uploadNewFile(File file, String fileName, String memoryId,
      MemoriesModel? memoriesModel, DateTime getDate) async {
    UploadTask uploadTask;

    Reference ref =
        FirebaseStorage.instance.ref().child('memories').child('/$fileName');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'picked-file-path': file.path,
        // 'imageDate': covertedDateTime,

        // create date and send
      },
    );

    uploadTask = ref.putFile(io.File(file.path), metadata);
    uploadTask.whenComplete(() => {
          uploadTask.snapshot.ref.getDownloadURL().then((value) => {
                imageCaptionUrls.add(ImagesCaption(
                    caption: "",
                    image: value,
                    commentCount: 0,
                    updatedAt: Timestamp.now(),
                    createdAt: Timestamp.fromDate(getDate),
                    userId: userId,
                    imageId:
                        Timestamp.now().millisecondsSinceEpoch.toString())),
                if (imageCaptionUrls.length < resultgetList.length)
                  {
                    uploadCount += 1,
                    uploadImagesToMemories(
                        uploadCount, memoryId, memoriesModel),
                  }
                else
                  {
                    EasyLoading.dismiss(),
                    if (memoriesModel == null)
                      {createMemories()}
                    else
                      {
                        updateMemory(memoryId, memoriesModel),
                        if (memoriesModel.createdBy != userId)
                          {addNewPhotoNotification(memoriesModel)}
                      }
                  }
              })
        });

    return Future.value(uploadTask);
  }

// Update or Add images to existing memory
  void updateMemory(String memoryId, MemoriesModel? memoriesModel) {
    MemoriesModel memoriesModels = memoriesModel!;
    memoriesModels.imagesCaption!.addAll(imageCaptionUrls);
    try {
      memoriesModels.imagesCaption!.sort((a, b) {
        return b.updatedAt!.compareTo(a.updatedAt!);
      });
    } catch (ex) {
      ex.toString();
    }

    memoriesRef.doc(memoryId).update(memoriesModels.toJson()).then((value) => {
          scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          ),
          update(),
          if (memoriesModels.imagesCaption!.isEmpty)
            {
              Get.back(),
            }
        });
  }

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      keepExif: true,
      quality: 50,
      minWidth: 700,
      minHeight: 700,
    );

    return result;
  }

  // Future<File?> testCompressAndGetFile(File file, String targetPath) async {
  //   final result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 50,
  //     minWidth: 700,
  //     minHeight: 700,
  //   );
  //   return result;
  // }

  // Create memories to Firebase
  void createMemories() {
    List<SharedWith> shareList = List.empty(growable: true);
    EasyLoading.show(status: 'Creating Memory');
    MemoriesModel memoriesModel = MemoriesModel(
        title: titleController.text.toString(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        createdBy: userId,
        imagesCaption: imageCaptionUrls,
        inviteLink: "",
        published: false,
        commentCount: 0,
        sharedWithCount: 0,
        publishLink: "",
        sharedWith: shareList);
    memoriesRef
        .add(memoriesModel)
        .then((value) => {
              EasyLoading.dismiss(),
              Get.snackbar('Success', 'Memory folder created'),
              goToMemoriesAndClearAll()
            })
        .onError((error, stackTrace) => {EasyLoading.dismiss()});
  }

  void saveCaption(String caption, int captionIndex, MemoriesModel model) {
    MemoriesModel memoriesModel = MemoriesModel();
    memoriesModel = model;

    memoriesModel.imagesCaption![captionIndex].updatedAt = Timestamp.now();
    memoriesModel.imagesCaption![captionIndex].caption = caption;
    EasyLoading.show(status: 'Processing');
    memoriesRef
        .doc(model.memoryId)
        .set(memoriesModel)
        .then((value) => {EasyLoading.dismiss(), Get.back()})
        .onError((error, stackTrace) => {EasyLoading.dismiss()});
  }

  void deleteInvite(MemoriesModel sharedMemories, int shareIndex) {
    MemoriesModel memoriesModel = sharedMemories;

    memoriesModel.sharedWith!.removeAt(shareIndex);
    memoriesRef
        .doc(sharedMemories.memoryId)
        .set(memoriesModel)
        .then((value) => {
              if (sharedMemoriesList.isEmpty)
                {sharedMemoriesExpand.value = false},
              // sharedMemoriesList.removeAt(mainIndex),
              update()
            });
  }
}
