import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import '../models/host_ip.dart';

class AuthProvider with ChangeNotifier {
  String username = '';
  bool isLeader=false;
  String? token;

  bool get isAuth{
    return token!=null;
  }

  Future<String> login(String username, String password) async {
    String fullname='';
    final url = Uri.parse('$host/users/login');
    final body = json.encode({"username": username, "password": password});

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);
    final result = jsonDecode(response.body);
    if (response.statusCode == 401) {
      throw HttpException('401');
    } else if (response.statusCode == 302) {
      this.username = username;
      throw HttpException('302');
    } else {
      final user = result["User"];
      token = result["token"];
      this.username = user["username"];
      isLeader=user["leader"]=='';
      fullname=user["fullname"];
      notifyListeners();
    }
    return fullname;
  }

  Future<void> activateAccount(String key, String password) async {
    if (username.isNotEmpty) {
      final url = Uri.parse('$host/users/activate-user');
      final body =
          json.encode({"username": username, "password": password, "key": key});

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 400) {
        throw HttpException('400');
      } else if (response.statusCode == 500) {
        throw HttpException('500');
      }
    }
  }

  void logout(){
    username='';
    token=null;
    notifyListeners();
  }
}
