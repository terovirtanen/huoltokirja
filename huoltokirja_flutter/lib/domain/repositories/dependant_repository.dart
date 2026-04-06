import '../models/dependant.dart';

abstract class DependantRepository {
  Future<List<Dependant>> getAll();
  Future<Dependant?> getById(int id);
  Future<Dependant> create(Dependant dependant);
  Future<Dependant> update(Dependant dependant);
  Future<void> delete(int id);
}
