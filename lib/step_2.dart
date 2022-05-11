import 'package:flutter/material.dart';

import 'memories.dart';

class Step_2 extends StatefulWidget{
  @override
  State<Step_2> createState() {
    return _Step_2();
  }

}

class _Step_2 extends State<Step_2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child:
      Padding(padding: EdgeInsets.zero,
        child: Center(
          child: Column(
        children: [
          Text("stasht.",
              style: TextStyle(fontSize:70,color: Colors.deepPurple, fontWeight: FontWeight.w900,
                  fontFamily: "adobe-clean-cufonfonts",),),
          Text("Step 2",
              style: TextStyle(fontSize:25,color: Colors.deepPurple,
                  fontFamily: "adobe-clean-cufonfonts",),),
          SizedBox(height: 5,),
          Text("Choose photos to add to your memory folder ",
              style: TextStyle(fontSize:15,color: Colors.black,
                  fontFamily: "adobe-clean-cufonfonts",),),

          SizedBox(height: 15,),
          Container(width: MediaQuery.of(context).size.width,
            height: 530,
            child: GridView.builder(
            itemCount:30,
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
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: [
                     Text("hi")
                    ],
                  ),
                ),
              );
            },
          ),),
          Padding(padding: EdgeInsets.only(top: 12,right: 10),child:
              InkWell(onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context)=> Memories()));
              },
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Done",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w400),),
              SizedBox(width: 5,),
              Icon(Icons.arrow_forward_ios_outlined,color: Colors.black,)
            ],
          )))



        ],
      ),)),)
    );
  }
}