import 'package:flutter/material.dart';
import 'package:stasht/sign_up.dart';
import 'package:stasht/step_1.dart';

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
          context, MaterialPageRoute(builder: (cotext) => SignUp()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/preloader.png',
                    ))),
            child: Image.asset("assets/images/logo.png",height: 40,width: 40,)
        ));
  }
}