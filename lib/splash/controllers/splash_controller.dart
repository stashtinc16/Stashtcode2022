import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/constants.dart';
import 'package:connectivity/connectivity.dart';

class SplashController extends GetxController {
  User? firebaseAuth = FirebaseAuth.instance.currentUser;
  final facebookAuth = FacebookLogin();
  bool? _isLogged;

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final Connectivity _connectivity = Connectivity();

  final usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  @override
  void onInit() {
    super.onInit();
    hundling();
    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
        print("none");
        Get.snackbar('Internet Not Connected', "Please connect to internet");

        break;
      default:
        break;
    }
  }

  hundling() async {
    Future.delayed(const Duration(milliseconds: 2500), () async {
      _isLogged = await facebookAuth.accessToken != null;
      print('_isLogged $_isLogged');

      if (firebaseAuth != null || _isLogged!) {
        String email = "";
        if (firebaseAuth != null) {
          email = firebaseAuth!.email!;
          isSocailUser = false;
          goToMemories(email);
        } else {
          isSocailUser = true;
          facebookAuth
              .getUserProfile()
              .then((value) => print('UserProfile $value'));
          facebookAuth.getUserEmail().then((value) => {
             print('value $value'),

                if (value == null) {facebookAuth.logOut()
                , Get.offNamed(AppRoutes.signIn)
               
                }else{
                email = value,
                goToMemories(email)
                }
               
              });
        }
      } else {
        Get.offNamed(AppRoutes.signIn);
      }
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (cotext) => const SignUp()));
    });
  }

  // redirect user into app , if already logged in
  void goToMemories(String email) {
    usersRef.where("email", isEqualTo: email).get().then((value) => {
          value.docs.forEach((element) => {
                print('UsersDB $value'),
                saveSession(element.id, element.data().userName!,
                    element.data().email!, ""),
                Get.offNamed(AppRoutes.memories),
              })
        });
  }

// Save User Session
  void saveSession(
      String _userId, String _userName, String _userEmail, String _userImage) {
    print('userId $_userId');
    userId = _userId;
    userEmail = _userEmail;
    userName = _userName;
    userImage = _userImage;
  }
}
