import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

import '../../../../../utilis/constants/colors.dart';
import '../../../../../utilis/constants/size.dart';
import '../../../../../utilis/helpers/helper_function.dart';
import '../../../../../utilis/loaders/loaders.dart';
import '../../../../../utilis/validations/validation.dart';
import '../../../controllers/update_wound_controller.dart';
import '../../../models/wound_type_model.dart';

class UpdateWoundScreen extends StatelessWidget {
  const UpdateWoundScreen({super.key, required this.woundModel});
  final WoundTypeModel woundModel;

  @override
  Widget build(BuildContext context) {
    final updatewoundcontroller = Get.put(WoundUpdateController(woundModel));
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: WColors.white),
        backgroundColor: WColors.primary,
        title: Text(
          'Update Wound Details',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: WColors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: updatewoundcontroller.updatewoundFormKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    // Pick Image
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                      maxWidth: 512,
                      maxHeight: 512,
                    );

                    if (image != null) {
                      // Set the selected image in the container
                      updatewoundcontroller.woundimage.value = image.path;
                    } else {
                      // User canceled image selection
                      TLoaders.errorSnackBar(
                        title: 'No Image Selected',
                        message: 'Please choose an image for wound.',
                      );
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Obx(
                          () => updatewoundcontroller.woundimage.isNotEmpty
                              ? Container(
                                  width: double.infinity,
                                  height: 230,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(updatewoundcontroller.woundimage.value),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 230,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: dark
                                                ? WColors.white
                                                : WColors.black)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            Image(
                                              image: const AssetImage(
                                                  'assets/home/image-gallery.png'),
                                              color: dark
                                                  ? WColors.white
                                                  : WColors.black,
                                              width: 150,
                                              height: 150,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              'Select Image from Gallery',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                TextFormField(
                  validator: (value) =>
                      TValidator.vaildationEmptyText('Wound Name', value),
                  controller: updatewoundcontroller.woundtile,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.abc),
                    labelText: 'Wound Name',
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwInputFields,
                ),
                TextFormField(
                  validator: (value) =>
                      TValidator.vaildationEmptyText('Sub Title', value),
                  controller: updatewoundcontroller.woundsubtitle,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.subtitles),
                    labelText: 'Sub Title',
                  ),
                ),
                const SizedBox(
                  height: TSizes.spaceBtwInputFields,
                ),
                TextFormField(
                  validator: (value) =>
                      TValidator.vaildationEmptyText('Description', value),
                  controller: updatewoundcontroller.wounddescription,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(
                  height: TSizes.defaultSpace,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      updatewoundcontroller.updatedetails();
                    },
                    child: const Text('Update Wound Details'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
