# 贡献指南 / Contributing Guide

感谢你帮助建设世界神话系统。**中文与英文贡献都欢迎**；第一次参与不需要会写程序。

## 最简单的参与方式

1. 在公开网页找到相关实体，并复制实体 ID。
2. 选择 [资料纠错](https://github.com/darenyew7527/world-mythology-system/issues/new?template=data-correction.yml)、[建议新实体](https://github.com/darenyew7527/world-mythology-system/issues/new?template=new-entity.yml) 或 [建议新来源](https://github.com/darenyew7527/world-mythology-system/issues/new?template=source-suggestion.yml)。
3. 写清楚“哪项说法需要新增或修改”，并附上可追踪来源与具体定位。

## 可接受的来源

优先顺序是原始文本／铭文、学术校勘或数字版、博物馆、大学、国家图书馆、考古机构、UNESCO、官方遗址资料、学术论文与出版社，以及获得适当授权或具有清楚社区语境的活态传统记录。

普通网页可以作为发现线索，但重要说法应尽量回到更可靠的来源。提交时请尽量提供：

- 标题、作者／机构与稳定链接；
- 章节、卷、诗节、行号、页码、馆藏号、DOI、ISBN 或手稿号；
- 这条资料支持哪一项具体说法；
- 来源类型、年代、语言、权利说明与文化权限；
- 如果不同来源互相矛盾，分别列出，不要自行删除其中一方。

## 数据原则

- 不按名称相似自动合并实体。
- 不把现代影视、漫画或游戏当成古代原始神话。
- 区分神话叙事、历史事实、考古证据、口述传统和学术解释。
- 活态传统的限制知识、社区自我命名和授权要求优先于“收得更全”。
- 不提交受版权保护作品的大段正文；书目信息、短引用、定位与研究摘要通常足够。
- 不写无法追踪来源的确定性结论；不确定时用明确的状态和备注表示。

## 代码或数据贡献

```bash
python3 scripts/run_pipeline.py
python3 -m unittest discover -s tests -v
python3 scripts/generate_web_data.py
cd web && npm ci && npm run build
```

Pull Request 应说明：改了什么、依据是什么、是否新增迁移、测试结果，以及是否影响数据许可或文化权限。对持久数据库的结构或记录变更应使用追加式 migration 或可重建的规范输入，不要用会抹掉现有研究增量的流程。

## English summary

Contributions are welcome in Chinese or English. Use an issue template for corrections, new entities, or sources. Identify the affected entity or claim, provide a traceable source and precise locator, state the source type and rights/cultural context, and preserve conflicting variants. Do not merge by name similarity or treat modern adaptations as ancient evidence. Code changes should run the full Python tests, regenerate the public snapshot, and build the web app.

参与本项目即表示同意遵守 [行为准则](CODE_OF_CONDUCT.md)。
