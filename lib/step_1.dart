import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class Step1 extends GetView<MemoriesController> {
  int val = -1;
  bool isEmail = false;

  Step1({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var argument = Get.arguments;
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
            child: Column(
              children: [
                Expanded(
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
                    const Center(
                        child: Text(
                      "Step 1",
                      style: TextStyle(
                          fontSize: 21,
                          color: AppColors.primaryColor,
                          fontFamily: gibsonRegular),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                        child: Text(
                      "Create your first memory folder",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: robotoMedium),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextFormField(
                        controller: controller.titleController,
                        decoration: const InputDecoration(
                            hintText: "Ex: Wedding Photos",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(76, 73, 73, 0.6),
                                fontSize: 24,
                                fontFamily: gibsonSemiBold),
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(bottom: 10, top: 5)),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 34,
                            fontFamily: robotoBold),
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            controller.showNext.value = true;
                          } else {
                            controller.showNext.value = false;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
                ),
                Obx(
                  () => Visibility(
                    maintainAnimation: true,
                    maintainSize: false,
                    maintainState: true,
                    visible: controller.showNext.value,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Cancel",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontFamily: gibsonRegular),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.memoriesStep2, arguments: {
                                "title": controller.titleController.value.text
                              });
                            },
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
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
                ),
               if(argument=="yes") InkWell(
                  onTap: () {
                    Get.offNamed(AppRoutes.memories);
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Skip this step",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(108, 96, 255, 1),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
