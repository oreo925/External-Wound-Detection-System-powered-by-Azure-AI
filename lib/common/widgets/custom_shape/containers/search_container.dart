import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utilis/constants/colors.dart';
import '../../../../utilis/constants/size.dart';
import '../../../../utilis/device/device_utility.dart';
import '../../../../utilis/helpers/helper_function.dart';



class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBoder = true,
    this.padding = const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
  });
  final String text;
  final IconData? icon;
  final bool showBackground, showBoder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: padding,
      child: Container(
        width: TDeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: showBackground
              ? dark
                  ? WColors.dark
                  : WColors.light
              : Colors.transparent,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: showBoder ? Border.all(color: WColors.grey) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: dark ? WColors.light : WColors.darkGrey,
            ),
            const SizedBox(
              width: TSizes.spaceBtwItem,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall!.apply(
                    color: dark ? WColors.light : WColors.darkGrey,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
