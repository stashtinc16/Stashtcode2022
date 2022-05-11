import 'package:flutter/material.dart';
import 'package:stasht/notifications.dart';

import 'all_photos.dart';
import 'memories.dart';
import 'profile.dart';

PreferredSizeWidget commonAppbar(BuildContext context,String title){
  return AppBar(
    backgroundColor: Colors.white,
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 19,
          ),
          InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Memories()));
          },
            child: Icon(
            Icons.folder_outlined,
            color: Colors.deepPurpleAccent,
          ),),
          const SizedBox(
            width: 15,
          ),InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> All_Photos()));
          },
            child:
          const Icon(
            Icons.content_copy_outlined,
            color: Colors.deepPurpleAccent,
          ),),
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
                color: Colors.deepPurpleAccent,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Notifications()));
            },
            child:const Icon(
              Icons.notifications,
              color: Colors.deepPurpleAccent,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile()));
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                  color: Colors.grey, shape: BoxShape.circle),
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
