import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starter/controllers/theme_controller.dart';
import 'package:starter/core/helpers/route_helper.dart';
import 'package:starter/services/local_client.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'bindings/initial_binding.dart';
import 'core/helpers/dependency_injection.dart';
import 'features/splash/controller/splash_controller.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await HiveStorage.initHive();
  HiveStorage.registerAdapters();
  await DependencyInjection.initialize();
  final splashController = Get.find<SplashController>();
  await splashController.initSharedData();
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Starter app',
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
            },
          ),
          getPages: RouteHelper.routes,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 500),
          initialBinding: InitialBinding(),
          initialRoute: RouteHelper.initial,
          themeMode: themeController.themeMode,
          theme: AppTheme.light(context),
          darkTheme: AppTheme.dark(context),
        );
      },
    );
  }
}
