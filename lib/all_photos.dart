// ignore_for_file: avoid_print, sized_box_for_whitespace, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stasht/models/photos_model.dart';

class All_Photos extends StatefulWidget {
  const All_Photos({Key? key}) : super(key: key);

  @override
  State<All_Photos> createState() {
    return _All_Photos();
  }
}

class _All_Photos extends State<All_Photos> {
  bool isSelect = false;

  List<PhotosModel> photosList = [


  ];
  int count = 0;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 50; i++) {
      photosList.add(PhotosModel(imagePath: "assets/images/nature.webp", isChecked: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/dropbox.svg",
                        height: 22,
                        width: 21,

                      ),
                      const SizedBox(
                        width: 15,),
                      Image.asset(
                        "assets/images/photoApple.webp",
                        height: 32,
                        width:31,
                      ),
                    ],
                  ),
                  Container(
                    height: 30,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color.fromRGBO(108, 96, 255, 1))),
                    child: const Text(
                      "3 Grid",
                      style: TextStyle(
                          color: Color.fromRGBO(108, 96, 255, 1), fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isSelect = !isSelect;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 550,
                child: GridView.builder(
                  itemCount: photosList.length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                        Orientation.landscape
                        ? 3
                        : 3,
                    crossAxisSpacing: 0.5,
                    mainAxisSpacing: 0.5,
                    childAspectRatio: (1 / 1),
                  ),
                  itemBuilder: (
                      context,
                      index,
                      ) {
                    return GestureDetector(
                      onTap: () {
                        //Navigator.of(context).pushNamed(RouteName.GridViewCustom);
                        setState(() {
                          photosList[index].isChecked =
                          !photosList[index].isChecked;
                          if (photosList[index].isChecked) {
                            count++;
                          } else {
                            count--;
                          }
                          print("Counts $count");
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.32,
                            height: MediaQuery.of(context).size.width * 0.32,
                            color: Colors.grey,
                            child: Image.asset(
                              photosList[index].imagePath,
                              height: MediaQuery.of(context).size.height,
                              width:MediaQuery.of(context).size.width,fit: BoxFit.fill,
                            ),
                          ),
                          if (photosList[index].isChecked)
                            Container(
                                width: MediaQuery.of(context).size.width * 0.32,
                                height:
                                MediaQuery.of(context).size.width * 0.32,
                                color: photosList[index].isChecked
                                    ?  const Color.fromRGBO(108, 96, 255, 1).withOpacity(0.3)
                                    : Colors.transparent,
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Colors.white,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 25,bottom: 10,top: 5),
                child:Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5,),
                    child:
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(169, 165, 218, 1),
                          border: Border.all(
                              color: const Color.fromRGBO(108, 96, 255, 1), width: 3.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.asset("assets/images/nature.webp",fit: BoxFit.fill,),
                    ),),
                  Padding(padding: const EdgeInsets.only(bottom: 15,left: 40),child:
                  Container(
                    alignment: Alignment.center,
                    height: 25,
                    width: 25,
                    decoration: const BoxDecoration(shape: BoxShape.circle,color: Color.fromRGBO(108, 96, 255, 1)),
                    child: Text(count.toString(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
                  ))

                ],)
            )
          ],
        ),
      ),
    );
  }
}