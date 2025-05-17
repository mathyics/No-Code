import 'dart:convert';

import 'package:http/http.dart' as http;
void main() async{
  
  var url=Uri.http('localhost:8080','/api/users/login');

  var res=await 
  http
  .post(
    url,
    body: {
      "userName":"Suhail",
      "password":"Suhail",
    },
  );

  print(jsonDecode(res.body)['data']['user']);

}
