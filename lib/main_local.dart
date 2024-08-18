import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movieflix/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/app_config.dart';
import 'main.dart';

class AppConfigLocal extends AppConfig {
  @override
  // TODO: implement domain
  String get domain => "api.themoviedb.org";

  @override
  // TODO: implement slugUrl
  String get slugUrl => '/3/';

  @override
  // TODO: implement privacyPolicy
  String get privacyPolicy => throw UnimplementedError();

  @override
  // TODO: implement refundPolicy
  String get refundPolicy => throw UnimplementedError();

  @override
  // TODO: implement termsAndConditions
  String get termsAndConditions => throw UnimplementedError();

  @override
  // TODO: implement port
  String get port => '';

  @override
  // TODO: implement scheme
  String get scheme => 'https';
}

void main() async {
  appConfig = AppConfigLocal();
  await mainCommon();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
