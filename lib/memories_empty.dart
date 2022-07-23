// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:stasht/all_photos.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/notifications/presentation/notifications.dart';
import 'package:stasht/profile/presentation/profile.dart';
import 'package:stasht/login_signup/domain/sign_up.dart';

class Memories_Empty extends StatefulWidget {
  const Memories_Empty({Key? key}) : super(key: key);

  @override
  State<Memories_Empty> createState() {
    return _Memories_Empty();
  }
}

class _Memories_Empty extends State<Memories_Empty> {
  List Items = [
    "",
  ];

  bool isMemory = true;
  bool isPhotos = false;
  bool isNotification = false;
  bool isSetting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
        context,
        isMemory
            ? "Memories"
            : isPhotos
                ? "All Photos"
                : isNotification
                    ? "Notifications"
                    : "Settings",
        pageSelected: (bool isMemory, bool isPhotos, bool isNotification,
            bool isSettings) {
          setState(() {
            this.isMemory = isMemory;
            this.isPhotos = isPhotos;
            this.isNotification = isNotification;
             isSetting = isSettings;
          });
        },
      ),
      body: isMemory
          ? SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/memoryempty.png",
                      height: 230,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "You haven't created a memory yet!",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create your first memory!",
                      style: TextStyle(
                          color: Color.fromRGBO(108, 96, 255, 1),
                          fontSize: 15,
                          decoration: TextDecoration.underline),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text(
                          "My Memories (0) ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromRGBO(0, 0, 0, 0.16),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text(
                          "Public Memories (0) ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromRGBO(0, 0, 0, 0.16),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.arrow_right,
                          color: Colors.black,
                          size: 30,
                        ),
                        Text(
                          "My Published (0) ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color.fromRGBO(0, 0, 0, 0.16),
                      height: 1,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ))
          : isPhotos
              ? const All_Photos()
              : isNotification
                  ? Notifications()
                  : Profile(),
      floatingActionButton: isMemory
          ? SizedBox(
              height: 79,
              width: 79,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                  backgroundColor: const Color.fromRGBO(108, 96, 255, 1),
                ),
              ))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
