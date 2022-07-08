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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    memoryId = Get.arguments['memoryId'];
    print('memoryId $memoryId');
    // controller.getMyMemoryData(memoryId);

    return GetBuilder(
      initState: (state) {
        print('InitState');
        controller.getMyMemoryData(memoryId);
      },
      builder: (MemoriesController controller) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                  onPressed: () {
                    controller.pickImages(
                        controller.detailMemoryModel!.memoryId!,
                        controller.detailMemoryModel!);
                  },
                  child: SvgPicture.asset(addPhotos),
                  backgroundColor: AppColors.primaryColor),
            ),
            body: controller.hasMemory.value == 2
                ? Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 170,
                            padding: const EdgeInsets.only(top: 45),
                            decoration: controller.detailMemoryModel!
                                    .imagesCaption!.isNotEmpty
                                ? BoxDecoration(
                                    image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            controller
                                                .detailMemoryModel!
                                                .imagesCaption![controller
                                                        .detailMemoryModel!
                                                        .imagesCaption!
                                                        .length -
                                                    1]
                                                .image!),
                                        fit: BoxFit.cover))
                                : null,
                            color: controller.detailMemoryModel!.imagesCaption!
                                    .isNotEmpty
                                ? null
                                : Colors.grey,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 170,
                              padding: const EdgeInsets.only(top: 45),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.15),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () => Get.back(),
                                                icon: const Icon(
                                                  Icons.arrow_back_ios_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (userId ==
                                                controller.detailMemoryModel!
                                                    .createdBy &&
                                            !controller
                                                .detailMemoryModel!.published!)
                                          InkWell(
                                            onTap: () {
                                              publishMemoryBottomSheet(context);
                                            },
                                            child: Image.asset(
                                              publishIcon,
                                              color: Colors.white,
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        if (userId ==
                                            controller
                                                .detailMemoryModel!.createdBy)
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(
                                                  AppRoutes.collaborators,
                                                  arguments: {
                                                    // 'mainIndex': mainIndex,
                                                    'imageIndex': 0,
                                                    'list': controller
                                                        .detailMemoryModel!,
                                                    // 'type': type
                                                  });
                                              controller.createDynamicLink(
                                                  controller.detailMemoryModel!
                                                      .memoryId!,
                                                  true,
                                                  false,
                                                  controller
                                                      .detailMemoryModel!);
                                            },
                                            child: const Icon(
                                              Icons.person_add_alt_1_outlined,
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
                                        margin: const EdgeInsets.only(top: 5),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            controller.detailMemoryModel!
                                                        .sharedWith!.length >
                                                    0
                                                ? getCollaboratorsImage(context)
                                                : controller
                                                        .detailMemoryModel!
                                                        .userModel!
                                                        .profileImage!
                                                        .contains("http")
                                                    ? CachedNetworkImage(
                                                        imageUrl: controller
                                                            .detailMemoryModel!
                                                            .userModel!
                                                            .profileImage!,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 60,
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color: Colors
                                                                    .white),
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder:
                                                            (context, url) =>
                                                                Container(
                                                          width: 60,
                                                          height: 60,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      userIcon))),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Container(
                                                          width: 60,
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .black),
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
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                width: 0.5,
                                                                color: Colors
                                                                    .grey),
                                                            image: const DecorationImage(
                                                                image: AssetImage(
                                                                    userIcon)))),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                child: Text(
                                                  "${controller.detailMemoryModel!.title!} (${controller.detailMemoryModel!.imagesCaption!.length})",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 18),
                                                ))
                                          ],
                                        )),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      if ((userId == controller.detailMemoryModel!.createdBy) &&
                          controller.detailMemoryModel!.published!)
                        InkWell(
                          onTap: () {
                            controller.sharePublishMemory(
                                controller.detailMemoryModel!.title!,
                                controller.detailMemoryModel!.publishLink!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            color: AppColors.collaboratorBgColor,
                            child: Row(children: [
                              InkWell(
                                onTap: () {
                                  controller.copyShareLink(
                                      controller.detailMemoryModel!.title!,
                                      controller
                                          .detailMemoryModel!.publishLink!);
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
                                  'Share link: ${controller.detailMemoryModel!.publishLink}',
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.black),
                                ),
                              )
                            ]),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller
                              .detailMemoryModel!.imagesCaption!.length,
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
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 45,
                                            width: 45,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2)),
                                            child: controller
                                                        .detailMemoryModel!
                                                        .imagesCaption![index]
                                                        .userModel !=
                                                    null
                                                ? controller
                                                        .detailMemoryModel!
                                                        .imagesCaption![index]
                                                        .userModel!
                                                        .profileImage!
                                                        .isNotEmpty
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
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
                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              (context, url) {
                                                            return Image.asset(
                                                                userIcon);
                                                          },
                                                          errorWidget: (context,
                                                              url, error) {
                                                            return Image.asset(
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
                                                            .substring(0, 1)
                                                            .toUpperCase()
                                                        : "",
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 22,
                                                        color: Colors.white,
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
                                                  CrossAxisAlignment.stretch,
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
                                                          .imagesCaption![index]
                                                          .userModel!
                                                          .displayName!
                                                      : "",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: robotoBold),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: '',
                                                    style: const TextStyle(
                                                        fontSize: 11),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: controller
                                                                      .detailMemoryModel!
                                                                      .imagesCaption![
                                                                          index]
                                                                      .createdAt !=
                                                                  null
                                                              ? DateFormat(
                                                                      "MMM dd/yy hh:mm a")
                                                                  .format(controller
                                                                      .detailMemoryModel!
                                                                      .imagesCaption![
                                                                          index]
                                                                      .createdAt!
                                                                      .toDate())
                                                                  .toString()
                                                              : "",
                                                          style:
                                                              TextStyle(
                                                                  color: AppColors
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.67),
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      gibsonRegularItalic)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (controller.detailMemoryModel!
                                                  .imagesCaption!.isNotEmpty) {
                                                Get.toNamed(AppRoutes.comments,
                                                    arguments: {
                                                      "memoryId": controller
                                                          .detailMemoryModel!
                                                          .memoryId!,
                                                      "memoryImage": controller
                                                          .detailMemoryModel!
                                                          .imagesCaption![index]
                                                          .image,
                                                      "imageId": controller
                                                          .detailMemoryModel!
                                                          .imagesCaption![index]
                                                          .imageId,
                                                      'list': controller
                                                          .detailMemoryModel,
                                                      'imageIndex': index,
                                                    });
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller
                                                      .detailMemoryModel!
                                                      .imagesCaption![index]
                                                      .commentCount
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                Image.asset(
                                                  messageIcon,
                                                  width: 12,
                                                  height: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          if (controller.detailMemoryModel!
                                                  .createdBy ==
                                              userId)
                                            moreButton(
                                                context,
                                                controller.detailMemoryModel!
                                                    .memoryId!,
                                                index,
                                                controller,
                                                controller.detailMemoryModel!,
                                                controller.detailMemoryModel!
                                                    .imagesCaption![index]),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 400,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: 400,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: CachedNetworkImage(
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                progress) =>
                                                            Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value: progress
                                                                    .progress,
                                                              ),
                                                            ),
                                                    fit: BoxFit.cover,
                                                    imageUrl: controller
                                                        .detailMemoryModel!
                                                        .imagesCaption![index]
                                                        .image!),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (userId ==
                                              controller.detailMemoryModel!
                                                  .createdBy) {
                                            Get.toNamed(AppRoutes.addCaption,
                                                arguments: {
                                                  'imageIndex': index,
                                                  'list': controller
                                                      .detailMemoryModel,
                                                });
                                          }
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 5),
                                          child: Text(
                                              controller
                                                      .detailMemoryModel!
                                                      .imagesCaption![index]
                                                      .caption!
                                                      .isEmpty
                                                  ? 'Add caption to this Post...'
                                                  : controller
                                                      .detailMemoryModel!
                                                      .imagesCaption![index]
                                                      .caption!,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: controller
                                                          .detailMemoryModel!
                                                          .imagesCaption![index]
                                                          .caption!
                                                          .isEmpty
                                                      ? AppColors.textColor
                                                      : AppColors.darkColor,
                                                  fontSize: 12,
                                                  fontStyle: controller
                                                          .detailMemoryModel!
                                                          .imagesCaption![index]
                                                          .caption!
                                                          .isEmpty
                                                      ? FontStyle.italic
                                                      : FontStyle.normal)),
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
                    : Container(
                        alignment: Alignment.center,
                        child: const Text('This memory is no longer available'),
                      ));
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
            height: 220,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
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
                  ],
                )
              ],
            ),
          );
        });
  }

  getCollaboratorsImage(BuildContext context) {
    int listSize = 0;
    int restValue = 0;
    if (controller.detailMemoryModel!.sharedWith!.length > 3) {
      listSize = 3;
      restValue = controller.detailMemoryModel!.sharedWith!.length - listSize;
    } else {
      listSize = controller.detailMemoryModel!.sharedWith!.length;
    }
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
                        border: Border.all(width: 0.5, color: Colors.white),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: AssetImage(userIcon))),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black),
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
                        border: Border.all(width: 0.5, color: Colors.grey),
                        image: const DecorationImage(
                            image: AssetImage(userIcon)))),
            Padding(
                padding: const EdgeInsets.only(
                  left: 75 / 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        for (int i = 0; i < listSize; i++)
                          i == 0
                              ? controller.detailMemoryModel!.sharedWith![i]
                                      .sharedUser!.profileImage!
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
                                              width: 0.5, color: Colors.white),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
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
                                              image: AssetImage(userIcon))),
                                    )
                              : Padding(
                                  padding: EdgeInsets.only(
                                    left: i * (75) / 2,
                                  ),
                                  child: controller
                                          .detailMemoryModel!
                                          .sharedWith![i]
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
                                            imageUrl: controller
                                                .detailMemoryModel!
                                                .sharedWith![i]
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
                                                  width: 1, color: Colors.grey),
                                              image: const DecorationImage(
                                                  image: AssetImage(userIcon))),
                                        ),
                                ),
                        if (restValue > 0)
                          Padding(
                            padding: EdgeInsets.only(left: listSize * (75) / 2),
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.black),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "+$restValue",
                                style: const TextStyle(
                                    fontSize: 9, color: Colors.white),
                              ),
                            ),
                          )
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
      icon: Icon(Icons.more_vert),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      onSelected: (value) {
        showDeleteBottomSheet(context, memoriesModel.memoryId!, index,
            controller, memoriesModel, memoriesModel.imagesCaption![index]);
      },
    );
  }
}
