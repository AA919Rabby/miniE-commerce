import 'package:e_commerce/controllers/details_controllers.dart';
import 'package:e_commerce/schreens/auth/register_schreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/allcolors.dart';
import '../../widgets/custom_auth.dart';
import '../../widgets/custom_button.dart';

class LoginSchreen extends StatelessWidget {
  const LoginSchreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            // Top right blobs
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color:AllColors.primaryColor.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Bottom left blobs
            Positioned(
              bottom: -80,
              left: -50,
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  color: AllColors.primaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome\nBack',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Hola ! Good to see you again",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),

                      Form(
                        key: controller.loginKey,
                        child: Column(
                          children: [
                            // Email
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your email';
                                  }
                                  if (!GetUtils.isEmail(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                                controller: controller.email,
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email_outlined, color: AllColors.primaryColor),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Password
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your password';
                                  }
                                  return null;
                                },
                                controller: controller.password,
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon:  Icon(Icons.lock_outline, color: AllColors.primaryColor),
                                obscureText: true,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Button
                            Obx(
                                  () => CustomButton(
                                height: 50,
                                width: Get.width,
                                color: AllColors.primaryColor,
                                labelColor: Colors.white,
                                label: controller.isLoading.value
                                    ? 'Please wait...'
                                    : 'Login',
                                onTap: () {
                                  controller.login();
                                  controller.email.clear();
                                  controller.password.clear();
                                },
                              ),
                            ),
                            const SizedBox(height: 15),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    showForgetPasswordDialog(controller);
                                  },
                                  child: Text(
                                    'Forget password?',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),

                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () => Get.to(const RegisterSchreen()),
                                      child: const Text(
                                        'Register now !',
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
 //dialog box
    showForgetPasswordDialog(DetailsController controller) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Card(
              elevation: 5,
              shadowColor: Colors.black.withOpacity(.6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      leading:  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.lock_reset, size: 45, color: AllColors.primaryColor),
                      ),
                      title: const Text(
                        "Reset Password",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: const Text(
                        "We will send a link",
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Card(
                          elevation: 3,
                          shape: const CircleBorder(),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                    ),

                    const Divider(),
                    const SizedBox(height: 15),

                    TextField(
                      controller: controller.email,
                      decoration: InputDecoration(
                        labelText: "Enter your email",
                        hintText: "example@email.com",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon:  Icon(Icons.email_outlined, color: AllColors.primaryColor),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AllColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                        //calling a function
                          controller.sendPasswordResetEmail();
                        },
                        child: const Text("Send Reset Link", style: TextStyle(fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}