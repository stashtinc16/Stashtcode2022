import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stasht/login_signup/controllers/signup_controller.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/splash/controllers/splash_controller.dart';
import 'package:stasht/utils/constants.dart';

import '../../utils/app_colors.dart';
import '../../utils/assets_images.dart';

class ProfileController extends GetxController {
  RxBool isObscureNew = true.obs;
  RxBool isObscureOld = true.obs;
  RxBool isObscureConfirm = true.obs;
  var oldPasswordcontroller = TextEditingController().obs;
  var newPasswordcontroller = TextEditingController().obs;
  var confirmPasswordcontroller = TextEditingController().obs;
  var nameController = TextEditingController().obs;
  RxBool status1 = true.obs;
  RxBool status2 = true.obs;
  RxBool status3 = true.obs;
  RxBool changeUserName = false.obs;
  RxBool allowBackPress = true.obs;
  RxBool allowBackPressOnPw = true.obs;
  FirebaseAuth firebaseAuthInfo = FirebaseAuth.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkeyPassword = GlobalKey<FormState>();
  MemoriesController memoriesController = Get.isRegistered() ? Get.find<MemoriesController>() : Get.put(MemoriesController());

  final memoriesRef = FirebaseFirestore.instance.collection(memoriesCollection).withConverter<MemoriesModel>(
        fromFirestore: (snapshots, _) => MemoriesModel.fromJson(snapshots.data()!),
        toFirestore: (memories, _) => memories.toJson(),
      );

  FacebookLogin facebookAuth = FacebookLogin();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    nameController.value.text = userName;
  }

  final usersRef = FirebaseFirestore.instance.collection(userCollection).withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (users, _) => users.toJson(),
      );

  void updateProfileImage(String profileUrl) {
    usersRef.doc(userId).update({"profile_image": profileUrl}).then((value) => {
          userImage.value = profileUrl,
          memoriesController.onInit(),
        });
  }

  changePassword() async {
    if (formkeyPassword.currentState!.validate()) {
      formkeyPassword.currentState!.save();
      allowBackPressOnPw.value = false;
      EasyLoading.show(status: 'Processing..');
      final user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(email: user!.email!, password: oldPasswordcontroller.value.text);

      user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPasswordcontroller.value.text).then((_) {
          EasyLoading.dismiss();
          allowBackPressOnPw.value = true;
          clearPassword();
          Get.back();
          Get.snackbar('Success', 'Password changed.');
        }).catchError((error) {
          Get.snackbar('User not found', '');
          allowBackPressOnPw.value = true;
          clearPassword();
          EasyLoading.dismiss();
        });
      }).catchError((err) {
        EasyLoading.dismiss();
        clearPassword();
        allowBackPressOnPw.value = true;
        Get.snackbar('Password Incorrect', 'Current password is incorrect.');
      });
    }
  }

// Clear Passwords for change password view
  clearPassword() {
    oldPasswordcontroller.value.text = "";
    newPasswordcontroller.value.text = "";
    confirmPasswordcontroller.value.text = "";
  }

  logoutUser() {
    usersRef.doc(userId).update({"device_token": ""}).then((value) async {
      firebaseAuthInfo.signOut();
      firebaseAuthSplash = null;
      isFacebookLogin = false;

      isAppleLogin = false;
      final prefs = await SharedPreferences.getInstance();
      print("prefs Apple Token  ${prefs.getString("appleToken")}");
      prefs.setString("appleToken", '');
      await facebookAuth.logOut();
      userEmail = "";
      userId = "";
      userImage.value = "";
      userName = "";
      fromShare = false;
      sharedMemoryCount.value = 0;

      Get.offAllNamed(AppRoutes.signup);
    }).onError((error, stackTrace) {});
  }

  void deleteAccount() async {
    EasyLoading.show();

    if (isAppleLogin != null && isAppleLogin!) {
      final prefs = await SharedPreferences.getInstance();
      var appleEmail = prefs.getString("appleEmail");
      usersRef.where('email', isEqualTo: appleEmail).get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      }).then((value) => {EasyLoading.dismiss(), Get.offAllNamed(AppRoutes.signup)});
    } else {
      final user = FirebaseAuth.instance.currentUser;
      print("user...${user!.email}");
      usersRef.where('email', isEqualTo: user.email).get().then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      }).then((value) => {
            user.delete().then((value) => {EasyLoading.dismiss(), Get.offAllNamed(AppRoutes.signup)})
          });
    }
  }

  void deleteAccountAlert(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15)), color: Colors.white),
            height: 200,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    'Are you sure you want to delete your account?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: AppColors.darkColor, fontFamily: robotoBold),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        deleteAccount();
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
          );
        });
  }

  // update notification count as 0
  void updateNotificationCount() {
    usersRef.doc(userId).update({"notification_count": 0});
  }

  void changeUserNameFunc() {
    if (formkey.currentState!.validate()) {
      usersRef.doc(userId).update({"display_name": nameController.value.text.toString().trim()}).then((value) => {memoriesController.onInit(), userName = nameController.value.text.toString()});
    }
  }
}
