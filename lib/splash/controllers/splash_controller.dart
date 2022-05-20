import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/constants.dart';

class SplashController extends GetxController {
  User? firebaseAuth = FirebaseAuth.instance.currentUser;
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  bool? _isLogged;

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
  }

  hundling() async {
    print('FlutterFirebaseAuth $firebaseAuth');
    Future.delayed(const Duration(milliseconds: 2500), () async {
      _isLogged = await facebookAuth.accessToken != null;
      if (firebaseAuth != null || _isLogged!) {
        usersRef
            .where("email", isEqualTo: firebaseAuth!.email!)
            .get()
            .then((value) => {
                  value.docs.forEach((element) => {
                        print('UsersDB $value'),
                        saveSession(element.id, element.data().userName!,
                            element.data().email!, ""),
                      })
                });

        Get.offNamed(AppRoutes.memories);
      } else {
        Get.offNamed(AppRoutes.signIn);
      }
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (cotext) => const SignUp()));
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
