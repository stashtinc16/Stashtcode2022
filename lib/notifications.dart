import 'package:flutter/material.dart';
import 'package:stasht/models/notification_model.dart';

import 'app_bar.dart';

class Notifications extends StatefulWidget{
  @override
  State<Notifications> createState() {
    return _Notifications();
  }

}

class _Notifications extends State<Notifications> {

  List<NotificationModel> photosList = [


  ];
  int count = 0;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 50; i++) {
      photosList.add(NotificationModel(imagePath: "assets/images/nature.webp", isTap: false, content: '',));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(child:
        Padding(padding: const EdgeInsets.all(15),child:
        Column(children: [
          Container(height: MediaQuery.of(context).size.height,
              width:MediaQuery.of(context).size.width ,
              child: ListView.builder(
                itemCount:5,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10,),
                      InkWell(onTap: (){
                        setState(() {

                          photosList[index].isTap =
                          !photosList[index].isTap;
                          if (photosList[index].isTap) {
                            count++;
                          } else {
                            count--;
                          }
                          print("Counts $count");


                        });
                      },
                          child:

                          Stack(children: [
                            Container(
                              child: Row(
                                children: [
                                  CircleAvatar(radius: 20,
                                    child:  ClipRRect(
                                      child:Image.asset("assets/images/nature.webp",
                                        fit: BoxFit.fill,height: MediaQuery.of(context).size.height,
                                        width: MediaQuery.of(context).size.width,),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                  const SizedBox(width: 8,),
                                  RichText(
                                    text: const TextSpan(
                                      text: 'John Paxton ',
                                      style: TextStyle(fontFamily: "gibsonsemibold",
                                          color:  Color.fromRGBO(108, 96, 255, 1),fontSize: 13
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(text: 'added you a public memory\n', style: TextStyle(fontFamily: "gibsonsemibold",color: Colors.black,fontSize: 13,fontWeight: FontWeight.w400)),
                                        TextSpan(text: 'Boat cruise 2019', style: TextStyle(fontFamily: "gibsonsemibold",color: Color.fromRGBO(108, 96, 255, 1),fontSize: 13)),
                                      ],
                                    ),)
                                ],
                              ),), if (photosList[index].isTap)
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                color: photosList[index].isTap
                                    ?  const Color.fromRGBO(108, 96, 255, 1).withOpacity(0.3)
                                    : Colors.transparent,),
                          ],)

                      ),
                      const SizedBox(height: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 1,
                        color: Color.fromRGBO(108, 96, 255, 1),
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