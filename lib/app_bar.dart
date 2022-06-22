import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:stasht/utils/constants.dart';

PreferredSizeWidget commonAppbar(BuildContext context, String title,
    {required Function(
            bool isMemory, bool isPhotos, bool isNotification, bool isSettings)
        pageSelected}) {
  return AppBar(
    backgroundColor: Colors.white,
    centerTitle: false,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InkWell(
          onTap: () {
            pageSelected(true, false, false, false);
          },
          child: Container(
            decoration: title == memoriesTitle
                ? const BoxDecoration(
                    image: DecorationImage(image: AssetImage(eclipseImage)))
                : null,
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              folderIcon,
              width: 24,
              height: 20,
              color: AppColors.primaryColor,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        const SizedBox(
          width: 17,
        ),
        InkWell(
          onTap: () {
            pageSelected(false, true, false, false);
          },
          child: SvgPicture.asset(
            "assets/images/todayapp.svg",
            height: 22,
            width: 21,
            color: const Color.fromRGBO(108, 96, 255, 1),
          ),
        ),
        Expanded(
          child: Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontFamily: gibsonSemiBold,
                  fontSize: 22),
            ),
          ),
        ),
      ],
    ),
    actions: [
      Row(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  pageSelected(false, false, true, false);
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: title == notifications
                          ? const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(eclipseImage)))
                          : null,
                      width: 50,
                      height: 50,
                      child: SvgPicture.asset(
                        "assets/images/bell.svg",
                        height: 22,
                        width: 21,
                        fit: BoxFit.scaleDown,
                        color: const Color.fromRGBO(108, 96, 255, 1),
                      ),
                    ),
                    Positioned(
                      right: 7,
                      top: 7,
                      child: ValueListenableBuilder(
                        builder: (BuildContext context, value, Widget? child) {
                          return notificationCount.value>0 ?  Container(
                            width: 18.0,
                            height: 18.0,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),color: Colors.red),
                            child: Text(
                              '${notificationCount.value}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),textAlign: TextAlign.center,
                            ),
                          ) : Container();
                        },
                        valueListenable: notificationCount,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          InkWell(
            onTap: () {
              pageSelected(false, false, false, true);
            },
            child: ValueListenableBuilder(
              valueListenable: userImage,
              builder: (BuildContext context, value, Widget? child) {
                return CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  child: ClipRRect(
                    child: userImage.value.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: userImage.value,
                            fit: BoxFit.cover,
                            height: 34,
                            width: 34,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress))
                        : Image.asset(
                            userIcon,
                            fit: BoxFit.cover,
                            height: 34,
                            width: 34,
                          ),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            width: 19,
          ),
        ],
      )
    ],
  );
}
