# v0.29.0 — 阅读器与离线档案

状态：**正式封版**。本地检查点为 `release.v0.29.0` / Schema 40；GitHub tag 与 Release 仅在获得对外发布确认后创建。

## 本版完成

- 本机书签：按故事稳定 ID 保存，故事列表显示本机收藏状态。
- 阅读进度：按故事版本保存最后读到的分段序号，并显示进度条与百分比。
- 无障碍设置：90%／100%／115%／130% 字号、三档行距、高对比模式和系统减少动画偏好。
- 术语与人物速查：从当前故事主题与已连接实体即时生成，不建立无来源的新定义。
- 离线／打印：生成 `world-mythology-v0.29-story-archive.html` 单文件档案和对应 JSON；断网可打开，浏览器可直接打印。

## 隐私与证据边界

- `wms-reader-v029` 只位于浏览器 `localStorage`；不需要账号，也没有遥测或云同步。
- SQLite 只保存五项功能的隐私契约，不保存书签、进度、设备标识或个人阅读行为。
- 离线档案来自与公开探索器相同的浏览器安全快照，不包含 Evidence 短引文。
- 每个故事版本继续保留来源标题、机构、定位、权利状态、重用限制、Evidence 说明与编辑边界。
- Ifá 与其他 `DO_NOT_COLLECT`／`PERMISSION_REQUIRED` 内容不会因为“离线档案”而绕过权限规则。

## 正式检查点

- 26 个故事、29 个独立版本、89 个双语阅读分段、89 个事件节点与 6 条主题路线。
- 646 个登记实体／641 个可浏览规范实体、207 个来源、633 条 Claims 与 631 条 Evidence。
- HTML 与 JSON 都有 SHA-256 和字节数清单：`reports/offline_archive_manifest.json`。
- Migration 39 建立 `reader_feature_registry`；Migration 40 封存 `release.v0.29.0`。
- 正式快照必须显示 `snapshot_status=SEALED_RELEASE`，最新封版必须指向 `release.v0.29.0`。

## 验收说明

- 已运行数据库完整性、外键、来源、隐私、全表导出、Python 回归、编译与 Vite 生产构建门禁。
- 生产静态服务的探索器、离线 HTML 与离线 JSON 路由均返回 HTTP 200；本机状态逻辑、离线脚本语法和无外链脚本约束另有自动检查。
- 工作环境的云浏览器拒绝本机地址（`ERR_BLOCKED_BY_CLIENT`），而临时 Playwright Chromium 下载两次超时；因此本次不虚报截图式浏览器 PASS。发布包保留标准启动器，可在普通桌面浏览器继续进行人工视觉复核。

本版仍是可持续扩张的阶段性知识基线，不代表 `ALL COMPLETE`；v0.28 留下的排队与目标级权限阻塞状态继续保留。
