import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utilis/constants/colors.dart';
import '../../../../../utilis/constants/size.dart';
import '../../../../../utilis/helpers/helper_function.dart';
import '../../../../../utilis/loaders/shimmers/shimmer.dart';
import '../../../../../utilis/loaders/shimmers/wound_shimmer.dart';
import '../../../controllers/manage_controller.dart';
import '../../../models/wound_type_model.dart';
import '../../admin_home/mange_wound/mange_wound.dart';
import '../../admin_home/mange_wound/update_wound.dart';

class WoundTypeScreen extends StatelessWidget {
  const WoundTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final woundcontroller = Get.put(ManageWoundController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: WColors.white),
        backgroundColor: WColors.primary,
        title: Text(
          'Wound Types',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: WColors.white),
        ),
      ),
      body: Obx(() {
        if (woundcontroller.isloading.value) return const WoundShimer();
        if (woundcontroller.allwounds.isEmpty) {
          return Center(
            child: Text(
              'No Data Found!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView.builder(
            itemCount: woundcontroller.allwounds.length,
            itemBuilder: (context, index) {
              final wounds = woundcontroller.allwounds[index];
              return GestureDetector(
                onTap: () => showWoundDetailsDialog(context, wounds),
                child: Card(
                  color: WColors.white,
                  shadowColor: WColors.black,
                  elevation: 6,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: wounds.imageUrl,
                      placeholder: (context, url) =>
                          const TShimmerEffect(width: 80, height: 80),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(wounds.title,
                        style: TextStyle(
                            color: dark ? WColors.primary : WColors.black)),
                    subtitle: Text(wounds.subtitle,
                        style: TextStyle(
                            color: dark ? WColors.darkerGrey : WColors.black)),
                    trailing: buildTrailingWidget(
                        wounds, context, woundcontroller.userRole.value),
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Obx(()=> buildAdminButton(woundcontroller.userRole.value)),
    );
  }

  Widget buildTrailingWidget(
      WoundTypeModel wounds, BuildContext context, String role) {
    if (role == 'admin') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => Get.to(UpdateWoundScreen(woundModel: wounds)),
            child: const Icon(Icons.edit, color: WColors.primary),
          ),
          InkWell(
            onTap: () => ManageWoundController().deleteWarningPopup(wounds.id),
            child: const Icon(Icons.delete, color: WColors.error),
          ),
        ],
      );
    } else {
      return const Icon(Icons.list, color: WColors.black);
    }
  }

  Widget buildAdminButton(String role) {
    if (role == 'admin') {
      return Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton.icon(
          onPressed: () => Get.to(const MangeWoundScreen()),
          icon: const Icon(Icons.add, color: WColors.white),
          label: const Text('Add Wounds'),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

void showWoundDetailsDialog(BuildContext context, WoundTypeModel wounds) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(wounds.title)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: wounds.imageUrl,
                  placeholder: (context, url) => const TShimmerEffect(
                      width: double.maxFinite, height: 180),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.maxFinite,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                wounds.subtitle,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Detailed Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                textAlign: TextAlign.justify,
                wounds.description,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
