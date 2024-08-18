// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movieflix/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/app_route.dart';
import 'services/fcm_service.dart';
import 'theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/shared_preferences_services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

final navigatorKey = GlobalKey<NavigatorState>();

mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPreferencesService.i.initialize();
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  // Setup crashletics
  if (!kIsWeb) {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  // notification setup
  FCMService.setupNotification();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Animate.restartOnHotReload = true;
    observer = FirebaseAnalyticsObserver(analytics: analytics);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setSystemOverlay();
    });
  }

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  late FirebaseAnalyticsObserver observer;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (BuildContext context, themeProvider, child) => MaterialApp(
        navigatorObservers: [observer],
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoute.onGenerateRoute,
        onGenerateInitialRoutes: AppRoute.onGenerateInitialRoute,
        theme: themeProvider.currentTheme,
      ),
    );
  }
}
