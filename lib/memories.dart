import 'package:flutter/material.dart';
import 'package:stasht/app_bar.dart';

class Memories extends StatefulWidget{
  @override
  State<Memories> createState() {
    return _Memories();
  }

}

class _Memories extends State<Memories>{
  bool isTap = false;
  bool isClick = false;
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context,"Memories"),
      body:Padding(padding: EdgeInsets.all(15),
        child: SingleChildScrollView(child:
        Column(
        children: [
          InkWell(onTap: (){
            setState(() {
              isTap = !isTap;

            });
          },
            child: Row(
            children: [
              isTap? Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
                size: 30,
              ):
            Icon(
                Icons.arrow_right,
                color: Colors.black,
                size: 30,
             ),
              Text(
                "My Memories (1) ",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),),
          SizedBox(height: 0,),
          isTap?
          Container(height: 100,
          width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(15),),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Container(height: 45,
            width: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.lightBlueAccent,shape: BoxShape.circle),),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Baniff Trip 2021",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 18),),
                  Text("Author: Taniya & 10 others",style: TextStyle(color: Colors.white,fontSize: 12),)
                ],
              ),
              Container(height: 35,
                width: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.greenAccent,shape: BoxShape.circle),child: Text("34",style:
                  TextStyle(color: Colors.blue,fontSize: 14),),),
          ],),):
          Container(),
          SizedBox(height: 10,),
          Container(
            height:1 ,width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          ),
          SizedBox(height: 10,),
          InkWell(onTap: (){
            setState(() {
              isClick = !isClick;

            });
          },
            child: Row(
              children: [
                isClick? Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 30,
                ):
                Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                  size: 30,
                ),
                Text(
                  "Shared Memories (0) ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),),
          SizedBox(height: 10,),
          Container(
            height:1 ,width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          ),
          SizedBox(height: 10,),
          InkWell(onTap: (){
            setState(() {
              isCheck = !isCheck;

            });
          },
            child: Row(
              children: [
                isCheck? Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 30,
                ):
                Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                  size: 30,
                ),
                Text(
                  "My Published (0) ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),),
          SizedBox(height: 10,),
          Container(
            height:1 ,width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          ),
          SizedBox(height: 10,),


        ],
      ),)),

        floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
            //  Navigator.push(context,
                //  MaterialPageRoute(builder: (context) => Sign_In()));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 25,
            ),
            backgroundColor: Colors.deepPurpleAccent,
          ),
        )),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}