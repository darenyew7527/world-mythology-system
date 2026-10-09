# World Mythology System

[中文首页](README.md) · [Live explorer](https://darenyew7527.github.io/world-mythology-system/) · [Contributing](CONTRIBUTING.md) · [Discussions](https://github.com/darenyew7527/world-mythology-system/discussions)

World Mythology System is an expandable, multilingual, evidence-aware knowledge network connecting deities, heroes, creatures, artifacts, concepts, narratives, texts, sites, museum objects, and later adaptations across cultures.

The repository contains a reproducible staged knowledge baseline, not a claim of completeness. Conflicting accounts may coexist; similar names are not merged automatically; archaeological evidence, ancient texts, oral traditions, scholarship, folklore, and popular culture remain distinct knowledge layers.

## Public preview

> 📖 **Read now**: [Deity story collection (all 184 deities)](profiles/stories/deities/index.md) · [Story dossiers (55 stories)](profiles/stories/index.md) · [Live explorer](https://darenyew7527.github.io/world-mythology-system/?view=deities)

The bilingual React explorer provides searchable entities, filters, relationship graphs, claims, evidence locators, sources, coverage, and the permanent research queue. Chinese is the default interface; English can be selected from the header.

Current sealed release: `v0.31.0-deity-stories`.

v0.31 gives every deity a story to tell. The 54 deities that had no claims now have 26 new source-located stories or evidence cards — from the Heliopolitan family, the Tale of the Heavenly Cow and the weighing of Ani's heart to Izanagi and Izanami, the Vanir, Týr and Fenrir, Huitzilopochtli's birth at Coatepec, Enki and Ninhursaĝa, Fuxi's trigrams, the Yellow Emperor and Chiyou, Pangu in the Sanwu liji, the Second Battle of Mag Tuired, the Kyiv idols, the Mihr Yasht and Videvdad 1, an attributed account of Pele's journey and Te Ara's common threads of Māori creation. Journey to the West stays in the later-reception layer, and Ogun and Olodumare remain permission-limited. The explorer adds a deity-story gallery (184 cards: 111 full stories, 71 evidence cards, 2 permission-limited), a full-screen storyteller mode with keyboard and swipe navigation, a story card in each deity profile, and a readable minimum type size. See [the v0.31 release notes](RELEASE_NOTES_v0.31.0.md).

v0.30 completes the two targets that v0.28 left queued. Nüwa repairing the sky is read separately in Huainanzi “Lan Ming” and Liezi “Tang Wen”; a companion story keeps Gonggong striking Mount Buzhou in Huainanzi “Tian Wen” apart from the Liezi passage that places it *after* the repair. The churning of the ocean is registered from the Mahābhārata critical edition (Ādiparvan 1.15–1.17) and the Bhāgavata Purāṇa (8.5–8.9): the tortoise king Akūpāra and Viṣṇu's Kūrma form stay separate as an explicit witness conflict, and Śiva drinking the poison is recorded as `NOT_STATED` at the critical-edition locator rather than as counter-evidence. The Angkor Wat relief is cross-referenced without inferring its recension. Later causal retellings and the critical apparatus are queued, and Māori plus Yorùbá/Ifá remain permission-blocked only within their own targets. See [the v0.30 release notes](RELEASE_NOTES_v0.30.0.md).

v0.29 adds on-device bookmarks, per-version section progress, accessible text controls, glossary/character quick look, and a self-contained bilingual offline/print archive. Personal reading state never enters SQLite, exports, or the public snapshot. See [the v0.29 release notes](RELEASE_NOTES_v0.29.0.md).

v0.28 adds a public K'iche'-context Hero Twins and Seven Macaw episode, two separately sourced Kusanagi layers (a university academic synopsis and Atsuta Jingu's public tradition), and the Angkor Wat Churning relief as a Khmer material witness. Of seven independently audited targets, three are complete, China and India remain queued, and Māori plus Yorùbá/Ifá are permission-blocked only within their own targets. These open states remain part of the formal checkpoint rather than an `ALL COMPLETE` claim. See [the v0.28 release notes](RELEASE_NOTES_v0.28.0.md).

v0.27 introduces item-by-item comparison for four independent witnesses to the Aphrodite-origin and Ask/Embla stories. Seven comparison topics and fourteen witness members expose original forms, transliterations, languages, source locators, rights boundaries, and explicit `NOT_STATED` / `UNMODELED` states. The Theogony is not merged with the Iliad, and Völuspá is not merged with Gylfaginning.

v0.26 adds two authority-backed public-procession stories, 77 persistent event nodes, six witness-safe reading routes, and a mobile event/place timeline. Routes are editorial navigation rather than common-origin claims, and missing coordinates are never inferred.

v0.24 adds Explorer 2.0: a coordinate-evidence map, exact dataset-release timeline, entity-to-claim-to-source witness graph, release and conflict comparison, four-dimensional evidence filters, source-quality metadata, research-density heatmap, permanent-queue progress, and living-tradition access-policy views. Coordinates and chronology are never inferred for presentation.

v0.18 adds a distinct Karaijin dossier, the quoted Yamashiro Fudoki Kamo fragment, dated festival phases, Kōrin A-11189-1, and a non-merging Sōtatsu–Kōrin–Hōitsu reception network.

v0.17 expands Eleusis with two additional inscriptions, Ninnion Tablet A11036, dated Sacred Way monuments, Telesterion phase scope, and an object-preserving relief-copy network.

v0.16 adds the 1972 report dossier, XSd, official UNESCO Susa components, qualified Heliopolis and Wadi Hammamat links, and a transparent NMI 4112 authority gap.

v0.15 decomposes the statue programme into four editorially numbered hieroglyphic witnesses and two twelve-unit subject-list side sets. Ancient labels, modern numbering, language witnesses, and modern geography remain separate.

v0.14 adds Xerxes I, Susa, the Darius Gate, a qualified ancient-transfer reconstruction, the 1972 discovery event and the National Museum of Iran custody layer. Manufacture, transfer interpretation, find context, installation and modern custody remain distinct.

- 726 registered entities / 721 browsable canonical entities
- 99 civilizations and traditions
- 233 source records
- 892 structured claims and 916 evidence records
- 639 direct relationship assertions and 35 explicit conflicts
- 55 readable stories / 64 witness versions / 212 bilingual sections and event nodes / 7 reading routes
- 184 deity story cards (111 full stories, 71 evidence cards, 2 permission-limited)
- 3 global-expansion batches / 43 independently audited targets
- 10 original-witness profiles / 20 comparison topics / 40 comparison members
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
