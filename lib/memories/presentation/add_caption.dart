import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class AddCaption extends GetView<MemoriesController> {
  int? mainIndex, imageIndex;
  TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    mainIndex = Get.arguments['mainIndex'];
    imageIndex = Get.arguments['imageIndex'];
    captionController.text = controller.memoriesList[mainIndex!]
            .imagesCaption[imageIndex].caption.isNotEmpty
        ? controller.memoriesList[mainIndex!].imagesCaption[imageIndex].caption
        : "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.darkColor,
            )),
        elevation: 0,
        actions: [
          InkWell(
            onTap: () {
              controller.saveCaption(
                  captionController.text.toString(),
                  imageIndex!,
                  controller.memoriesList[mainIndex!].memoryId,
                  mainIndex!);
            },
            child: Row(
              children: const [
                Text(
                  'Done',
                  style: TextStyle(
                      fontFamily: robotoBold,
                      fontSize: 14,
                      color: AppColors.darkColor),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.darkColor,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 0.5,
            color: AppColors.primaryColor,
          ),
          TextFormField(
            controller: captionController,
            maxLines: 4,
            textInputAction: TextInputAction.done,
            maxLength: 350,
            decoration: const InputDecoration(
                hintText: 'Add Caption to this post..',
              
                hintStyle: TextStyle(fontSize: 14, color: AppColors.textColor),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0)),
            style: const TextStyle(fontSize: 14.0, color: Colors.black),
          ),
          Expanded(
            child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) => Center(
                      child: CircularProgressIndicator(
                        value: progress.progress,
                      ),
                    ),
                fit: BoxFit.cover,
                imageUrl: controller.memoriesList[mainIndex!]
                    .imagesCaption[imageIndex!].image!),
          )
        ],
      ),
    );
  }
}
