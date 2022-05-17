import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/utils/app_colors.dart';
import '../../memory_lane.dart';

class Memories extends GetView<MemoriesController> {
  bool isTap = false;
  bool isClick = false;
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppbar(
          context,
          'Memories',
          pageSelected: (isMemory, isPhotos, isNotification, isSettings) => {},
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      isTap = !isTap;
                    },
                    child: Row(
                      children: [
                        isTap
                            ? const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                                size: 30,
                              )
                            : const Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                                size: 30,
                              ),
                        const Text(
                          "My Memories (1) ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  isTap
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Memory_Lane()));
                          },
                          child: Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      shape: BoxShape.circle),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Baniff Trip 2021",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "Author: Taniya & 10 others",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                                Container(
                                  height: 35,
                                  width: 35,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.greenAccent,
                                      shape: BoxShape.circle),
                                  child: const Text(
                                    "34",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      isClick = !isClick;
                    },
                    child: Row(
                      children: [
                        isClick
                            ? const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                                size: 30,
                              )
                            : const Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                                size: 30,
                              ),
                        const Text(
                          "Shared Memories (0) ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      isCheck = !isCheck;
                    },
                    child: Row(
                      children: [
                        isCheck
                            ? const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                                size: 30,
                              )
                            : const Icon(
                                Icons.arrow_right,
                                color: Colors.black,
                                size: 30,
                              ),
                        const Text(
                          "My Published (0) ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )),
        floatingActionButton: SizedBox(
            height: 70,
            width: 70,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  //  Navigator.push(context,
                  //  MaterialPageRoute(builder: (context) => Sign_In()));
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 25,
                ),
                backgroundColor: Colors.deepPurpleAccent,
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
