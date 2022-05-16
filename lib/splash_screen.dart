import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:stasht/sign_up.dart';
import 'package:stasht/utils/assets_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<StatefulWidget> {
  @override
  void initState() {
    super.initState();
    hundling();
  }

  hundling() async{
    Future.delayed(const Duration(milliseconds:3000),(){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (cotext) => const SignUp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image:  DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      preLoader,
                    ))),
            child: Image.asset(logo,height: 40,width: 40,)
        ));
  }
}