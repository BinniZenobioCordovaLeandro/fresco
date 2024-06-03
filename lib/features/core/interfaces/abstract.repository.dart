abstract class AbstractRepository<T> {
  AbstractRepository(T service);
  Future<Map<String, dynamic>> create(Map<String, dynamic> data);
  Future<Map<String, dynamic>> update(Map<String, dynamic> data);
  Future delete(T data);
  Future<List<Map<String, dynamic>>> getAll();
  Future<Map<String, dynamic>> getById(String id);
}
