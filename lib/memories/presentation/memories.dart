import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class Memories extends GetView<MemoriesController> {
  bool isCheck = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppbar(
          context,
          'Memories',
          pageSelected: (isMemory, isPhotos, isNotification, isSettings) => {
            print('isSettings $isSettings'),
            if (isSettings) {Get.toNamed(AppRoutes.profile)}
          },
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
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
                          SvgPicture.asset(
                            noMemories,
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
                          InkWell(
                            onTap: () {
                              controller.createMemoriesStep1();
                            },
                            child: const Text(
                              "Create your first memory!",
                              style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            ),
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
                  Obx(() => Container(
                      child: controller.myMemoriesExpand.value
                          ? ListView.builder(
                              itemCount: controller.memoriesList.length,
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.memoryList,
                                          arguments: {
                                            'mainIndex': index,
                                          });
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => Memory_Lane()));
                                    },
                                    child: Container(
                                      height: 100,
                                      margin: const EdgeInsets.only(top: 20),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            controller.memoriesList.isNotEmpty
                                                ? controller.memoriesList[index]
                                                    .imagesCaption[0].image
                                                : "",
                                          ),
                                          fit: BoxFit.cover
                                          // NetworkImage(
                                          //   controller.memoriesList.isNotEmpty
                                          //       ? controller
                                          //           .memoriesList[index]
                                          //           .imagesCaption[0]
                                          //           .image
                                          //       : "",
                                          // ),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        // mainAxisAlignment:
                                        // MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle),
                                            child: Image.asset(
                                              userIcon,
                                              fit: BoxFit.fill,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  controller.memoriesList
                                                          .isNotEmpty
                                                      ? controller
                                                          .memoriesList[index]
                                                          .title!
                                                      : "",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  controller.memoriesList
                                                          .isNotEmpty
                                                      ? "Author : ${controller.userModel!.userName!}"
                                                      : "",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 35,
                                            width: 35,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: Text(
                                              controller.memoriesList.isNotEmpty
                                                  ? "${controller.memoriesList[index].imagesCaption!.length}"
                                                  : "0",
                                              style: const TextStyle(
                                                  color: AppColors.primaryColor,
                                                  fontSize: 14),
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
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      controller.sharedMemoriesExpand.value =
                          !controller.sharedMemoriesExpand.value;
                    },
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
                          "Shared Memories (0) ",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  sharedMemoryUI(),
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
                      // isCheck = !isCheck;
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
                  Get.toNamed(AppRoutes.memoriesStep1, arguments: "no");
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

  sharedMemoryUI() {
    return Obx(() => Container(
        child: controller.sharedMemoriesExpand.value
            ? ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.memoryList, arguments: {
                          'mainIndex': index,
                        });
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Memory_Lane()));
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
                                  // image: NetworkImage(
                                  //   controller.memoriesList.isNotEmpty
                                  //       ? controller.memoriesList[index]
                                  //           .imagesCaption[0].image
                                  //       : "",
                                  // ),
                                  image: AssetImage(pastaImage),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: index == 0
                                  ? AppColors.primaryColor.withOpacity(0.62)
                                  : Colors.transparent,
                            ),
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  height: 45,
                                  width: 45,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle),
                                  child: Image.asset(
                                    userIcon,
                                    fit: BoxFit.fill,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Author: Mandy Torrenson",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                      Text(
                                        "Our Food Spots",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: gibsonSemiBold,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  child: index == 0
                                      ? Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              color: Colors.white),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 13.0, vertical: 7.0),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 13.0),
                                          child: const Text(
                                            'Join',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.primaryColor,
                                                fontFamily: robotoBold),
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
            : Container()));
  }
}
