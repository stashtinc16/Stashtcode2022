// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/profile.dart';
import 'package:stasht/sign_in.dart';

import 'notifications.dart';

class Memories_Empty extends StatefulWidget {
  const Memories_Empty({Key? key}) : super(key: key);

  @override
  State<Memories_Empty> createState() {
    return _Memories_Empty();
  }
}

class _Memories_Empty extends State<Memories_Empty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context,"Memories"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              //   Image.asset(""),
              const SizedBox(
                height: 150,
              ),
              const Text(
                "You haven't created a memory yet!",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Create your first memory!",
                style: TextStyle(
                    color: Colors.deepPurpleAccent,
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(170, 164, 164, 1.0),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(170, 164, 164, 1.0),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: const Color.fromRGBO(170, 164, 164, 1.0),
                height: 1,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
          height: 70,
          width: 70,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Sign_In()));
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
