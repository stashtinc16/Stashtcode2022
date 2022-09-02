import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/constants.dart';

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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkeyPassword = GlobalKey<FormState>();
  MemoriesController memoriesController = Get.isRegistered()
      ? Get.find<MemoriesController>()
      : Get.put(MemoriesController());

  final memoriesRef = FirebaseFirestore.instance
      .collection(memoriesCollection)
      .withConverter<MemoriesModel>(
        fromFirestore: (snapshots, _) =>
            MemoriesModel.fromJson(snapshots.data()!),
        toFirestore: (memories, _) => memories.toJson(),
      );

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
    usersRef.doc(userId).update({"profile_image": profileUrl}).then((value) => {
          print('Profile updated'),
          userImage.value = profileUrl,
          memoriesController.onInit(),
        });
  }

  changePassword() async {
    if (formkeyPassword.currentState!.validate()) {
      formkeyPassword.currentState!.save();
      allowBackPressOnPw.value = false;
      EasyLoading.show(status: 'Processing..');
      final user = await FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email!, password: oldPasswordcontroller.value.text);

      user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPasswordcontroller.value.text).then((_) {
          //Success, do something
          print('NewPassword');
          EasyLoading.dismiss();
          allowBackPressOnPw.value = true;
          clearPassword();
          Get.back();
          Get.snackbar('Success', 'Password changed.');
        }).catchError((error) {
          //Error, show something
          print('catchErrorUpdate $error');
          Get.snackbar('User not found', '');
          allowBackPressOnPw.value = true;
          clearPassword();
          EasyLoading.dismiss();
        });
      }).catchError((err) {
        print('catchError $err');
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
    usersRef.doc(userId).update({"device_token": ""}).then((value) {
      print('Token Removed');
      firebaseAuth.signOut();
      facebookAuth.logOut();
      userEmail = "";
      userId = "";
      userImage.value = "";
      userName = "";
      fromShare = false;
      sharedMemoryCount.value = 0;

      Get.offAllNamed(AppRoutes.signup);
      print('UserId==== $userId');
    }).onError((error, stackTrace) {
      print('Profile ${error}');
    });
  }

  // update notification count as 0
  void updateNotificationCount() {
    usersRef.doc(userId).update({"notification_count": 0});
  }

  void changeUserNameFunc() {
    if (formkey.currentState!.validate()) {
      usersRef.doc(userId).update({
        "display_name": nameController.value.text.toString().trim()
      }).then((value) => {
            print('onNameChange...${nameController.value.text.toString()} '),
            memoriesController.onInit(),
            userName = nameController.value.text.toString()
          });
    }
  }
}
