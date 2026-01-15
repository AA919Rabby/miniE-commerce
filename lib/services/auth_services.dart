//services handle backend and api calls


import 'dart:convert';
import 'package:e_commerce/const/base_url.dart';
import 'package:http/http.dart' as http;
class AuthServices {
  Future<http.Response> signUpUser(String UserName, String Email, String Password) async {

    String url = '${BaseUrl.baseUrl}users';
    Map body = {
      'Username': 'UserName',
      'Email': 'Email',
      'Password': 'Password',
    };
    http.Response response = await http.post(

        Uri.parse(url),
        body: json.encode(body)

    );

    return response;
  }

  Future<http.Response> signInUser(String UserName,String Password)async{

    String url='${BaseUrl.baseUrl}auth/login';
    Map body={
      'Username':'UserName',
      'Password':'Password',
    };
    http.Response response=await http.post(
        Uri.parse(url),
        body:json.encode(body)
    );
    return response;
  }


  Future<http.Response> userUpdate(String UserName, String Email, String Password) async {
    int userId=1;

    String url = '${BaseUrl.baseUrl}users/${userId.toString()}';
    Map body = {
      'Username': 'UserName',
      'Email': 'Email',
      'Password': 'Password',
    };
    http.Response response = await http.put(

        Uri.parse(url),
        body: json.encode(body)

    );

    return response;
  }



  Future<http.Response>userDelete(String userId) async{
    //using baseUrl for add the endpoint users
    String url = '${BaseUrl.baseUrl}users/${userId.toString()}';

    http.Response response = await http.delete(
      //Uri for http request and understand
      Uri.parse(url),
      //encode to send json format from dart format
      //decode to covert the json format into dart format
    );
    //we send response because this response store the values
    return response;
  }

}

