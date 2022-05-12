import 'package:flutter/material.dart';

import 'app_bar.dart';

class Notifications extends StatefulWidget{
  @override
  State<Notifications> createState() {
    return _Notifications();
  }

}

class _Notifications extends State<Notifications> {
  bool isTap = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppbar(context, "Notifications"),
        body: SingleChildScrollView(child:
        Padding(padding: EdgeInsets.all(15),child:
        Column(children: [
          Container(height: MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width ,
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 10,),
                      InkWell(onTap: (){
                        setState(() {
                          //  isTap=!isTap;
                        });
                      },
                        child:Container(
                          color: isTap ? Colors.grey: Colors.white,
                          child: Row(
                            children: [
                              Container(height: 35,width: 35,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,color: Colors.grey,
                                ),),
                              SizedBox(width: 8,),
                              RichText(
                                text: TextSpan(
                                  text: 'John Paxton ',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent,fontSize: 13
                                  ),
                                  children: const <TextSpan>[
                                    TextSpan(text: 'added you a public memory\n', style: TextStyle(color: Colors.black,fontSize: 13)),
                                    TextSpan(text: 'Boat cruise 2019', style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 13)),
                                  ],
                                ),)
                            ],
                          ),),),
                      SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Colors.deepPurpleAccent,
                      )
                    ],
                  );
                },
              ))

        ],),)
        )
    );
  }
}
