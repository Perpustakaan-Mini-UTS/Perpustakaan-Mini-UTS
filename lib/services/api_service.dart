import 'package:dio/dio.dart';
import '../models/catalog_model.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<CatalogModel>> fetchCatalog() async {
    try {
      final response = await _dio.get('/posts');
      final List data = response.data;
      return data.map((json) => CatalogModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_friendlyMessage(e));
    }
  }

  String _friendlyMessage(DioException e) {
    final status = e.response?.statusCode;
    if (status != null && status >= 500) {
      return 'Server error ($status). Coba lagi nanti!';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout: Server tidak merespon. Periksa koneksi internet!';
      case DioExceptionType.connectionError:
        return 'Tidak ada koneksi Internet. Silakan cek kuota/wifi!';
      default:
        return e.message ?? 'Gagal mengambil data dari server.';
    }
  }
}
