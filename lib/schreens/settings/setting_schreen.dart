import 'package:e_commerce/const/allcolors.dart';
import 'package:e_commerce/controllers/auth_controllers.dart';
import 'package:e_commerce/schreens/auth/login_schreen.dart';
import 'package:e_commerce/schreens/history_schreen.dart';
import 'package:e_commerce/schreens/profileset_schreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingSchreen extends StatefulWidget {
  const SettingSchreen({super.key});

  @override
  State<SettingSchreen> createState() => _SettingSchreenState();
}

class _SettingSchreenState extends State<SettingSchreen> {
  AuthControllers authControllers=Get.put(AuthControllers());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AllColors.primaryColor,
        leading: InkWell(
            onTap: (){
              Get.back();
            },
            child: Icon (Icons.arrow_back,color: Colors.white,)),
        title: Text ('Settings',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(.5),
            child:ListTile(
              onTap: (){
               Get.to(()=> ProfilesetSchreen());
              },
              leading: Icon(Icons.edit),
              title: Text('Update profile'),
            ) ,
          ),

          Card(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(.5),
            child:ListTile(
              onTap: (){
                Get.to(HistorySchreen());
              },
              leading: Icon(Icons.history),
              title: Text('Payment history'),
            ) ,
          ),

          Card(
            child:ListTile(
              onTap: (){
                Get.to(LoginSchreen());
              },
              leading: Icon(Icons.login_outlined,color: Colors.red,),
              title: Text('Log out'),
            ) ,
          ),
        ],
      ),
    );
  }
}
