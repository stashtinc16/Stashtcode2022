import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:stasht/utils/constants.dart';

class Memories extends GetView<MemoriesController> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return GetBuilder(
        builder: (MemoriesController controller) => SafeArea(
              child: Container(
                color: Colors.white,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: commonAppbar(
                    context,
                    memoriesTitle,
                    pageSelected:
                        (isMemory, isPhotos, isNotification, isSettings) => {
                      print('isSettings $isSettings'),
                      if (isSettings) {Get.toNamed(AppRoutes.profile)}
                    },
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Obx(
                          () => Visibility(
                            maintainAnimation: true,
                            maintainSize: false,
                            maintainState: true,
                            visible: controller.memoriesList.isEmpty,
                            child: Column(
                              children: [
                                Image.asset(
                                  noMemoriesPlaceholder,
                                  height: 230,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text("You haven't created a memory yet!",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                const SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.createMemoriesStep1();
                                  },
                                  child: const Text("Create your first memory!",
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 15,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.memoriesList.isNotEmpty) {
                              controller.myMemoriesExpand.value =
                                  !controller.myMemoriesExpand.value;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Obx(
                                  () => Icon(
                                    controller.myMemoriesExpand.value
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_right,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                                Obx(
                                  () => Text(
                                    "My Memories (${controller.memoriesList.length}) ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(() => Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: controller.myMemoriesExpand.value
                                ? ListView.builder(
                                    itemCount: controller.memoriesList.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.memoryList,
                                                arguments: {
                                                  'mainIndex': index,
                                                  'list': controller
                                                      .memoriesList[index]
                                                });
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 20),
                                            child: Stack(
                                              children: [
                                                Card(
                                                  elevation: 1,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          15))),
                                                  child: Container(
                                                    height: 100,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                            controller
                                                                    .memoriesList
                                                                    .isNotEmpty
                                                                ? controller
                                                                    .memoriesList[
                                                                        index]
                                                                    .imagesCaption[
                                                                        0]
                                                                    .image
                                                                : "",
                                                          ),
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 100,
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.shadowColor
                                                        .withOpacity(0.27),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        height: 45,
                                                        width: 45,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 15),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.grey,
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white,
                                                                width: 1)),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          child: controller
                                                                          .memoriesList[
                                                                              index]
                                                                          .userModel !=
                                                                      null &&
                                                                  controller
                                                                      .memoriesList[
                                                                          index]
                                                                      .userModel!
                                                                      .profileImage!
                                                                      .isNotEmpty
                                                              ? CachedNetworkImage(
                                                                  imageUrl: controller
                                                                      .memoriesList[
                                                                          index]
                                                                      .userModel!
                                                                      .profileImage!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: 45,
                                                                  width: 45,
                                                                )
                                                              : Image.asset(
                                                                  userIcon,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              controller
                                                                      .memoriesList
                                                                      .isNotEmpty
                                                                  ? controller
                                                                      .memoriesList[
                                                                          index]
                                                                      .title!
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              controller.memoriesList[index]
                                                                          .userModel !=
                                                                      null
                                                                  ? "Author : ${controller.memoriesList[index].userModel!.userName!}"
                                                                  : "",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10),
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Text(
                                                          controller
                                                                  .memoriesList
                                                                  .isNotEmpty
                                                              ? "${controller.memoriesList[index].imagesCaption!.length}"
                                                              : "0",
                                                          style: const TextStyle(
                                                              color: AppColors
                                                                  .primaryColor,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ));
                                    },
                                  )
                                : Container())),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.bgColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            controller.sharedMemoriesExpand.value =
                                !controller.sharedMemoriesExpand.value;
                            if (controller.sharedMemoriesExpand.value) {
                              controller.getSharedMemories();
                            }
                            controller.update();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Obx(
                                  () => Icon(
                                    controller.sharedMemoriesExpand.value
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_right,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  "Shared Memories (${controller.sharedMemoriesList.length}) ",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                        sharedMemoryUI(),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.bgColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            // showInviteRepondDialog(context);
                            // isCheck = !isCheck;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width,
                          color: AppColors.bgColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  floatingActionButton: SizedBox(
                      height: 70,
                      width: 70,
                      child: FittedBox(
                        child: FloatingActionButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.memoriesStep1,
                                arguments: "no");
                          },
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 25,
                          ),
                          backgroundColor: Colors.deepPurpleAccent,
                          elevation: 0,
                        ),
                      )),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                ),
              ),
            ));
  }

  sharedMemoryUI() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: controller.sharedMemoriesExpand.value
            ? ListView.builder(
                itemCount: controller.sharedMemoriesList.length,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  // List<SharedWith> shareList = List.empty(growable: true);
                  // shareList
                  //     .addAll(controller.sharedMemoriesList[index].sharedWith);
                  int shareIndex = 0;
                  int isJoined = 0;

                  if (controller.sharedMemoriesList[index].sharedWith.length >
                      0) {
                    var shareObject =
                        controller.sharedMemoriesList[index].sharedWith.where(
                      (element) {
                        shareIndex = controller
                            .sharedMemoriesList[index].sharedWith
                            .indexOf(element);
                        print(
                            'IndexOfElement ${controller.sharedMemoriesList[index].sharedWith.indexOf(element)}');
                        return element.userId == userId;
                      },
                    );
                    isJoined = shareObject.first.status;
                    print(
                        'isjoined ${controller.sharedMemoriesList[index].sharedWith.indexOf(shareObject)} => ${shareObject.first.status}');
                  }

                  return InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.memoryList, arguments: {
                          'mainIndex': index,
                          'list': controller.sharedMemoriesList[index]
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            height: 100,
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      controller.sharedMemoriesList.isNotEmpty
                                          ? controller.sharedMemoriesList[index]
                                              .imagesCaption[0].image
                                          : "",
                                    ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: isJoined == 0
                                  ? AppColors.primaryColor.withOpacity(0.62)
                                  : AppColors.shadowColor,
                            ),
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  height: 45,
                                  width: 45,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 1)),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: controller.memoriesList[index]
                                                    .userModel !=
                                                null &&
                                            controller
                                                .memoriesList[index]
                                                .userModel!
                                                .profileImage!
                                                .isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: controller
                                                .memoriesList[index]
                                                .userModel!
                                                .profileImage!,
                                            fit: BoxFit.cover,
                                            height: 45,
                                            width: 45,
                                          )
                                        : Image.asset(
                                            userIcon,
                                            fit: BoxFit.fill,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Author: ${controller.sharedMemoriesList[index].userModel.userName}",
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                      Text(
                                        controller
                                            .sharedMemoriesList[index].title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontFamily: gibsonSemiBold,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: isJoined == 0
                                      ? InkWell(
                                          onTap: () {
                                            // showInviteRepondDialog(context);
                                            controller.updateJoinStatus(
                                                controller
                                                    .sharedMemoriesList[index]
                                                    .memoryId,
                                                1,
                                                index,
                                                shareIndex);
                                            controller.update();
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                color: Colors.white),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13.0,
                                                vertical: 7.0),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 13.0),
                                            child: const Text(
                                              'Join',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.primaryColor,
                                                  fontFamily: robotoBold),
                                            ),
                                          ),
                                        )
                                      : SvgPicture.asset(
                                          checkBox,
                                          width: 45,
                                        ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          )
                        ],
                      ));
                },
              )
            : Container());
  }

  showInviteRepondDialog(BuildContext context) {
    Get.defaultDialog(
        title: '',
        radius: 9,
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    const Text(
                      'Join a shared memory',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: robotoMedium,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Positioned(
                      right: 40,
                      top: 10,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 25,
                            color: AppColors.darkColor,
                          )),
                    )
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.hintTextColor,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.primaryColor, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: const Text(
                          'Accept',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: robotoBold,
                              color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.redBorder, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: const Text(
                          'Deny',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: robotoBold,
                              color: AppColors.redBorder),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
