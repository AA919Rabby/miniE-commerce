import 'package:e_commerce/controllers/details_controllers.dart';
import 'package:e_commerce/controllers/profile_controller.dart';
import 'package:e_commerce/widgets/custom_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfilesetSchreen extends StatelessWidget {
  const ProfilesetSchreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailsController());
    final profileController = Get.put(ProfileController());


    if(profileController.username.value.isNotEmpty){
      controller.save.text = profileController.username.value;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: controller.savedKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 150,
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text("Camera"),
                                        onTap: () {
                                          profileController.getImage(ImageSource.camera);
                                          Get.back();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo),
                                        title: Text("Gallery"),
                                        onTap: () {
                                          profileController.getImage(ImageSource.gallery);
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          //obx for live update
                          child: Obx(() {

                            bool hasImage = profileController.selectedImagePath.value.isNotEmpty ||
                                profileController.profileImageBase64.value.isNotEmpty;

                            return CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.blueAccent,

                              backgroundImage: hasImage ? profileController.getProfileImage() : null,
                              child: hasImage
                                  ? null
                                  : const Icon(Icons.add, color: Colors.white, size: 70),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Set profile picture',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 80),

                      CustomAuth(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your username';
                          }
                          return null;
                        },
                        controller: controller.save,
                        labelText: 'Username',
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(
                          Icons.perm_identity_outlined,
                          color: Colors.blueAccent,
                        ),
                      ),

                      const SizedBox(height: 100),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (controller.savedKey.currentState!.validate()) {

                                await profileController.saveProfileData(controller.save.text);

                                controller.saved();
                              }
                            },
                            child: Obx(() => (controller.isLoading.value || profileController.isProfileLoading.value)
                                ? const CircularProgressIndicator()
                                : const Text('Save', style: TextStyle(fontSize: 18))),
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
    );
  }
}