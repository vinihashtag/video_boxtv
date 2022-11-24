import 'package:flutter/material.dart';

abstract class IToastAdapter {
  void showLoading({String text});
  void closeLoading();
  void messageSucess({required String text, Alignment alignment, Duration duration});
  void messageError({required String text, Alignment alignment, Duration duration});
  void messageAlert({required String text, Alignment alignment, Duration duration});
  void messageInfo({required String text, Alignment alignment, Duration duration});
}
