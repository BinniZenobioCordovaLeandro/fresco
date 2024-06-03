import 'dart:convert';

import 'package:myapp/features/core/interfaces/abstract.repository.dart';
import 'package:myapp/features/core/repositories/mocks/requests.mock.dart';
import 'package:myapp/shared/interface/abstract.service.dart';

class RequestRepository implements AbstractRepository {
  final AbstractService service;
  final String baseUrl = 'requests';

  @override
  RequestRepository(this.service);

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> data) {
    return service.post(baseUrl, body: jsonEncode(data));
  }

  @override
  Future<Map<String, dynamic>> update(Map<String, dynamic> data) {
    return Future.delayed(
      const Duration(seconds: 3),
      () => requestsMock[0],
    );
  }

  @override
  Future delete(data) {
    return Future.delayed(
      const Duration(seconds: 3),
      () => null,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() {
    return service.get(baseUrl);
  }

  @override
  Future<Map<String, dynamic>> getById(String id) {
    return service.get(baseUrl, params: {"id": id}).then(
      (value) => value.first,
    );
  }
}
