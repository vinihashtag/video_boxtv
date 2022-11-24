import 'package:auto_size_text/auto_size_text.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../components/custom_loading.dart';
import '../../components/custom_responsive.dart';
import '../../theme/color_theme.dart';
import '../../theme/text_theme.dart';
import 'toast_adapter.dart';

class ToastAdapter implements IToastAdapter {
  @override
  void showLoading({String text = 'Aguarde...'}) {
    late Alignment alignment;
    if (CustomResponsive.isMobile(Get.context!)) {
      alignment = Alignment.center;
    } else {
      alignment = const Alignment(1, -0.95);
    }
    BotToast.showCustomLoading(
      backgroundColor: Colors.black54,
      backButtonBehavior: BackButtonBehavior.ignore,
      align: alignment,
      toastBuilder: (cancelFunc) => Container(
        width: CustomResponsive.isMobile(Get.context!) ? Get.width : Get.width * 0.3,
        margin: const EdgeInsets.symmetric(horizontal: 26),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(height: 100, width: 100, child: CustomLoading()),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: AutoSizeText(
                  text,
                  style: AppTextStyle.white(16, FontWeight.w600),
                  maxLines: 3,
                  minFontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void closeLoading() => BotToast.closeAllLoading();

  @override
  void messageSucess({
    required String text,
    Alignment alignment = const Alignment(0, -0.85),
    Duration duration = const Duration(seconds: 2, milliseconds: 500),
  }) {
    var width = Get.width;
    if (!CustomResponsive.isMobile(Get.context!)) {
      width = Get.width * 0.3;
      alignment = const Alignment(1, -0.95);
    }
    BotToast.showCustomText(
      toastBuilder: (cancelFunc) => AnimatedContainer(
        width: width,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.success,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 5, spreadRadius: 3)],
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Flexible(
              child: AutoSizeText(
                text,
                style: AppTextStyle.white(16, FontWeight.w600),
                maxLines: 3,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      align: alignment,
      clickClose: true,
      ignoreContentClick: true,
      duration: duration,
    );
  }

  @override
  void messageError({
    required String text,
    Alignment alignment = const Alignment(0, -0.85),
    Duration duration = const Duration(seconds: 3, milliseconds: 500),
  }) {
    var width = Get.width;
    if (!CustomResponsive.isMobile(Get.context!)) {
      width = Get.width * 0.3;
      alignment = const Alignment(1, -0.95);
    }
    BotToast.showCustomText(
      toastBuilder: (cancelFunc) => AnimatedContainer(
        width: width,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 5, spreadRadius: 3),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Flexible(
              child: AutoSizeText(
                text,
                style: AppTextStyle.white(16, FontWeight.w600),
                maxLines: 3,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      align: alignment,
      clickClose: true,
      ignoreContentClick: true,
      duration: duration,
    );
  }

  @override
  void messageAlert({
    required String text,
    Alignment alignment = const Alignment(0, -0.85),
    Duration duration = const Duration(seconds: 2, milliseconds: 500),
  }) {
    var width = Get.width;
    if (!CustomResponsive.isMobile(Get.context!)) {
      width = Get.width * 0.3;
      alignment = const Alignment(1, -0.95);
    }
    BotToast.showCustomText(
      toastBuilder: (cancelFunc) => AnimatedContainer(
        width: width,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 5, spreadRadius: 3)],
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Flexible(
              child: AutoSizeText(
                text,
                style: AppTextStyle.white(16, FontWeight.w600),
                maxLines: 3,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      align: alignment,
      clickClose: true,
      ignoreContentClick: true,
      duration: duration,
    );
  }

  @override
  void messageInfo({
    required String text,
    Alignment alignment = const Alignment(0, -0.85),
    Duration duration = const Duration(seconds: 2, milliseconds: 500),
  }) {
    var width = Get.width;
    if (!CustomResponsive.isMobile(Get.context!)) {
      width = Get.width * 0.3;
      alignment = const Alignment(1, -0.95);
    }
    BotToast.showCustomText(
      toastBuilder: (cancelFunc) => AnimatedContainer(
        width: width,
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.info,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 5, spreadRadius: 3)],
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Flexible(
              child: AutoSizeText(
                text,
                style: AppTextStyle.white(16, FontWeight.w600),
                maxLines: 3,
                minFontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
      align: alignment,
      clickClose: true,
      ignoreContentClick: true,
      duration: duration,
    );
  }
}
