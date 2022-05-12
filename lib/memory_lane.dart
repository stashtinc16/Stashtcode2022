import 'package:flutter/material.dart';

class Memory_Lane extends StatefulWidget {
  @override
  State<Memory_Lane> createState() {
    return _Memory_Lane();
  }
}

class _Memory_Lane extends State<Memory_Lane> {
  String items = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Icon(
                              Icons.arrow_back_ios_outlined,
                              color: Colors.white,
                            ),
                            InkWell(onTap: (){

                            },
                              child: Icon(
                                Icons.person_add_alt_1_outlined,
                                color: Colors.white,
                              ),)
                          ],
                        ),
                        Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.greenAccent,
                                      border: Border.all(
                                          color: Colors.white, width: 2)),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 5, left: 35),
                                    child: const Text(
                                      "Bnaff Trip 2021",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18),
                                    ))
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 35, left: 180),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                                border:
                                Border.all(color: Colors.white, width: 2)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 35, left: 200),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                                border:
                                Border.all(color: Colors.white, width: 2)),
                          ),
                        )
                      ],
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5,bottom: 60),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width*1.5,
                    child: ListView.builder(
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                          border: Border.all(
                                              color: Colors.white, width: 2)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Tanya Peters",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Banff, vancouvar, BC ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10),
                                            children: const <TextSpan>[
                                              TextSpan(
                                                  text: 'Apr 29/21',
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 10)),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "3",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      color: Colors.black,
                                      size: 16,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 400,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5, left: 15),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Add caption to this Post...',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ),
                            Container(
                              height: 1,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
      bottomSheet: Container(
          height: 60,
          color: Colors.white,
          child:Padding(padding: EdgeInsets.only(left: 30,right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Icon(Icons.insert_drive_file_outlined,color: Colors.grey,size: 25,),
                Icon(Icons.share_outlined,color: Colors.grey,size: 25,),
                Icon(Icons.web_outlined,color: Colors.grey,size: 25,),


              ],
            ),)
      ),
    );
  }
}