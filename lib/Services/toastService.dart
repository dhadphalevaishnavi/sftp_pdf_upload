import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ToastService{

  static ToastFuture toast(String msg, Color color) {
    return showToast(
      msg,
      position: ToastPosition.bottom,
      textPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      backgroundColor: color,
      duration: const Duration(seconds: 5),
    );
  }

}
