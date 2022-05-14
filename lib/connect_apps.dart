// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'memories_empty.dart';

class Connect_Apps extends StatefulWidget{
  const Connect_Apps({Key? key}) : super(key: key);

  @override
  State<Connect_Apps> createState() {
    return _Connect_Apps();
  }

}

class _Connect_Apps extends State<Connect_Apps>{
  bool isClick = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:  SafeArea(child: Center(child:
        Column(
          children: [
            const SizedBox(height: 20,),
            const Text("stasht.",textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "adobe-clean-cufonfonts",
                  color: Colors.deepPurpleAccent,fontWeight: FontWeight.bold,fontSize: 40),),
            const Padding(padding: EdgeInsets.only(left: 30,right: 30) ,
                child: Text("Connect more apps to build more meaningful memories",textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),)),
            const SizedBox(height:120,),
            InkWell(onTap: (){
              setState(() {
                isClick= !isClick;
              });
              //Navigator.push(context, MaterialPageRoute(builder: (context)=> Memories_Empty()));
            },
              child:
              Container(
                height: 40,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(color:isClick? Colors.deepPurpleAccent: Colors.green,borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text("Allow Get Pictures",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w900),),
                  ],),
              ),),
            const SizedBox(height:100,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Memories_Empty()));
              },
              child:
              Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.deepPurpleAccent,borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Text("Next",textAlign:TextAlign.center,style:  TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w900),),
                    Padding(padding:  EdgeInsets.only(left: 5),child:
                    Icon(Icons.arrow_forward_ios,color: Colors.white,size: 13,))
                  ],),
              ),),
            const SizedBox(height: 10,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Memories_Empty()));
              },
              child:
              const Text("Skip This Step",textAlign:TextAlign.center,
                style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 13,decoration:TextDecoration.underline, ),),)
          ],
        ),),)
    );
  }
}