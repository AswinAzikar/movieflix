import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movieflix/features/authentication/social_authentication/social_authentication_screen.dart';
import '../../../widgets/loading_button.dart';
import '../../../exporter.dart';

class LandingPage extends StatefulWidget {
  static const String path = "/landing-page";

  const LandingPage({
    super.key,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late AnimationController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: SizedBox(
            //       width: 100,
            //       child: AspectRatio(aspectRatio: 3, child: Placeholder())),
            // ),
            const Spacer(),
            SizedBox(
              width: 200,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset("assets/appicon/logo.png"),
              ),
            ).animate().scaleXY(curve: Curves.fastOutSlowIn, begin: .8, end: 1),
            gapLarge,
            Text(
              'Let movies move you!',
              style: context.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              "Sign In or Sign Up ",
              style: context.labelLarge,
              textAlign: TextAlign.center,
            ),
            gapLarge,
            LoadingButton(
              onPressed: () {
                Navigator.pushNamed(context, SocialAuthenticationScreen.path);
              },
              text: ('Get Started'),
              buttonLoading: false,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    ));
  }
}
