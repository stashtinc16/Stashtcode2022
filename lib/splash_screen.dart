import 'package:flutter/material.dart';
import 'package:stasht/sign_up.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}
class _SplashScreen extends  State<StatefulWidget> {
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

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        // body:Container(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   decoration: const BoxDecoration(
        //       color: Colors.deepPurple,
        //       image: DecorationImage(
        //           fit: BoxFit.cover, image: AssetImage('assets/images/stasht.png',
        //           )
        //       )),
        // )

    );
  }
}