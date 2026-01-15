import 'package:e_commerce/controllers/details_controllers.dart';
import 'package:e_commerce/schreens/auth/login_schreen.dart';
import 'package:e_commerce/widgets/custom_auth.dart';
import 'package:e_commerce/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/allcolors.dart';

class RegisterSchreen extends StatelessWidget {
  const RegisterSchreen({super.key});

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
            // Top Blobs
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: AllColors.primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: -60,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: AllColors.primaryColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Hola ! let's join with us",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 40),

                      Form(
                        key: controller.registerKey,
                        child: Column(
                          children: [
                            // Username
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5)
                                    )
                                  ]
                              ),
                              child: CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your username';
                                  }
                                  return null;
                                },
                                controller: controller.name,
                                labelText: 'Name',
                                hintText: 'Enter your username',
                                prefixIcon: Icon(Icons.person, color: AllColors.primaryColor),
                              ),
                            ),

                            // Email
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5)
                                    )
                                  ]
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
                                prefixIcon: Icon(Icons.email_sharp, color: AllColors.primaryColor),
                              ),
                            ),

                            // Password
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5)
                                    )
                                  ]
                              ),
                              child: CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your password';
                                  }
                                  if (value.length < 7) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  return null;
                                },
                                controller: controller.password,
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Icon(Icons.lock, color: AllColors.primaryColor),
                                obscureText: true,
                              ),
                            ),

                            // Confirm Password
                            Container(
                              margin: const EdgeInsets.only(bottom: 25),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5)
                                    )
                                  ]
                              ),
                              child: CustomAuth(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter your password';
                                  }
                                  if (value.length < 7) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if (value != controller.password.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                controller: controller.confirmPassword,
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your password',
                                prefixIcon:  Icon(Icons.lock_outline, color:AllColors.primaryColor),
                                obscureText: true,
                              ),
                            ),

                            // Button
                            Obx(
                                  () => CustomButton(
                                height: 50,
                                width: Get.width,
                                color: AllColors.primaryColor, // Changed to Pink
                                labelColor: Colors.white,
                                label: controller.isLoading.value
                                    ? 'Please wait...'
                                    : 'Sign Up',
                                onTap: () {
                                  controller.register();
                                },
                              ),
                            ),

                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Already have an account ?',style: TextStyle(color: Colors.grey),),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => const LoginSchreen());
                                    controller.email.clear();
                                    controller.password.clear();
                                    controller.name.clear();
                                    controller.confirmPassword.clear();
                                  },
                                  child: Text('Sign In', style: TextStyle(color:Colors.black, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Blob
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 100,
                  width: Get.width * 0.8,
                  decoration: BoxDecoration(
                    color: AllColors.primaryColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(100)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}