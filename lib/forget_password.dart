import 'package:flutter/material.dart';
import 'package:stasht/splash_screen.dart';


class Forget_Password extends StatefulWidget {
  const Forget_Password({Key? key}) : super(key: key);

  @override
  State<Forget_Password> createState() => _Forget_PasswordState();
}

class _Forget_PasswordState extends State<Forget_Password> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(child:
        Padding(padding: const EdgeInsets.only(top: 50,left: 25,right: 25),child:
        Column(
          children: [
            const Center(
              child: Text(
                "stasht.",
                style: TextStyle(
                    fontSize: 53,
                    color: Color.fromRGBO(108, 96, 255, 1),
                    fontWeight: FontWeight.w800,
                    fontFamily: "gibsonsemibold"
                ),
              ),
            ),
            const SizedBox(height: 50,),
            const Center(
              child:  Text("Forget Password",
                style:  TextStyle(fontSize:21,fontFamily: "gibsonsemibold",
                  color: Color.fromRGBO(108, 96, 255, 1), fontWeight: FontWeight.w200,

                  //fontFamily: "adobe-clean-cufonfonts"),
                ),
              ),
            ),
            const SizedBox(height: 50,),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(169, 165, 218, 1),),
                borderRadius: BorderRadius.circular(50),
                color:  Colors.white,
              ),
              child: TextFormField(

                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Username",
                  contentPadding: EdgeInsets.only(top: 5,left: 20,bottom: 5),
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(108, 96, 255, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      fontFamily: "assets/fonts/roboto_regular.ttf"
                  ),
                ),
                style:const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),

              ),
            ),

            const SizedBox(height: 50,),
            InkWell(
              onTap: (){
                //  Navigator.push(context, MaterialPageRoute(builder: (context)=> Step_2()));
              },
              child:
              Center(
                child: Container(
                  height: 42,
                  width: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: const Color.fromRGBO(108, 96, 255, 1),borderRadius: BorderRadius.circular(18)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                      Text("Send Link",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w200),),
                    ],),
                ),
              ),
            ),
            const SizedBox(height:20,),
            InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SplashScreen()));
            },
              child: const Center(
                child:  Text("Back to login",textAlign:TextAlign.center,
                  style: TextStyle(color: Color.fromRGBO(108, 96, 255, 1),fontSize: 14,decoration:TextDecoration.underline, ),),
              ),)
          ],
        ),),)
    );
  }
}