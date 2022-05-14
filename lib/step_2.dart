// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'memories.dart';

class Step_2 extends StatefulWidget{
  const Step_2({Key? key}) : super(key: key);

  @override
  State<Step_2> createState() {
    return _Step_2();
  }

}

class _Step_2 extends State<Step_2> {
  List Items = [
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(child:
        SingleChildScrollView(child:
        Padding(padding: EdgeInsets.zero,
            child: Center(
              child: Column(
                children: [
                  const Text("stasht.",
                    style: TextStyle(
                        fontSize: 53,
                        color: Color.fromRGBO(108, 96, 255, 1),
                        fontWeight: FontWeight.w800,
                        fontFamily: "gibsonsemibold"
                    ),),
                  SizedBox(height: 10,),
                  const Text("Step 2",
                    style: TextStyle(fontSize:21,color:Color.fromRGBO(108, 96, 255, 1),
                      fontFamily: "gibsonsemibold",),),
                  const SizedBox(height: 8,),
                  const Text("Choose photos to add to your memory folder ",
                    style: TextStyle(fontSize:16,color: Colors.black,
                      fontFamily: "gibsonsemibold",),),

                  const SizedBox(height: 15,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width*1.5,
                    child: GridView.builder(
                      itemCount:Items.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation == Orientation.landscape ? 3: 3,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio: (1 / 1),
                      ),
                      itemBuilder: (context,index,) {
                        return GestureDetector(
                          onTap:(){
                            //Navigator.of(context).pushNamed(RouteName.GridViewCustom);
                          },
                          child:Container(
                              height: 30,
                              width: 30,
                              color: Colors.grey,
                              child: Image.asset( Items[index],fit: BoxFit.fill,)
                          ),
                        );
                      },
                    ),),




                ],
              ),)),)),
        bottomSheet:Container(
          height: 50,
          child:   Padding(padding: const EdgeInsets.only(top: 5,right: 10),child:
          InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Memories()));
          },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:const [
                  Text("Done",style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                  SizedBox(width: 5,),
                  Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,)
                ],
              ))),
        )
    );
  }
}