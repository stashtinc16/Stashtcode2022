import 'package:flutter/material.dart';
import 'package:stasht/step_2.dart';

import 'memories_empty.dart';

class Step1 extends StatefulWidget {
  const Step1({Key? key}) : super(key: key);

  @override
  State<Step1> createState() {
    return _Step1();
  }
}
class _Step1 extends State<Step1> {
  int val = -1;
  bool isEmail=false;

  var passwordcontroller=TextEditingController();
  var namecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.only(top:50,left: 25,right: 25),
                child:Column(
                    children: [
                      const Center(
                        child:  Text("stasht.",
                          style:  TextStyle(
                              fontSize: 53,
                              color: Color.fromRGBO(108, 96, 255, 1),
                              fontWeight: FontWeight.w800,
                              fontFamily: "gibsonbold"
                          ),),
                      ),
                      const SizedBox(height: 100,),
                      const Center(
                        child:  Text("Step 1",
                          style:  TextStyle(fontSize:21,fontFamily: "gibsonsemibold",
                            color: Color.fromRGBO(108, 96, 255, 1), fontWeight: FontWeight.w200,

                            //fontFamily: "adobe-clean-cufonfonts"),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Center(
                          child:  Text("Create your first memory folder",
                            style: TextStyle(fontSize:16,color: Colors.black, fontWeight: FontWeight.w600,

                            ),
                          )
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        height: 43,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromRGBO(169, 165, 218, 1),),
                          borderRadius: BorderRadius.circular(50),
                          color:  Colors.white,
                        ),
                        child: TextFormField(

                          decoration: const InputDecoration( hintText: "Ex: Wedding Photos",
                              hintStyle:
                              TextStyle(color: Color.fromRGBO(76, 73, 73, 0.6),
                                fontSize:18,
                                fontWeight: FontWeight.w200,),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom:10,left: 20,top:5)
                          ),
                          style:const TextStyle(color: Colors.black),

                        ),
                      ),

                      const SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Step_2()));
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
                                Text("Next",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w900),),
                                Padding(padding:  EdgeInsets.only(left: 5),child:
                                Icon(Icons.arrow_forward_ios,color: Colors.white,size: 16,))
                              ],),
                          ),
                        ),
                      ),
                      const SizedBox(height:10,),
                      InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Memories_Empty()));
                      },
                        child: const Center(
                          child:  Text("Skip This Step",textAlign:TextAlign.center,
                            style: TextStyle(color: Color.fromRGBO(108, 96, 255, 1),fontSize: 14,decoration:TextDecoration.underline, ),),
                        ),)
                    ]
                )
            )
        )
    );
  }
}