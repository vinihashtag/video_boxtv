import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_boxtv/core/components/custom_responsive.dart';

import '../../core/components/custom_loading.dart';
import '../../core/enums/status_page.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.status == StatusPage.loadingMore) return const CustomLoading();
        return AbsorbPointer(
          absorbing: controller.status == StatusPage.loading,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  vertical: Get.height * .08,
                  horizontal: CustomResponsive.isMobile(context) ? Get.width * .08 : Get.width * .38),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Icon(
                      Icons.video_collection_outlined,
                      color: Get.theme.primaryColorDark,
                      size: CustomResponsive.isMobile(context) ? 150 : 250,
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) => controller.username = value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Informe um usuário';
                      } else if ((value?.trim().length ?? 0) <= 2) {
                        return 'Usuário inválido';
                      }
                      return null;
                    },
                    onEditingComplete: controller.passwordFocus.requestFocus,
                    decoration: const InputDecoration(
                      label: Text('Usuário', style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ObxValue(
                    (visible) => TextFormField(
                      focusNode: controller.passwordFocus,
                      obscureText: visible.value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) => controller.password = value,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Informe sua senha';
                        } else if ((value?.trim().length ?? 0) <= 5) {
                          return 'Senha deve conter no mínimo 6 caracteres';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text(
                          'Senha',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => visible.value = !visible.value,
                          icon: Icon(visible.value ? Icons.visibility : Icons.visibility_off),
                        ),
                      ),
                      onEditingComplete: () {
                        controller.passwordFocus.unfocus();
                        if (controller.isValid) controller.login();
                      },
                    ),
                    true.obs,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: Get.width,
                      child: ElevatedButton(
                        onPressed: controller.isValid
                            ? () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                controller.login();
                              }
                            : null,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: controller.status == StatusPage.loading
                              ? Transform.scale(
                                  scale: .8,
                                  child: const CustomLoading(color: Colors.white),
                                )
                              : const Text('ENTRAR'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
