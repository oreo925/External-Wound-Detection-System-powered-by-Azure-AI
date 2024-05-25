import 'package:flutter/material.dart';

import '../../../../utilis/constants/colors.dart';


class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WColors.primary,
        title: Text('Body Anatomy',style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: WColors.white),),
      ),
      body: const SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image(image: AssetImage('assets/images/content/body.jpg'),width: double.infinity,height: double.infinity,fit: BoxFit.fill,),
      )
    );
  }
}