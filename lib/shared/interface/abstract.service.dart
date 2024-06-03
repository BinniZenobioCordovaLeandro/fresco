abstract class AbstractService {
  AbstractService();
  Future<List<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, dynamic>? params,
  });
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? params, required String body});
  Future<Map<String, dynamic>> patch(String endpoint,
      {Map<String, dynamic>? params, required String body});
  Future delete(String endpoint, {Map<String, dynamic>? params});
}
