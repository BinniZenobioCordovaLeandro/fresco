import 'package:myapp/features/core/interfaces/abstract.repository.dart';
import 'package:myapp/features/core/repositories/mocks/requests.mock.dart';

class FirestoreRepository implements AbstractRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> model) {
    return Future.value(requestsMock[0]);
  }

  @override
  Future delete(model) {
    return Future.value();
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() {
    return Future.value(requestsMock);
  }

  @override
  Future<Map<String, dynamic>> getById(String id) {
    return Future.value(requestsMock[0]);
  }

  @override
  Future<Map<String, dynamic>> update(Map<String, dynamic> model) {
    return Future.value(requestsMock[0]);
  }
}
