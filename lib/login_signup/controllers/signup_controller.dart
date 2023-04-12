import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/splash/controllers/splash_controller.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/constants.dart';

bool? isFacebookLogin;
bool? isAppleLogin;

class SignupController extends GetxController {
  // var facebookLogin = FacebookLogin();
  final RxBool isObscure = true.obs;
  final RxBool isObscureCP = true.obs;
  bool? _isLogged;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> formkeySignin = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  Rx<TextEditingController> emailController = TextEditingController().obs;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController email1Controller = TextEditingController();
  TextEditingController password1Controller = TextEditingController();

  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;
  final plugin = FacebookLogin(debug: true);
  bool _fetching = false;

  bool get fetching => _fetching;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  final usersRef = FirebaseFirestore.instance.collection(userCollection).withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void checkEmailExists() {
    usersRef.where("email", isEqualTo: emailController.value.text.toString().trim()).get().then((value) => {
          value.docs.length,
          if (value.docs.isEmpty) {signupUser()} else {Get.snackbar("Email Exists", "This email id is already registered with us, please sign-in!", colorText: Colors.white)}
        });
  }

// Signup user to app and save session
  Future<void> signupUser() async {
    if (formkey.currentState!.validate()) {
      try {
        EasyLoading.show(status: 'Processing..');
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.value.text.toString().trim(),
          password: passwordController.text,
        )
            .then((value) {
          saveUserToDB(value.user, userNameController.text.toString().trim());
        }).onError((error, stackTrace) {
          if (error.toString().contains("email-already-in-use")) {
            Get.snackbar("Email exits", "The email address is already in use by another account.", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
          }
          EasyLoading.dismiss();
          Get.snackbar("Email exits", "Enter a valid email", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
        });
      } on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        return;
      }
    }
  }

// Signin to apple
  Future<bool> appleLogin() async {
    EasyLoading.show(status: 'Processing');

    await _updateLoginInfo();
    EasyLoading.dismiss();

    return _isLogged!;
  }

  void initiateAppleSignUp() async {
    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;
            final prefs = await SharedPreferences.getInstance();

            String s = String.fromCharCodes(result.credential.identityToken);
            var outputAsUint8List = Uint8List.fromList(s.codeUnits);
            var convertedIdentityToken = Utf8Decoder().convert(outputAsUint8List);
            print("Identity token: ${convertedIdentityToken}");
            prefs.setString("appleToken", convertedIdentityToken);

            if (appleIdCredential.email != null) {
              print("Apple Login Credentials...  ${appleIdCredential.email} \n  ${appleIdCredential.fullName.givenName} \n ${appleIdCredential.fullName.familyName}");
              prefs.setString("appleToken", convertedIdentityToken);
              prefs.setString("appleEmail", appleIdCredential.email);
              prefs.setString("appleFullName", appleIdCredential.fullName.givenName);
            }

            var appleEmail = prefs.getString("appleEmail");
            var appleFullName = prefs.getString("appleFullName");
            print(" appleEmail  appleFullName ${appleEmail} ${appleFullName}");
            print("Apple Token in Preferences  ${prefs.getString("appleToken")}");
            if (_isLogged! && appleEmail != null) {
              isFacebookLogin = false;
              isAppleLogin = true;
              _fetching = false;
              usersRef.where("email", isEqualTo: appleEmail).get().then((value) => {
                    value.docs.length,
                    if (value.docs.isEmpty)
                      {
                        isSocailUser = true,
                        saveUserToFirebase(appleFullName, appleEmail, ''),
                      }
                    else
                      {
                        isSocailUser = true,
                        saveSession(value.docs[0].id, value.docs[0].data().displayName!, value.docs[0].data().email!, value.docs[0].data().profileImage!,
                            value.docs[0].data().notificationCount != null ? value.docs[0].data().notificationCount! : 0),
                        EasyLoading.dismiss(),
                        emailController.value.text = "",
                        passwordController.text = "",
                        print("in apple block"),
                        print("line 155"),
                        firebaseAuthSplash = FirebaseAuth.instance.currentUser,
                        goToMemories(fromShare),
                        Get.snackbar('Success', "User logged-in!", snackPosition: SnackPosition.BOTTOM, duration: Duration(seconds: 2), colorText: Colors.white, backgroundColor: Colors.green),
                      }
                  });
            } else {
              EasyLoading.dismiss();
            }
          } catch (e) {
            print("error");
          }
          break;
        case AuthorizationStatus.error:
          print("Apple AuthorizationStatus.error");
          break;

        case AuthorizationStatus.cancelled:
          print("Apple AuthorizationStatus.cancelled");
          break;
      }
    } catch (error) {
      print("error with apple sign in");
    }
  }

