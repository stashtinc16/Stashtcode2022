import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

User? firebaseAuth = FirebaseAuth.instance.currentUser;

class SplashController extends GetxController {
  // User? firebaseAuth = FirebaseAuth.instance.currentUser;
  final facebookAuth = FacebookLogin();
  // bool? _isLogged;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  var memoryController = Get.isRegistered()
      ? Get.find<MemoriesController>()
      : Get.put(MemoriesController());

  final usersRef = FirebaseFirestore.instance
      .collection(userCollection)
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  final linkRef = FirebaseFirestore.instance
      .collection(shareLinkCollection)
      .withConverter<ShareLinkModel>(
        fromFirestore: (snapshots, _) =>
            ShareLinkModel.fromJson(snapshots.data()!),
        toFirestore: (shareLink, _) => shareLink.toJson(),
      );

  final memoriesRef = FirebaseFirestore.instance
      .collection(memoriesCollection)
      .withConverter<MemoriesModel>(
        fromFirestore: (snapshots, _) =>
            MemoriesModel.fromJson(snapshots.data()!),
        toFirestore: (memories, _) => memories.toJson(),
      );

  @override
  Future<void> onInit() async {
    super.onInit();
    String appBadgeSupported;
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
      print(' String appBadgeSupported $appBadgeSupported');
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }
//Here you can remove the badge you created when it's launched
    FlutterAppBadger.removeBadge();
    initializeFirebaseNotification();
    initDynamicLinks();
  }

  Future<void> initializeFirebaseNotification() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: true);
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

    FirebaseMessaging.instance.getToken().then((value) =>
        {globalNotificationToken = value!, print('GetToken $value')});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onFirebaseMessaging ${message.data}');
      notificationCount.value = notificationCount.value + 1;
      FlutterAppBadger.updateBadgeCount(notificationCount.value);

      RemoteNotification? notification = message.notification;
      saveNotificationCount();
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
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonEncode(message.data));
      }
    });
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // String memoryId = message.data["memoryID"];
      // Get.toNamed(AppRoutes.memoryList, {});
      print('A new onMessageOpenedApp event was published! ${message.data}');
      var data = message.data;
      notificationClick(data);
    });
  }

  void notificationClick(var data) {
    var memoryId = data['memoryID'];
    if (data['type'] == "comment") {
      var commentImage = data["memoryImage"];
      var imageId = data["imageId"];
      Get.offAndToNamed(AppRoutes.comments, arguments: {
        "memoryId": memoryId,
        "memoryImage": commentImage,
        "imageId": imageId,
        "fromNot": true
      });
    } else {
      Get.offAndToNamed(AppRoutes.memoryList,
          arguments: {"memoryId": memoryId, "fromNot": true});
    }
  }

  Future onSelectNotification(String? payload) async {
    print('payload $payload');
    if (payload != null) {
      var data = jsonDecode(payload);
      notificationClick(data);
    }
  }

// Update notification Count for a user
  saveNotificationCount() {
    // usersRef
    //     .doc(userId)
    //     .update({"notification_count": notificationCount.value})
    //     .then((value) => print('NotificationCount Updated'))
    //     .catchError((onError) {
    //       print('onError $onError');
    //     });
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      var link = dynamicLinkData.link.toString().split("memory_id=");
      var memory = link[1].split("&");
      var timeStamp = dynamicLinkData.link.toString().split("timestamp=");
      memoryLink = dynamicLinkData.link;
      memoryId = memory[0];

      if (firebaseAuth != null || isFacebookLogin!) {
        fromShare = true;

        print('fromShare splash $fromShare');
        print('dynamicLinkData $dynamicLinkData');
        EasyLoading.show(status: 'Please wait.. we are fetching memory');
        checkValidLink(dynamicLinkData.link, memory[0]);
      } else {
        fromShare = true;
        print('checkValidLink ');
        handleNavigation(true);
      }
    }).onError((error) {
      print('onErro $error');
    });
    if (!dynamicLinks.isBlank!) {
      print('HandleNavigation ');
      handleNavigation(false);
    }
  }

