import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
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
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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

  changePassword() async {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      EasyLoading.show(status: 'Processing..');
      final user = await FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email!, password: oldPasswordcontroller.value.text);

      user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPasswordcontroller.value.text).then((_) {
          //Success, do something
          print('NewPassword');
           EasyLoading.dismiss();
          Get.back();
          Get.snackbar('Success', 'Password changed successfully.');
         
        }).catchError((error) {
          //Error, show something
          print('catchErrorUpdate $error');
          Get.snackbar('User not found', '');
          EasyLoading.dismiss();
        });
      }).catchError((err) {
        print('catchError $err');
        EasyLoading.dismiss();
        Get.snackbar('Password Incorrect', 'Current password is incorrect.');
      });
    }
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
    if (formkey.currentState!.validate()) {}
    usersRef
        .doc(userId)
        .update({"display_name": nameController.value.text}).then(
            (value) => {print('onNameChange ')});
  }
}
