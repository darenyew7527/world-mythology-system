# 阿波罗 / Apollo

- ID: `deity.greek.apollo`
- 类型: `DEITY`
- 文明／传统: 古希腊
- 原文名: Ἀπόλλων
- 转写: Apollōn
- 研究状态: `PARTIAL`
- 证据状态: `SOURCE_BACKED`

## 概要

勒托与宙斯之子；第3首《荷马颂歌》连接提洛岛诞生、弓、琴与神谕。 / Son of Leto and Zeus; Hymn 3 connects his Delian birth, bow, lyre and oracle.

## 分类

`DEITY`

## 关系网络

| Relation | Target | Review / layer | Evidence | Confidence | Direction |
|---|---|---|---:|---:|---|
| `BORN_IN` | 提洛岛 (`site.greece.delos`) | VERIFIED / IN_TRADITION / MYTHIC_NARRATIVE | 1 | 0.85 | stored claim; `claim.greek.apollo_born_delos` |
| `CHILD_OF` | 勒托 (`deity.greek.leto`) | VERIFIED / TEXT_SAYS / MYTHIC_NARRATIVE | 1 | 0.99 | stored claim; `claim.v050.theogony.apollo_child_leto` |
| `CHILD_OF` | 宙斯 (`deity.greek.zeus`) | VERIFIED / TEXT_SAYS / MYTHIC_NARRATIVE | 1 | 0.99 | stored claim; `claim.v050.theogony.apollo_child_zeus` |
| `KILLED` | 德尔斐的母龙 (`creature.greek.delphic_drakaina`) | VERIFIED / TEXT_SAYS / MYTHIC_NARRATIVE | 1 | 0.90 | stored claim; `claim.v0360.hym_apollo.12` |
| `MENTIONED_IN` | 《荷马颂歌·致阿波罗》（第3首） (`text.greek.homeric_hymn_apollo_3`) | VERIFIED / TEXT_SAYS / TEXTUAL_WITNESS | 1 | 1.00 | inferred inverse; `claim.v050.h3.text_mentions_apollo` |
| `USES` | 阿波罗之弓 (`weapon.greek.apollo_bow`) | VERIFIED / TEXT_SAYS / MYTHIC_NARRATIVE | 1 | 0.99 | stored claim; `claim.v050.h3.apollo_uses_bow` |
| `WORSHIPPED_AT` | 德尔斐 (`site.greece.delphi`) | VERIFIED / HISTORICAL_REALITY / ARCHAEOLOGICAL | 1 | 0.98 | stored claim; `claim.greek.apollo_worshipped_delphi` |

## Claims 与证据

