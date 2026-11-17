import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/umkm.dart';

/// Service untuk komunikasi dengan REST API backend CI4.
/// Menggunakan package http untuk HTTP requests dan dart:convert untuk JSON parsing.
class ApiService {
  // Base URL backend CI4 — sesuaikan dengan environment:
  //   - Android Emulator : http://10.0.2.2:8080/api
  //   - iOS Simulator    : http://localhost:8080/api
  //   - Device fisik     : http://<IP_KOMPUTER>:8080/api
  static const String baseUrl = 'http://localhost:8080/api';

  /// Headers default untuk JSON request
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ─────────────────────────────────────────────── GET ALL (Read)
  /// Ambil daftar UMKM dari API.
  /// Mendukung pencarian (?q) dan filter kategori (?kategori).
  Future<List<Umkm>> getUmkmList({String? query, String? kategori}) async {
    // Bangun query parameters
    final Map<String, String> params = {'per_page': '100'};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (kategori != null && kategori.isNotEmpty) params['kategori'] = kategori;

    final uri = Uri.parse('$baseUrl/umkm').replace(queryParameters: params);

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      // JSON Parsing: decode response body → Map → List<Umkm>
      final Map<String, dynamic> body = jsonDecode(response.body);

      if (body['success'] == true) {
        final List<dynamic> dataList = body['data'] as List<dynamic>;
        return dataList
            .map((json) => Umkm.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(body['message'] ?? 'Gagal mengambil data');
      }
    } else {
      throw Exception('HTTP Error: ${response.statusCode}');
    }
  }

  // ─────────────────────────────────────────────── GET BY ID (Read)
  /// Ambil detail satu UMKM berdasarkan ID.
  Future<Umkm> getUmkmById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/umkm/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['success'] == true) {
        return Umkm.fromJson(body['data']);
      }
      throw Exception(body['message']);
    }
    throw Exception('HTTP Error: ${response.statusCode}');
  }

  // ─────────────────────────────────────────────── POST (Create)
  /// Tambah data UMKM baru ke API.
  Future<Umkm> createUmkm(Umkm umkm) async {
    final response = await http.post(
      Uri.parse('$baseUrl/umkm'),
      headers: _headers,
      body: jsonEncode(umkm.toJson()), // Serialization: Dart → JSON
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201 && body['success'] == true) {
      return Umkm.fromJson(body['data']);
    } else {
      // Ambil pesan error dari response
      final errors = body['errors'] as Map<String, dynamic>?;
      final errorMsg =
          errors?.values.join('\n') ?? body['message'] ?? 'Gagal menambahkan';
      throw Exception(errorMsg);
    }
  }

  // ─────────────────────────────────────────────── PUT (Update)
  /// Update data UMKM berdasarkan ID.
  Future<Umkm> updateUmkm(int id, Umkm umkm) async {
    final response = await http.put(
      Uri.parse('$baseUrl/umkm/$id'),
      headers: _headers,
      body: jsonEncode(umkm.toJson()),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return Umkm.fromJson(body['data']);
    } else {
      final errors = body['errors'] as Map<String, dynamic>?;
      final errorMsg =
          errors?.values.join('\n') ?? body['message'] ?? 'Gagal memperbarui';
      throw Exception(errorMsg);
    }
  }

  // ─────────────────────────────────────────────── DELETE (Delete)
  /// Hapus data UMKM berdasarkan ID.
  Future<bool> deleteUmkm(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/umkm/$id'),
      headers: _headers,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['success'] == true) {
      return true;
    } else {
      throw Exception(body['message'] ?? 'Gagal menghapus');
    }
  }
}
