BEGIN IMMEDIATE;

-- v0.29 reader state is deliberately outside the public research database.
-- This registry records the delivery/privacy contract, not personal activity.
CREATE TABLE IF NOT EXISTS reader_feature_registry (
    feature_code TEXT PRIMARY KEY,
    title_zh TEXT NOT NULL,
    title_en TEXT NOT NULL,
    storage_scope TEXT NOT NULL
        CHECK(storage_scope IN ('LOCAL_ONLY','STATIC_PUBLIC_ARTIFACT')),
    public_database_writes INTEGER NOT NULL DEFAULT 0
        CHECK(public_database_writes = 0),
    personal_data_collection INTEGER NOT NULL DEFAULT 0
        CHECK(personal_data_collection = 0),
    offline_capable INTEGER NOT NULL DEFAULT 0 CHECK(offline_capable IN (0,1)),
    print_capable INTEGER NOT NULL DEFAULT 0 CHECK(print_capable IN (0,1)),
    introduced_in TEXT NOT NULL,
    privacy_note TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_reader_feature_scope
    ON reader_feature_registry(storage_scope, feature_code);

INSERT OR IGNORE INTO reader_feature_registry(
    feature_code,title_zh,title_en,storage_scope,public_database_writes,
    personal_data_collection,offline_capable,print_capable,introduced_in,privacy_note
) VALUES
('LOCAL_BOOKMARKS','本机书签','On-device bookmarks','LOCAL_ONLY',0,0,0,0,'v0.29.0-dev','Only story IDs are stored in the browser-local versioned state key.'),
('LOCAL_READING_PROGRESS','本机阅读进度','On-device reading progress','LOCAL_ONLY',0,0,0,0,'v0.29.0-dev','Section order and update time stay on the reader device and are never exported.'),
('ACCESSIBLE_READER_SETTINGS','无障碍阅读设置','Accessible reader settings','LOCAL_ONLY',0,0,0,0,'v0.29.0-dev','Font scale, line spacing and high contrast are local presentation preferences.'),
('GLOSSARY_QUICK_LOOK','术语与人物速查','Glossary and character quick look','LOCAL_ONLY',0,0,0,0,'v0.29.0-dev','Quick-look terms are derived at render time from the public story snapshot.'),
('OFFLINE_PRINT_ARCHIVE','离线打印故事档案','Offline printable story archive','STATIC_PUBLIC_ARTIFACT',0,0,1,1,'v0.29.0-dev','Self-contained HTML and JSON contain public source-scoped summaries only; no reading state is embedded.');

INSERT OR IGNORE INTO explorer_feature_registry(
    feature_code,title_zh,title_en,feature_group,data_basis,evidence_caveat,
    status,introduced_in,display_order,updated_at,notes
) VALUES
('reader_local_state','本机阅读工具','On-device reader tools','STORY_READING','Versioned browser localStorage containing bookmarks, section progress and presentation settings only.','Local state is not evidence and never enters SQLite, JSONL, CSV or the public snapshot.','ACTIVE','v0.29.0-dev',300,'2026-09-02T02:41:44Z','No account, telemetry or cloud synchronization.'),
('offline_story_archive','离线故事档案','Offline story archive','STORY_READING','Generated from the same browser-safe story snapshot used by the public explorer.','The archive preserves source, locator, evidence-note and rights boundaries; it does not reproduce evidence short quotes.','ACTIVE','v0.29.0-dev',310,'2026-09-02T02:41:44Z','Self-contained HTML is searchable, bilingual and print-friendly; JSON is supplied for inspection.');

INSERT INTO project_metadata(key,value,updated_at) VALUES
('project_version','0.29.0-reader-offline-archive-dev','2026-09-02T02:41:44Z'),
('data_version','0.29.0-dev','2026-09-02T02:41:44Z'),
('schema_version','39','2026-09-02T02:41:44Z'),
('generated_at','2026-09-02T02:41:44Z','2026-09-02T02:41:44Z'),
('project_status','v0.29.0 development checkpoint: on-device reader state and public offline archive; latest sealed release remains v0.28.0','2026-09-02T02:41:44Z')
ON CONFLICT(key) DO UPDATE SET value=excluded.value,updated_at=excluded.updated_at;

INSERT INTO schema_migrations(version,name,applied_at)
VALUES(39,'20260902_v0290_reader_offline_archive','2026-09-02T02:41:44Z');

COMMIT;
