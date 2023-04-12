import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_up_app/services/response.dart';

class PyService {
  static const baseURLFlask = 'http://10.0.2.2:5000/';
  static const headers = {
    'Content-Type': 'application/json',
    'Connection': 'Keep-Alive',
  };

  Future<APiResponse<Map<String, dynamic>>> extractInformation() {
    print("asd");
    return http.get(Uri.parse('$baseURLFlask/test')).then((data) {
      print(data.statusCode);
      if (data.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(data.body);
        return APiResponse<Map<String, dynamic>>(
          data: jsonData,
        );
      }
      return APiResponse<Map<String, dynamic>>(
          error: true, errorMessage: "An error occured");
    }).catchError((_) => APiResponse<Map<String, dynamic>>(
        error: true, errorMessage: "An error occured"));
  }
}
