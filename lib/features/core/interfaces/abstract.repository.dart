abstract class AbstractRepository<T> {
  AbstractRepository(T service);
  Future<Map<String, dynamic>> create(Map<String, dynamic> data);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data);
  Future delete(String id);
  Future<List<Map<String, dynamic>>> getAll();
  Future<Map<String, dynamic>> getById(String id);
}
