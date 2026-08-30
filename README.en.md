# World Mythology System

[中文首页](README.md) · [Live explorer](https://darenyew7527.github.io/world-mythology-system/) · [Contributing](CONTRIBUTING.md) · [Discussions](https://github.com/darenyew7527/world-mythology-system/discussions)

World Mythology System is an expandable, multilingual, evidence-aware knowledge network connecting deities, heroes, creatures, artifacts, concepts, narratives, texts, sites, museum objects, and later adaptations across cultures.

The repository contains a reproducible staged knowledge baseline, not a claim of completeness. Conflicting accounts may coexist; similar names are not merged automatically; archaeological evidence, ancient texts, oral traditions, scholarship, folklore, and popular culture remain distinct knowledge layers.

## Public preview

The bilingual React explorer provides searchable entities, filters, relationship graphs, claims, evidence locators, sources, coverage, and the permanent research queue. Chinese is the default interface; English can be selected from the header.

Current `v0.26.0-story-maps-reading-routes` checkpoint:

v0.26 adds two authority-backed public-procession stories, 77 persistent event nodes, six witness-safe reading routes, and a mobile event/place timeline. Routes are editorial navigation rather than common-origin claims, and missing coordinates are never inferred.

v0.24 adds Explorer 2.0: a coordinate-evidence map, exact dataset-release timeline, entity-to-claim-to-source witness graph, release and conflict comparison, four-dimensional evidence filters, source-quality metadata, research-density heatmap, permanent-queue progress, and living-tradition access-policy views. Coordinates and chronology are never inferred for presentation.

v0.18 adds a distinct Karaijin dossier, the quoted Yamashiro Fudoki Kamo fragment, dated festival phases, Kōrin A-11189-1, and a non-merging Sōtatsu–Kōrin–Hōitsu reception network.

v0.17 expands Eleusis with two additional inscriptions, Ninnion Tablet A11036, dated Sacred Way monuments, Telesterion phase scope, and an object-preserving relief-copy network.

v0.16 adds the 1972 report dossier, XSd, official UNESCO Susa components, qualified Heliopolis and Wadi Hammamat links, and a transparent NMI 4112 authority gap.

v0.15 decomposes the statue programme into four editorially numbered hieroglyphic witnesses and two twelve-unit subject-list side sets. Ancient labels, modern numbering, language witnesses, and modern geography remain separate.

v0.14 adds Xerxes I, Susa, the Darius Gate, a qualified ancient-transfer reconstruction, the 1972 discovery event and the National Museum of Iran custody layer. Manufacture, transfer interpretation, find context, installation and modern custody remain distinct.

- 637 registered entities / 632 browsable canonical entities
- 99 civilizations and traditions
- 203 source records
- 612 structured claims and 608 evidence records
- 484 direct relationship assertions
- 23 readable stories / 25 witness versions / 77 bilingual sections / 6 reading routes
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
