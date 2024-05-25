import 'package:flutter/material.dart';

import '../../../utilis/constants/size.dart';



class CustomGridLayout extends StatelessWidget {
  const CustomGridLayout({
    super.key,
    required this.itemcount,
    this.mainAxisExtent = 200,
    required this.itemBuilder,
  });
  final int itemcount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemcount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: TSizes.gridViewSpacing,
        crossAxisSpacing: TSizes.gridViewSpacing,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
