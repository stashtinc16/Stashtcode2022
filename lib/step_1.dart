import 'package:flutter/material.dart';

import 'memories_empty.dart';

class Step1 extends StatefulWidget {
  @override
State<Step1> createState() {
  return _Step1();
}
}
class _Step1 extends State<Step1> {
  bool _iisObscure=true;
  int val = -1;
  bool isEmail=false;
  // NetworkUtil _networkUtil = new NetworkUtil();

  var passwordcontroller=TextEditingController();
  var namecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
            child: Padding(padding: EdgeInsets.only(top:50,left: 25,right: 25),
                child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text("stasht.",
                          style: TextStyle(fontSize:70,color: Colors.deepPurple, fontWeight: FontWeight.w900,
                              fontFamily: "adobe-clean-cufonfonts",

                              fontStyle: FontStyle.italic),),
                      ),
                      SizedBox(height: 100,),
                      Center(
                        child: Text("Step 1",
                          style: TextStyle(fontSize:20,color: Colors.deepPurple, fontWeight: FontWeight.w600,

                            //fontFamily: "adobe-clean-cufonfonts"),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Center(
                          child: Text("Create your first memory folder",
                            style: TextStyle(fontSize:15,color: Colors.black, fontWeight: FontWeight.w600,

                              // fontFamily: "adobe-clean-cufonfonts"),),
                            ),
                          )
                      ),
                      SizedBox(height: 20,),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color.fromRGBO(76, 73, 73, 0.6),),
                          borderRadius: BorderRadius.circular(50),
                          color:  Colors.white,
                        ),
                        child: TextFormField(

                          decoration: const InputDecoration( labelText: "Ex: Wedding Photos",
                              labelStyle:
                              TextStyle(color: Color.fromRGBO(76, 73, 73, 0.6),
                                fontSize:20,
                                fontWeight: FontWeight.w400,),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom:10,left: 15,top:5)
                          ),
                          style:TextStyle(color: Colors.black),
                          // validator: (v){
                          //   if(v!.isEmpty ||
                          //       !RegExp(
                          //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          //           .hasMatch(v)) {
                          //     return 'Enter a valid email!';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),

                      SizedBox(height: 20,),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Memories_Empty()));
                        },
                        child:
                        Center(
                          child: Container(
                            height: 40,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.deepPurpleAccent,borderRadius: BorderRadius.circular(20)),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Next",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w900),),
                                Padding(padding: EdgeInsets.only(left: 5),child:
                                Icon(Icons.arrow_forward_ios,color: Colors.white,size: 13,))
                              ],),
                          ),
                        ),
                      ),
                      SizedBox(height:10,),
                      Center(
                        child: Text("Skip This Step",textAlign:TextAlign.center,
                          style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 13,decoration:TextDecoration.underline, ),),
                      ),


                    ]
                )
            )
        )
    );
  }
}