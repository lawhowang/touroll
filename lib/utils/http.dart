import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class HttpUtils {
  //static String idToken;
  static _buildUrl(String path, [Map<String, dynamic> queryParams]) {
    if (kReleaseMode || true) {
      if (queryParams != null)
        queryParams.forEach((key, value) => queryParams[key] =
            value is List ? value.join(',') : value?.toString());

      final uri = Uri.https('acjut00sil.execute-api.us-east-1.amazonaws.com',
          join('dev', path), queryParams);
      print(uri);
      return uri;
    } else {
      return Uri.http('localhost:3000', path, queryParams);
    }
  }

  static _buildHeaders() async {
    String idToken;
    try {
      idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    } catch (ex) {
      print(ex);
    }
    return <String, String>{
      'Content-Type': 'application/json',
      ...idToken != null ? {'Authorization': 'Bearer $idToken'} : {}
    };
  }

  static Future<dynamic> postData(
      String path, Map<String, dynamic> data) async {
    try {
      print(jsonEncode(data));
      final response = await http.post(
        _buildUrl(path),
        headers: await _buildHeaders(),
        body: jsonEncode(data),
      );
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return false;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  static Future<dynamic> patchData(
      String path, Map<String, dynamic> data) async {
    try {
      print(jsonEncode(data));
      final response = await http.patch(
        _buildUrl(path),
        headers: await _buildHeaders(),
        body: jsonEncode(data),
      );
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return false;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  static Future<dynamic> getData(String path,
      [Map<String, dynamic> queryParams]) async {
    try {
      final response = await http.get(
        _buildUrl(path, queryParams),
        headers: await _buildHeaders(),
      );
      //print(_buildUrl(path, queryParams));
      print(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return false;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  static Future<dynamic> deleteData(String path) async {
    try {
      final response = await http.delete(
        _buildUrl(path),
        headers: await _buildHeaders(),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return false;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }

  static Future<dynamic> upload(String url, File file) async {
    try {
      final response = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'image/jpeg',
            "Content-Length": file.lengthSync().toString(),
          },
          body: file.readAsBytesSync());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex.toString());
      return false;
    }
  }
}
