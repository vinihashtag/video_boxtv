import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../core/components/custom_responsive.dart';
import '../../core/enums/status_page.dart';
import '../../core/theme/color_theme.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          if (controller.statusPage == StatusPage.finish) return const SizedBox.shrink();

          if (controller.statusPage == StatusPage.failure) {
            return Center(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: AppColors.primary, size: CustomResponsive.isDesktopOrUltra(context) ? 220 : 100),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Erro ao reproduzir video',
                        style: TextStyle(
                            fontSize: CustomResponsive.isDesktopOrUltra(context) ? 30 : 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: Get.width * .2,
                            height: 45,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(width: 2, color: AppColors.primary),
                              ),
                              onPressed: controller.logout,
                              child: const Text(
                                'SAIR',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            width: Get.width * .2,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: controller.loadInitialInfos,
                              child: const Text(
                                'ATUALIZAR',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: controller.statusPage == StatusPage.loading
                ? const Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 0, 0, 0.7))))
                : GestureDetector(
                    onTap: controller.visibleControls ? controller.onTapVideo : controller.showControls,
                    child: Stack(
                      children: [
                        AbsorbPointer(
                          child: AspectRatio(
                            aspectRatio: Get.mediaQuery.size.aspectRatio,
                            child: VideoPlayer(controller.listPlayers[controller.indexVideo]),
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: !controller.visibleControls
                              ? const SizedBox.shrink()
                              : ValueListenableBuilder(
                                  valueListenable: controller.listPlayers[controller.indexVideo],
                                  builder: (context, value, child) {
                                    return Container(
                                      color: Colors.black45,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        value.isPlaying
                                            ? Icons.pause_circle_outline_outlined
                                            : Icons.play_circle_outline_outlined,
                                        color: Colors.white70,
                                        size: 80,
                                      ),
                                    );
                                  },
                                ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: !controller.visibleControls
                              ? const SizedBox.shrink()
                              : Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: IconButton(
                                      onPressed: () {
                                        controller.visibleControls = false;
                                        Get.bottomSheet(Material(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              ListTile(
                                                onTap: () => controller.loadInitialInfos(forceRestart: true),
                                                leading: const Icon(Icons.refresh),
                                                title: const Text(
                                                  'Reiniciar',
                                                  style: TextStyle(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              ListTile(
                                                onTap: controller.logout,
                                                leading: const Icon(Icons.logout),
                                                title: const Text(
                                                  'Sair',
                                                  style: TextStyle(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              const Divider(),
                                              ListTile(
                                                onTap: Get.back,
                                                leading: const Icon(Icons.close),
                                                title: const Text(
                                                  'Cancelar',
                                                  style: TextStyle(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                      },
                                      icon: const Icon(Icons.settings, color: Colors.white70),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
          );
        }));
  }
}