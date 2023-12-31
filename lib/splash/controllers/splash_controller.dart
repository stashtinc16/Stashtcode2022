import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stasht/login_signup/controllers/signup_controller.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/splash/domain/share_links_model.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:stasht/utils/constants.dart';

import '../../main.dart';

User? firebaseAuthSplash = FirebaseAuth.instance.currentUser;

class SplashController extends GetxController {
  // User? firebaseAuth = FirebaseAuth.instance.currentUser;
  final facebookAuth = FacebookLogin();
  // bool? _isLogged;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  var memoryController = Get.isRegistered() ? Get.find<MemoriesController>() : Get.put(MemoriesController());

  final usersRef = FirebaseFirestore.instance.collection(userCollection).withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  final linkRef = FirebaseFirestore.instance.collection(shareLinkCollection).withConverter<ShareLinkModel>(
        fromFirestore: (snapshots, _) => ShareLinkModel.fromJson(snapshots.data()!),
        toFirestore: (shareLink, _) => shareLink.toJson(),
      );

  final memoriesRef = FirebaseFirestore.instance.collection(memoriesCollection).withConverter<MemoriesModel>(
        fromFirestore: (snapshots, _) => MemoriesModel.fromJson(snapshots.data()!),
        toFirestore: (memories, _) => memories.toJson(),
      );

  String _authStatus = 'Unknown';

  @override
  Future<void> onInit() async {
    super.onInit();
    print("splash init called");
    // if (Platform.isIOS) {
    //   initPlugin();
    // }
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }
//Here you can remove the badge you created when it's launched
    FlutterAppBadger.removeBadge();
    initializeFirebaseNotification();

    initDynamicLinks();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
    _authStatus = '$status';
    update();
    print("_authStatus: $_authStatus");

    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      // await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
      _authStatus = '$status';
      update();
    }
    // If the system can show an authorization request dialog
    else if (status == TrackingStatus.denied) {
      // Show a custom explainer dialog before the system dialog
      // await showCustomTrackingDialog(context);
      // Wait for dialog popping animation

      await Future.delayed(const Duration(milliseconds: 2));
      // Request system's tracking authorization dialog
      final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
      _authStatus = '$status';
      update();
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async => await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
  Future<void> initializeFirebaseNotification() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.requestPermission(sound: true, badge: true, alert: true, provisional: true);
    if (Platform.isIOS) {
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }
    firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {}
    });

    FirebaseMessaging.instance.getToken().then((value) => {globalNotificationToken = value!});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationCount.value = notificationCount.value + 1;
      FlutterAppBadger.updateBadgeCount(notificationCount.value);

      RemoteNotification? notification = message.notification;

      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.data));
      }
    });
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var data = message.data;
      notificationClick(data);
    });
  }

  void notificationClick(var data) {
    var memoryId = data['memoryID'];
    if (data['type'] == "comment") {
      var commentImage = data["memoryImage"];
      var imageId = data["imageId"];
      Get.offAndToNamed(AppRoutes.comments, arguments: {"memoryId": memoryId, "memoryImage": commentImage, "imageId": imageId, "fromNot": true});
    } else {
      Get.offAndToNamed(AppRoutes.memoryList, arguments: {"memoryId": memoryId, "fromNot": true});
    }
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      var data = jsonDecode(payload);
      notificationClick(data);
    }
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      var link = dynamicLinkData.link.toString().split("memory_id=");
      memoryLink = dynamicLinkData.link;
      memoryId = link[1];

      if (firebaseAuthSplash != null || isFacebookLogin!) {
        fromShare = true;

        EasyLoading.show(status: 'Please wait.. we are fetching memory');

        checkValidLink(dynamicLinkData.link, memoryId);
      } else if (firebaseAuthSplash != null || isAppleLogin!) {
        fromShare = true;

        EasyLoading.show(status: 'Please wait.. we are fetching memory');

        checkValidLink(dynamicLinkData.link, memoryId);
      } else {
        fromShare = true;
        print("handleNavigation method fired from 227");
        handleNavigation(true);
      }
    }).onError((error) {});
    if (!dynamicLinks.isBlank!) {
      print("handleNavigation method fired from 232 ");
      final prefs = await SharedPreferences.getInstance();
      var appletoknss = prefs.getString("appleToken");
      print("appleToken 233 ${appletoknss}");
      // if (appletoknss == null || appletoknss == '') {
      handleNavigation(false);
      // }
    }
  }

