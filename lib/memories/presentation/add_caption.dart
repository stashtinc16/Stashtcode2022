import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class AddCaption extends GetView<MemoriesController> {
  int? imageIndex;
  MemoriesModel? memoriesModel;
  TextEditingController captionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    imageIndex = Get.arguments['imageIndex'];
    memoriesModel = Get.arguments['list'];
    captionController.text =
        memoriesModel!.imagesCaption![imageIndex!].caption!.isNotEmpty
            ? memoriesModel!.imagesCaption![imageIndex!].caption!
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
              controller.saveCaption(captionController.text.toString(),
                  imageIndex!, memoriesModel!);
            },
            child: Row(
              children: const [
                Text(
                  'Done',
                  style: TextStyle(
                      fontFamily: robotoBold,
                      fontSize: 16,
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
                counterText: '',
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
                imageUrl: memoriesModel!.imagesCaption![imageIndex!].image!),
          )
        ],
      ),
    );
  }
}
