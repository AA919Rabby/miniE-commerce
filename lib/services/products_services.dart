//services handle backend and api calls

import 'dart:convert';
import 'package:e_commerce/const/base_url.dart';
import 'package:e_commerce/models/cart_model.dart';
import 'package:http/http.dart'as http;

class ProductsServices{

  Future<http.Response> getProducts ()async{
    String url='${BaseUrl.baseUrl}Products';

    http.Response response=await http.get(
        Uri.parse(url),
    );
    return response;
  }


  Future<http.Response> postOrder (CartModel cart)async{
    String url='${BaseUrl.baseUrl}carts';

    http.Response response=await http.post(
        Uri.parse(url),
        headers: {'Content-type':'application/json'},
        body: jsonEncode(cart.toJson())
    );
    return response;
  }

}