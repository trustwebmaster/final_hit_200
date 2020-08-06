import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:pharmifind/loginModel.dart';

class LoginService {
  static const ROOT = 'http://192.168.137.1/DrugsDB/drug_actions.php';
  static const _LOGIN_ACTION = 'LOGIN';

  static Future<List<Account>> verifyPassword(user, pass) async {
    try {
      print('AAPI HIT');
      var map = Map<String, dynamic>();
      map['action'] = _LOGIN_ACTION;
      map['username'] = user.toString();
      map['password'] = pass.toString();

      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        List<Account> list = parseResponse(response.body);
        if (list.isNotEmpty) {
          return list;
        } else {
          print("Invalid username/username");
          return list;
        }
      } else {
        print("500r");
        return List<Account>();
      }
    } catch (e) {
      print(e);
      print("API DOWN");
      return List<Account>();
    }
  }

  static List<Account> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Account>((json) => Account.fromJson(json)).toList();
  }
}
