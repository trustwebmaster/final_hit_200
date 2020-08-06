import 'dart:convert';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'roadAngels.dart';

class Services {
  static const ROOT =
      'http://192.168.137.1/DrugsDB/drug_actions.php?action=GET_ALL';

  // Method to create the table Drugs.
  static Future<String> createTable() async {
    try {
      // add the parameters to pass to the request.

      final response = await http.get(ROOT);
      if (200 == response.statusCode) {
        return response.body;
      } else {
        return "error 1";
      }
    } catch (e) {
      return 'error-->: $e';
    }
  }

  static Future<List<Drug>> getRoadAngels() async {
    try {
      final response = await http.get(ROOT);
      print('----------------------------------------------');
      print(response.statusCode);
      print(response.body);
      print('----------------------------------------------');
      if (200 == response.statusCode) {
        List<Drug> list = parseResponse(response.body);
        return list;
      } else {
        return List<Drug>();
      }
    } catch (e) {
      return List<Drug>();
    }
  }

  static List<Drug> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Drug>((json) => Drug.fromJson(json)).toList();
  }
}
