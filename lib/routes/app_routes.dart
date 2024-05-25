import 'package:get/get.dart';
import '../feature/authentication/screens/onboarding/onboarding_screen.dart';
import 'routes.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: WRoutes.onBoarding, page: ()=> const OnBoardingScreen()),
  ];
}
