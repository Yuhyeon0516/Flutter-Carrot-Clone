import 'package:fast_app_base/app.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_carrot_button.riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FcmManager {
  static void requestPermission() {
    FirebaseMessaging.instance.requestPermission();
  }

  static void initialize(WidgetRef ref) async {
    // Foreground
    FirebaseMessaging.onMessage.listen((msg) async {
      final title = msg.notification?.title;
      if (title == null) {
        return;
      }

      ref.read(floatingButtonStateProvider.notifier).hideButton();
      App.navigatorKey.currentContext?.showSnackbar(title);
      await sleepAsync(4.seconds);
      ref.read(floatingButtonStateProvider.notifier).showButton();
    });

    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {});

    // Not running

    final firstMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (firstMessage != null) {
      // context가 정상적인 상태로 로딩될때까지 sleep
      await sleepUntil(() => App.navigatorKey.currentContext != null);

      final context = App.navigatorKey.currentContext;

      // context가 정상적으로 로딩이 되었고 mounted상태일때
      if (context != null && context.mounted) {
        // 이후 알림에 대한 동작상태 구성
      }
    }

    // token은 서버에 저장을 해두어야함
    final token = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      // token이 변경되면 여기로 들어오고 서버에 token을 갱신해줘야함
    });
  }
}
