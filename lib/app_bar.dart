import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


PreferredSizeWidget commonAppbar(BuildContext context,String title,{required Function(bool isMemory,bool isPhotos,bool
isNotification, bool isSettings) pageSelected}){
  return AppBar(
    backgroundColor: Colors.white,
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            width: 19,
          ),
          InkWell(onTap: (){
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Memories()),(kj)=>false);
            pageSelected(true,false,false,false);
          },
            child: const Icon(
              Icons.folder_open_outlined,
              size: 24,
              color: Color.fromRGBO(108, 96, 255, 1),

            ),),
          const SizedBox(
            width: 15,
          ),InkWell(onTap: (){
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const All_Photos()),(kj)=>false);
            pageSelected(false,true,false,false);
          },
            child:
            SvgPicture.asset(
              "assets/images/todayapp.svg",
              height: 22,
              width: 21,
              color: const Color.fromRGBO(108, 96, 255, 1),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            height: 30,
            width: 160,
            alignment: Alignment.center,
            child: Text(
              title,
              style:const TextStyle(
                  color: Color.fromRGBO(108, 96, 255, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),),
          const SizedBox(
            width: 15,
          ),
          Stack(children: [
            InkWell(
              onTap: () {
                pageSelected(false,false,true,false);
                // Navigator.pushAndRemoveUntil(context,
                //     MaterialPageRoute(builder: (context) => Notifications()),(kj)=>false);
              },
              child: SvgPicture.asset(
                "assets/images/bell.svg",
                height: 22,
                width: 21,
                color: const Color.fromRGBO(108, 96, 255, 1),
              ),
            ),],),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              pageSelected(false,false,false,true);
              // Navigator.pushAndRemoveUntil(context,
              //     MaterialPageRoute(builder: (context) => Profile()),(kj)=>false);
            },
            child: CircleAvatar(
              radius: 18,
              child:  ClipRRect(
                child: Image.asset("assets/images/photo.jpeg",fit: BoxFit.cover,height: MediaQuery.of(context).size.height
                  ,width: MediaQuery.of(context).size.width,),
                borderRadius: BorderRadius.circular(50.0),
              ),

            ),
          ),
          const SizedBox(
            width: 19,
          ),
        ],
      )
    ],
  );
}