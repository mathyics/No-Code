import 'dart:async';
import 'dart:convert';
import 'dart:developer' show log;
import 'package:get/get.dart';
import 'package:no_code/network/http_exception_handler.dart' show HttpExceptionHandler;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';


import '../../models/User/user.dart';
import '../../network/response_handler.dart';
import '../../network/uri.constants.dart';

class AuthController extends GetxController{

  late final Rx<User> user;
  String my_ref_token="";

  // static const headers={
  // 'Authorization': 'Bearer $my_ref_token',
  // };

  /// {"statusCode":200,"data":{"user":{"_id":"681b4849995d33c7b494580a","userName":"suhail","email":"suhailsharieffsharieff@gmail.com","fullName":"Suhail Beta","avatar":"http://res.cloudinary.com/diioxxov8/image/upload/v1746689778/j39fjsnrsg3knsvhuvjy.png","coverImage":"http://res.cloudinary.com/diioxxov8/image/upload/v1746618441/trdzp2sfy0oupddvaftn.jpg","watchHistory":[],"password":"$2b$10$CZaKeNYM5HVTjlJxds4wBOIsG.B4cn81tKuBWHal.cbRrG7g8y04y","createdAt":"2025-05-07T11:47:21.772Z","updatedAt":"2025-05-11T16:36:54.933Z","__v":0,"refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODFiNDg0OTk5NWQzM2M3YjQ5NDU4MGEiLCJpYXQiOjE3NDY5ODE0MTQsImV4cCI6MTc0NzU4NjIxNH0.uiqzxlCqHxoqiiqZogGUJlESKJq_utM-_VxB6mF_v_Y"},"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODFiNDg0OTk5NWQzM2M3YjQ5NDU4MGEiLCJlbWFpbCI6InN1aGFpbHNoYXJpZWZmc2hhcmllZmZAZ21haWwuY29tIiwiZnVsbE5hbWUiOiJTdWhhaWwgQmV0YSIsImlhdCI6MTc0Njk4MTg0MSwiZXhwIjoxNzQ3MDY4MjQxfQ.HjhhrLhHj97LPgLjO4y6YVY5mEM1N4GJ2Ung2d45aWk","refreshToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODFiNDg0OTk5NWQzM2M3YjQ5NDU4MGEiLCJpYXQiOjE3NDY5ODE4NDEsImV4cCI6MTc0NzU4NjY0MX0.LKHAlqNUFZ-etDSPQQIsTlZuyTdA-ugkyYl9DrAPJVc"},"message":"Login session created!","success":true}
   Future<User?> loginWithEmailAndPassword(String? email,
      String? password,
      String? userName,
      BuildContext context,) async {
    try {
      var url = Uri.http(main_uri, '/api/users/login');
      var res = await http
          .post(
        url,
        body: {"userName": userName, "password": password, "email": email},

      )
          .timeout(const Duration(seconds: 5));
      if (!ResponseHandler.is_good_response(res, context)) {
        return null;
      }
      var json = jsonDecode(res.body)['data']['user'];
      var user = User.fromJson(json);
      // log('Logged in user: ${user.toString()}');

      this.user=User.fromJson(json).obs;


      //save user
      final refreshToken=json['refreshToken'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('refreshToken', refreshToken);
      my_ref_token=refreshToken;
      final v=await isLoggedIn(context);
      log('login status: $v');


      return user;

    } on Exception catch (e) {
      HttpExceptionHandler.handle(e, context);
    }
    return null;
  }

  Future<bool> isLoggedIn(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('refreshToken');
    } on Exception catch (e) {
      HttpExceptionHandler.handle(e, context);
    }
    return false;
  }


  Future<bool> logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      var url=Uri.http(main_uri,'/api/users/logout');
      // log('logout out using ref token: $my_ref_token');
      var res=await http.post(url,headers:
      {
        'authorization': 'Bearer $my_ref_token'
      });
      if(ResponseHandler.is_good_response(res, context)){
        return true;
      }

    } on Exception {
      HttpExceptionHandler.handle(Exception("Cant logout!"), context);
    }
    return false;
  }


  Future<bool>updatePassword(BuildContext context,String oldPassword,String newPassword) async {
    try {
      var url=Uri.http(main_uri,'/api/users/updatePassword');
      // log('logout out using ref token: $my_ref_token');
      var res=await http.post(url,
          body: {
            'oldPassword':oldPassword,
            'newPassword':newPassword,
          },
          headers:
      {
        'authorization': 'Bearer $my_ref_token'
      });

      if(ResponseHandler.is_good_response(res, context)){
        user.value=user.value.copyWith(password: newPassword);
        return true;
      }
    } on Exception catch (e) {
      HttpExceptionHandler.handle(e, context );
    }
    return false;
  }


  Future<bool>updateFullName(BuildContext context,String newFullName) async {
    try {
      var url=Uri.http(main_uri,'/api/users/updateFullName');
      // log('logout out using ref token: $my_ref_token');
      var res=await http.post(url,
          body: {'newFullName':newFullName},
          headers:
      {
        'authorization': 'Bearer $my_ref_token'
      });

      if(ResponseHandler.is_good_response(res, context)){
        user.value=user.value.copyWith(fullName: newFullName);
        return true;
      }
    } on Exception catch (e) {
      HttpExceptionHandler.handle(e, context );
    }
    return false;
  }


  Future<bool> registerUser(BuildContext context,
      String? email,
      String? password,
      String? userName,
      String? fullName,
      XFile? profileImage,
      XFile? coverImage,) async {
    try {
      var uri = Uri.http(main_uri, '/api/users/register');
      final request = http.MultipartRequest('POST', uri);

      request.fields['email'] = email ?? '';
      request.fields['userName'] = userName ?? '';
      request.fields['password'] = password ?? '';
      request.fields['fullName'] = fullName ?? '';

      if (profileImage != null && profileImage.path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            profileImage.path,
            contentType: MediaType('image', 'jpeg'), // or 'png' if applicable
          ),
        );
      }

// Cover Image
      if (coverImage != null && coverImage.path.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'coverImage',
            coverImage.path,
            contentType: MediaType('image', 'jpeg'), // or 'png' if applicable
          ),
        );
      }

      final response = await request.send().timeout(
          const Duration(seconds: 10));

      if (response.statusCode == 200) {
        log('User registered successfully');
        return true;
      } else {
        HttpExceptionHandler.handle(Exception("Registration failed"), context);
      }
    } on Exception catch (e) {
      HttpExceptionHandler.handle(e, context);
    }
    return false;
  }


  Future<String>getAPIRes(BuildContext context,String input)async{
     try{
       var url=Uri.http(main_uri,'/api/users/getAPIRes');
       // log('logout out using ref token: $my_ref_token');
       var res=await http.post(url,
           body: {'input':input},
           headers:
           {
             'authorization': 'Bearer $my_ref_token'
           });

         // print("${res.body.toString()} helo world");
         return res.body.toString();
     }on Exception catch(e){
       HttpExceptionHandler.handle(e, context);
     }
     return "Server is down pls try again later!";
  }

}
