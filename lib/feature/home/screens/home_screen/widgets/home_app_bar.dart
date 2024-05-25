import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utilis/constants/colors.dart';
import '../../../../../utilis/loaders/shimmers/shimmer.dart';
import '../../../../personalization/controllers/user_controller.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello there!',
            style: Theme.of(context).textTheme.labelMedium!.apply(
                  color: WColors.grey,
                ),
          ),
          Obx(
            () {
              if (controller.profileloading.value) {
                // Display a shimmer loader while user profile is being loading
                return const TShimmerEffect(width: 80, height: 15);
              } else {
                return Text(
                  controller.user.value.fullname,
                  style: Theme.of(context).textTheme.headlineSmall!.apply(
                        color: WColors.white,
                      ),
                );
              }
            },
          ),
        ],
      ),
      action: [
        IconButton(
          onPressed: () async {
            Uri dialnumber = Uri(scheme: 'tel', path: '1122');
                await launchUrl(dialnumber);
          },
          icon: const Image(
            image: AssetImage('assets/home/emergency-call.png'),
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 10,)
      ],
    );
  }
}
