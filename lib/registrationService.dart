import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:pharmifind/GenericResponse.dart';

class RegistrationService {
  static const ROOT = 'http://192.168.137.1/DrugsDB/register.php';
  static const _REGISTER = 'REGISTER';

  static  register(user, pass) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _REGISTER;
      map['username'] = user.toString();
      map['password'] = pass.toString();

      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode) {
        // var res = parseResponse(response.body);
        return 'success';
      } else {
        return GenRes();
      }
    } catch (e) {
      print(e);
      
      return GenRes();
    }
  }

  static GenRes parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<GenRes>((json) => GenRes.fromJson(json)).toList();
  }
}
