import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:stasht/utils/constants.dart';

class Memory_Lane extends GetView<MemoriesController> {
  // int? mainIndex;
  MemoriesModel? memoriesModel;
  // String? type;
  String? memoryId;
  bool closeTopContainer = false;
  double topContainer = 0;

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      memoryId = Get.arguments['memoryId'];
    } else {}
    return GetBuilder(
      initState: (state) {
        print('InitState');
        controller.getMyMemoryData(memoryId);
      },
      builder: (MemoriesController controller) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

        return Container(
          color: Colors.white,
          child: WillPopScope(
            onWillPop: Platform.isAndroid
                ? () async => controller.allowBackPress.value
                : null,
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: controller.hasMemory.value == 2
                    ? SizedBox(
                        height: 70,
                        width: 70,
                        child: FloatingActionButton(
                          onPressed: () {
                            controller.pickImages(
                                controller.detailMemoryModel!.memoryId!,
                                context,
                                controller.detailMemoryModel!);
                          },
                          // child: SvgPicture.asset(addPhotos),
                          child: Image.asset(
                            "assets/images/photosIcon.png",
                          ),
                          // backgroundColor: AppColors.primaryColor
                        ),
                      )
                    : SizedBox(
                        height: 1,
                        width: 1,
                      ),
                body: controller.hasMemory.value == 0
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.blue))
                    : controller.hasMemory.value == 2
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  controller.detailMemoryModel == null
                                      ? Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.black))
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 170,
                                          padding:
                                              const EdgeInsets.only(top: 45),
                                          decoration: controller
                                                  .detailMemoryModel!
                                                  .imagesCaption!
                                                  .isNotEmpty
                                              ? BoxDecoration(
                                                  image: DecorationImage(
                                                      image: CachedNetworkImageProvider(controller
                                                          .detailMemoryModel!
                                                          .imagesCaption![controller
                                                                  .detailMemoryModel!
                                                                  .imagesCaption!
                                                                  .length -
                                                              1]
                                                          .image!),
                                                      fit: BoxFit.cover))
                                              : null,
                                          color: controller.detailMemoryModel!
                                                  .imagesCaption!.isNotEmpty
                                              ? null
                                              : Colors.grey,
                                        ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 170,
                                      padding: const EdgeInsets.only(top: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Stack(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        // onPressed: () => Get.back(),
                                                        onPressed: () {
                                                          if (Get.arguments !=
                                                                  null &&
                                                              Get.arguments[
                                                                  "fromNot"]) {
                                                            Get.offNamed(
                                                                AppRoutes
                                                                    .memories);
                                                            // Get.back();
                                                          } else {
                                                            Get.back();
                                                          }
                                                        },
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_back_ios_outlined,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (controller
                                                        .detailMemoryModel !=
                                                    null)
                                                  if (userId ==
                                                          controller
                                                              .detailMemoryModel!
                                                              .createdBy &&
                                                      !controller
                                                          .detailMemoryModel!
                                                          .published!)
                                                    InkWell(
                                                      onTap: () {
                                                        publishMemoryBottomSheet(
                                                            context);
                                                      },
                                                      child: Image.asset(
                                                        publishIcon,
                                                        color: Colors.white,
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                    ),
                                                const SizedBox(
                                                  width: 35,
                                                ),
                                                if (controller
                                                        .detailMemoryModel !=
                                                    null)
                                                  if (userId ==
                                                      controller
                                                          .detailMemoryModel!
                                                          .createdBy)
                                                    InkWell(
                                                      onTap: () {
                                                        Get.toNamed(
                                                            AppRoutes
                                                                .collaborators,
                                                            arguments: {
                                                              // 'mainIndex': mainIndex,
                                                              'imageIndex': 0,
                                                              'list': controller
                                                                  .detailMemoryModel!,
                                                              // 'type': type
                                                            });

                                                        controller
                                                            .createLinkForDetail(
                                                          controller
                                                              .detailMemoryModel!,
                                                        );
                                                      },
                                                      child: const Icon(
                                                        Icons
                                                            .person_add_alt_1_outlined,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                    ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                              ],
                                            ),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    top: 5),
                                                alignment: Alignment.center,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    if (controller
                                                            .detailMemoryModel !=
                                                        null)
                                                      controller
                                                                  .detailMemoryModel!
                                                                  .sharedWith!
                                                                  .length >
                                                              0
                                                          ? getCollaboratorsImage(
                                                              context, controller)
                                                          : controller
                                                                  .detailMemoryModel!
                                                                  .userModel!
                                                                  .profileImage!
                                                                  .contains(
                                                                      "http")
                                                              ? CachedNetworkImage(
                                                                  imageUrl: controller
                                                                      .detailMemoryModel!
                                                                      .userModel!
                                                                      .profileImage!,
                                                                  imageBuilder:
                                                                      (context,
                                                                              imageProvider) =>
                                                                          Container(
                                                                    width: 60,
                                                                    height: 60,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              Colors.white),
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            imageProvider,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                      //   boxShadow: [
                                                                      // const BoxShadow(
                                                                      //     color: Colors.white60,
                                                                      //     spreadRadius: 2,
                                                                      //     blurRadius: 2)]
                                                                    ),
                                                                  ),
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Container(
                                                                    width: 60,
                                                                    height: 60,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: const BoxDecoration(
                                                                        // shape: BoxShape
                                                                        //     .circle,
                                                                        image: DecorationImage(image: AssetImage(userIcon))),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Container(
                                                                    width: 60,
                                                                    height: 60,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .error,
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: 60,
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          width:
                                                                              0.5,
                                                                          color: Colors
                                                                              .grey),
                                                                      image: const DecorationImage(
                                                                          image:
                                                                              AssetImage(userIcon)),
                                                                      boxShadow: const [
                                                                        // BoxShadow(
                                                                        //     color: Colors
                                                                        //         .white60,
                                                                        //     spreadRadius:
                                                                        //         2,
                                                                        //     blurRadius:
                                                                        //         2)
                                                                      ])),
                                                    if (controller
                                                            .detailMemoryModel !=
                                                        null)
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 5,
                                                          ),
                                                          child: Text(
                                                            "${controller.detailMemoryModel!.title!} (${controller.detailMemoryModel!.imagesCaption!.length})",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                                fontSize: 18),
                                                          ))
                                                  ],
                                                )),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              if (controller.detailMemoryModel != null)
                                if ((userId ==
                                        controller
                                            .detailMemoryModel!.createdBy) &&
                                    controller.detailMemoryModel!.published!)
                                  InkWell(
                                    onTap: () {
                                      print("copy link");
                                      controller.sharePublishMemory(
                                          controller.detailMemoryModel!.title!,
                                          controller
                                              .detailMemoryModel!.publishLink!);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      color: AppColors.collaboratorBgColor,
                                      child: Row(children: [
                                        InkWell(
                                          onTap: () {
                                            // print("copy link1");
                                            // controller.copyPublishLink(
                                            //     controller.detailMemoryModel!.title!,
                                            //     controller
                                            //         .detailMemoryModel!.publishLink!);
                                          },
                                          child: Image.asset(
                                            copyIcon,
                                            width: 20,
                                            height: 20,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            'Publish link: ${controller.detailMemoryModel!.publishLink}',
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                              if (controller.detailMemoryModel != null)
                                Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: controller.detailMemoryModel!
                                        .imagesCaption!.length,
                                    reverse: false,
                                    controller: controller.scrollController,
                                    itemBuilder: (context, index) {
                                      // if (type == "1") {
                                      //   memoriesModel = controller.memoriesList[mainIndex!];
                                      // } else {
                                      //   memoriesModel =
                                      //       controller.sharedMemoriesList[mainIndex!];
                                      // }
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                bottom: 8.0,
                                                top: 5),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 45,
                                                      width: 45,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 2)),
                                                      child: controller
                                                                  .detailMemoryModel!
                                                                  .imagesCaption![
                                                                      index]
                                                                  .userModel !=
                                                              null
                                                          ? controller
                                                                  .detailMemoryModel!
                                                                  .imagesCaption![
                                                                      index]
                                                                  .userModel!
                                                                  .profileImage!
                                                                  .isNotEmpty
                                                              ? ClipRRect(
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          30)),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    width: 45,
                                                                    height: 45,
                                                                    imageUrl: controller
                                                                        .detailMemoryModel!
                                                                        .imagesCaption![
                                                                            index]
                                                                        .userModel!
                                                                        .profileImage!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder:
                                                                        (context,
                                                                            url) {
                                                                      return Image
                                                                          .asset(
                                                                              userIcon);
                                                                    },
                                                                    errorWidget:
                                                                        (context,
                                                                            url,
                                                                            error) {
                                                                      return Image
                                                                          .asset(
                                                                              userIcon);
                                                                    },
                                                                  ),
                                                                )
                                                              : Image.asset(
                                                                  userIcon,
                                                                  width: 45,
                                                                  height: 45,
                                                                )
                                                          : Text(
                                                              controller
                                                                          .detailMemoryModel!
                                                                          .imagesCaption![
                                                                              index]
                                                                          .userModel !=
                                                                      null
                                                                  ? controller
                                                                      .detailMemoryModel!
                                                                      .imagesCaption![
                                                                          index]
                                                                      .userModel!
                                                                      .displayName!
                                                                      .toString()
                                                                      .substring(
                                                                          0, 1)
                                                                      .toUpperCase()
                                                                  : "",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontSize: 22,
                                                                  color: Colors
                                                                      .white,
                                                                  fontFamily:
                                                                      gibsonSemiBold),
                                                            ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            controller
                                                                        .detailMemoryModel!
                                                                        .imagesCaption![
                                                                            index]
                                                                        .userModel !=
                                                                    null
                                                                ? controller
                                                                    .detailMemoryModel!
                                                                    .imagesCaption![
                                                                        index]
                                                                    .userModel!
                                                                    .displayName!
                                                                : "",
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    robotoBold
                                                                // fontFamily: gibsonRegularItalic
                                                                ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: '',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          11),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: controller.detailMemoryModel!.imagesCaption![index] !=
                                                                            null
                                                                        ? DateFormat("MMM dd/yy hh:mm a")
                                                                            .format(controller.detailMemoryModel!.imagesCaption![index].createdAt!.toDate())
                                                                            .toString()
                                                                        : "",
                                                                    style: TextStyle(
                                                                        color: AppColors.primaryColor.withOpacity(0.67),
                                                                        // color: Colors.black,
                                                                        fontSize: 12,
                                                                        fontFamily: robotoItalic)),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              if (controller
                                                                  .detailMemoryModel!
                                                                  .imagesCaption!
                                                                  .isNotEmpty) {
                                                                Get.toNamed(
                                                                    AppRoutes
                                                                        .comments,
                                                                    arguments: {
                                                                      "memoryId": controller
                                                                          .detailMemoryModel!
                                                                          .memoryId!,
                                                                      "memoryImage": controller
                                                                          .detailMemoryModel!
                                                                          .imagesCaption![
                                                                              index]
                                                                          .image,
                                                                      "imageId": controller
                                                                          .detailMemoryModel!
                                                                          .imagesCaption![
                                                                              index]
                                                                          .imageId,
                                                                      'list': controller
                                                                          .detailMemoryModel,
                                                                      'imageIndex':
                                                                          index,
                                                                      "fromNot":
                                                                          false
                                                                    });
                                                              }
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  controller
                                                                      .detailMemoryModel!
                                                                      .imagesCaption![
                                                                          index]
                                                                      .commentCount
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const SizedBox(
                                                                  width: 3,
                                                                ),
                                                                Image.asset(
                                                                  messageIcon,
                                                                  width: 12,
                                                                  height: 12,
                                                                ),
                                                                if (controller
                                                                        .detailMemoryModel!
                                                                        .createdBy ==
                                                                    userId)
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                Container(
                                                                  width: 30,
                                                                  child: moreButton(
                                                                      context,
                                                                      controller
                                                                          .detailMemoryModel!
                                                                          .memoryId!,
                                                                      index,
                                                                      controller,
                                                                      controller
                                                                          .detailMemoryModel!,
                                                                      controller
                                                                          .detailMemoryModel!
                                                                          .imagesCaption![index]),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // const SizedBox(
                                                    //   width: 4,
                                                    // ),
                                                    // if (controller.detailMemoryModel!
                                                    //         .createdBy ==
                                                    //     userId)
                                                    //   moreButton(
                                                    //       context,
                                                    //       controller.detailMemoryModel!
                                                    //           .memoryId!,
                                                    //       index,
                                                    //       controller,
                                                    //       controller.detailMemoryModel!,
                                                    //       controller.detailMemoryModel!
                                                    //           .imagesCaption![index]),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 400,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blueGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Stack(
                                                      children: [
                                                        SizedBox(
                                                          height: 400,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child:
                                                              CachedNetworkImage(
                                                                  progressIndicatorBuilder:
                                                                      (context,
                                                                              url,
                                                                              progress) =>
                                                                          Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              value: progress.progress,
                                                                            ),
                                                                          ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  imageUrl: controller
                                                                      .detailMemoryModel!
                                                                      .imagesCaption![
                                                                          index]
                                                                      .image!),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                if ((userId ==
                                                        controller
                                                            .detailMemoryModel!
                                                            .createdBy) ||
                                                    controller
                                                            .detailMemoryModel!
                                                            .imagesCaption![
                                                                index]
                                                            .caption!
                                                            .toString()
                                                            .isNotEmpty &&
                                                        userId !=
                                                            controller
                                                                .detailMemoryModel!
                                                                .createdBy)
                                                  InkWell(
                                                    onTap: () {
                                                      if (userId ==
                                                          controller
                                                              .detailMemoryModel!
                                                              .createdBy) {
                                                        Get.toNamed(
                                                            AppRoutes
                                                                .addCaption,
                                                            arguments: {
                                                              'imageIndex':
                                                                  index,
                                                              'list': controller
                                                                  .detailMemoryModel,
                                                            });
                                                      }
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 5),
                                                      child: Text(
                                                          controller
                                                                  .detailMemoryModel!
                                                                  .imagesCaption![
                                                                      index]
                                                                  .caption!
                                                                  .isEmpty
                                                              ? userId ==
                                                                      controller
                                                                          .detailMemoryModel!
                                                                          .createdBy
                                                                  ? 'Add caption to this post...'
                                                                  : ''
                                                              : controller
                                                                  .detailMemoryModel!
                                                                  .imagesCaption![
                                                                      index]
                                                                  .caption!,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              color: controller
                                                                      .detailMemoryModel!
                                                                      .imagesCaption![
                                                                          index]
                                                                      .caption!
                                                                      .isEmpty
                                                                  ? AppColors
                                                                      .textColor
                                                                  : AppColors
                                                                      .darkColor,
                                                              fontSize: 12,
                                                              fontStyle: controller
                                                                      .detailMemoryModel!
                                                                      .imagesCaption![
                                                                          index]
                                                                      .caption!
                                                                      .isEmpty
                                                                  ? FontStyle
                                                                      .italic
                                                                  : FontStyle
                                                                      .normal)),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            color: AppColors.bgColor,
                                            height: 3,
                                          ),
                                          const SizedBox(
                                            height: 11,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                            ],
                          )
                        : controller.hasMemory.value == 0
                            ? Container(
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              )
                            : SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 40, left: 15),
                                      child: IconButton(
                                          onPressed: () {
                                            controller.hasMemory.value = 0;
                                            Get.back();
                                          },
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                            size: 30,
                                          )),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: const Text(
                                            'This memory is no longer available'),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
          ),
        );
      },
    );
  }

  void publishMemoryBottomSheet(BuildContext context) {
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
            // height: 220,
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Text(
                          "Would you like to publish your memory",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontFamily: robotoBold),
                        )),
                  ),
                  Container(
                    height: 1,
                    color: AppColors.viewColor,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          controller.publishMemory(
                              controller.detailMemoryModel!.title!,
                              controller.detailMemoryModel!.memoryId!);
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: AppColors.hintTextColor),
                        ),
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  getCollaboratorsImage(BuildContext context, controller) {
    int listSize = 0;
    int evenListSize = 0;
    int oldListSize = 0;
    int restValue = 0;
    List<SharedWith>? leftWith = [];
    List<SharedWith>? rightWith = [];

    if (controller.detailMemoryModel!.sharedWith!.length > 6) {
      for (int i = 0; i < 6; i++) {
        if (i % 2 == 0) {
          leftWith.add(controller.detailMemoryModel!.sharedWith![i]);
        } else {
          rightWith.add(controller.detailMemoryModel!.sharedWith![i]);
        }
      }

      print("leftWith${leftWith.length}");
      print("rightWith${rightWith.length}");
    } else {
      for (int i = 0;
          i < controller.detailMemoryModel!.sharedWith!.length;
          i++) {
        if (i % 2 == 0) {
          leftWith.add(controller.detailMemoryModel!.sharedWith![i]);
        } else {
          rightWith.add(controller.detailMemoryModel!.sharedWith![i]);
        }
      }

      print("leftWith${leftWith.length}");
      print("rightWith${rightWith.length}");
    }
    print('listSize ${listSize}');
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            controller.detailMemoryModel!.userModel!.profileImage!
                    .contains("http")
                ? CachedNetworkImage(
                    imageUrl:
                        controller.detailMemoryModel!.userModel!.profileImage!,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.white),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white60,
                                spreadRadius: 1,
                                blurRadius: 1)
                          ]),
                    ),
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          // shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(userIcon))),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: Colors.black),
                      ),
                      child: const Icon(
                        Icons.error,
                        size: 30,
                      ),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(width: 0.5, color: Colors.grey),
                      image: const DecorationImage(image: AssetImage(userIcon)),
                    )),
            // i%2==0?
            Padding(
                padding: EdgeInsets.only(left: 60),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        for (int i = 0; i < leftWith.length; i++)
                          i == 0
                              ? leftWith[i]
                                      .sharedUser!
                                      .profileImage!
                                      .contains("http")
                                  ? CachedNetworkImage(
                                      imageUrl: controller
                                          .detailMemoryModel!
                                          .sharedWith![i]
                                          .sharedUser!
                                          .profileImage!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: []),
                                      ),
                                      placeholder: (context, url) => Container(
                                        width: 30,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(userIcon))),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2, color: Colors.black),
                                        ),
                                        child: const Icon(
                                          Icons.error,
                                          size: 30,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2, color: Colors.grey),
                                        image: const DecorationImage(
                                            image: AssetImage(userIcon)),
                                      ),
                                    )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    left: i * (75) / 2,
                                  ),
                                  child: leftWith[i]
                                          .sharedUser!
                                          .profileImage!
                                          .contains("http")
                                      ? Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2, color: Colors.white),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: leftWith[i]
                                                .sharedUser!
                                                .profileImage!,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.white),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 30,
                                              height: 30,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          userIcon))),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2,
                                                    color: Colors.black),
                                              ),
                                              child: const Icon(
                                                Icons.error,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2, color: Colors.grey),
                                            image: const DecorationImage(
                                                image: AssetImage(userIcon)),
                                          ),
                                        ),
                                ),
                        if (controller.detailMemoryModel!.sharedWith!.length >
                            6)
                          Padding(
                            padding: EdgeInsets.only(left: 3 * (75) / 2),
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.black),
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                "+${controller.detailMemoryModel!.sharedWith!.length - 6}",
                                style: const TextStyle(
                                    fontSize: 9, color: Colors.white),
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                )),
            for (int i = 0; i < rightWith.length; i++)
              Padding(
                  padding: EdgeInsets.only(right: 60),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          for (int i = 0; i < rightWith.length; i++)
                            i == 0
                                ? rightWith[i]
                                        .sharedUser!
                                        .profileImage!
                                        .contains("http")
                                    ? CachedNetworkImage(
                                        imageUrl: rightWith[i]
                                            .sharedUser!
                                            .profileImage!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.white),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              boxShadow: []),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          width: 30,
                                          height: 30,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(userIcon))),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1, color: Colors.black),
                                          ),
                                          child: const Icon(
                                            Icons.error,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                            image: const DecorationImage(
                                                image: AssetImage(userIcon)),
                                            boxShadow: []),
                                      )
                                : Padding(
                                    padding: EdgeInsets.only(
                                      right: i * (75) / 2,
                                    ),
                                    child: rightWith[i]
                                            .sharedUser!
                                            .profileImage!
                                            .contains("http")
                                        ? Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.white),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: rightWith[i]
                                                  .sharedUser!
                                                  .profileImage!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.white),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    boxShadow: []),
                                              ),
                                              placeholder: (context, url) =>
                                                  Container(
                                                width: 30,
                                                height: 30,
                                                padding: EdgeInsets.all(1),
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            userIcon))),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.black),
                                                ),
                                                child: const Icon(
                                                  Icons.error,
                                                  size: 30,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey),
                                                image: const DecorationImage(
                                                  image: AssetImage(userIcon),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.white60,
                                                      spreadRadius: 2,
                                                      blurRadius: 2)
                                                ]),
                                          ),
                                  ),
                          // if (restValue > 0)
                          //   Padding(
                          //     padding: EdgeInsets.only(right: listSize * (75) / 2),
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //           border:
                          //           Border.all(width: 1, color: Colors.white),
                          //           borderRadius: BorderRadius.circular(40),
                          //           color: Colors.black),
                          //       padding: const EdgeInsets.all(5),
                          //       child: Text(
                          //         "+$restValue",
                          //         style: const TextStyle(
                          //             fontSize: 9, color: Colors.white),
                          //       ),
                          //     ),
                          //   )
                        ],
                      ),
                    ],
                  ))
          ],
        ));
  }

  returnUserImage(int index) {
    return Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: Colors.white, width: 2)),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: CachedNetworkImage(
              imageUrl: controller.detailMemoryModel!.sharedWith![index]
                  .sharedUser!.profileImage!,
              fit: BoxFit.cover,
              height: 35,
              width: 35,
            )));
  }

  void showDeleteBottomSheet(
      BuildContext context,
      String memoryId,
      int index,
      MemoriesController controller,
      MemoriesModel memoriesModel,
      ImagesCaption imagesCaption) {
    print('Data ${imagesCaption.caption} => ${imagesCaption.image}');

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
                        controller.deleteMemoryImages(
                            memoryId, index, memoriesModel, imagesCaption);

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

  Widget moreButton(
      BuildContext context,
      String memoryId,
      int index,
      MemoriesController controller,
      MemoriesModel memoriesModel,
      ImagesCaption imagesCaption) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        // popupmenu item 1
        PopupMenuItem(
          value: 1,

          // row has two child icon and text.
          child: Row(
            children: const [
              Icon(Icons.delete),
              // SizedBox(
              //   // sized box with width 10
              //   width: 10,
              // ),
              Text("Delete")
            ],
          ),
        ),
      ],
      offset: const Offset(-10, 40),
      color: Colors.white,
      splashRadius: 5,
      elevation: 2,
      // position: RelativeRect.fromLTRB(100, 100, 100, 100),
      icon: const Icon(Icons.more_vert),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      onSelected: (value) {
        showDeleteBottomSheet(context, memoriesModel.memoryId!, index,
            controller, memoriesModel, memoriesModel.imagesCaption![index]);
      },
    );
  }
}
