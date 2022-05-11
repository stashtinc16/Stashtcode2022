import 'package:flutter/material.dart';


class Bottom_bar extends StatefulWidget {
  @override
  State<Bottom_bar> createState() {
    return _Bottom_bar();
  }
}

class _Bottom_bar extends State<Bottom_bar> {
  int tabClick = 0;
  bool isSelected=true;
  bool a = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabClick == 0
          ? Container()
          : tabClick == 1
          ? Container()
          : tabClick == 2
          ? Container()
          : tabClick == 3
          ?Container ()
          : Container(),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(85, 85, 85, 0.2),
              blurRadius: 100,
              spreadRadius: 1)
        ]),
        child: BottomNavigationBar(
            elevation: 40,
            currentIndex: tabClick,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color.fromRGBO(2, 152, 216, 1),
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            onTap: (value) async{
              if(value==1){

              }
              setState(() {
                isSelected=!isSelected;
              });
              if (value == 0) {
                tabClick = value;
              } else if (value == 1) {
                tabClick = value;
              }

              else {
                tabClick = value;
              }

              setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                label: 'Schedule',
                activeIcon: Image.asset(
                  'assets/images/Group 57.png',
                  height: 21,
                  width: 21,
                ),
                icon: Image.asset(
                  'assets/images/calendar.png',
                  height: 21,
                  width: 21,
                ),
              ),
              BottomNavigationBarItem(
                label: 'Discover',
                activeIcon: Image.asset(
                  'assets/images/discove2.png',
                  height: 21,
                  width: 21,
                ),
                icon: Image.asset(
                  'assets/images/discoverrr.png',
                  height: 21,
                  width: 21,
                ),),
              BottomNavigationBarItem(
                  label: 'Tournaments',
                  activeIcon: Image.asset(
                    'assets/images/SubtractT.png',
                    height: 21,
                    width: 21,
                  ),
                  icon: Image.asset(
                    'assets/images/trophy.png',
                    height: 21,
                    width: 21,
                  )),
              BottomNavigationBarItem(
                label: 'Chat',
                activeIcon: Image.asset(
                  'assets/images/VectorC.png',
                  height: 21,
                  width: 21,
                ),
                icon: Image.asset(
                  'assets/images/chat.png',
                  height: 21,
                  width: 21,
                ),
              ),

              BottomNavigationBarItem(
                  label: 'Setting',
                  activeIcon: Image.asset(
                    'assets/images/setting1.png',
                    height: 21,
                    width: 21,
                  ),
                  icon: Image.asset(
                    'assets/images/settings.png',
                    height: 21,
                    width: 21,
                  )),
            ]),
      ),
    );
  }
}