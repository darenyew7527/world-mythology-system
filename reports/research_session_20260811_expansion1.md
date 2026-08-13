# 研究检查点：2026-08-11 扩张批次 1

本检查点是可持续扩张的阶段性知识基线，不是 `ALL COMPLETE`。

## 本轮范围

- 希腊：Typhon、Metis、Tartarus、宙斯—Typhon 战斗事件。
- 北欧：Búri、Borr、Bestla、Vili、Vé、Mímir、Mímisbrunnr、Brokkr、Eitri、Sindri、Gullinbursti 与诸神宝物锻造事件。
- 中国：`尚書`、`洪範`、`漢書·五行志`，以及水、火、木、金、土五个原生五行成员实体。

## 主要依据

- Hesiod《Theogony》：Perseus Digital Library 的 [820–852 行](https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0130%3Acard%3D820)、[853–885 行](https://www.perseus.tufts.edu/hopper/text?doc=Perseus%3Atext%3A1999.01.0130%3Acard%3D853) 与 [886–900 行](https://www.perseus.tufts.edu/hopper/text?doc=Hes.+Th.+886)。
- Viking Society for Northern Research：[Edda: Prologue and Gylfaginning](https://vsnr.org/editions/snorri-sturluson-edda-prologue-and-gylfaginning/) 与 [Edda: Skáldskaparmál](https://vsnr.org/editions/snorri-sturluson-edda-skaldskaparmal/) 学术版登记；claims 保留到 `Gylfaginning 6, 8–9, 15` 与 `Skáldskaparmál 35` 的章节定位。
- Chinese Text Project：[《尚書·周書·洪範》](https://ctext.org/shang-shu/great-plan/zh) 与 [《漢書·五行志上》](https://ctext.org/han-shu/wu-xing-zhi-shang)。

所有新增来源状态均为 `URL_SYNTAX_VALID`，没有在缺少机器回执时升级为 `WEB_CONFIRMED`。

## 数据增量

| 对象 | 上一检查点 | 当前 | 新增 |
|---|---:|---:|---:|
| entities | 406 | 430 | 24 |
| canonical entities（排除 redirects） | 406 | 425 | 19 |
| sources | 82 | 87 | 5 |
| claims | 61 | 109 | 48 |
| evidence | 50 | 103 | 53 |
| 直接关系边 | 55 | 94 | 39 |
| collection_queue | 25 | 31 | 6 |
| conflicts | 1 | 2 | 1 |

## 关键建模决定

- `Typhon / Typhoeus` 只在当前 Hesiod/Evelyn-White 见证内建立别名；`Typhaon` 进入冲突队列，不自动合并。
- `Eitri` 与 `Sindri` 建为两个实体，并以 `POSSIBLY_SAME` 候选关系及开放冲突保存。
- `Gullinbursti` 同时分类为 `DIVINE_BEAST` 与 `ARTIFACT`，保留“被锻造的活物”双重性质。
- 五行之水、火、木、金、土使用独立的中国原生实体，不与比较层的 Water/Fire/Wood/Metal/Earth 合并。
- `Mímir` 暂以未决超自然生物归档；来源不足以强制归入统一“物种”。

## 失败与修复审计

第一次完整验证发现 6 个阻断项：3 个实体缺少 names、Gullinbursti 缺 artifact profile、Tartarus 与 Mímisbrunnr 缺 place profile。`0003_20260811_profile_repairs.sql` 追加修复后，数据库验证通过；失败过程未导致已有增量回滚或覆盖。

随后去重审计发现基线早已有 `element.chinese.*` 五行成员，本轮迁移 2 又创建了五个同义 ID。`0004_20260811_wuxing_dedup.sql` 将全部 claims 迁回原 canonical 实体，并以 `entity_redirects` 保留错误 ID 与修复依据；没有把它们与跨文明比较层元素合并。

最终状态：SQLite integrity/foreign-key 检查通过，来源检查通过，28 项自动测试通过。后续优先事项继续由永久队列选择。
