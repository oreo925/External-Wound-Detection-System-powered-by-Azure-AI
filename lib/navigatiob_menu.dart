import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'feature/home/screens/body_anatomy/body_screen.dart';
import 'feature/home/screens/home_screen/home_screen.dart';
import 'feature/personalization/screens/setting/settings.dart';
import 'utilis/constants/colors.dart';
import 'utilis/helpers/helper_function.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controlller = Get.put(NavigationController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controlller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controlller.selectedIndex.value = index,
          backgroundColor: dark ? WColors.black : WColors.white,
          indicatorColor: dark
              ? WColors.white.withOpacity(0.1)
              : WColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.boy_sharp,size: 32,), label: 'Body'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controlller.screens[controlller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = const [HomeScreen(), BodyScreen(), SettingScreen()];
}