- `claim.greek.apollo_born_delos` [VERIFIED / IN_TRADITION / 0.85] Greek myth locates Apollo's birth on Delos.
  - 来源：[Delos](https://whc.unesco.org/en/list/530/)；定位：World Heritage property description
- `claim.greek.apollo_worshipped_delphi` [VERIFIED / HISTORICAL_REALITY / 0.98] Delphi was the pan-Hellenic sanctuary where Apollo's oracle spoke.
  - 来源：[Archaeological Site of Delphi](https://whc.unesco.org/en/list/393/)；定位：World Heritage property description
- `claim.v0340.argo_1.10` [VERIFIED / TEXT_SAYS / 0.90] On the island of Thynias the Argonauts see Apollo pass at dawn on his way from Lycia to the Hyperboreans and build him an altar; in the land of the Mariandyni the seer Idmon is killed by a boar and the helmsman Tiphys dies of sickness.
  - 来源：[Apollonius Rhodius, The Argonautica (tr. R. C. Seaton, 1912)](https://www.gutenberg.org/ebooks/830)；定位：Book II, Thynias and the Mariandyni
- `claim.v0340.argo_2.14` [VERIFIED / TEXT_SAYS / 0.90] In the Pall of Darkness after Crete, Apollo answers Jason's prayer and lights the sea with his golden bow, revealing the island the Argonauts name Anaphe; Euphemus's clod becomes Thera, and the heroes reach Pagasae.
  - 来源：[Apollonius Rhodius, The Argonautica (tr. R. C. Seaton, 1912)](https://www.gutenberg.org/ebooks/830)；定位：Book IV, Anaphe and the return
- `claim.v0360.hym_apollo.06` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 3, lines 127–139, says that the newborn Apollo, after tasting ambrosia, burst his swaddling bands and claimed the lyre and the curved bow and the declaring of Zeus's will, and that Delos was laden with gold.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 3, lines 127–139
- `claim.v0360.hym_apollo.07` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 3, lines 140–178, describes the Ionian festival for Apollo on Delos, the Delian maidens who sing of Apollo, Leto and Artemis, and the poet's request to be remembered as the blind man of Chios.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 3, lines 140–178
- `claim.v0360.hym_apollo.09` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 3, lines 207–276, says that Apollo travelled from Pieria through Euboea and Boeotia seeking a site for his oracle, and that the spring nymph Telphusa, jealous of her glory, persuaded him to go instead to Crisa below Parnassus.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 3, lines 207–276
- `claim.v0360.hym_apollo.10` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 3, lines 277–304, says that Apollo laid the foundations of his temple at Crisa below Parnassus, that Trophonius and Agamedes laid its stone threshold, and that a fierce she-dragon who had reared Typhaon for Hera lived by a nearby spring.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 3, lines 277–304
- `claim.v0360.hym_apollo.12` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 3, lines 356–387, says that Apollo shot the she-dragon, that her body rotted (pythein) in the sun so that the place is called Pytho, and that he then buried Telphusa's spring beneath a crag.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 3, lines 356–387
- `claim.v0360.hym_apollo.13` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 3, lines 388–439, says that Apollo, seeking priests for his temple, leapt onto a Cretan ship from Cnossos in the form of a dolphin and carried it, against the will of its crew, around the Peloponnese to Crisa.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 3, lines 388–439
- `claim.v0360.hym_apollo.14` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 3, lines 440–546, says that Apollo revealed himself to the Cretans at Crisa, made them keepers of his temple, named his altar Delphinius after the dolphin, led them to Pytho singing the paean and warned them against insolence.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 3, lines 440–546
- `claim.v0360.hym_hermes.07` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 4, lines 184–212, says that Apollo, seeking his fifty cattle, questioned the old man at Onchestus, knew the thief from a bird omen, and marvelled at the backward cattle tracks and the strange footprints beside them.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 4, lines 184–212
- `claim.v0360.hym_hermes.08` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 4, lines 213–277, says that Apollo came to Maia's cave on Cyllene, searched its storerooms full of nectar, ambrosia, gold, silver and the nymph's garments, and threatened Hermes, who lay curled in his cradle and denied all knowledge of the cattle.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 4, lines 213–277
- `claim.v0360.hym_hermes.12` [VERIFIED / TEXT_SAYS / 0.90] Homeric Hymn 4, lines 503–580, says that Hermes swore by Styx never to steal from Apollo, that Apollo gave him a golden staff of wealth and told him of the three bee-maidens of Parnassus, and that Zeus made Hermes lord of beasts and messenger to Hades.
  - 来源：[Hesiod, the Homeric Hymns, and Homerica, tr. Hugh G. Evelyn-White (1914)](https://www.gutenberg.org/ebooks/348)；定位：Homeric Hymn 4, lines 503–580
- `claim.v050.h3.apollo_uses_bow` [VERIFIED / TEXT_SAYS / 0.99] Homeric Hymn 3 repeatedly characterizes Apollo as bearing or delighting in the bow.
  - 来源：[Homeric Hymn 3 to Apollo, Evelyn-White English text](https://scaife.perseus.org/library/urn%3Acts%3AgreekLit%3Atlg0013.tlg003.perseus-eng2/)；定位：lines 1-20; 115-132
- `claim.v050.theogony.apollo_child_leto` [VERIFIED / TEXT_SAYS / 0.99] Theogony 918-920 presents Apollo as a child of Leto and Zeus.
  - 来源：[Hesiod, Theogony, Evelyn-White English text](https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0130)；定位：lines 918-920
- `claim.v050.theogony.apollo_child_zeus` [VERIFIED / TEXT_SAYS / 0.99] Theogony 918-920 presents Apollo as a child of Leto and Zeus.
  - 来源：[Hesiod, Theogony, Evelyn-White English text](https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0130)；定位：lines 918-920

> 本档案只代表当前阶段性基线，不是对该传统的最终或唯一解释。
