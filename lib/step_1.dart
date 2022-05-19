import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/step_2.dart';
import 'package:stasht/utils/assets_images.dart';

import 'memories_empty.dart';

class Step1 extends GetView<MemoriesController> {
  int val = -1;
  bool isEmail = false;

  var passwordcontroller = TextEditingController();
  var namecontroller = TextEditingController();

  Step1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
                child: Column(children: [
                  const Center(
                    child: Text(
                      "stasht.",
                      style: TextStyle(
                          fontSize: 53,
                          color: Color.fromRGBO(108, 96, 255, 1),
                          fontWeight: FontWeight.w800,
                          fontFamily: "gibsonbold"),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Center(
                      child: Text(
                    "Memory folder name",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: robotoMedium),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Ex: Wedding Photos",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(76, 73, 73, 0.6),
                            fontSize: 24,
                            fontFamily: gibsonSemiBold),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(bottom: 10, left: 20, top: 5)),
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        controller.showNext.value = true;
                      } else {
                        controller.showNext.value = false;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => Visibility(
                      maintainAnimation: true,
                      maintainSize: false,
                      maintainState: true,
                      visible: controller.showNext.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  Step_2()));
                            },
                            child: const Center(
                              child: Text(
                                "Cancel",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromRGBO(108, 96, 255, 1),
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.memoriesStep2);


                            },
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(108, 96, 255, 1),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Next",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 16,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]))));
  }
}
