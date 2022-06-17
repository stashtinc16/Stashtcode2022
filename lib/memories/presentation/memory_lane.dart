import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int? mainIndex;
  MemoriesModel? memoriesModel;
  String? type;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    mainIndex = Get.arguments['mainIndex'];
    // memoriesModel = Get.arguments['list'];
    type = Get.arguments['type'];
    if (type == "1") {
      memoriesModel = controller.memoriesList[mainIndex!];
    } else {
      memoriesModel = controller.sharedMemoriesList[mainIndex!];
    }
    return GetBuilder(
      builder: (MemoriesController controller) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
                      padding: const EdgeInsets.only(top: 45),
                      decoration: memoriesModel!.imagesCaption!.isNotEmpty
                          ? BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      memoriesModel!.imagesCaption![0].image!),
                                  fit: BoxFit.cover))
                          : null,
                      color: memoriesModel!.imagesCaption!.isNotEmpty
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
                          padding: const EdgeInsets.only(left: 15, right: 15),
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
                                  if (userId == memoriesModel!.createdBy)
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(AppRoutes.collaborators,
                                            arguments: {
                                              'mainIndex': mainIndex,
                                              'imageIndex': 0,
                                              'list': memoriesModel,
                                              'type': type
                                            });
                                        controller.createDynamicLink(
                                            memoriesModel!.memoryId!,
                                            true,
                                            mainIndex!);
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
                                  if (memoriesModel!.createdBy == userId)
                                    InkWell(
                                      onTap: () {
                                        controller.pickImages(
                                            memoriesModel!.memoryId!,
                                            memoriesModel!);
                                      },
                                      child: const Icon(
                                        Icons.add_box_rounded,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    )
                                ],
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      memoriesModel!.userModel != null &&
                                              memoriesModel!.userModel!
                                                  .profileImage!.isNotEmpty
                                          ? Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2)),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(30)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: memoriesModel!
                                                        .userModel!
                                                        .profileImage!,
                                                    fit: BoxFit.cover,
                                                  )))
                                          : Container(
                                              child: Image.asset(userIcon),
                                              height: 60,
                                              width: 60,
                                            ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                            top: 5,
                                          ),
                                          child: Text(
                                            "${memoriesModel!.title!} (${memoriesModel!.imagesCaption!.length})",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 18),
                                          ))
                                    ],
                                  )),
                            ],
                          ),
                        )),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: memoriesModel!.imagesCaption!.length,
                    itemBuilder: (context, index) {
                      if (type == "1") {
                        memoriesModel = controller.memoriesList[mainIndex!];
                      } else {
                        memoriesModel =
                            controller.sharedMemoriesList[mainIndex!];
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 8.0, top: 5),
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
                                              color: Colors.white, width: 2)),
                                      child: memoriesModel!.userModel != null
                                          ? memoriesModel!.userModel!
                                                  .profileImage!.isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(30)),
                                                  child: CachedNetworkImage(
                                                    width: 45,
                                                    height: 45,
                                                    imageUrl: memoriesModel!
                                                        .userModel!
                                                        .profileImage!,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) {
                                                      return Image.asset(
                                                          userIcon);
                                                    },
                                                    errorWidget:
                                                        (context, url, error) {
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
                                              memoriesModel!
                                                  .userModel!.userName!
                                                  .toString()
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.white,
                                                  fontFamily: gibsonSemiBold),
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
                                            memoriesModel!.userModel!.userName!,
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
                                              style:
                                                  const TextStyle(fontSize: 11),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        DateFormat("MMM dd/yy")
                                                            .format(
                                                                memoriesModel!
                                                                    .createdAt!
                                                                    .toDate())
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor
                                                            .withOpacity(0.67),
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
                                        if (memoriesModel!
                                            .imagesCaption!.isNotEmpty) {
                                          Get.toNamed(AppRoutes.comments,
                                              arguments: {
                                                "memoryId":
                                                    memoriesModel!.memoryId!,
                                                "memoryImage": memoriesModel!
                                                    .imagesCaption![index]
                                                    .image,
                                                'list': memoriesModel,
                                                'mainIndex': mainIndex,
                                                'imageIndex': index,
                                                'type': type
                                              });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            memoriesModel!.imagesCaption![index]
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
                                    if (memoriesModel!.createdBy == userId)
                                      moreButton(
                                          context,
                                          memoriesModel!.memoryId!,
                                          index,
                                          controller,
                                          memoriesModel!,
                                          memoriesModel!.imagesCaption![index]),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          height: 400,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: CachedNetworkImage(
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value:
                                                              progress.progress,
                                                        ),
                                                      ),
                                              fit: BoxFit.cover,
                                              imageUrl: memoriesModel!
                                                  .imagesCaption![index]
                                                  .image!),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.addCaption,
                                        arguments: {
                                          'mainIndex': mainIndex,
                                          'imageIndex': index,
                                          'list': memoriesModel,
                                          'type': type
                                        });
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: Text(
                                        memoriesModel!.imagesCaption![index]
                                                .caption!.isEmpty
                                            ? 'Add caption to this Post...'
                                            : memoriesModel!
                                                .imagesCaption![index].caption!,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: memoriesModel!
                                                    .imagesCaption![index]
                                                    .caption!
                                                    .isEmpty
                                                ? AppColors.textColor
                                                : AppColors.darkColor,
                                            fontSize: 12,
                                            fontStyle: memoriesModel!
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
            ));
      },
    );
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
                        controller.deleteMemory(
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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      onSelected: (value) {
        showDeleteBottomSheet(context, memoriesModel.memoryId!, index,
            controller, memoriesModel, memoriesModel.imagesCaption![index]);
      },
    );
  }
}
