import 'dart:convert';
import 'package:myapp/features/core/interfaces/abstract.repository.dart';
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
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) {
    return service.patch(baseUrl, body: jsonEncode(data));
  }

  @override
  Future delete(String id) {
    return update(id, {"status": "cancelled"});
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() {
    return service.get(baseUrl, params: {
      "createdAt": DateTime.now()
          .subtract(const Duration(days: 7))
          .millisecondsSinceEpoch,
      "status": "pending",
    });
  }

  @override
  Future<Map<String, dynamic>> getById(String id) {
    return service.get(baseUrl, params: {"id": id}).then(
      (value) => value.first,
    );
  }
}
