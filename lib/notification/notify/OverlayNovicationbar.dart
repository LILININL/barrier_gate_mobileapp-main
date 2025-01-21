import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotificationController extends GetxController {
  OverlayEntry? overlayEntry;

  void showOverlayNotification(
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor = Colors.black87,
    IconData? icon,
  }) {
    final overlay = Overlay.of(Get.overlayContext!);
    if (overlay == null) return;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: 40,
        right: 40,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) Icon(icon, color: Colors.white),
                if (icon != null) SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry!);

    Future.delayed(duration, () {
      if (overlayEntry != null) {
        overlayEntry!.remove();
        overlayEntry = null;
      }
    });
  }
}
