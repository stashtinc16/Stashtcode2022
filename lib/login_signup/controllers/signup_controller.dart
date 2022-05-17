import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stasht/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/routes/app_routes.dart';

class SignupController extends GetxController {
  var facebookLogin = FacebookLogin();
  final RxBool isObscure = true.obs;

  final AuthenticationService _auth = AuthenticationService();
  final formkey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final usersRef = FirebaseFirestore.instance
      .collection('users')
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );
  @override
  void onInit() {
    super.onInit();
  }

  void checkEmailExists() {
    usersRef
        .where("email", isEqualTo: emailController.text.toString())
        .get()
        .then((value) => {
              value.docs.length,
              if (value.docs.isEmpty)
                {signupUser()}
              else
                {
                  Get.snackbar("Email Exists",
                      "This email id is already registered with us, please sign-in!")
                }
            });
  }

  Future<void> signupUser() async {
    if (formkey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((value) {
          print("FirebaseAuthExceptionValue $value");
          saveUserToDB(value.user, userNameController.text);
        }).onError((error, stackTrace) {
          print("FirebaseAuthExceptionError $error");
        });
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException $e");
        return;
      }
    }
  }

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) {
        Get.offNamed(AppRoutes.memories);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("User not found");
        return Future.error(
            "User Not Found", StackTrace.fromString("User Not Found"));
      } else if (e.code == 'wrong-password') {
        print("Incorrect password");

        return Future.error(
            "Incorrect password", StackTrace.fromString("Incorrect password"));
      } else {
        print("Login Failed");
        return Future.error(
            "Login Failed", StackTrace.fromString("Unknown error"));
      }
    }
  }

  void saveUserToDB(User? user, String username) {
    UserModel userModel = UserModel(
        userName: username,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        deviceToken: "",
        deviceType: Platform.isAndroid ? "Android" : "IOS",
        displayName: username,
        email: user!.email,
        profileImage: "",
        status: true);

    usersRef.add(userModel).then((value) => {
          print('UsersDB $value'),
          Get.snackbar('Success', "User logged-in successfully",
              snackPosition: SnackPosition.BOTTOM),
          Get.offNamed(AppRoutes.memories)
        });
  }

//Signin to facebook
  Future<void> facebookSignin() async {
    final fbLogin = FacebookLogin();
    final FacebookLoginResult result = await fbLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    final FacebookAccessToken? accessToken = result.accessToken;

    // Get profile data
    final profile = await fbLogin.getUserProfile();
    final email = await fbLogin.getUserEmail();
    final profileImage =
        await fbLogin.getProfileImageUrl(width: 500, height: 500);
    saveUserToFirebase(profile, email, profileImage);
    print('Hello, ${profile!.name}! You ID: ${profile.userId}');
  }

// Save user to firebase
  void saveUserToFirebase(
      FacebookUserProfile? profile, String? email, String? profileImage) {
    UserModel userModel = UserModel(
        userName: profile!.name!,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        deviceToken: "",
        deviceType: Platform.isAndroid ? "Android" : "IOS",
        displayName: profile.name,
        email: email,
        profileImage: profileImage,
        status: true);

    usersRef.add(userModel).then((value) => {
          print('UsersDB $value'),
          Get.snackbar('Success', "User logged-in successfully",
              snackPosition: SnackPosition.BOTTOM),
          Get.offNamed(AppRoutes.memories)
        });
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
