abstract class Failure {
  final String message;
  const Failure(this.message);
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure(super.message);
}

class DuplicateEntryFailure extends Failure {
  const DuplicateEntryFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
class SupabaseDatabaseFailure extends Failure {
  const SupabaseDatabaseFailure(super.message);
}

class MachineMismatchFailure extends Failure {
  const MachineMismatchFailure(super.message);
}