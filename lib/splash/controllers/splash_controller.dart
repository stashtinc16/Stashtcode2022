import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

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

    initializeFirebaseNotification();
    initDynamicLinks();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initializeFirebaseNotification() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);
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
      // if (data['type'] == "comment") {
      var memoryId = data['memoryID'];
      Get.offAndToNamed(AppRoutes.memoryList, arguments: {"memoryId": memoryId});
    });
  }

  Future onSelectNotification(String? payload) async {
    print('payload $payload');
    if (payload != null) {
      var data = jsonDecode(payload!);
      // if (data['type'] == "comment") {
      var memoryId = data['memoryID'];
      Get.offAndToNamed(AppRoutes.memoryList, arguments: {"memoryId": memoryId});
      // }
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
      fromShare = true;
      print('fromShare splash $fromShare');
      print('dynamicLinkData $dynamicLinkData');
      var link = dynamicLinkData.link.toString().split("memory_id=");
      var memory = link[1].split("&");
      var timeStamp = dynamicLinkData.link.toString().split("timestamp=");
      var nowTime = DateTime.now().millisecondsSinceEpoch;
      var difference = nowTime - double.parse(timeStamp[1]);
      print('difference $nowTime ${timeStamp[1]} $difference');
      if (difference > 3600000) {
        Get.snackbar("", "This link has expired");
        globalShareMemoryModel = null;
        handleNavigation(false);
      } else {
        checkMemoryForUser(memory[0]);
      }
    }).onError((error) {
      print('onErro $error');
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
    print('memoryId $memoryId');
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
                      globalShareMemoryModel = memoriesModel,
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
    firebaseAuth = FirebaseAuth.instance.currentUser;
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
                            element.data().profileImage!,
                            element.data().notificationCount != null
                                ? element.data().notificationCount!
                                : 0),
                        print('fromDeepLink $fromDeepLink'),
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
