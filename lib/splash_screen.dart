import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/controllers/signup_controller.dart';
import 'package:stasht/utils/assets_images.dart';

class SplashScreen extends GetView<SignupController> {
  const SplashScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      preLoader,
                    ))),
            child: Image.asset(
              logo,
              height: 40,
              width: 40,
            )));
  }
}
