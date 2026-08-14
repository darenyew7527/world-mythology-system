# World Mythology System

[中文首页](README.md) · [Live explorer](https://darenyew7527.github.io/world-mythology-system/) · [Contributing](CONTRIBUTING.md) · [Discussions](https://github.com/darenyew7527/world-mythology-system/discussions)

World Mythology System is an expandable, multilingual, evidence-aware knowledge network connecting deities, heroes, creatures, artifacts, concepts, narratives, texts, sites, museum objects, and later adaptations across cultures.

The repository contains a reproducible staged knowledge baseline, not a claim of completeness. Conflicting accounts may coexist; similar names are not merged automatically; archaeological evidence, ancient texts, oral traditions, scholarship, folklore, and popular culture remain distinct knowledge layers.

## Public preview

The bilingual React explorer provides searchable entities, filters, relationship graphs, claims, evidence locators, sources, coverage, and the permanent research queue. Chinese is the default interface; English can be selected from the header.

Current `v0.5.1-mobile-graph-hotfix` checkpoint:

- 468 registered entities / 463 browsable canonical entities
- 95 civilizations and traditions
- 100 source records
- 221 structured claims and 215 evidence records
- 193 direct relationship assertions
- A bilingual genealogy mode for parents, children, siblings, consorts, and their evidence
- Structured deity, artifact, text, place, creature, and event profiles in the entity view

v0.5.1 fixes clipped mobile graph nodes, target-relative genealogy labels, selected-entity centering, and iPhone safe-area spacing. The mythology data remains on the same v0.5.0 evidence baseline. See the [v0.5.1 release notes](RELEASE_NOTES_v0.5.1.md) and [v0.5.0 research expansion notes](RELEASE_NOTES_v0.5.0.md).

These are release checkpoint counts, not project limits.

## Run locally

```bash
python3 scripts/generate_web_data.py
cd web
npm install
npm run dev
```

Run the data pipeline and tests:

```bash
python3 scripts/run_pipeline.py
python3 -m unittest discover -s tests -v
```

The normal pipeline migrates, validates, exports, and refreshes the existing database without overwriting accumulated research. Use `--init` only when the database is absent; `--rebuild` explicitly restores the seed baseline.

## Repository map

- `database/`: persistent SQLite checkpoint
- `schema/`: canonical schema
- `exports/`: complete JSONL, CSV, and graph exports
- `profiles/`: readable generated profiles
- `reports/`: coverage, source registry, conflicts, gaps, and QA
- `web/`: public React/Vite explorer
- `scripts/`: migration, validation, import, export, and report automation
- `tests/`: persistence, graph, source, and public-export regression tests

See [Methodology](docs/METHODOLOGY.md), [Data dictionary](docs/DATA_DICTIONARY.md), [Data license](DATA_LICENSE.md), and [Contributing](CONTRIBUTING.md).

## License

Code is MIT licensed. Original structured metadata and research summaries are CC BY 4.0. Third-party media, modern editions and translations, source databases, and community-governed living-tradition knowledge retain their original rights and permissions.
