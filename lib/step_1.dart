import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
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
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
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
                        if (argument == "yes")
                          const Text(
                            "Step 1",
                            style: TextStyle(
                                fontSize: 21,
                                color: AppColors.primaryColor,
                                fontFamily: gibsonRegular),
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          argument == "yes"
                              ? "Create your first memory folder"
                              : "Memory folder name",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: robotoMedium),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => Focus(
                            autofocus: false,
                            child: TextFormField(
                              controller: controller.titleController,
        
                              decoration: InputDecoration(
                                  hintText: controller.hasFocus.value
                                      ? ""
                                      : "E.g. Wedding Photos",
                                  hintStyle: const TextStyle(
                                      color: AppColors.hintTextColor,
                                      fontSize: 34,
                                      fontFamily: robotoBold),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
                                  contentPadding:
                                      const EdgeInsets.only(bottom: 10, top: 5)),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 34,
                                  fontFamily: robotoBold),
                              // readOnly: true,
                              textAlign: TextAlign.center,
                              onChanged: (text) {
                                if (text.isNotEmpty) {
                                  controller.showNext.value = true;
                                } else {
                                  controller.showNext.value = false;
                                }
                              },
                            ),
                            onFocusChange: (hasFocus) {
                              controller.hasFocus.value = hasFocus;
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
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.0, vertical: 8),
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
                              InkWell(
                                onTap: () {
                                  // controller.promptPermissionSetting();
                                  // controller.update();
                                  // Get.toNamed(AppRoutes.memoriesStep2, arguments: {
                                  //   "title": controller.titleController.value.text,
                                  //   "fromSignup": argument
                                  // });
                                  controller.pickImages();
                                },
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 11),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryColor,
                                        borderRadius: BorderRadius.circular(18)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Next",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: gibsonSemiBold),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 10,
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
                    if (argument == "yes")
                      InkWell(
                        onTap: () {
                          Get.offNamed(AppRoutes.memories);
                        },
                        child: const Padding(
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
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )),
          ),
        ));
  }
}
