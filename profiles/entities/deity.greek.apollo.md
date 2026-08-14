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
| `MENTIONED_IN` | 《荷马颂歌·致阿波罗》（第3首） (`text.greek.homeric_hymn_apollo_3`) | VERIFIED / TEXT_SAYS / TEXTUAL_WITNESS | 1 | 1.00 | inferred inverse; `claim.v050.h3.text_mentions_apollo` |
| `USES` | 阿波罗之弓 (`weapon.greek.apollo_bow`) | VERIFIED / TEXT_SAYS / MYTHIC_NARRATIVE | 1 | 0.99 | stored claim; `claim.v050.h3.apollo_uses_bow` |
| `WORSHIPPED_AT` | 德尔斐 (`site.greece.delphi`) | VERIFIED / HISTORICAL_REALITY / ARCHAEOLOGICAL | 1 | 0.98 | stored claim; `claim.greek.apollo_worshipped_delphi` |

## Claims 与证据

- `claim.greek.apollo_born_delos` [VERIFIED / IN_TRADITION / 0.85] Greek myth locates Apollo's birth on Delos.
  - 来源：[Delos](https://whc.unesco.org/en/list/530/)；定位：World Heritage property description
- `claim.greek.apollo_worshipped_delphi` [VERIFIED / HISTORICAL_REALITY / 0.98] Delphi was the pan-Hellenic sanctuary where Apollo's oracle spoke.
  - 来源：[Archaeological Site of Delphi](https://whc.unesco.org/en/list/393/)；定位：World Heritage property description
- `claim.v050.h3.apollo_uses_bow` [VERIFIED / TEXT_SAYS / 0.99] Homeric Hymn 3 repeatedly characterizes Apollo as bearing or delighting in the bow.
  - 来源：[Homeric Hymn 3 to Apollo, Evelyn-White English text](https://scaife.perseus.org/library/urn%3Acts%3AgreekLit%3Atlg0013.tlg003.perseus-eng2/)；定位：lines 1-20; 115-132
- `claim.v050.theogony.apollo_child_leto` [VERIFIED / TEXT_SAYS / 0.99] Theogony 918-920 presents Apollo as a child of Leto and Zeus.
  - 来源：[Hesiod, Theogony, Evelyn-White English text](https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0130)；定位：lines 918-920
- `claim.v050.theogony.apollo_child_zeus` [VERIFIED / TEXT_SAYS / 0.99] Theogony 918-920 presents Apollo as a child of Leto and Zeus.
  - 来源：[Hesiod, Theogony, Evelyn-White English text](https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0130)；定位：lines 918-920

> 本档案只代表当前阶段性基线，不是对该传统的最终或唯一解释。
