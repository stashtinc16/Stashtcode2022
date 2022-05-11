import 'package:flutter/material.dart';
import 'package:stasht/models/photos_model.dart';

import 'app_bar.dart';

class All_Photos extends StatefulWidget {
  @override
  State<All_Photos> createState() {
    return _All_Photos();
  }
}

class _All_Photos extends State<All_Photos> {
  bool isSelect = false;

  List<PhotosModel> photosList = [];
  int count = 0;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; i++) {
      photosList.add(PhotosModel(imagePath: "", isChecked: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context, "All Photos"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                      )
                    ],
                  ),
                  Container(
                    height: 30,
                    width: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurpleAccent)),
                    child: Text(
                      "3 Grid",
                      style: TextStyle(
                          color: Colors.deepPurpleAccent, fontSize: 14),
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
                height: 530,
                child: GridView.builder(
                  itemCount: photosList.length,
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 3
                        : 3,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [Text("hi")],
                            ),
                          ),
                          if (photosList[index].isChecked)
                            Container(
                                width: MediaQuery.of(context).size.width * 0.32,
                                height:
                                    MediaQuery.of(context).size.width * 0.32,
                                color: photosList[index].isChecked
                                    ? Colors.deepPurpleAccent.withOpacity(0.3)
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
            Padding(
                padding: EdgeInsets.only(top: 5, left: 25,bottom: 10),
                child:Stack(children: [
                Padding(
                padding: EdgeInsets.only(top: 5,),
              child:
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                            color: Colors.deepPurpleAccent, width: 3.5),
                        borderRadius: BorderRadius.circular(10)),
                  ),),
                  Padding(padding: EdgeInsets.only(bottom: 15,left: 40),child:
                  Container(
                    alignment: Alignment.center,
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.deepPurpleAccent),
                    child: Text(count.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400),),
                  ))

                ],)
            )
          ],
        ),
      ),
    );
  }
}
