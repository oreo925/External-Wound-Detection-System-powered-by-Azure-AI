import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wounddetectionsystem/data/wound/wound_repositories.dart';

import '../../../utilis/constants/image_strings.dart';
import '../../../utilis/helpers/network_manager.dart';
import '../../../utilis/loaders/loaders.dart';
import '../../../utilis/popups/full_screen_loader.dart';
import '../models/wound_type_model.dart';

class WoundUpdateController extends GetxController {
  static WoundUpdateController get instance => Get.find();

  // variable
  RxString woundimage = RxString('');
  RxBool refreshData = true.obs;

  final woundtile = TextEditingController();
  final woundsubtitle = TextEditingController();
  final wounddescription = TextEditingController();
  final woundsRepository = Get.put(WoundsRepository());
  GlobalKey<FormState> updatewoundFormKey = GlobalKey<FormState>();

  final WoundTypeModel wound;
  WoundUpdateController(this.wound);

  /// init user data when Home Screen appears
  @override
  void onInit() {
    initializeWoundDetails();
    super.onInit();
  }

  Future<void> initializeWoundDetails() async {
    woundtile.text = wound.title;
    woundsubtitle.text = wound.subtitle;
    wounddescription.text = wound.description;
    woundimage.value = wound.imageUrl;
  }

  Future<void> updatedetails() async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialogue(
        'We are updating your information...',
        WImages.docerAnimation,
      );

      // check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!updatewoundFormKey.currentState!.validate()) {
        // Remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }
      // update user's first and last name in the Firebase Firestore
      Map<String, dynamic> wounds = {
        'Woundpic': woundimage.value,
        'WoundName': woundtile.text.trim(),
        'WoundSubtitle': woundsubtitle.text.trim(),
        'description': wounddescription.text.trim(),
      };
      await woundsRepository.updateSingleField(wounds, wound.id);

      // Remove Loader
      TFullScreenLoader.stopLoading();
      Get.back();
      
      refreshData.toggle();

      // Show Sucess Message
      TLoaders.successSnackBar(
          title: 'Congratulations', message: 'Your Details has been updated');
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
