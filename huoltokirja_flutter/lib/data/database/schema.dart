const dependantTable = 'dependants';
const notesTable = 'notes';
const schedulersTable = 'schedulers';

const createDependantsTable = '''
CREATE TABLE dependants (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  birth_date TEXT,
  relation TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
''';

const createNotesTable = '''
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dependant_id INTEGER NOT NULL,
  type TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  service_date TEXT,
  inspector_name TEXT,
  estimated_counter INTEGER,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(dependant_id) REFERENCES dependants(id) ON DELETE CASCADE
);
''';

const createSchedulersTable = '''
CREATE TABLE schedulers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dependant_id INTEGER NOT NULL,
  label TEXT NOT NULL,
  interval_days INTEGER NOT NULL,
  last_completed_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(dependant_id) REFERENCES dependants(id) ON DELETE CASCADE
);
''';
