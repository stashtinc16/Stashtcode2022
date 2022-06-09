import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class Collaborators extends GetView<MemoriesController> {
  String? imagePath = "";
  int? mainIndex;
  MemoriesModel? memoriesModel;
  
  @override
  Widget build(BuildContext context) {
    mainIndex = Get.arguments['mainIndex'];
    memoriesModel = Get.arguments['list'];
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(imagePath!))),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Title",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18),
                )
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.primaryColor,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Collaborators (8)',
              style: TextStyle(
                  fontSize: 16, fontFamily: robotoBold, color: Colors.black),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            color: AppColors.collaboratorBgColor,
            child: Row(children: [
              Image.asset(
                copyIcon,
                width: 20,
                height: 20,
              ),
              const Text(
                'Share link: www.stasht.com/sdkflxckudfklj….',
                style: TextStyle(fontSize: 15, color: Colors.black),
              )
            ]),
          ),
          ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            primary: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Dismissible(
                    key: ValueKey(index),
                    background: Container(
                      color: Colors.green,
                      child: const Align(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(Icons.favorite),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: Row(children: [
                      Container(
                        height: 45,
                        width: 45,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1)),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: controller.memoriesList[index].userModel !=
                                      null &&
                                  controller.memoriesList[index].userModel!
                                      .profileImage!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: controller.memoriesList[index]
                                      .userModel!.profileImage!)
                              : Image.asset(
                                  userIcon,
                                  fit: BoxFit.fill,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'User',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: gibsonSemiBold,
                            color: Colors.black),
                      )
                    ]),
                    secondaryBackground: Container(
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
                  ),
                  Container(
                    height: 2,
                    color: AppColors.bgColor,
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
