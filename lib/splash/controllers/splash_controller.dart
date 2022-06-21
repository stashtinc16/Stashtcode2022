import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/bindings/memories_binding.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/memories/presentation/memories.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/constants.dart';
import 'package:connectivity/connectivity.dart';

import '../../main.dart';

class SplashController extends GetxController {
  User? firebaseAuth = FirebaseAuth.instance.currentUser;
  final facebookAuth = FacebookLogin();
  bool? _isLogged;

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

  @override
  void onInit() {
    super.onInit();
    initDynamicLinks();
    initializeFirebaseNotification();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void initializeFirebaseNotification() {
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });

    FirebaseMessaging.instance.getToken().then((value) =>
        {globalNotificationToken = value!, print('GetToken $value')});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onFirebaseMessaging ${message.data}');
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
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String memoryId = message.data["memoryID"];
      // Get.toNamed(AppRoutes.memoryList, {});
      print('A new onMessageOpenedApp event was published!');
    });
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      fromShare = true;
      print('fromShare splash $fromShare');
      print('dynamicLinkData $dynamicLinkData');
      var link = dynamicLinkData.link.toString().split("memory_id=");

      checkMemoryForUser(link[1]);
    }).onError((error) {
      print('onErro $error');
      print(error.message);
    });
    if (!dynamicLinks.isBlank!) {
      print('HandleNavigation ');
      handleNavigation(false);
    }
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
    memoriesRef.doc(memoryId).get().then((value) {
      if (value.exists) {
        memoriesModel = value.data()!;
        memoriesModel.memoryId = value.id;
        shareList = value.data()!.sharedWith != null
            ? value.data()!.sharedWith!
            : shareList;
        print(' Exist_userId ${value.data()!.createdBy} ==> $userId');
        bool userExists = false;
        if (value.data()!.createdBy != userId) {
          if (value.data()!.sharedWith != null) {
            value.data()!.sharedWith!.forEach((element) {
              print('Inside For Loop');
              if (element.userId == userId) {
                print('User Exist');
                userExists = true;
                return;
              }
            });
          }
          if (!userExists) {
            EasyLoading.show(status: 'Processing');
            print('userExists $userExists');
            shareList.add(SharedWith(userId: userId, status: 0));
            memoriesModel.sharedWith = shareList;

            memoriesRef
                .doc(memoryId)
                .set(memoriesModel)
                .then((value) => {
                      print('UpdateCaption '),

                      EasyLoading.dismiss(),
                      fromShare = true,
                      handleNavigation(true),
                      // Get.back()
                    })
                .onError((error, stackTrace) => {EasyLoading.dismiss()});
          } else {
            fromShare = false;
            print('User Not Exist Else');

            handleNavigation(false);
          }
        }
      } else {
        print('Not Exist');
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
    Future.delayed(const Duration(milliseconds: 2500), () async {
      _isLogged = await facebookAuth.accessToken != null;

      if (firebaseAuth != null || _isLogged!) {
        print('Inside ');
        String email = "";
        if (firebaseAuth != null) {
          email = firebaseAuth!.email!;
          isSocailUser = false;
          goToMemories(email, fromDeepLink);
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
                    goToMemories(email, fromDeepLink)
                  }
              });
        }
      } else {
        print('InSide_1 ');
        Get.offNamed(AppRoutes.signup);
      }
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (cotext) => const SignUp()));
    });
  }

  // redirect user into app , if already logged in
  void goToMemories(String email, bool fromDeepLink) {
    print('Inside_5 $email');
    usersRef
        .where("email", isEqualTo: email)
        .get()
        .then((value) => {
              if (value.docs.isNotEmpty)
                {
                  value.docs.forEach((element) => {
                        print('Inside_6 ${element.data().userName}'),
                        saveSession(
                            element.id,
                            element.data().displayName!,
                            element.data().email!,
                            element.data().profileImage!),
                        if (fromDeepLink)
                          {
                            Get.off(() => Memories(),
                                binding: MemoriesBinding())
                          }
                        else
                          {
                            Get.offNamed(AppRoutes.memories,
                                arguments: {"fromDeepLink": fromDeepLink})
                          }
                      })
                }
              else
                {Get.offNamed(AppRoutes.signup)}
            })
        .onError((error, stackTrace) => {});
  }

// Save User Session
  void saveSession(
      String _userId, String _userName, String _userEmail, String _userImage) {
    print('saveSession userId $_userId => $_userImage');
    userId = _userId;
    userEmail = _userEmail;
    userName = _userName;
    userImage.value = _userImage;
  }
}
