import '../models/scheduler.dart';

abstract class SchedulerRepository {
  Future<List<Scheduler>> listByDependant(int dependantId);
  Future<Scheduler?> getById(int id);
  Future<Scheduler> create(Scheduler scheduler);
  Future<Scheduler> update(Scheduler scheduler);
  Future<void> delete(int id);
}
