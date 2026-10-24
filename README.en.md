# World Mythology System

[中文首页](README.md) · [Live explorer](https://darenyew7527.github.io/world-mythology-system/) · [Contributing](CONTRIBUTING.md) · [Discussions](https://github.com/darenyew7527/world-mythology-system/discussions)

World Mythology System is an expandable, multilingual, evidence-aware knowledge network connecting deities, heroes, creatures, artifacts, concepts, narratives, texts, sites, museum objects, and later adaptations across cultures.

The repository contains a reproducible staged knowledge baseline, not a claim of completeness. Conflicting accounts may coexist; similar names are not merged automatically; archaeological evidence, ancient texts, oral traditions, scholarship, folklore, and popular culture remain distinct knowledge layers.

## Public preview

> 📖 **Read now**: [Deity story collection (all 245 deities)](profiles/stories/deities/index.md) · [Story dossiers (105 stories)](profiles/stories/index.md) · **Series**: [Journey to the West in six parts](profiles/stories/story.chinese.xiyouji_havoc_in_heaven.md) · [the Rāmāyaṇa in six books](profiles/stories/story.hindu.ramayana_bala.md) · [the Odyssey in two parts](profiles/stories/story.greek.odyssey_wanderings.md) · [Greek heroes](profiles/stories/story.greek.perseus_library.md) · [the Argonauts](profiles/stories/story.greek.argonautica_outward.md) · [the twilight of the gods](profiles/stories/story.norse.frigg_baldr.md) · [the Völsungs](profiles/stories/story.norse.volsunga_sigmund.md) · [the Táin](profiles/stories/story.irish.tain_muster_boy_deeds.md) · [the Four Branches of the Mabinogi](profiles/stories/story.welsh.mabinogi_pwyll.md) · [the Kojiki](profiles/stories/story.japanese.izanagi_izanami.md) · [the Kalevala](profiles/stories/story.finnish.kalevala_sampo_forging.md) · [the Mahābhārata](profiles/stories/story.hindu.nala_damayanti.md) · [the Shahnameh](profiles/stories/story.persian.zal_rudabeh_rostam.md) ([series index](profiles/stories/series.md)) · Long reads: [Rāmāyaṇa](profiles/stories/story.hindu.ramayana.md) · [Gilgamesh](profiles/stories/story.babylonian.gilgamesh_epic.md) · [Havoc in Heaven](profiles/stories/story.chinese.xiyouji_havoc_in_heaven.md) · [Theogony](profiles/stories/story.greek.theogony_cosmos.md) · [Rock-Cave and Serpent](profiles/stories/story.japanese.iwato_orochi.md) · [Tales from the Soushen ji](profiles/stories/story.chinese.soushenji_tales.md) · [Live explorer](https://darenyew7527.github.io/world-mythology-system/?view=stories)

The bilingual React explorer provides searchable entities, filters, relationship graphs, claims, evidence locators, sources, coverage, and the permanent research queue. Chinese is the default interface; English can be selected from the header.

Current sealed release: `v0.35.0-world-epics`.

v0.35 takes the series to Japan, Finland, India and Persia. Four new series add 15 parts and 188 chapters: the Kojiki in Chamberlain's translation (from Izanagi and Izanami to Yamato Takeru, five parts), the Kalevala in Crawford's translation (the world and the Sampo, Lemminkäinen, Kullervo and the theft of the Sampo, four parts), the Mahābhārata in Ganguli's translation (Nala and Damayantī, Sāvitrī and the war at Kurukṣetra, three parts) and the Shahnameh in Zimmern's prose retelling (Zāl, the seven stages of Rostam, and Rostam and Sohrāb, three parts), plus thirteen tales from the Soushen ji — about 64,000 new characters of retelling. Every chapter keeps its own anchor claim and evidence; Zimmern is recorded as a retelling rather than a full translation, and each series names the sections and runes it skips. Takemikazuchi now opens a full story, and twenty-four newly registered deities — among them Ōkuninushi, Ilmatar, Yama, Krishna, the Weaver Girl and Chang'e — have stories. See [the v0.35 release notes](RELEASE_NOTES_v0.35.0.md).

v0.34 grows the series from three works to nine. Six new series add 17 parts and 209 chapters: Greek heroes from Apollodorus's Library (Perseus and Heracles in four parts), the Argonautica in Seaton's translation (Books I–IV in two parts), the twilight of the gods (the death of Baldr and a new long Ragnarök), the Völsunga saga (chapters 1–32 in three parts), the Táin (two parts) and the Four Branches of the Mabinogi — about 77,000 new characters of retelling, every chapter with its own anchor claim and evidence from a public-domain translation. The one passage left out, Library 2.7.4, is named in the series. Hera and Apollo now open full stories, newly registered deities such as Heracles, Víðarr and Arawn have stories, and the series shelf is a single swipeable row on every screen with only the series being read unfolded. See [the v0.34 release notes](RELEASE_NOTES_v0.34.0.md).

v0.33 reads whole works in order. Thirteen new long stories join the existing Journey to the West chapters 1–7 to form three series: Journey to the West in six parts (how the pilgrimage began, the pilgrims come together, the White Bone Demon, the two Monkey Kings, the plantain fan — 91 chapters), Vālmīki's Rāmāyaṇa one book per part (Books I–VI, 87 chapters), and Homer's Odyssey in two parts covering all twenty-four books in Butler's public-domain prose translation (32 chapters) — 14 parts and 210 chapters in all. Every chapter keeps its own anchor claim and evidence; each series records the source span of every part and names the chapters it skips rather than filling them in. The explorer adds a series shelf, part X of N with previous/next part, and a “continue with the next part” link at the end of each part, worked out from the existing on-device reading positions. See [the v0.33 release notes](RELEASE_NOTES_v0.33.0.md).

v0.32 makes the stories long. Twelve long-form retellings of 12–20 chapters each follow one located public witness from beginning to end: Vālmīki's Rāmāyaṇa (Books I–VI, 20 chapters), Journey to the West chapters 1–7, Hesiod's Theogony, the Standard Babylonian Gilgamesh (Tablets I–XI), the Kojiki's rock-cave and eight-forked serpent, Nezha in Investiture of the Gods, Thor at Útgarða-Loki's hall, Plutarch on Isis and Osiris, and long versions of the Hymn to Demeter, the death of Baldr, Enūma eliš and Inana's Descent (the short versions stay). Every chapter has its own anchor claim and evidence; the Ming novels and Plutarch stay in the later-reception layer, and Gilgamesh Tablet XII, Rāmāyaṇa Book VII and the passages Plutarch omits are not filled in. Deity cards now carry every chapter of their story, and the reader adds a contents list, next-chapter links, an on-device “continue reading” position and a long-stories filter. See [the v0.32 release notes](RELEASE_NOTES_v0.32.0.md).

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

- 777 registered entities / 772 browsable canonical entities
- 99 civilizations and traditions
- 237 source records
- 1,065 structured claims and 1,089 evidence records
- 645 direct relationship assertions and 35 explicit conflicts
- 63 readable stories (12 long-form, 12–20 chapters each) / 76 witness versions / 385 bilingual sections and event nodes / 7 reading routes
- 210 deity story cards (149 full stories — 60 of them long-form — 59 evidence cards, 2 permission-limited)
- 4 global-expansion batches / 55 independently audited targets
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