// Signin user to app and save session
  Future<void> signIn() async {
    if (formkeySignin.currentState!.validate()) {
      try {
        EasyLoading.show(status: 'Processing..');
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email1Controller.text.toString().trim(), password: password1Controller.text).then((value1) {
          usersRef.where("email", isEqualTo: value1.user!.email).get().then((value) => {
                EasyLoading.dismiss(),
                if (value.docs.isNotEmpty)
                  {
                    // if (value.docs[0].data().deviceToken!.isEmpty)
                    //   {
                    usersRef.doc(value.docs[0].id).update({"device_token": globalNotificationToken}),

                    // },
                    saveSession(value.docs[0].id, value.docs[0].data().displayName!, email1Controller.text.toString().trim(), value.docs[0].data().profileImage!,
                        value.docs[0].data().notificationCount != null ? value.docs[0].data().notificationCount! : 0),
                    firebaseAuthSplash = FirebaseAuth.instance.currentUser,
                    goToMemories(fromShare)
                  }
                else
                  {Get.snackbar("Error", "Email not exists!", colorText: Colors.white)}
              });
        });
      } on FirebaseAuthException catch (e) {
        EasyLoading.dismiss();
        if (e.code == 'user-not-found') {
          print("user-not-found");
          Get.back(result: {"email": email1Controller.text.toString()});
          Get.snackbar("Error", "User not found, Please signup new user", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
          return Future.error("User Not Found", StackTrace.fromString("User Not Found"));
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Password is incorrect", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
          return Future.error("Incorrect password", StackTrace.fromString("Incorrect password"));
        } else {
          Get.snackbar("Error", "Login Failed! Please try again in some time", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white);
          return Future.error("Login Failed", StackTrace.fromString("Unknown error"));
        }
      }
    }
  }

//Save user to Firebase

  void saveUserToDB(User? user, String username) {
    UserModel userModel = UserModel(
        userName: username,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        deviceToken: globalNotificationToken,
        deviceType: Platform.isAndroid ? "Android" : "IOS",
        displayName: username,
        email: user!.email,
        notificationCount: 0,
        profileImage: "",
        status: true);

    usersRef.add(userModel).then((value) => {
          EasyLoading.dismiss(),
          saveSession(value.id, username, user.email!, "", 0),
          clearTexts(),
          Get.snackbar('Success', "User registered", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.green),
          if (fromShare) {firebaseAuthSplash = FirebaseAuth.instance.currentUser, goToMemories(true)} else {Get.offNamed(AppRoutes.memoriesStep1, arguments: "yes")}
        });
  }

// Initialize Facebook
  void _init() async {
    _isLogged = plugin.accessToken != null;
  }

//Signin to facebook
  Future<bool> facebookLogin() async {
    EasyLoading.show(status: 'Processing');
    await plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
    EasyLoading.dismiss();

    return _isLogged!;
  }

  Future<void> _updateLoginInfo() async {
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    // OAuthCredential credential = FacebookAuthProvider.credential(token!.token);
    // UserCredential user = await firebaseAuth.signInWithCredential(credential);

    EasyLoading.dismiss();
    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }
    if (_isLogged! && email != null) {
      isFacebookLogin = true;
      _fetching = false;
      usersRef.where("email", isEqualTo: email).get().then((value) => {
            value.docs.length,
            if (value.docs.isEmpty)
              {
                isSocailUser = true,
                saveUserToFirebase(profile!.name, email, imageUrl),
              }
            else
              {
                isSocailUser = true,
                saveSession(value.docs[0].id, value.docs[0].data().displayName!, value.docs[0].data().email!, value.docs[0].data().profileImage!,
                    value.docs[0].data().notificationCount != null ? value.docs[0].data().notificationCount! : 0),
                EasyLoading.dismiss(),
                emailController.value.text = "",
                passwordController.text = "",
                Get.snackbar('Success', "User logged-in!", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: Colors.green),
                print("line 299"),
                firebaseAuthSplash = FirebaseAuth.instance.currentUser,
                goToMemories(fromShare)
              }
          });
    } else {
      EasyLoading.dismiss();
    }
  }

// Save user to firebase
  void saveUserToFirebase(String? name, String? email, String? profileImage) {
    UserModel userModel = UserModel(
        userName: name!,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        deviceToken: globalNotificationToken,
        deviceType: Platform.isAndroid ? "Android" : "IOS",
        displayName: name,
        email: email,
        profileImage: profileImage,
        notificationCount: 0,
        status: true);

    usersRef.add(userModel).then((value) => {
          EasyLoading.dismiss(),
          saveSession(value.id, name, email!, profileImage!, 0),
          Get.snackbar('Success', "User logged-in!", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white),
          print("line 326"),
          Get.offNamed(AppRoutes.memoriesStep1, arguments: "yes")
        });
  }

// Save User Session
  void saveSession(String _userId, String _userName, String _userEmail, String _userImage, int _notificationCount) {
    userId = _userId;
    userEmail = _userEmail;
    userName = _userName;
    userImage.value = _userImage;
    notificationCount.value = _notificationCount;
    clearTexts();
  }

// Clear
  void clearTexts() {
    userNameController.text = "";
    emailController.value.text = "";
    passwordController.text = "";
    email1Controller.text = "";
    password1Controller.text = "";
    confirmPasswordController.text = "";
  }

  @override
  void onClose() {
    super.onClose();
    clearTexts();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
