import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/helpers/responsive_helper.dart';
import '../utils/dimensions.dart';


void customSnackBar(
  String? message, {
  bool isError = true,
  double margin = Dimensions.paddingSizeSmall,
  int duration = 4,
  Color? backgroundColor,
  Widget? customWidget,
  double borderRadius = Dimensions.radiusSmall,
  BuildContext? context,
}) {
  if (message != null && message.isNotEmpty) {
    final BuildContext currentContext = context ?? Get.context ?? Get.overlayContext ?? Get.key.currentContext!;
    final double screenWidth = MediaQuery.of(currentContext).size.width;
    
    Get.showSnackbar(GetSnackBar(
      backgroundColor: backgroundColor ?? (isError ? Colors.red : Colors.green),
      message: customWidget == null ? message.tr : null,
      messageText: customWidget,
      maxWidth: Dimensions.webMaxWidth,
      duration: Duration(seconds: duration),
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.only(
        top: Dimensions.paddingSizeSmall,
        left: ResponsiveHelper.isDesktop(currentContext)
            ? (screenWidth - Dimensions.webMaxWidth) / 2
            : Dimensions.paddingSizeSmall,
        right: ResponsiveHelper.isDesktop(currentContext)
            ? (screenWidth - Dimensions.webMaxWidth) / 2
            : Dimensions.paddingSizeSmall,
        bottom: margin,
      ),
      borderRadius: borderRadius,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}


void customXSnackBar(
    String? message, {
      bool isError = true,
      int duration = 20,
      Color? backgroundColor,
      Widget? customWidget,
      double borderRadius = 10,
    }) {
  if (message != null && message.isNotEmpty) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: customWidget ?? Text(message.tr), // Use customWidget if provided
        backgroundColor: backgroundColor ?? (isError ? Colors.red : Colors.green),
        duration: Duration(seconds: duration),
        behavior: SnackBarBehavior.floating, // Use floating behavior for similar effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
