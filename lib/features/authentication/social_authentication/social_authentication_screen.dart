import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../exporter.dart';
import '../../../widgets/loading_button.dart';
import 'email_and_password_mixin.dart';
import 'google_oauth_mixin.dart';

class SocialAuthenticationScreen extends StatefulWidget {
  static const String path = "/social-authentication";

  const SocialAuthenticationScreen({super.key});

  @override
  State<SocialAuthenticationScreen> createState() =>
      _SocialAuthenticationScreenState();
}

class _SocialAuthenticationScreenState extends State<SocialAuthenticationScreen>
    with GoogleOauthMixin, EmailPasswordMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(paddingLarge),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/appicon/logo.png",
                width: 150,
                height: 150,
              ),

              Text(
                "Let's start by loging into ",
                style: TextStyle(
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    fontSize: 20,
                    color: Colors.white),
              ),

              // gapLarge,
              // FormHeader(
              //   label: "Email",
              //   child: TextFormField(
              //     controller: emailController,
              //     validator: emailValidator,
              //     decoration: const InputDecoration(
              //       prefixIcon: Icon(Icons.email_outlined),
              //       hintText: "Email",
              //     ),
              //   ),
              // ),
              // gapLarge,
              // FormHeader(
              //   label: "Password",
              //   child: TextFormField(
              //     obscureText: !passwordVisible,
              //     validator: passwordValidator,
              //     controller: passwordController,
              //     decoration: InputDecoration(
              //         errorText: passwordError,
              //         prefixIcon: const Icon(
              //           Icons.lock_outline,
              //         ),
              //         hintText: "Password",
              //         suffixIcon: IconButton(
              //             onPressed: touglePasswordVisibility,
              //             icon: Icon(visibilityIcon))),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: TextButton(
              //       onPressed: navigateForgotPassword,
              //       child: Text(
              //         "Forget Password?",
              //         style: context.labelLarge.copyWith(
              //           color: Colors.grey,
              //         ),
              //       )),
              // ),
              // gapLarge,
              // LoadingButtonV2(
              //     buttonLoading: loginButtonLoading,
              //     text: "Log In",
              //     onPressed: signInWithEmailAndPassword),
              // gap,
              // const Text("OR"),
              gap,
              LoadingButtonV2(
                icon: SvgPicture.asset(
                  Assets.svgs.icons8Google,
                  height: paddingXL,
                ),
                backgroundColor: Colors.white,
                buttonLoading: buttonLoading,
                text: "Sign In With Google",
                textColor: Colors.red,
                
                onPressed: signInWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateForgotPassword() {}

  void signupAction() {}
}
