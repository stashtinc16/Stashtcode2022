import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/splash/controllers/splash_controller.dart';
import 'package:stasht/utils/assets_images.dart';

class SplashScreen extends GetView<SplashController> {
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
              color: Color.fromRGBO(108, 96, 255, 1),
              height: 40,
              width: 40,
            )));
  }

  
}
