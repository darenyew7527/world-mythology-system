# 奥佩特节的公开仪仗路线 / Public route of the Opet procession

- ID: `story.egyptian.opet_procession`
- 文明／传统: 古埃及
- 故事类型: `TRADITION_OVERVIEW`
- 证据状态: `SOURCE_BACKED`
- 阅读时间: 4 分钟

## 阅读边界

埃及文物主管部门的卢克索神庙档案记录：阿蒙、穆特和孔苏的神像由卡纳克出发，沿仪仗联系抵达卢克索神庙。本页只叙述可公开核对的路线与纪念物层。

The Egyptian antiquities authority records the cult images of Amun, Mut, and Khonsu leaving Karnak and reaching Luxor Temple along a processional connection. This page covers only the public route and monument layer.

## 埃及文物主管部门卢克索神庙档案 / Egyptian antiquities authority Luxor Temple record

- 来源：[Luxor Temple](https://egymonuments.gov.eg/monuments/luxor-temple/)
- 机构：Egyptian Ministry of Tourism and Antiquities
- 定位：Official Luxor Temple record, monument description
- 见证范围：现代埃及官方遗址档案对古代祭典路线与纪念物的公开说明
- 叙述范围：只概述卡纳克出发、仪仗联系、抵达卢克索和柱廊图像；不声称重建完整祭仪
- 权利／访问：`PUBLIC_CONTEXT`；版权归埃及主管部门；公开快照只含独立概述、元数据与定位。

### 01 · 从卡纳克出发 / Departure from Karnak

官方档案将奥佩特节的公开进程起点放在卡纳克诸神庙，并点名阿蒙、穆特与孔苏的神像。

The official record places the public procession’s departure at the Karnak temples and names the cult images of Amun, Mut, and Khonsu.

> 证据说明：埃及文物主管部门卢克索神庙档案。
> Claim: `claim.v070.egypt.opet_associated_karnak`
> 未知／边界：当前来源未给出每一尊神像在每一历史时期的完整次序。

### 02 · 仪仗联系 / The processional connection

卡纳克与卢克索之间由一条两侧有斯芬克斯像的仪仗道相连；本数据库不凭描述自行绘制精确古路线。

Karnak and Luxor were connected by a sphinx-bordered processional way; the database does not infer an exact ancient route geometry from this description.

> 证据说明：官方遗址档案第一个说明段。
> Claim: `claim.v0260.opet_way_sphinxes`
> 未知／边界：当前证据未说明各段统一的建造日期与完整保存状态。

### 03 · 抵达卢克索 / Arrival at Luxor

神像被运往卢克索神庙；官方说明把此行解释为拜访当地的阿蒙涅姆奥佩特。

The cult images were transported to Luxor Temple; the official account interprets the visit as directed to Amenemopet there.

> 证据说明：官方卢克索神庙奥佩特段落。
> Claim: `claim.v0260.opet_visits_amenemopet`
> 未知／边界：阿蒙涅姆奥佩特本轮只作来源中的名称保存，不与其他阿蒙形态合并。

### 04 · 柱廊保存的图像层 / Festival scenes on the colonnade

卢克索大神柱廊的装饰包含奥佩特节场景；这是现实纪念物的图像见证，不等于完整祭典脚本。

The Great Colonnade decoration includes scenes of the Opet Festival; this is a monumental visual witness, not a complete ritual script.

> 证据说明：官方神庙档案的柱廊说明。
> Claim: `claim.v0260.opet_colonnade_scenes`
> 未知／边界：完整图像学分段与各场景定位仍待专项研究。

### 事件顺序与地点

> 以下是本见证内的叙事顺序，不是绝对年代。没有可靠坐标时不推测坐标。

- 01 · 从卡纳克出发 — 卡纳克 (`REAL_SITE` / `ENTITY_PROFILE_ONLY`)
- 02 · 仪仗联系 — 卡纳克—卢克索仪仗道 (`REAL_SITE` / `NO_COORDINATE`)
- 03 · 抵达卢克索 — 卢克索神庙 (`REAL_SITE` / `ENTITY_PROFILE_ONLY`)
- 04 · 柱廊保存的图像层 — 卢克索神庙 (`REAL_SITE` / `ENTITY_PROFILE_ONLY`)

### 本版本连接的 Claims

- `claim.v0260.opet_colonnade_scenes` [VERIFIED / HISTORICAL_REALITY] The official Luxor Temple record states that the Great Colonnade decoration includes scenes depicting the Opet Festival. — Luxor Temple
- `claim.v0260.opet_visits_amenemopet` [VERIFIED / SCHOLARLY_INTERPRETATION] The official record explains the procession as bringing the cult images from Karnak to visit Amenemopet at Luxor Temple. — Luxor Temple
- `claim.v0260.opet_way_sphinxes` [VERIFIED / HISTORICAL_REALITY] The Egyptian Ministry description says the processional way between Karnak and Luxor was bordered with sphinxes. — Luxor Temple
- `claim.v070.egypt.opet_associated_karnak` [VERIFIED / HISTORICAL_REALITY] The Opet procession departed from the deities' temples at Karnak in the registered official account. — Luxor Temple
- `claim.v070.egypt.opet_associated_luxor` [VERIFIED / HISTORICAL_REALITY] Luxor Temple was a principal destination and venue of the Opet Festival in the registered official account. — Luxor Temple
- `claim.v070.egypt.opet_associated_triad` [VERIFIED / HISTORICAL_REALITY] The official Luxor Temple record describes an Opet procession of the cult images of Amun, Mut and Khonsu. — Luxor Temple

### 连接实体

- `EVENT` 奥佩特节 (`festival.egyptian.opet`)
- `CHARACTER_GROUP` 底比斯三神组 (`group.egyptian.theban_triad`)
- `PLACE` 卡纳克 (`site.egypt.karnak`)
- `PLACE` 卡纳克—卢克索仪仗道 (`site.egypt.karnak_luxor_processional_way`)
- `PLACE` 卢克索神庙 (`site.egypt.luxor_temple`)

## 编辑说明

古代祭典、现实遗址与现代官方解释分层；未公开或当前来源未说明的仪式内容不补写。

> 本故事页是可持续扩张的阶段性阅读基线；只重述已连接见证，不把现代改编或推测写成古代事实。
