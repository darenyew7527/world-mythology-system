# 来源验证报告

本报告区分来源登记、URL 语法检查与可复验网络确认。访问日期是登记元数据，不等同于访问成功回执；没有结构化回执的记录不会标为 `WEB_CONFIRMED`。

状态协议：`REGISTERED` 表示有 DOI、ISBN、馆藏号、手稿号等稳定定位符；`URL_SYNTAX_VALID` 只表示 HTTP(S) URL 结构有效；`WEB_CONFIRMED` 还必须在 notes 中保留机器可读的 `VERIFICATION_RECEIPT_JSON`（checked_at、method、locator、outcome）。

| Status | Count |
|---|---:|
| URL_SYNTAX_VALID | 160 |

## 同一文本见证的多个入口

| Source | Same witness as |
|---|---|
| `source.greek.homeric_hymn_aphrodite5.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_apollo3.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_ares8.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_artemis27.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_athena28.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_demeter.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_dionysus7.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_helios31.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_hephaestus20.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_hermes4.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_hestia29.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_poseidon22.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.homeric_hymn_selene32.scaife` | `source.greek.homeric_hymns.scaife` |
| `source.greek.theogony.perseus_eng1` | `source.greek.theogony.scaife` |
| `source.japanese.naruikazuchi.kokugakuin` | `source.japanese.kojiki_kami_index.kokugakuin` |
| `source.japanese.takemikazuchi_names.kokugakuin` | `source.japanese.takemikazuchi.kokugakuin` |
| `source.japanese.wakaikazuchi.kokugakuin` | `source.japanese.kojiki_kami_index.kokugakuin` |
| `source.mexica.florentine.loc` | `source.mexica.florentine.getty` |
| `source.slavic.laurentian.unesco` | `source.slavic.laurentian.nlr` |
| `source.slavic.pvl.obdurodon` | `source.slavic.laurentian.nlr` |
| `source.yoruba.sango_decision.unesco` | `source.yoruba.sango_festival.unesco` |

网络可达性会变化；即使有回执，`WEB_CONFIRMED` 也只证明回执记录的检查时点与结果，不代表永久在线、内容正确或学术结论成立。
