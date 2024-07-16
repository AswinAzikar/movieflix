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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(paddingLarge),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/appicon/logo.png",
                    ),
                    gapLarge,
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
                      backgroundColor: const Color.fromARGB(255, 250, 3, 3),
                      buttonLoading: buttonLoading,
                      text: "Sign In With Google",
                      textColor: Colors.red,
                      onPressed: signInWithGoogle,
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       "Do not have an account?",
                //       style: context.labelLarge.copyWith(
                //         color: Colors.black.withOpacity(.5),
                //       ),
                //     ),
                //     // gapSmall,
                //     TextButton(
                //       style: TextButton.styleFrom(
                //         // padding: EdgeInsets.zero,
                //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //       ),
                //       onPressed: signupAction,
                //       child: Text(
                //         "Sign Up",
                //         style: context.bodyLarge,
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateForgotPassword() {}

  void signupAction() {}
}
