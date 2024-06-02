abstract class AbstractRepository<T> {
  Future<Map<String, dynamic>> create(Map<String, dynamic> model);
  Future<Map<String, dynamic>> update(Map<String, dynamic> model);
  Future delete(T model);
  Future<List<Map<String, dynamic>>> getAll();
  Future<Map<String, dynamic>> getById(String id);
}
