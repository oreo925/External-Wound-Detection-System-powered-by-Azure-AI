import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repositories/user/user_repoistory.dart';
import '../../../data/wound/wound_repositories.dart';
import '../../../utilis/constants/colors.dart';
import '../../../utilis/constants/image_strings.dart';
import '../../../utilis/constants/size.dart';
import '../../../utilis/helpers/network_manager.dart';
import '../../../utilis/loaders/loaders.dart';
import '../../../utilis/popups/full_screen_loader.dart';
import '../models/wound_type_model.dart';

class ManageWoundController extends GetxController {
  static ManageWoundController get instance => Get.find();

  final woundrepository = Get.put(WoundsRepository());
  final userRepository = Get.put(UserRepository());
  Rx<WoundTypeModel> woundmodel = WoundTypeModel.empty().obs;
  final RxList<WoundTypeModel> allwounds = <WoundTypeModel>[].obs;

  RxBool refreshData = true.obs;
  final isloading = false.obs;
  final imageUploading = false.obs;
  final RxString userRole = ''.obs;
  RxString selectedImage = RxString('');

  // Variables
  PickedFile? image;
  final woundname = TextEditingController();
  final subtitle = TextEditingController();
  final description = TextEditingController();

  GlobalKey<FormState> woundFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    checkUserRole();
    fetchwounds();
    super.onInit();
  }

  Future<String> fetchRole() async {
    // Retrieve user data from Firebase
    final userData = await userRepository.fetchUserDetails();
    // Get the user's role
    final String userRole = userData.role;
    // Return the user's role
    return userRole;
  }

  void checkUserRole() async {
    try {
      String role = await fetchRole();
      userRole.value = role;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Opps!', message: e.toString());
    }
  }

  Future<void> fetchwounds() async {
    try {
      // Show loader while loading Banners
      isloading.value = true;

      // Fetch Wounds
      final allwounddb = await woundrepository.fetchWoundDetails();

      // Assign Banners
      allwounds.assignAll(allwounddb);
      refreshData.toggle();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Opps!', message: e.toString());
    } finally {
      // Remove Loader
      isloading.value = false;
    }
  }

  Future addnewwounddetails() async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialogue(
          'Storing Wound Details....', WImages.docerAnimation);

      // check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!woundFormKey.currentState!.validate()) {
        // Remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Check if an image is selected
      if (selectedImage.value.isEmpty) {
        // Remove Loader
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(
          title: 'No Image Selected',
          message: 'Please choose an image for your car.',
        );
        return;
      }

      // Convert PickedFile to XFile
      final xFile = XFile(selectedImage.value);

      // Upload
      final imageUrl =
          await woundrepository.uploadImage('Wounds/Images/', xFile);

      // Save Address Data
      final wounds = WoundTypeModel(
        id: '',
        title: woundname.text.trim(),
        subtitle: subtitle.text.trim(),
        description: description.text.trim(),
        imageUrl: imageUrl,
      );
      await woundrepository.addwounddetails(wounds);

      // Directly update the list
      allwounds.add(wounds);

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show Success Message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your Car has been Saved Successfully.');

      // Reset Fields
      resetFormFields();

      // Reset Image Container
      selectedImage.value = '';

      // Reset
      Navigator.of(Get.context!).pop();

      // Refresh wounds Data
      refreshData.toggle();
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void resetFormFields() {
    woundname.clear();
    subtitle.clear();
    description.clear();
    woundFormKey.currentState?.reset();
  }

  // Delete Account Warnings
  void deleteWarningPopup(String woundId) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(TSizes.md),
      title: 'Delete Account',
      middleText: 'Are you Sure you went to delete wounds Details',
      confirm: ElevatedButton(
        onPressed: () {
          // Close the dialog
          Navigator.of(Get.overlayContext!).pop();

          // Delete the car details
          deletewound(woundId);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            side: const BorderSide(color: Colors.red)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Delete'),
        ),
      ),
      cancel: ElevatedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        style: ElevatedButton.styleFrom(
            backgroundColor: WColors.primary,
            side: const BorderSide(color: WColors.primary)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
          child: Text('Cancel'),
        ),
      ),
    );
  }

  // Delete User Account
  void deletewound(String woundId) async {
    try {
      // start loading
      TFullScreenLoader.openLoadingDialogue(
        'Processing...',
        WImages.docerAnimation,
      );
      await woundrepository.removewoundrecord(woundId);

      // Close the loading dialog
      TFullScreenLoader.stopLoading();
      
      // Refresh wounds Data
      refreshData.toggle();
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Show some Generic Error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
