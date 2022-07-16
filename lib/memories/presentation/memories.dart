import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // Future.delayed(Duration.zero, () {
    print('FutureDelay $fromShare');

    return GetBuilder(
        builder: (MemoriesController controller) => Container(
              color: Colors.white,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                appBar: commonAppbar(
                  context,
                  memoriesTitle,
                  pageSelected:
                      (isMemory, isPhotos, isNotification, isSettings) => {
                    print('isSettings $isSettings $userId'),
                    if (isSettings)
                      {Get.toNamed(AppRoutes.profile)}
                    else if (isNotification)
                      {
                        notificationCount.value = 0,
                        controller.updateNotificationCount(),
                        Get.toNamed(AppRoutes.notifications)
                      }
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
                          visible: !controller.noData.value,
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
                                        decoration: TextDecoration.underline)),
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
                              ? myMemoriesUI(controller.memoriesList, "My")
                              : Container())),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.bgColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.sharedMemoriesList.isNotEmpty) {
                            controller.sharedMemoriesExpand.value =
                                !controller.sharedMemoriesExpand.value;
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

                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: controller.sharedMemoriesExpand.value
                              ? ListView.builder(
                                  itemCount:
                                      controller.sharedMemoriesList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int shareIndex = 0;
                                    int isJoined = 0;

                                    if (controller.sharedMemoriesList[index]
                                            .sharedWith.length >
                                        0) {
                                      var shareObject = controller
                                          .sharedMemoriesList[index].sharedWith
                                          .where(
                                        (element) {
                                          shareIndex = controller
                                              .sharedMemoriesList[index]
                                              .sharedWith
                                              .indexOf(element);
                                          return element.userId == userId;
                                        },
                                      );
                                      if (shareObject.length > 0) {
                                        isJoined = shareObject.first.status;
                                      }
                                    }

                                    return InkWell(
                                        onTap: () {
                                          if (isJoined == 1) {
                                            Get.toNamed(AppRoutes.memoryList,
                                                arguments: {
                                                  'mainIndex': index,
                                                  'list': controller
                                                          .sharedMemoriesList[
                                                      index],
                                                  'type': "2",
                                                  "memoryId": controller
                                                      .sharedMemoriesList[index]
                                                      .memoryId
                                                });
                                          }
                                        },
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 100,
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: controller
                                                      .sharedMemoriesList[index]
                                                      .imagesCaption
                                                      .isNotEmpty
                                                  ? BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                          image: CachedNetworkImageProvider(controller
                                                              .sharedMemoriesList[
                                                                  index]
                                                              .imagesCaption![controller
                                                                      .sharedMemoriesList[
                                                                          index]
                                                                      .imagesCaption
                                                                      .length -
                                                                  1]
                                                              .image),
                                                          fit: BoxFit.cover))
                                                  : null,
                                              color: controller
                                                      .sharedMemoriesList[index]
                                                      .imagesCaption!
                                                      .isNotEmpty
                                                  ? null
                                                  : Colors.grey,
                                            ),
                                            Container(
                                              height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: isJoined == 0
                                                    ? AppColors.primaryColor
                                                        .withOpacity(0.62)
                                                    : Colors.black
                                                        .withOpacity(0.22),
                                              ),
                                              margin: const EdgeInsets.only(
                                                  top: 20),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 45,
                                                    width: 45,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: Colors.white,
                                                            width: 1)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  30)),
                                                      child: controller
                                                                      .sharedMemoriesList[
                                                                          index]
                                                                      .userModel !=
                                                                  null &&
                                                              controller
                                                                  .sharedMemoriesList[
                                                                      index]
                                                                  .userModel!
                                                                  .profileImage!
                                                                  .isNotEmpty
                                                          ? CachedNetworkImage(
                                                              imageUrl: controller
                                                                  .sharedMemoriesList[
                                                                      index]
                                                                  .userModel!
                                                                  .profileImage!,
                                                              fit: BoxFit.cover,
                                                              height: 45,
                                                              width: 45,
                                                            )
                                                          : Image.asset(
                                                              userIcon,
                                                              fit: BoxFit.fill,
                                                              color:
                                                                  Colors.white,
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
                                                                      .sharedMemoriesList[
                                                                          index]
                                                                      .userModel !=
                                                                  null
                                                              ? controller
                                                                          .sharedMemoriesList[
                                                                              index]
                                                                          .sharedWithCount >
                                                                      0
                                                                  ? controller.sharedMemoriesList[index]
                                                                              .sharedWithCount >
                                                                          1
                                                                      ? "Author : ${controller.sharedMemoriesList[index].userModel!.displayName!} + ${controller.sharedMemoriesList[index].sharedWithCount} others"
                                                                      : "Author : ${controller.sharedMemoriesList[index].userModel!.displayName!} + ${controller.sharedMemoriesList[index].sharedWithCount} other"
                                                                  : "Author : ${controller.sharedMemoriesList[index].userModel!.displayName!}"
                                                              : "",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 11),
                                                        ),
                                                        Text(
                                                          controller
                                                              .sharedMemoriesList[
                                                                  index]
                                                              .title,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  gibsonSemiBold,
                                                              fontSize: 16),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                      child: isJoined == 0
                                                          ? InkWell(
                                                              onTap: () {
                                                                showInviteRepondDialog(
                                                                    context,
                                                                    controller
                                                                            .sharedMemoriesList[
                                                                        index],
                                                                    index);

                                                                controller
                                                                    .update();
                                                              },
                                                              child: Container(
                                                                decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10.0)),
                                                                    color: Colors
                                                                        .white),
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        13.0,
                                                                    vertical:
                                                                        7.0),
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        13.0),
                                                                child:
                                                                    const Text(
                                                                  'Join',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: AppColors
                                                                          .primaryColor,
                                                                      fontFamily:
                                                                          robotoBold),
                                                                ),
                                                              ),
                                                            )
                                                          : Container()
                                                      // : SvgPicture.asset(
                                                      //     checkBox,
                                                      //     width: 45,
                                                      //   ),
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
                              : Container()),
                      // sharedMemoryUI(),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.bgColor,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.publishMemoryList.isNotEmpty) {
                            controller.publishMemoriesExpand.value =
                                !controller.publishMemoriesExpand.value;
                          }
                          print(
                              'publishsss ${controller.publishMemoriesExpand.value}');
                          controller.update();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              controller.publishMemoriesExpand.value
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
                              Text(
                                "My Published (${controller.publishMemoryList.length}) ",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Obx(() => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: controller.publishMemoriesExpand.value
                              ? myMemoriesUI(
                                  controller.publishMemoryList, "Publish")
                              : Container())),
                      const SizedBox(
                        height: 30,
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
                          Get.toNamed(AppRoutes.memoriesStep1, arguments: "no");
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
            ));
  }

  showInviteRepondDialog(
      BuildContext context, MemoriesModel memoriesModel, int mainIndex) async {
    int shareIndex = 0;
    for (int i = 0; i < memoriesModel.sharedWith!.length; i++) {
      if (memoriesModel.sharedWith![i].userId == userId) {
        shareIndex = i;
      }
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: Colors.white),
            height: 220,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0, bottom: 7),
                          child: RichText(
                              text: TextSpan(
                                  text: memoriesModel.userModel!.displayName!,
                                  style: const TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontFamily: robotoBold),
                                  children: const [
                                TextSpan(
                                  text: " invited you to join a memory:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.darkColor,
                                      fontFamily: robotoRegular,
                                      fontStyle: FontStyle.italic),
                                ),
                              ])),
                        ),
                      ),
                      // Positioned(
                      //   top: 0,
                      //   bottom: 0,
                      //   right: 10,
                      //   child: IconButton(
                      //     onPressed: () {
                      //       fromShare = false;
                      //       Get.back();
                      //     },
                      //     icon: const Icon(
                      //       Icons.close,
                      //       color: AppColors.darkColor,
                      //       size: 20,
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                Text(
                  memoriesModel.title!,
                  style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.darkColor,
                      fontFamily: robotoBold),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                       
                        controller.expireSharedLink(memoriesModel, 1, mainIndex, shareIndex);
                        Get.back();
                        
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontFamily: robotoBold),
                          textAlign: TextAlign.center,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColors.hintTextColor),
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                       
                        controller.expireSharedLink(memoriesModel,2,mainIndex,shareIndex);
                       
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontFamily: robotoBold),
                          textAlign: TextAlign.center,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColors.hintTextColor),
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  moreIcon(context, memoriesModel) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        // popupmenu item 1
        PopupMenuItem(
          value: 1,
          // row has two child icon and text.
          child: Row(
            children: const [
              Icon(Icons.delete),
              SizedBox(
                // sized box with width 10
                width: 10,
              ),
              Text("Delete")
            ],
          ),
        ),
      ],
      offset: const Offset(0, 40),
      color: Colors.white,
      splashRadius: 5,
      elevation: 2,
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      onSelected: (value) {
        showDeleteBottomSheet(context, memoriesModel);
      },
    );
  }

  void showDeleteBottomSheet(
      BuildContext context, MemoriesModel memoriesModel) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
                color: Colors.white),
            height: 200,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Text(
                    'Are you sure you want to delete?',
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.darkColor,
                        fontFamily: robotoBold),
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        controller.deleteMemory(memoriesModel);

                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontFamily: robotoBold),
                          textAlign: TextAlign.center,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColors.hintTextColor),
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primaryColor,
                              fontFamily: robotoBold),
                          textAlign: TextAlign.center,
                        ),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: AppColors.hintTextColor),
                      ),
                    )),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  myMemoriesUI(RxList memoriesList, String folderType) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: memoriesList.length,
      shrinkWrap: true,
      primary: false,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.memoryList, arguments: {
                'mainIndex': index,
                'list': memoriesList[index],
                'type': "1",
                "memoryId": memoriesList[index].memoryId
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  Card(
                    elevation: 1,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: memoriesList[index].imagesCaption.isNotEmpty
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(
                                  memoriesList[index].imagesCaption.isNotEmpty
                                      ? memoriesList[index]
                                          .imagesCaption[memoriesList[index]
                                                  .imagesCaption
                                                  .length -
                                              1]
                                          .image
                                      : "",
                                ),
                                fit: BoxFit.cover)
                            : null,
                        color: memoriesList[index].imagesCaption.isNotEmpty
                            ? null
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    margin: const EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: AppColors.shadowColor.withOpacity(0.27),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  child: memoriesList[index].userModel !=
                                              null &&
                                          memoriesList[index]
                                              .userModel!
                                              .profileImage!
                                              .isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: memoriesList[index]
                                              .userModel!
                                              .profileImage!,
                                          fit: BoxFit.cover,
                                          height: 45,
                                          width: 45,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress))
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      memoriesList.isNotEmpty
                                          ? memoriesList[index].title!
                                          : "",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: gibsonSemiBold,
                                          fontSize: 16),
                                    ),
                                    Text(
                                      memoriesList[index].userModel != null
                                          ? memoriesList[index]
                                                      .sharedWithCount >
                                                  0
                                              ? memoriesList[index]
                                                          .sharedWithCount >
                                                      1
                                                  ? "Author : ${memoriesList[index].userModel!.displayName!} + ${memoriesList[index].sharedWithCount} others"
                                                  : "Author : ${memoriesList[index].userModel!.displayName!} + ${memoriesList[index].sharedWithCount} other"
                                              : "Author : ${memoriesList[index].userModel!.displayName!}"
                                          : "",
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 35,
                                width: 35,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(left: 5),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Text(
                                  memoriesList.isNotEmpty
                                      ? "${memoriesList[index].imagesCaption!.length}"
                                      : "0",
                                  style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                       
                       
                          Container(
                              alignment: Alignment.topRight,
                              margin: const EdgeInsets.only(right: 5, top: 5),
                              child: moreIcon(context, memoriesList[index]))
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
