import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class Collaborators extends GetView<MemoriesController> {
  String? imagePath = "";
  // int? mainIndex;
  String? type;
  String? memoryId;
  // MemoriesModel? memoriesModel;

  Collaborators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      memoryId = Get.arguments['memoryId'];
      print("memory Id in collaborators page ${memoryId}");
    }
    // mainIndex = Get.arguments['mainIndex'];
    // memoriesModel = Get.arguments['list'];
    type = Get.arguments['type'];
    return GetBuilder(
      initState: (state) {
        controller.getMyMemoryData(memoryId);
      },
      builder: (MemoriesController controller) {
        return Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 140,
                    padding: const EdgeInsets.only(top: 45),
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        controller.detailMemoryModel!.imagesCaption!.isNotEmpty
                            ? BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(controller
                                        .detailMemoryModel!
                                        .imagesCaption![0]
                                        .image!),
                                    fit: BoxFit.cover))
                            : null,
                    color:
                        controller.detailMemoryModel!.imagesCaption!.isNotEmpty
                            ? null
                            : Colors.grey,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    padding: const EdgeInsets.only(top: 45),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                    ),
                    child: Stack(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            controller.detailMemoryModel!.title!,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18),
                          ),
                        ),
                        Visibility(
                          visible: false,
                          child: Positioned(
                            right: 10,
                            top: 0,
                            child: IconButton(
                              onPressed: () => {
                                controller.checkIfLinkExpire(
                                    controller.detailMemoryModel!,
                                    controller.shareLink.value.toString(),
                                    false)
                              },
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: AppColors.primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Collaborators (${controller.getSharedUsers(controller.detailMemoryModel!).length})',
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: robotoBold,
                      color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.checkIfLinkExpire(controller.detailMemoryModel!,
                      controller.shareLink.value.toString(), false);
                  // controller.checkIfLinkExpire(memoriesModel!, controller.shareLink.toString(), true);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  color: AppColors.collaboratorBgColor,
                  child: Row(children: [
                    InkWell(
                      onTap: () {
                        controller.checkIfLinkExpire(
                            controller.detailMemoryModel!,
                            controller.shareLink.value.toString(),
                            false);
                        // controller.checkIfLinkExpire(memoriesModel!, controller.shareLink.toString(), true);
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
                    Obx(() => Text(
                          'Share link: ${controller.shareLink}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ))
                  ]),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller
                    .getSharedUsers(controller.detailMemoryModel!)
                    .length,
                shrinkWrap: true,
                primary: true,
                itemBuilder: (BuildContext context, int index) {
                  return FutureBuilder(
                    future: controller.getUserData(controller
                        .getSharedUsers(controller.detailMemoryModel!)[index]
                        .userId!),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      DocumentSnapshot<UserModel> userModelSnapshot =
                          snapshot.data! as DocumentSnapshot<UserModel>;
                      UserModel userModel = userModelSnapshot.data()!;
                      return Column(
                        children: [
                          Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            child: Row(children: [
                              Container(
                                height: 45,
                                width: 45,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  child: userModel.profileImage!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: userModel.profileImage!)
                                      : Image.asset(
                                          userIcon,
                                          fit: BoxFit.fill,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  userModel.displayName!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: gibsonSemiBold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 10)
                            ]),
                            background: Container(
                              color: AppColors.redBgColor,
                              child: Align(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                      deleteIcon,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            onDismissed: (DismissDirection dismissDirection) {
                              if (dismissDirection ==
                                  DismissDirection.endToStart) {
                                deleteCollaborator(index, "1");
                              }
                            },
                          ),
                          Container(
                            height: 2,
                            color: AppColors.bgColor,
                          )
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  //delete collaborator
  void deleteCollaborator(int index, String type) {
    controller.deleteCollaborator(controller.detailMemoryModel!.memoryId!,
        controller.detailMemoryModel!, index, type);
  }
}
