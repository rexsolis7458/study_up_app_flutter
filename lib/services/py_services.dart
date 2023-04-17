import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:study_up_app/services/response.dart';

class PyService {
  static const baseURLFlask = 'http://172.29.9.53';
  static const headers = {
    'Content-Type': 'application/json',
    'Connection': 'Keep-Alive',
  };

  Future<APiResponse<Map<String, dynamic>>> extractInformation() {
    print('$baseURLFlask/test');
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
Future<APiResponse<String>> flaskTest(String id) {
    return http
        .get(Uri.parse("${baseURLFlask}/api?query=$id"), headers: headers)
        .then((data) {
      if (data.statusCode == 200) {
        final jsonData = jsonDecode(data.body);
        return APiResponse<String>(
          data: jsonData.toString(),
        );
      }
      return APiResponse<String>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError((_) =>
            APiResponse<String>(error: true, errorMessage: "An error occured"));
 }

}
