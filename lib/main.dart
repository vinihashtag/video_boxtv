import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_boxtv/core/theme/app_theme.dart';

import 'core/controllers/auth_controller.dart';
import 'modules/main_bindings.dart';
import 'modules/splash/splash_page.dart';
import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: SplashPage(), debugShowCheckedModeBanner: false));

  MainBindings().dependencies();

  await Future.wait([
    GetStorage.init(),
    Get.find<AuthController>().getCurrentUser(),
    // if (GetPlatform.isAndroid) PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem'),
  ]);

  // if (GetPlatform.isAndroid) {
  //   final ByteData data = futures.last as ByteData;
  //   SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BOXTV VIDEO',
      debugShowCheckedModeBanner: false,
      enableLog: kDebugMode,
      defaultTransition: Transition.native,
      getPages: AppPages.routes,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      darkTheme: AppTheme.dark,
      initialRoute: Routes.home,
    );
  }
}