// check if link exists
  void checkValidLink(Uri link, String memoryId) {
    linkRef.where("share_link", isEqualTo: link.toString()).get().then((value) {
      if (value.docs.isEmpty) {
        print('DeepLink=> NotUsed  and and not saved');
        // Link doesnot exists in shared links
        ShareLinkModel linkModel = ShareLinkModel(
            shareLink: link.toString(),
            linkUsed: false,
            memoryId: memoryId,
            createdAt: Timestamp.now(),
            usedBy: userId);
        linkRef.add(linkModel).then((value) => print('ShareLinkSaved $value'));
        checkMemoryForUser(memoryId);
      } else {
        // Link is in shared link but it is not used yet
        if (!value.docs.first.data().linkUsed!) {
          print('DeepLink=> Link is saved but not used');
          checkMemoryForUser(memoryId);
        } else {
          // Link is used by other user
          print('DeepLink=> Link is used');
          EasyLoading.dismiss();
          Get.snackbar("Error", "Link has expired", colorText: Colors.red);

          handleNavigation(false);
        }
      }
    });
  }

  // Expire the shared link
  void expireSharedLink(MemoriesModel memoriesModel, int respondType,
      int mainIndex, int shareIndex) {
    linkRef
        .where("memory_id", isEqualTo: memoriesModel.memoryId)
        .where("link_used", isEqualTo: false)
        .get()
        .then((value) => {
              print('ExpireLink ${value.docs.length}'),
              if (value.docs.isNotEmpty)
                {
                  memoryController.sharedMemoriesExpand.value = true,
                  if (respondType == 2)
                    {
                      memoryController.deleteInvite(memoriesModel, shareIndex),
                      fromShare = false
                    }
                  else
                    {
                      expandShareMemory = true,
                      fromShare = true,
                      memoryController.updateJoinStatus(
                          1, mainIndex, shareIndex, memoriesModel),
                      memoryController.acceptInviteNotification(memoriesModel),
                      print('sharedMemoriesExpand ==> $expandShareMemory ')
                    },
                  linkRef.doc(value.docs.first.id).update(
                      {"link_used": true, "used_by": userId}).then((value) {
                    print('Link is used');
                  })
                }
              else
                {
                  memoryController.deleteInvite(memoriesModel, shareIndex),
                  Get.snackbar("Error", "This link has been expired!",
                      colorText: Colors.red)
                }
            });
  }

  //check memory for user if shared
  void checkMemoryForUser(String memoryId) {
    var memoriesRef = FirebaseFirestore.instance
        .collection(memoriesCollection)
        .withConverter<MemoriesModel>(
          fromFirestore: (snapshots, _) =>
              MemoriesModel.fromJson(snapshots.data()!),
          toFirestore: (memories, _) => memories.toJson(),
        );
    MemoriesModel memoriesModel = MemoriesModel();
    List<SharedWith> shareList = List.empty(growable: true);
    print('DeepLink=> memoryId $memoryId');
    memoriesRef.doc(memoryId).get().then((value) {
      if (value.exists) {
        memoriesModel = value.data()!;
        memoriesModel.memoryId = value.id;
        usersRef
            .doc(memoriesModel.createdBy!)
            .get()
            .then((userValue) => memoriesModel.userModel = userValue.data());

        shareList = value.data()!.sharedWith != null
            ? value.data()!.sharedWith!
            : shareList;
        bool userExists = false;
        if (value.data()!.createdBy != userId) {
          if (value.data()!.sharedWith != null) {
            value.data()!.sharedWith!.forEach((element) {
              outerLoop:
              if (element.userId == userId) {
                print('DeepLink=> User Exist');
                userExists = true;
                break outerLoop;
              }
            });
          }
          print('DeepLink=> ShareWith $userId');
          if (!userExists) {
            print('DeepLink=> userExists $userExists $userId');
            shareList.add(SharedWith(userId: userId, status: 0));
            memoriesModel.sharedCreatedAt = Timestamp.now();
            memoriesModel.sharedWith = shareList;

            memoriesRef
                .doc(memoryId)
                .set(memoriesModel)
                .then((value) => {
                      print('DeepLink=> globalShareMemoryModel '),
                      globalShareMemoryModel = MemoriesModel(),
                      globalShareMemoryModel = memoriesModel,

                      fromShare = true,
                      handleNavigation(true),
                      // Get.back()
                    })
                .onError((error, stackTrace) => {EasyLoading.dismiss()});
          } else {
            Get.snackbar("Error", "This memory already exist.",
                colorText: Colors.red);
            EasyLoading.dismiss();
            //  https://stasht2.page.link/Y72F   Jgxm
          }
        } else {
          EasyLoading.dismiss();
        }
      } else {
        EasyLoading.dismiss();
        Get.snackbar("Error", "This memory doesn't exist.",
            colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
        print('Memory Not Exist');
      }
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        print("wifi");

        break;
      case ConnectivityResult.mobile:
        print("mobile");

        break;
      case ConnectivityResult.none:
        Get.snackbar('Internet Not Connected', "Please connect to internet");

        break;
      default:
        break;
    }
  }

  handleNavigation(bool fromDeepLink) async {
    print('FromShare $fromDeepLink');
    firebaseAuth = FirebaseAuth.instance.currentUser;
    Future.delayed(const Duration(milliseconds: 2500), () async {
      isFacebookLogin = await facebookAuth.accessToken != null;

      if (firebaseAuth != null || isFacebookLogin!) {
        print('Inside ');
        String email = "";
        if (firebaseAuth != null) {
          email = firebaseAuth!.email!;
          isSocailUser = false;
          goToMemoriesFunc(email, fromDeepLink);
        } else {
          isSocailUser = true;
          facebookAuth
              .getUserProfile()
              .then((value) => print('UserProfile $value'));

          facebookAuth.getUserEmail().then((value) => {
                if (value == null)
                  {
                    facebookAuth.logOut(),
                    print('Inside_2'),
                    Get.offNamed(AppRoutes.signup)
                  }
                else
                  {
                    email = value,
                    print('Inside_3'),
                    goToMemoriesFunc(email, fromDeepLink)
                  }
              });
        }
      } else {
        EasyLoading.dismiss();
        print('GoToSignup $fromDeepLink');
        Get.offNamed(AppRoutes.signup);
      }
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (cotext) => const SignUp()));
    });
  }

  // redirect user into app , if already logged in
  void goToMemoriesFunc(String email, bool fromDeepLink) {
    print('Inside_5 $email');
    usersRef
        .where("email", isEqualTo: email)
        .get()
        .then((value) => {
              if (value.docs.isNotEmpty)
                {
                  value.docs.forEach((element) => {
                        saveSession(
                            element.id,
                            element.data().displayName!,
                            element.data().email!,
                            element.data().profileImage!,
                            element.data().notificationCount != null
                                ? element.data().notificationCount!
                                : 0),
                        EasyLoading.dismiss(),
                        if (fromDeepLink)
                          {
                            showInviteJoinPopUp(globalShareMemoryModel!)
                            // Get.off(() => Memories(),
                            //     binding: MemoriesBinding())
                          }
                        else
                          {
                            goToMemories(fromDeepLink),
                            // Get.offNamed(AppRoutes.memories,
                            //     arguments: {"fromDeepLink": fromDeepLink})
                          }
                      })
                }
              else
                {Get.offNamed(AppRoutes.signup)}
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

    showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: Colors.white),
            height: 220,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0, bottom: 7),
                          child: RichText(
                              text: TextSpan(
                                  text: memoriesModel.userModel!.displayName!,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontFamily: robotoBold),
                                  children: const [
                                TextSpan(
                                  text: " invited you to join a memory:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.darkColor,
                                      fontFamily: robotoRegular,
                                      fontStyle: FontStyle.italic),
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
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.darkColor,
                      fontFamily: robotoBold),
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
                        expireSharedLink(
                            globalShareMemoryModel!, 1, 0, shareIndex);
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontFamily: robotoBold),
                          textAlign: TextAlign.center,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColors.hintTextColor),
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
                        expireSharedLink(
                            globalShareMemoryModel!, 2, 0, shareIndex);
                        fromShare = false;
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontFamily: robotoBold),
                          textAlign: TextAlign.center,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColors.hintTextColor),
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

// Save User Session
  void saveSession(String _userId, String _userName, String _userEmail,
      String _userImage, int _notificationCount) {
    print('saveSession userId $_userId => $_userImage');
    userId = _userId;
    userEmail = _userEmail;
    userName = _userName;
    userImage.value = _userImage;
    notificationCount.value = _notificationCount;

    usersRef.doc(userId).update({"device_token": globalNotificationToken});
  }
}
