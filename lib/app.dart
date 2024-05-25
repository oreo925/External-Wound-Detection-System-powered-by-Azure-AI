import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'bindings/general_bindings.dart';
import 'routes/app_routes.dart';
import 'utilis/constants/colors.dart';
import 'utilis/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.drakTheme,
      initialBinding: GeneralBindings(),
      getPages: AppRoutes.pages,
      // show loader or circular progress Indicator meanwhile Authentication Repository is deciding to show releveant screen
      home: const Scaffold(
        backgroundColor: WColors.primary,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}