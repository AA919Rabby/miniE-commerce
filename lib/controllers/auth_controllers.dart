//controllers handle logic and states updates

import 'package:e_commerce/services/auth_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
class AuthControllers extends GetxController {
  AuthServices authServices = AuthServices();

  signUpUser(String UserName, String Email, String Password) async {
    try {
      http.Response response = await authServices.signUpUser(
          UserName, Email, Password);
      print('code ${response.statusCode}');
      if (response.statusCode == 201) {
        print('Success');
      }
      else
        print('bad gateway ${response.statusCode}');
    }
    catch (e) {
      print(e.toString());
    }
  }


  signInUser(String UserName, String Password) async {
    try {
      http.Response response = await authServices.signInUser(
          UserName, Password);
      print('code ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Success');
      }
      else
        print('bad gateway ${response.statusCode}');
    }
    catch (e) {
      print(e.toString());
    }
  }



  userUpdate(String UserName,String Email,String Password)async{
    try{
      http.Response response=await authServices.userUpdate(UserName,Email,Password);
      print('code ${response.statusCode}');
      if(response.statusCode==200){
        print('Update successful');
      }
      else
        print('bad gateway ${response.statusCode}');
    }
    catch (e){
      print(e.toString());
    }
  }

  userDelete(String userId)async {
    try{
      http.Response response=await authServices.userDelete(userId);
      print('code ${response.statusCode}');
      if(response.statusCode==200){
        print('Delete successful');
      }
      else
        print('bad gateway ${response.statusCode}');
    }
    catch(e){
      print(e.toString());
    }
  }

}


