import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:plproject/settings/connection.dart';

class StorageService {
  static const String _baseUrl = Connection.emulator_baseUrl;

  Future<String> uploadImage(String filePath) async {
    final file = File(filePath);
    final uri = Uri.parse('$_baseUrl/upload-image'); // Assuming this is the endpoint

    var request = http.MultipartRequest('POST', uri);
    request.headers['Accept'] = 'application/json';
    
    request.files.add(await http.MultipartFile.fromPath(
      'image', // The field name the backend expects for the file
      file.path
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final json = jsonDecode(responseData);
      return json['url'] as String;
    } else {
      final errorBody = await response.stream.bytesToString();
      throw Exception('Failed to upload image. Status: ${response.statusCode}, Body: $errorBody');
    }
  }
}
