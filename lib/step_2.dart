// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class Step_2 extends GetView<MemoriesController> {
  List Items = [
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
    "assets/images/photo.jpeg",
    "assets/images/nature.webp",
    "assets/images/nature.webp",
  ];

  @override
  Widget build(BuildContext context) {
    print('Step2Page');

    var data = Get.arguments;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
          padding: EdgeInsets.zero,
          child: Obx(() {
            return Center(
              child: controller.permissionStatus.value ==
                      PermissionStatus.granted
                  ? Column(
                      children: [
                        SvgPicture.asset(
                          stashtLogo,
                          height: 41,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (data["fromSignup"] == "yes")
                          const Text(
                            "Step 2",
                            style: TextStyle(
                              fontSize: 21,
                              color: Color.fromRGBO(108, 96, 255, 1),
                              fontFamily: "gibsonsemibold",
                            ),
                          ),
                        if (data["fromSignup"] == "yes")
                          const SizedBox(
                            height: 8,
                          ),
                        if (data["fromSignup"] == "yes")
                          const Text(
                            "Choose photos to add to ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: robotoMedium,
                            ),
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        Obx(
                          () => Text(
                            "${data['title'].toString()} (${controller.selectedCount.value})",
                            style: const TextStyle(
                              fontSize: 19,
                              color: Colors.black,
                              fontFamily: robotoBold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(() => SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 1.5,
                              child: GridView.builder(
                                // controller: controller.controller,
                                itemCount: controller.mediaPages.value.length,
                                scrollDirection: Axis.vertical,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 1,
                                  mainAxisSpacing: 1,
                                  childAspectRatio: (1 / 1),
                                ),
                                itemBuilder: (
                                  context,
                                  index,
                                ) {
                                  print(
                                      'controller.mediaPages.length ${controller.mediaPages.length}');
                                  return Obx(() => GestureDetector(
                                      onTap: () {
                                        if (!controller.selectionList[index] &&
                                            controller.selectedCount.value ==
                                                10) {
                                          Get.snackbar('Max Limit',
                                              'You can add upto 10 images only');
                                        } else {
                                          controller.selectionList[index] =
                                              !controller.selectionList[index];
                                          controller.addIndex(index,
                                              controller.selectionList[index]);
                                          controller.getSelectedCount();
                                        }

                                        //Navigator.of(context).pushNamed(RouteName.GridViewCustom);
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            color: Colors.grey,
                                            child: Image(
                                                image: ResizeImage(
                                                    PhotoProvider(
                                                        mediumId: controller
                                                            .mediaPages
                                                            .value[index]
                                                            .id),
                                                    height: 150,
                                                    width: 150)),
                                          ),
                                          if (controller.selectionList[index])
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.32,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.32,
                                                color: controller
                                                        .selectionList[index]
                                                    ? AppColors.primaryColor
                                                        .withOpacity(0.62)
                                                    : Colors.transparent,
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 35,
                                                )),
                                        ],
                                      )));
                                },
                              ),
                            )),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.all(25),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.permissionStatus.value ==
                                    PermissionStatus.permanentlyDenied
                                ? 'Please grant Photos permission from settings to create memory'
                                : 'Please grant Photos permission to create memory',
                            style: const TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontFamily: gibsonSemiBold),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.permissionStatus.value !=
                                    PermissionStatus.permanentlyDenied) {
                                controller.promptPermissionSetting();
                              } else {
                                AppSettings.openAppSettings();
                              }
                            },
                            child: Container(
                              height: 42,
                              width: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(22)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Allow permission",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: gibsonSemiBold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
            );
          }),
        ))),
        bottomSheet: SizedBox(
          height:
              controller.permissionStatus == PermissionStatus.granted ? 50 : 1,
          child: Padding(
              padding: const EdgeInsets.only(top: 5, right: 10),
              child: InkWell(
                  onTap: () {
                    controller.uploadImagesToMemories(0);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black,
                        size: 20,
                      )
                    ],
                  ))),
        ));
  }
}
