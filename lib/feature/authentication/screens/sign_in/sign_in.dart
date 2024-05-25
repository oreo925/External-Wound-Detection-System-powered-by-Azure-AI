import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utilis/constants/size.dart';
import '../../../../utilis/constants/text_string.dart';
import '../../../../utilis/helpers/helper_function.dart';
import 'widgets/login_widgets.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Logo , Title , Sub Title
              LoginHeader(dark: dark),

              // Form
              const LoginForm(),

              // Divider
              TFormDivider(
                dark: dark,
                dividerText: WTexts.orSignInWith,
              ),
              const SizedBox(
                height: TSizes.spaceBtwItem,
              ),

              // Footer
              const TSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
