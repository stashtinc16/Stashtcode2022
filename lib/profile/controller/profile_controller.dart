import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/constants.dart';

class ProfileController extends GetxController {
  RxBool isObscure = true.obs;
  var passwordcontroller = TextEditingController();
  RxBool status1 = true.obs;
  RxBool status2 = true.obs;
  RxBool status3 = true.obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FacebookAuth facebookAuth = FacebookAuth.instance;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  logoutUser() {
    firebaseAuth.signOut();
    facebookAuth.logOut();
    userEmail = "";
    userId = "";
    userImage = "";
    userName = "";
    Get.offAllNamed(AppRoutes.signIn);
  }
}