// check if link exists
  void checkValidLink(Uri link, String memoryId) {
    linkRef.where("share_link", isEqualTo: link.toString()).get().then((value) {
      if (value.docs.isEmpty) {
        print('DocsLength ${value.docs.length}');
        // Link doesnot exists in shared links
        ShareLinkModel linkModel = ShareLinkModel(shareLink: link.toString(), linkUsed: false, memoryId: memoryId, createdAt: Timestamp.now(), usedBy: userId);
        linkRef.add(linkModel).then((value) {});
        checkMemoryForUser(memoryId);
      } else {
        var result = value.docs.where((element) {
          return element.data().linkUsed == false;
        });
        if (result.isNotEmpty) {
          checkMemoryForUser(memoryId);
        } else {
          // Link is used by other user
          EasyLoading.dismiss();
          Get.snackbar("Error", "Link has expired", colorText: Colors.red);
          print("handleNavigation method fired from 256 ");
          handleNavigation(false);
        }
      }
    });
  }

  // Expire the shared link
  void expireSharedLink(MemoriesModel memoriesModel, int respondType, int mainIndex, int shareIndex) {
    linkRef.where("memory_id", isEqualTo: memoriesModel.memoryId).where("link_used", isEqualTo: false).get().then((value) => {
          if (value.docs.isNotEmpty)
            {
              memoryController.sharedMemoriesExpand.value = true,
              if (respondType == 2)
                {memoryController.deleteInvite(memoriesModel, shareIndex), fromShare = false}
              else
                {
                  expandShareMemory = true,
                  fromShare = true,
                  memoryController.updateJoinStatus(1, mainIndex, shareIndex, memoriesModel),
                  memoryController.acceptInviteNotification(memoriesModel),
                },
              linkRef.doc(value.docs.first.id).update({"link_used": true, "used_by": userId}).then((value) {})
            }
          else
            {memoryController.deleteInvite(memoriesModel, shareIndex), Get.snackbar("Error", "This link has been expired!", colorText: Colors.red)}
        });
  }

  //check memory for user if shared
  void checkMemoryForUser(String memoryId) {
    var memoriesRef = FirebaseFirestore.instance.collection(memoriesCollection).withConverter<MemoriesModel>(
          fromFirestore: (snapshots, _) => MemoriesModel.fromJson(snapshots.data()!),
          toFirestore: (memories, _) => memories.toJson(),
        );
    MemoriesModel memoriesModel = MemoriesModel();
    List<SharedWith> shareList = List.empty(growable: true);
    memoriesRef.doc(memoryId).get().then((value) {
      if (value.exists) {
        memoriesModel = value.data()!;
        memoriesModel.memoryId = value.id;
        usersRef.doc(memoriesModel.createdBy!).get().then((userValue) => memoriesModel.userModel = userValue.data());

        shareList = value.data()!.sharedWith != null ? value.data()!.sharedWith! : shareList;
        bool userExists = false;
        if (value.data()!.createdBy != userId) {
          if (value.data()!.sharedWith != null) {
            value.data()!.sharedWith!.forEach((element) {
              outerLoop:
              if (element.userId == userId) {
                userExists = true;
                break outerLoop;
              }
            });
          }
          if (!userExists) {
            shareList.add(SharedWith(userId: userId, status: 0));
            memoriesModel.sharedCreatedAt = Timestamp.now();
            memoriesModel.sharedWith = shareList;

            memoriesRef
                .doc(memoryId)
                .set(memoriesModel)
                .then((value) => {
                      globalShareMemoryModel = MemoriesModel(),
                      globalShareMemoryModel = memoriesModel,

                      fromShare = true,
                      print("handleNavigation method fired from 323 "),
                      handleNavigation(true),
                      // Get.back()
                    })
                .onError((error, stackTrace) => {EasyLoading.dismiss()});
          } else {
            Get.snackbar("Error", "This memory already exist.", colorText: Colors.red);
            EasyLoading.dismiss();
          }
        } else {
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar("Error", "This memory doesn't exist.", colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
      }
    });
  }

  handleNavigation(bool fromDeepLink) async {
    print("isAppleLogin ${isAppleLogin}");
    firebaseAuthSplash = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(milliseconds: 2500), () async {
      isFacebookLogin = await facebookAuth.accessToken != null;

      final prefs = await SharedPreferences.getInstance();
      isAppleLogin = prefs.getString("appleToken") != null && prefs.getString("appleToken") != '' ? true : false;

      print("isAppleLogin...in splash controller 346 line ${isAppleLogin}");
      print("firebaseAuthSplash ${firebaseAuthSplash}");

      if (isAppleLogin!) {
        String email = '';
        final prefs = await SharedPreferences.getInstance();
        var appleEmail = prefs.getString("appleEmail");
        email = appleEmail ?? '';
        isSocailUser = true;
        goToMemoriesFunc(email, fromDeepLink);
      } else {
        if (firebaseAuthSplash != null || isFacebookLogin!) {
          String email = "";
          if (firebaseAuthSplash != null) {
            email = firebaseAuthSplash!.email!;
            isSocailUser = false;
            goToMemoriesFunc(email, fromDeepLink);
          } else {
            isSocailUser = true;
            facebookAuth.getUserProfile().then((value) {});

            facebookAuth.getUserEmail().then((value) => {
                  if (value == null) {print("406"), facebookAuth.logOut(), Get.offNamed(AppRoutes.signup)} else {email = value, goToMemoriesFunc(email, fromDeepLink)}
                });
          }
        } else {
          EasyLoading.dismiss();
          print("353");
          Get.offNamed(AppRoutes.signup);
        }
      }
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (cotext) => const SignUp()));
    });
  }

  // redirect user into app , if already logged in
  void goToMemoriesFunc(String email, bool fromDeepLink) {
    print("email ${email}");
    usersRef
        .where("email", isEqualTo: email)
        .get()
        .then((value) => {
              if (value.docs.isNotEmpty)
                {
                  value.docs.forEach((element) => {
                        saveSession(element.id, element.data().displayName!, element.data().email!, element.data().profileImage!,
                            element.data().notificationCount != null ? element.data().notificationCount! : 0),
                        EasyLoading.dismiss(),
                        if (fromDeepLink)
                          {
                            if (!Get.isBottomSheetOpen!) {showInviteJoinPopUp(globalShareMemoryModel!)}
                            // Get.off(() => Memories(),
                            //     binding: MemoriesBinding())
                          }
                        else
                          {
                            print('line 414'),
                            goToMemories(fromDeepLink),
                            // Get.offNamed(AppRoutes.memories,
                            //     arguments: {"fromDeepLink": fromDeepLink})
                          }
                      })
                }
              else
                {print("390"), Get.offNamed(AppRoutes.signup)}
            })
        .onError((error, stackTrace) => {});
  }

  void showInviteJoinPopUp(MemoriesModel memoriesModel) {
    int shareIndex = 0;
    for (int i = 0; i < memoriesModel.sharedWith!.length; i++) {
      if (memoriesModel.sharedWith![i].userId == userId) {
        shareIndex = i;
      }
    }

    Get.bottomSheet(Container(
      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)), color: Colors.white),
        height: 220,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(Get.context!).size.width,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0, bottom: 7),
                      child: RichText(
                          text: TextSpan(text: memoriesModel.userModel!.displayName!, style: const TextStyle(fontSize: 18.0, color: Colors.black, fontFamily: robotoBold), children: const [
                        TextSpan(
                          text: " invited you to join a memory:",
                          style: TextStyle(fontSize: 16, color: AppColors.darkColor, fontFamily: robotoRegular, fontStyle: FontStyle.italic),
                        ),
                      ])),
                    ),
                  ),
                  // Positioned(
                  //   top: 0,
                  //   bottom: 0,
                  //   right: 10,
                  //   child: IconButton(
                  //     onPressed: () {
                  //       fromShare = false;
                  //       Get.back();
                  //     },
                  //     icon: const Icon(
                  //       Icons.close,
                  //       color: AppColors.darkColor,
                  //       size: 20,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            Text(
              memoriesModel.title!,
              style: const TextStyle(fontSize: 18, color: AppColors.darkColor, fontFamily: robotoBold),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    expireSharedLink(globalShareMemoryModel!, 1, 0, shareIndex);
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: const Text(
                      'Yes',
                      style: TextStyle(fontSize: 18, color: AppColors.primaryColor, fontFamily: robotoBold),
                      textAlign: TextAlign.center,
                    ),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: AppColors.hintTextColor),
                  ),
                )),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    // controller.deleteInvite(
                    //     memoriesModel, shareIndex, mainIndex);
                    expireSharedLink(globalShareMemoryModel!, 2, 0, shareIndex);
                    fromShare = false;
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: const Text(
                      'No',
                      style: TextStyle(fontSize: 18, color: AppColors.primaryColor, fontFamily: robotoBold),
                      textAlign: TextAlign.center,
                    ),
                    decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: AppColors.hintTextColor),
                  ),
                )),
                const SizedBox(
                  width: 20,
                ),
              ],
            )
          ],
        ),
      ),
    ));
    // showModalBottomSheet(
    //     context: Get.context!,
    //     isScrollControlled: false,
    //     shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.only(
    //             topRight: Radius.circular(15), topLeft: Radius.circular(15))),
    //     builder: (context) {
    //       return Container(
    //         decoration: const BoxDecoration(
    //             borderRadius: BorderRadius.only(
    //                 topRight: Radius.circular(15),
    //                 topLeft: Radius.circular(15)),
    //             color: Colors.white),
    //         height: 220,
    //         child: Column(
    //           children: [
    //             SizedBox(
    //               width: MediaQuery.of(context).size.width,
    //               child: Stack(
    //                 children: [
    //                   Center(
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(
    //                           left: 25.0, right: 25.0, top: 25.0, bottom: 7),
    //                       child: RichText(
    //                           text: TextSpan(
    //                               text: memoriesModel.userModel!.displayName!,
    //                               style: const TextStyle(
    //                                   fontSize: 18.0,
    //                                   color: Colors.black,
    //                                   fontFamily: robotoBold),
    //                               children: const [
    //                             TextSpan(
    //                               text: " invited you to join a memory:",
    //                               style: TextStyle(
    //                                   fontSize: 16,
    //                                   color: AppColors.darkColor,
    //                                   fontFamily: robotoRegular,
    //                                   fontStyle: FontStyle.italic),
    //                             ),
    //                           ])),
    //                     ),
    //                   ),
    //                   // Positioned(
    //                   //   top: 0,
    //                   //   bottom: 0,
    //                   //   right: 10,
    //                   //   child: IconButton(
    //                   //     onPressed: () {
    //                   //       fromShare = false;
    //                   //       Get.back();
    //                   //     },
    //                   //     icon: const Icon(
    //                   //       Icons.close,
    //                   //       color: AppColors.darkColor,
    //                   //       size: 20,
    //                   //     ),
    //                   //   ),
    //                   // )
    //                 ],
    //               ),
    //             ),
    //             Text(
    //               memoriesModel.title!,
    //               style: const TextStyle(
    //                   fontSize: 18,
    //                   color: AppColors.darkColor,
    //                   fontFamily: robotoBold),
    //             ),
    //             const SizedBox(
    //               height: 25,
    //             ),
    //             Row(
    //               children: [
    //                 const SizedBox(
    //                   width: 20,
    //                 ),
    //                 Expanded(
    //                     child: InkWell(
    //                   onTap: () {
    //                     expireSharedLink(
    //                         globalShareMemoryModel!, 1, 0, shareIndex);
    //                     Get.back();
    //                   },
    //                   child: Container(
    //                     padding: const EdgeInsets.all(40),
    //                     child: const Text(
    //                       'Yes',
    //                       style: TextStyle(
    //                           fontSize: 18,
    //                           color: AppColors.primaryColor,
    //                           fontFamily: robotoBold),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                     decoration: const BoxDecoration(
    //                         borderRadius: BorderRadius.all(Radius.circular(15)),
    //                         color: AppColors.hintTextColor),
    //                   ),
    //                 )),
    //                 const SizedBox(
    //                   width: 20,
    //                 ),
    //                 Expanded(
    //                     child: InkWell(
    //                   onTap: () {
    //                     // controller.deleteInvite(
    //                     //     memoriesModel, shareIndex, mainIndex);
    //                     expireSharedLink(
    //                         globalShareMemoryModel!, 2, 0, shareIndex);
    //                     fromShare = false;
    //                     Get.back();
    //                   },
    //                   child: Container(
    //                     padding: const EdgeInsets.all(40),
    //                     child: const Text(
    //                       'No',
    //                       style: TextStyle(
    //                           fontSize: 18,
    //                           color: AppColors.primaryColor,
    //                           fontFamily: robotoBold),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                     decoration: const BoxDecoration(
    //                         borderRadius: BorderRadius.all(Radius.circular(15)),
    //                         color: AppColors.hintTextColor),
    //                   ),
    //                 )),
    //                 const SizedBox(
    //                   width: 20,
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //       );
    //     });
  }

// Save User Session
  void saveSession(String _userId, String _userName, String _userEmail, String _userImage, int _notificationCount) {
    userId = _userId;
    userEmail = _userEmail;
    userName = _userName;
    userImage.value = _userImage;
    notificationCount.value = _notificationCount;

    usersRef.doc(userId).update({"device_token": globalNotificationToken});
  }
}
