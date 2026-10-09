# 世界神话系统

<p align="center">
  <strong>World Mythology System</strong><br>
  跨文明 · 多语言 · 来源可追踪 · 可持续扩张
</p>

<p align="center">
  <a href="https://darenyew7527.github.io/world-mythology-system/">在线体验</a> ·
  <a href="#本地运行">本地运行</a> ·
  <a href="CONTRIBUTING.md">参与贡献</a> ·
  <a href="https://github.com/darenyew7527/world-mythology-system/discussions">中文讨论区</a> ·
  <a href="README.en.md">English</a>
</p>

![世界神话系统公开探索器实装截图](docs/design/public-explorer-desktop.png)

> 当前公开可发现资料的**阶段性知识基线**已经建立，并且系统可以继续扩张。它不是“全部完成”的百科，也不设 `ALL COMPLETE` 终点。

世界神话系统把神祇、英雄、怪物、神器、元素、古籍、神话事件、古迹、博物馆对象与现代改编连接成一个证据感知的知识网络。每一项重要说法尽量回到原始文本、铭文、馆藏、官方遗址、学术数字版或活态传统的授权语境；互相冲突的版本可以并存。

## 现在可以做什么

> 📖 **直接阅读**：[神祇故事集（全部 184 位神祇，打开即读）](profiles/stories/deities/index.md) · [神话故事档案（55 个故事）](profiles/stories/index.md) · [在线体验](https://darenyew7527.github.io/world-mythology-system/?view=deities)

- 在中文网页里搜索和筛选 721 个规范实体、99 个文明与传统。
- 在新的“神祇故事”画廊里给 184 位神祇逐一讲故事：111 位直接按原典段落讲述，71 位用带出处的证据要点讲述，2 位活态传统神祇只说明授权边界；可按文明、状态筛选，或“随机讲一位”。
- 打开“讲故事模式”：全屏、一段一段讲，支持键盘 ←／→、空格、Esc，手机左右滑动，字号可调，来源与不确定说明随时显示或隐藏。
- 在“神话故事”中阅读 55 个来源约束故事、64 个独立见证版本与 212 个中英分段，并沿 7 条阅读路线进入事件顺序、地点、原典来源、Claims 和相关实体。
- 使用只存本机的书签、分版本阅读进度、字号／行距／高对比设置与术语人物速查；也可下载双语离线 HTML／JSON 并直接打印。
- 查看全球扩张审计并在批次间切换：v0.31 神祇故事批次 28 个独立目标中 27 个已完成、1 个（奥贡与奥洛杜马雷）因权限条件不足仅阻塞自身；v0.28 与 v0.30 批次记录原样保留。
- 在“原典见证对读”中查看 10 份见证档案、20 个逐项对读主题与 40 个见证成员；原文名、转写、语言、来源定位、版权边界及 `NOT_STATED`／`UNMODELED` 状态保持可见。
- 使用 Explorer 2.0 证据工作台查看有坐标证据的现实地点、31 个封版数据版本、实体—Claim—来源见证图与版本比较。
- 通过来源质量面板、文明研究密度热图、冲突查看器、永久队列进度与活态传统访问策略定位当前证据边界。
- 从任意实体反向查看家族、神器、敌友、文献、遗址、Claims 与证据。
- 使用新增的“家谱模式”查看父母、子女、兄弟姐妹、伴侣及对应证据。
- 使用“雷神对照”比较 Thor、Zeus、Indra、Raijin、Takemikazuchi、雷公、雷泽雷神、Perun、Ṣàngó 与 Baʿlu/Haddu，同时保留各自原生语境和证据边界。
- 浏览关系图谱、892 条结构化 Claims、916 条证据和 233 条来源登记。
- 在详情页读取神祇、神器、古籍、地点与事件的结构化档案，并查看互不覆盖的版本冲突。
- 查看永久 `collection_queue`、研究缺口、显式冲突和下一轮工作。
- 通过中文 GitHub 表单提交纠错、建议新实体或补充来源。
- 运行 SQLite、JSONL、CSV、图谱导出、Markdown 档案与完整质量检查。

数据量是当前版本的检查点，不是数量上限。当前正式版本：`v0.31.0-deity-stories`。

v0.31 正式版让每一位神祇都有故事可讲：原本没有任何 Claim 的 54 位神祇，现在有 26 个新故事或证据卡——埃及的阿图姆家族、天牛之书、阿尼纸草的称量心脏与两位哀悼女神；伊邪那岐与伊邪那美；北欧华纳神族、提尔与芬里尔、海姆达尔、尤弥尔与巴德尔之死；墨西加蛇山诞生、羽蛇神离开图拉与大神庙双神殿；玛雅三位神的三份物质见证；苏美尔恩基与宁胡尔萨格、南纳航向尼普尔、吉尔伽美什与乌图；伏羲作八卦、黄帝战蚩尤、盘古开天地与《西游记》哪吒大战孙悟空（后世文学层）；爱尔兰《第二次马格图雷德之战》；《往年纪事》的基辅神像；《密赫尔颂》与《万迪达德》十六地；以及须署名的佩蕾旅程和 Te Ara 毛利创世共同线索。奥贡与奥洛杜马雷仍需社区授权，故事卡只说明边界。网页新增神祇故事画廊、全屏讲故事模式、实体页故事卡，并把过小的字号提升到可读下限。详见 [v0.31 发布说明](RELEASE_NOTES_v0.31.0.md)。

v0.30 正式版完成 v0.28 留下的两个排队目标：女娲补天分别按《淮南子·览冥训》与《列子·汤问》阅读；配套的“共工触不周山”故事把《淮南子·天文训》的独立起源叙述与《列子》中“其后”才出现的共工分开保存，不合成后世“共工撞山导致女娲补天”的因果版本。乳海搅拌登记《摩诃婆罗多》精校本初篇 1.15–1.17 与《薄伽梵往世书》8.5–8.9 两种梵语见证：龟王阿库帕拉与毗湿奴的龟形化身作为显式见证冲突分开建模，湿婆饮毒在精校本定位记为“未陈述”而非反证；吴哥寺浮雕只做交叉边界，不由文本推断其版本。后世因果化复述与精校本校勘记录已排队，毛利与约鲁巴／Ifá 仍只在各自目标上权限阻塞。详见 [v0.30 发布说明](RELEASE_NOTES_v0.30.0.md)与[后续路线](docs/ROADMAP_v0.30-v0.33.md)。

v0.29 正式版新增只存本机的书签、分版本分段阅读进度、字号／行距／高对比设置、术语与人物速查，以及可断网打开和打印的双语故事档案；个人阅读状态不会进入 SQLite、导出文件或公开快照。详见 [v0.29 发布说明](RELEASE_NOTES_v0.29.0.md)。

v0.28 正式版新增玛雅英雄双子与七金刚鹦鹉的公开 K'iche' 语境事件、草薙剑的大学学术综述／热田神宫公开传承双层版本，以及吴哥寺“乳海搅拌”浮雕的高棉物质见证。中国女娲与印度乳海文本见证继续排队；毛利具名 iwi／hapū 版本与 Yorùbá／Ifá 内容因授权范围不足保持目标级权限阻塞，不影响其他目标推进。详见 [v0.28 发布说明](RELEASE_NOTES_v0.28.0.md)与[故事阅读路线图](docs/ROADMAP_v0.26-v0.29.md)。

v0.27 首批为阿佛洛狄忒起源与 Ask／Embla 创造叙事建立原典见证逐项对读：古希腊语／古诺斯语原文名、转写、语言与定位并列；《神谱》与《伊利亚特》、《女巫的预言》与《欺骗古鲁菲》保持独立，不合成第三个“统一版本”。逐词赐予层仍显式标为未建模。详见 [v0.27 发布说明](RELEASE_NOTES_v0.27.0.md)。

v0.26 新增奥佩特节与厄琉息斯公开进程故事、77 个事件节点、6 条见证安全的阅读路线，以及手机友好的事件—地点导航。路线不代表跨文明同源，缺失坐标不推测。详见 [v0.26 发布说明](RELEASE_NOTES_v0.26.0.md)。

v0.26–v0.29 的故事阅读路线见 [故事阅读路线图](docs/ROADMAP_v0.26-v0.29.md)；v0.30 之后的候选方向见 [后续路线](docs/ROADMAP_v0.30-v0.33.md)。

v0.24 新增 Explorer 2.0 证据工作台、四维证据筛选、冲突与版本对照、来源质量、覆盖热图、队列进度和活态传统访问策略界面。地图只显示明确记录的非基线现实坐标，时间线只使用可核验的版本日期。详见 [v0.24 发布说明](RELEASE_NOTES_v0.24.0.md)。

v0.23 新增 Ifá、Ṣàngó 与 Māori 的持久权限治理层。详见 [v0.23 发布说明](RELEASE_NOTES_v0.23.0.md)。

v0.17 扩展厄琉息斯铭文、Ninnion Tablet、Telesterion 分期、圣道遗迹与浮雕摹本网络，同时维持秘仪证据限制。详见 [v0.17 发布说明](RELEASE_NOTES_v0.17.0.md)。

v0.16 接入 1972 报告组、XSd 门楼铭文、UNESCO 苏萨组成部分、赫利奥波利斯目的地假说、瓦迪哈马马特石材来源及 `NMI 4112` 权威缺口。详见 [v0.16 发布说明](RELEASE_NOTES_v0.16.0.md)。

v0.15 将大流士雕像象形文字文本 1–4 建为编辑见证，并把二十四属民先分成底座两侧各十二组；古代标签、语言见证、现代编辑编号和现代地理解释保持分离。详见 [v0.15 发布说明](RELEASE_NOTES_v0.15.0.md)。

v0.14 新增薛西斯一世、苏萨遗址、大流士门、古代转运重建、1972 年发现事件及伊朗国家博物馆馆藏层；古代制作、学术转运重建、考古发现、实体安装和现代保管严格分开。详见 [v0.14 发布说明](RELEASE_NOTES_v0.14.0.md)。

v0.13 新增 DSab 三语楔形文字铭文、古波斯语／埃兰语／阿卡德语独立见证、五组埃及象形文字铭文总档及二十四属民表现名单；文本、语言、考古载体和现代解释保持分离。详见 [v0.13 发布说明](RELEASE_NOTES_v0.13.0.md)。

v0.12 新增 Atum-Ra、Atum-Horakhty、《亡灵书》第15章太阳赞歌组、大流士一世及苏萨埃及式雕像；复合神名、文本见证、考古对象、跨文明王权语境和现代学术解释保持分离。详见 [v0.12 发布说明](RELEASE_NOTES_v0.12.0.md)。

v0.11 新增卜塔-索卡尔-奥西里斯复合神、索卡尔及四件大都会艺术博物馆对象的证据层；组成神、器物结构、实测内部材料、策展解释与现代馆藏分别建模。详见 [v0.11 发布说明](RELEASE_NOTES_v0.11.0.md)。

v0.10 新增贺茂别雷地方神祇谱系、上贺茂神社、葵祭、贺茂竞马及宗达《风神雷神图屏风》证据层；活态祭礼、片段文献与后世图像保持分离。详见 [v0.10 发布说明](RELEASE_NOTES_v0.10.0.md)。此前 Perses 同名审计、厄琉息斯证据层与雷神对照继续保留。

## 公开网页

发布 GitHub Pages 后访问：

**https://darenyew7527.github.io/world-mythology-system/**

网页默认中文，可切换英文；桌面与手机均可使用。公开快照会显示研究摘要、来源和定位符，但不会批量复制证据短引文。

## 本地运行

下载完整项目包后，先解压整个 ZIP，再在 Windows 双击 `START_WORLD_MYTHOLOGY.bat`；它使用 Windows 自带的 PowerShell 在 `127.0.0.1` 本机启动网页，不需要安装 Python。浏览器会打开 `http://127.0.0.1:8765/`，关闭启动窗口即可停止。

开发模式：

```bash
python3 scripts/generate_web_data.py
cd web
npm install
npm run dev
```

浏览器打开终端显示的地址（通常是 `http://127.0.0.1:5173/`）。

运行完整数据流水线：

```bash
python3 scripts/run_pipeline.py
python3 -m unittest discover -s tests -v
python3 scripts/privacy_release_check.py
```

数据库还不存在时才使用 `python3 scripts/run_pipeline.py --init`。日常流水线只迁移、验证和导出现有数据库，不会覆盖已经积累的研究增量；显式 `--rebuild` 仅用于恢复种子基线。

## 核心结构

| 路径 | 内容 |
|---|---|
| `database/world_mythology.sqlite` | SQLite 持久知识库 |
| `schema/schema.sql` | 可迁移到 PostgreSQL 的规范 Schema |
| `exports/jsonl/`、`exports/csv/` | 全部持久表的批量导出 |
| `exports/graph/` | 知识图谱节点与关系边 |
| `profiles/` | 按实体与故事生成的完整 Markdown 阅读档案 |
| `reports/` | 覆盖率、来源、冲突、缺失资料与质量报告 |
| `web/` | React/Vite 中文优先公开探索器 |
| `scripts/` | 构建、迁移、导入、验证、导出与报告自动化 |
| `tests/` | 数据持久性、图谱、来源与网页导出回归测试 |

完整入口见 [交付总索引](DELIVERY_INDEX.md)、[Schema Catalog](reports/schema_catalog.md) 与 [数据字段说明](docs/DATA_DICTIONARY.md)。

## 数据原则

1. **来源可追踪**：重要 Claim 连接到来源、章节、行号、页码、馆藏号、DOI 或手稿号。
2. **版本可并存**：不同传统与文本版本不会被压成一个“唯一答案”。
3. **不按名称粗暴合并**：别名、音译、地方版本、神祇融合和争议身份分别建模。
4. **知识层分离**：考古事实、古代文本、口述传统、现代研究、民间传说和流行文化分别标注。
5. **活态传统优先尊重社区**：记录文化权限、使用限制、自我命名和授权语境。
6. **不伪造核验**：`URL_SYNTAX_VALID` 只代表格式可解析；只有带机器回执的来源才可标为 `WEB_CONFIRMED`。

详见 [研究与证据方法](docs/METHODOLOGY.md)、[数据许可](DATA_LICENSE.md) 和逐条 [Source Registry](reports/source_registry.md)。

## 查询示例

```bash
PYTHONPATH=src python3 -m world_mythology.cli entity deity.greek.zeus
PYTHONPATH=src python3 -m world_mythology.cli network deity.norse.odin
PYTHONPATH=src python3 -m world_mythology.cli search 雷霆
PYTHONPATH=src python3 -m world_mythology.cli queue --status NEW
python3 scripts/import_queue_jsonl.py new_queue_items.jsonl        # 预检
python3 scripts/import_queue_jsonl.py new_queue_items.jsonl --apply
```

## 参与、试用与评论

- 发现名称、关系、年代或来源错误：[提交资料纠错](https://github.com/darenyew7527/world-mythology-system/issues/new?template=data-correction.yml)
- 想补充神祇、神器、怪物、古籍或遗址：[建议新实体](https://github.com/darenyew7527/world-mythology-system/issues/new?template=new-entity.yml)
- 有原始文本、馆藏号或学术资料：[建议新来源](https://github.com/darenyew7527/world-mythology-system/issues/new?template=source-suggestion.yml)
- 想讨论分类、版本差异或路线：[进入 Discussions](https://github.com/darenyew7527/world-mythology-system/discussions)

第一次参与不需要会写程序；中文内容完全可以。请先阅读 [贡献指南](CONTRIBUTING.md) 与 [行为准则](CODE_OF_CONDUCT.md)。

## 许可

- 代码：[MIT](LICENSE)
- 原创结构化元数据与研究摘要：[CC BY 4.0](DATA_LICENSE.md)
- 第三方来源、图片、现代译文及活态传统知识：保持原权利与文化权限，不由本仓库重新授权

## 项目状态

公开预览版重点是让数据可查询、可验证、可贡献和可持续维护。覆盖报告中的缺口会回流永久研究队列；局部资料缺失不会停止其他可执行工作。

如果这个项目对你有帮助，欢迎 Star、试用网页、提交 Issues 或在 Discussions 留下中文意见。
