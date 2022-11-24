import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/components/custom_splash.dart';
import '../../core/theme/color_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: CustomSplash(
          image: Icon(
            Icons.video_collection_outlined,
            color: AppColors.primary,
            size: 180,
          ),
        ),
      ),
    );
  }
}
