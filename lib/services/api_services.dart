import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:toksort_frontend/models/product_model.dart';

class ApiService {
  static String baseUrl = dotenv.env['BASE_URL']!;

  /// 🔥 UPLOAD CSV
  static Future<bool> uploadFile({
    required String fileName,
    String? filePath,
    List<int>? bytes,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/upload"),
      );

      if (bytes != null) {
        // ✅ WEB
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: fileName),
        );
      } else if (filePath != null) {
        // ✅ MOBILE
        request.files.add(await http.MultipartFile.fromPath('file', filePath));
      } else {
        throw Exception("File tidak valid");
      }

      final response = await request.send();

      return response.statusCode == 200;
    } catch (e) {
      print("🔥 Error upload: $e");
      return false;
    }
  }

  /// 🔥 GET DATA BY FILENAME
  static Future<List<Product>> getProducts(String filename) async {
    final url = "$baseUrl/read/${Uri.encodeComponent(filename)}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];

      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Gagal ambil data");
    }
  }

  /// 🔥 GET LATEST DATA (INI WAJIB DIPAKAI DI HOME)
  static Future<List<Product>> getLatestProducts() async {
    final url = "$baseUrl/read-latest";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final dynamic rawData = body['data'];

      List listData = [];

      if (rawData is List) {
        listData = rawData;
      } else if (rawData is Map) {
        for (var value in rawData.values) {
          if (value is List) {
            listData.addAll(value); // ambil list
          }
        }
      }

      print("🔥 FINAL LIST: $listData");

      return listData.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Gagal ambil data terbaru");
    }
  }

  /// 🔥 GET FILE LIST
  static Future<List<String>> getFiles() async {
    final res = await http.get(Uri.parse("$baseUrl/files"));

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body['data'];

      return data.cast<String>();
    } else {
      throw Exception("Gagal ambil list file");
    }
  }

  /// 🔥 DELETE FILE
  static Future<bool> deleteFile(String filename) async {
    final url = "$baseUrl/delete/${Uri.encodeComponent(filename)}";

    final res = await http.delete(Uri.parse(url));

    return res.statusCode == 200;
  }
}
