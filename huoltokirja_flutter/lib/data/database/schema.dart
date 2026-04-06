const dependantTable = 'dependants';
const notesTable = 'notes';
const schedulersTable = 'schedulers';

const createDependantsTable = '''
CREATE TABLE dependants (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  dependant_group TEXT NOT NULL DEFAULT 'none',
  initial_date TEXT,
  usage REAL,
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
  price REAL,
  approved INTEGER NOT NULL DEFAULT 0,
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
  interval_days INTEGER NOT NULL DEFAULT 0,
  last_completed_at TEXT,
  note_type TEXT NOT NULL DEFAULT 'plain',
  start_date TEXT NOT NULL,
  calendar_interval_months INTEGER,
  usage_interval REAL,
  usage_start_value REAL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY(dependant_id) REFERENCES dependants(id) ON DELETE CASCADE
);
''';
