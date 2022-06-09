import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/constants.dart';

class ProfileController extends GetxController {
  RxBool isObscure = true.obs;
  var passwordcontroller = TextEditingController();
  var nameController = TextEditingController().obs;
  RxBool status1 = true.obs;
  RxBool status2 = true.obs;
  RxBool status3 = true.obs;
  RxBool changeUserName = false.obs;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FacebookLogin facebookAuth = FacebookLogin();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nameController.value.text = userName;
  }

  final usersRef = FirebaseFirestore.instance
      .collection(userCollection)
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (users, _) => users.toJson(),
      );

  void updateProfileImage(String profileUrl) {
    usersRef.doc(userId).update({"profile_image": profileUrl}).then(
        (value) => {print('Profile updated'), userImage.value = profileUrl});
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
    userImage.value = "";
    userName = "";
    fromShare = false;
    Get.offAllNamed(AppRoutes.signIn);
    print('UserId==== $userId');
  }

  void changeUserNameFunc() {
    usersRef
        .doc(userId)
        .update({"display_name": nameController.value.text}).then(
            (value) => {print('onNameChange ')});
  }
}
