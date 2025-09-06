// lib/features/api/repo/Api.service.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'IApi.service.dart';

class ApiService implements IApiService {
  final Dio _dio;
  ApiService(this._dio);

  static final _reqOpts = Options(
    sendTimeout: Duration(seconds: 5),
    receiveTimeout: Duration(seconds: 5),
  );

  @override
  Future<Either<String, List>> fetchNotes() async {
    try {
      final resp = await _dio.get('/notes/', options: _reqOpts);
      if (resp.statusCode == 200 && resp.data is List) {
        return Right(resp.data as List);
      }
      return Left('Beklenmeyen yanıt: ${resp.statusCode}');
    } on DioException catch (e) {
      return Left(_errMsg(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> saveNotes(String title, String content) async {
    try {
      final resp = await _dio.post(
        '/notes/',
        data: {'title': title, 'content': content},
        options: _reqOpts,
      );
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return Right(resp.data['id'] as String);
      }
      return Left('Kaydedilemedi: ${resp.statusCode}');
    } on DioException catch (e) {
      return Left(_errMsg(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> updateNotes(
    String id,
    String title,
    String content,
  ) async {
    try {
      final resp = await _dio.put(
        '/notes/$id',
        data: {'id': id, 'title': title, 'content': content},
        options: _reqOpts,
      );
      if (resp.statusCode == 200) {
        return const Right(unit);
      }

      return Left('Güncellenemedi: ${resp.statusCode}');
    } on DioException catch (e) {
      return Left(_errMsg(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> deleteNotes(String id) async {
    try {
      final resp = await _dio.delete('/notes/$id', options: _reqOpts);
      if (resp.statusCode == 200 || resp.statusCode == 204) {
        return const Right(unit);
      }
      return Left('Silinemedi: ${resp.statusCode}');
    } on DioException catch (e) {
      return Left(_errMsg(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  String _errMsg(DioException e) {
    final sc = e.response?.statusCode;
    final data = e.response?.data;
    final body = data is Map
        ? (data['detail'] ?? data.toString())
        : (data is List ? data.join(' | ') : data?.toString());
    return sc != null
        ? 'HTTP $sc: ${body ?? e.message}'
        : (e.message ?? 'Ağ hatası');
  }
}
