# World Mythology System

[中文首页](README.md) · [Live explorer](https://darenyew7527.github.io/world-mythology-system/) · [Contributing](CONTRIBUTING.md) · [Discussions](https://github.com/darenyew7527/world-mythology-system/discussions)

World Mythology System is an expandable, multilingual, evidence-aware knowledge network connecting deities, heroes, creatures, artifacts, concepts, narratives, texts, sites, museum objects, and later adaptations across cultures.

The repository contains a reproducible staged knowledge baseline, not a claim of completeness. Conflicting accounts may coexist; similar names are not merged automatically; archaeological evidence, ancient texts, oral traditions, scholarship, folklore, and popular culture remain distinct knowledge layers.

## Public preview

The bilingual React explorer provides searchable entities, filters, relationship graphs, claims, evidence locators, sources, coverage, and the permanent research queue. Chinese is the default interface; English can be selected from the header.

Current `v0.10.0-japanese-thunder-local-dossiers` checkpoint:

- 558 registered entities / 553 browsable canonical entities
- 95 civilizations and traditions
- 160 source records
- 389 structured claims and 385 evidence records
- 355 direct relationship assertions
- A bilingual genealogy mode for parents, children, siblings, consorts, and their evidence
- An evidence-led comparison of Thor, Zeus, Indra, Raijin, Takemikazuchi, Leigong, the Leize thunder spirit, Perun, Ṣàngó, and Ugaritic Baʿlu/Haddu
- Structured deity, artifact, text, place, creature, and event profiles in the entity view

v0.10 adds the local Kamo Wakeikazuchi genealogy, Kamigamo Shrine, the Kamo/Aoi Festival, Kamo Kurabeuma, and the Sotatsu Wind and Thunder God screens. Fragmentary textual genealogy, living public practice, real heritage, and later visual reception remain separate layers. See the [v0.10 release notes](RELEASE_NOTES_v0.10.0.md).

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
