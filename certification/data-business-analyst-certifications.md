# Data Business Analyst — Certifications Study Guides

This file consolidates study guides for the Data Business Analyst profile.
Primary certifications:
- Microsoft PL-300 (Power BI Data Analyst)
- Microsoft DP-700 (Implementing Analytics Solutions Using Microsoft Fabric)
- Databricks Certified Data Analyst Associate (SQL on the Lakehouse, Databricks SQL dashboards)

Note: This is the preferred naming for the Analyst/BI track. The previous file `analyst-bi-certifications.md` remains as a redirect/alias.

## Databricks Certified Data Analyst Associate — Study Guide (English)

Purpose: focused prep for Databricks SQL and BI analyst workflows; paraphrases the live exam outline (verify the official page before booking).

### 1) Audience and goals
- Goal: query and analyze data using Databricks SQL; build dashboards and alerts; apply governance basics in Unity Catalog.
- Audience: BI/Analytics professionals using SQL and Databricks SQL Warehouses.

### 2) Assessment details
- Questions: 45 multiple choice
- Time: 90 minutes
- Fee: USD 200 (plus taxes)
- Delivery: online proctored; no aides
- Languages: English
- Prereqs: none; 6+ months experience with SQL recommended
- Validity: 2 years; recertify by retaking the current exam
- Unscored items may appear; time already accounts for them
- SQL is ANSI‑aligned; lakehouse specifics (Delta) feature prominently
- Official page: https://www.databricks.com/learn/certification/data-analyst-associate
- Exam guide PDF: https://www.databricks.com/sites/default/files/2025-02/databricks-certified-data-analyst-associate-exam-guide-1-mar-2025.pdf

### 3) Exam outline and weights
1. [DBX-DA-Assoc][SQL-Basics] SQL and Analytics Fundamentals — 22%
2. [DBX-DA-Assoc][UC-RLS] [DBX-DA-Assoc][UC-CLS] Data Management and Governance — 20%
3. [DBX-DA-Assoc][Dashboards] [DBX-DA-Assoc][Viz-BestPractices] [DBX-DA-Assoc][Alerts] Data Analysis and Visualization — 29%
4. [DBX-DA-Assoc][SQL-Basics] SQL Power Users — 18%
5. [DBX-DA-Assoc][SQL-Basics] SQL Advanced — 11%

Core topics
- Lakehouse and Delta basics: ACID, time travel, constraints; COPY INTO vs Auto Loader (awareness), OPTIMIZE/VACUUM. [DBX-DA-Assoc][Delta-Basics] [DBX-DA-Assoc][CopyInto-Awareness] [DBX-DA-Assoc][Maintenance]
- Unity Catalog: catalogs/schemas/tables, grants, dynamic views for RLS/CLS. [DBX-DA-Assoc][UC-RLS] [DBX-DA-Assoc][UC-CLS]
- Databricks SQL: dashboards, alerts, queries, visualization best practices. [DBX-DA-Assoc][Dashboards] [DBX-DA-Assoc][Alerts] [DBX-DA-Assoc][Viz-BestPractices]
- SQL patterns: joins, windows, aggregations, CTEs, subqueries, NULL handling; performance tips. [DBX-DA-Assoc][SQL-Basics]

### 4) Recommended training
- Databricks SQL for Data Analysts — https://www.databricks.com/training/catalog/databricks-sql-for-data-analysts-2311
- Data Analysis with Databricks SQL — https://www.databricks.com/training/catalog/data-analysis-with-databricks-sql-2756

### 5) Hands‑on mapping to this repository
- **Analytics/BI practice**
  - [DBX-DA-Assoc][Dashboards] [DBX-DA-Assoc][UC-RLS] [DBX-DA-Assoc][SQL-Basics] Build queries and dashboards on curated Delta tables; add RLS via dynamic views in UC.
  - [DBX-DA-Assoc][SQL-Basics] [DBX-DA-Assoc][Dashboards] Add a small "Analyst SQL" folder with reusable query snippets and a dashboard spec.

### 6) 7‑day study plan (example)
- Day 1: Delta lakehouse fundamentals; constraints/time travel.
- Day 2: SQL review — joins, windows, CTEs, NULLs.
- Day 3: Unity Catalog permissions and dynamic views for RLS.
- Day 4: Databricks SQL objects — queries, dashboards, alerts.
- Day 5: Performance tips — partitions, file sizes, OPTIMIZE/VACUUM.
- Day 6: Visualization UX and storytelling.
- Day 7: Mock test and notes.

### 7) Skills checklist
- [ ] Write robust SQL with windows/aggregations and handle NULLs. [DBX-DA-Assoc][SQL-Basics]
- [ ] Use Delta features (time travel, constraints) and manage table maintenance. [DBX-DA-Assoc][Delta-Basics] [DBX-DA-Assoc][Maintenance]
- [ ] Build dashboards and alerts in Databricks SQL. [DBX-DA-Assoc][Dashboards] [DBX-DA-Assoc][Alerts] [DBX-DA-Assoc][Viz-BestPractices]
- [ ] Implement RLS/CLS using UC dynamic views and grants. [DBX-DA-Assoc][UC-RLS] [DBX-DA-Assoc][UC-CLS]

### 8) Quick reference
- Time travel example: `SELECT * FROM table VERSION AS OF 3;`
- Constraint example: `ALTER TABLE t ADD CONSTRAINT chk CHECK (qty >= 0);`
- Dynamic view for RLS (concept): use `current_user()` and mapping table; grant SELECT on view.

### 9) Registration and resources
- Data Analyst Associate page: https://www.databricks.com/learn/certification/data-analyst-associate
- Exam guide PDF (Mar 1, 2025): https://www.databricks.com/sites/default/files/2025-02/databricks-certified-data-analyst-associate-exam-guide-1-mar-2025.pdf
- Registration: http://webassessor.com/databricks
- Docs:
  - Databricks SQL: https://docs.databricks.com/sql/
  - Unity Catalog: https://docs.databricks.com/data-governance/unity-catalog/
  - Delta Lake SQL: https://docs.databricks.com/delta/

Books (O'Reilly):
- Designing Data-Intensive Applications — Martin Kleppmann (2017): https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/
- Learning SQL — Alan Beaulieu (3rd ed., 2020): https://www.oreilly.com/library/view/learning-sql-3rd/9781492057604/

---

## Microsoft PL‑300: Power BI Data Analyst — Study Guide (English)

Purpose: concise prep for PL‑300; paraphrases the official outline (verify the exam page for updates).

### 1) Assessment details
- Skills measured: Prepare data; Model data; Visualize and analyze data; Deploy and maintain assets; Manage and secure data.
- Updated exam guide: https://learn.microsoft.com/credentials/certifications/power-bi-data-analyst/
- Free learning paths and labs available; practice assessments offered.

### 2) Outline (high level)
- **Prepare data**
  - [MS-PL300][Prepare] Profile, clean, transform in Power Query; data sources; incremental refresh basics.
- **Model data**
  - [MS-PL300][Model] Star schema, DAX basics, relationships, calculation groups (awareness).
- **Visualize and analyze**
  - [MS-PL300][Visualize] Visuals, measures, bookmarks, drillthrough; Q&A; optimize performance.
- **Manage and secure**
  - [MS-PL300][Secure] Workspaces, roles (RLS), sensitivity labels, deployment pipelines.

### 3) Recommended training
- Microsoft Learn collection (PL‑300): https://learn.microsoft.com/training/browse/?expanded=power-bi&resource_type=learning%20path&roles=data-analyst
- Power BI learning catalog: https://learn.microsoft.com/power-bi/learning-catalog/

### 4) Hands‑on mapping to this repository
- Create a Power BI report over curated Delta tables (via Direct Lake/Fabric awareness or Databricks SQL connector) and implement RLS. [MS-PL300][Visualize] [MS-PL300][Secure]

### 5) Quick reference
- DAX basics: CALCULATE, FILTER, SUMX, VAR, EARLIER (legacy), DIVIDE; date table and time intelligence.
- Performance: star schema, aggregations, composite models, incremental refresh.

### 6) Registration and resources
- PL‑300 page: https://learn.microsoft.com/credentials/certifications/power-bi-data-analyst/
- Practice assessment: available via exam page
- Power BI docs: https://learn.microsoft.com/power-bi/

Books (O'Reilly):
- Definitive Guide to DAX — Russo & Ferrari (2nd ed.): https://www.oreilly.com/library/view/the-definitive-guide/9780138203771/
- Implementing Power BI — Gohil et al.: https://www.oreilly.com/library/view/implementing-power-bi/9781801814457/

---

## Microsoft DP‑700 — Implementing Data Engineering Solutions Using Microsoft Fabric — Study Guide (English)

Purpose: actionable prep for DP‑700 centered on Fabric analytics workflows where a Data Business Analyst collaborates across Lakehouse, Warehouse, and Power BI. Always verify the live study guide before booking.

### 1) Assessment details
- Focus: implement analytics solutions on Microsoft Fabric (ingestion, transformation, Lakehouse/Warehouse, semantic models, reports, governance, deployment).
- Official study guide: https://learn.microsoft.com/credentials/certifications/resources/study-guides/dp-700
- Exam page: https://learn.microsoft.com/credentials/certifications/
- Delivery: online/proctored; format and duration per exam page; check updates for question count/time.

### 2) Skills outline (high level)
Note: see the official study guide for exact phrasing/weights. Typical domains include:

- **Ingest and prepare data in Fabric**
  - [MS-DP700][Pipelines] Data Pipelines vs Dataflows Gen2; connectors; scheduling; parameters; error handling.
  - [MS-DP700][Lakehouse] OneLake concepts; Shortcuts; Lakehouse Files vs Tables; staging with COPY INTO.

- **Implement Lakehouse/Warehouse**
  - [MS-DP700][Lakehouse] Lakehouse: tables, Delta/Parquet; notebooks; SQL endpoints.
  - [MS-DP700][Warehouse] Warehouse: T-SQL objects; views; stored procedures (awareness); performance (indexes/optimizations).

- **Transform and model**
  - [MS-DP700][Pipelines] Notebook transformations (PySpark/SQL); Dataflows Gen2 transformations.
  - [MS-DP700][Modeling] Semantic model design (star schema, relationships, calculation items awareness); RLS.

- **Build analytics artifacts**
  - [MS-DP700][Reports] Reports and dashboards; Direct Lake vs Import vs DirectQuery trade-offs.
  - [MS-DP700][Reports] Metrics, scorecards (awareness), and data lineage.

- **Secure, deploy, and manage**
  - [MS-DP700][Governance] Workspaces, roles, and permissions; sensitivity labels; endorsed datasets.
  - [MS-DP700][Deployment] Deployment Pipelines (Dev → Test → Prod); rules, parameters; ALM considerations.
  - [MS-DP700][Deployment] Monitoring and optimization; capacities; usage metrics.

### 3) Recommended training
- Microsoft Learn — Fabric learning paths and modules (DP‑700 collection):
  - https://learn.microsoft.com/training/browse/?expanded=fabric&roles=data-analyst&resource_type=learning%20path
  - https://learn.microsoft.com/fabric/
- Power BI and Fabric governance/security:
  - Sensitivity labels: https://learn.microsoft.com/power-bi/enterprise/service-security-sensitivity-label-overview
  - RLS in semantic models: https://learn.microsoft.com/power-bi/enterprise/row-level-security

### 4) Hands‑on mapping to this repository
- **From Databricks Gold to Fabric Lakehouse**
  - [MS-DP700][Lakehouse] [MS-DP700][Pipelines] Export curated Delta/Parquet from Databricks Gold; in Fabric, create a Lakehouse and add a Shortcut or ingest via Data Pipeline.
  - [MS-DP700][Modeling] Build a semantic model on top of Fabric Warehouse/Lakehouse tables with star schema and named measures.
  - [MS-DP700][Reports] [MS-DP700][Governance] Create a Power BI report using Direct Lake where possible; implement RLS and sensitivity labels.
  - [MS-DP700][Deployment] Set up a Deployment Pipeline (Dev → Test) and document promotion steps and rules.

### 5) 7‑day study plan (example)
- Day 1: Fabric fundamentals — OneLake, workspaces, capacities, items (Lakehouse, Warehouse, Data Pipeline, Semantic Model, Report).
- Day 2: Ingest — Data Pipelines vs Dataflows Gen2; connectors; scheduling; parameters; retry/error handling.
- Day 3: Lakehouse/Warehouse — tables, SQL endpoints; Warehouse T‑SQL objects; COPY INTO; performance basics.
- Day 4: Modeling — star schema, relationships, RLS; Direct Lake vs Import vs DirectQuery.
- Day 5: Governance — workspaces, roles, sensitivity labels, endorsements; lineage.
- Day 6: Deployment — Deployment Pipelines; rules/parameters; ALM; monitoring and optimization.
- Day 7: Mock review — end‑to‑end build (ingest → model → report → secure → deploy) and notes.

### 6) Skills checklist
- [ ] Configure OneLake Shortcuts and ingest with Data Pipelines/Dataflows Gen2. [MS-DP700][Workspaces] [MS-DP700][Pipelines] [MS-DP700][Lakehouse]
- [ ] Create and manage Lakehouse tables and a Fabric Warehouse for reporting. [MS-DP700][Lakehouse] [MS-DP700][Warehouse]
- [ ] Design a robust semantic model (star schema, relationships, named measures). [MS-DP700][Modeling]
- [ ] Choose and justify Direct Lake vs Import vs DirectQuery. [MS-DP700][Reports]
- [ ] Implement RLS and apply sensitivity labels; manage workspace roles. [MS-DP700][Governance]
- [ ] Configure Deployment Pipelines and promotion rules. [MS-DP700][Deployment]
- [ ] Monitor usage/performance; optimize capacity utilization. [MS-DP700][Deployment]

### 7) Quick reference
- Direct Lake vs Import vs DirectQuery: performance vs freshness vs feature trade‑offs.
- OneLake Shortcut: reference external data without copying; useful for Databricks → Fabric hand‑off.
- Dataflows Gen2 vs Data Pipelines: low‑code entity transforms vs orchestrated ELT pipelines.
- RLS: define roles/filters in the semantic model; test in Power BI Service.
- Deployment Pipelines: map Dev/Test/Prod, define data source rules, validate before promotion.

### 8) Registration and resources
- Study guide: https://learn.microsoft.com/credentials/certifications/resources/study-guides/dp-700
- Fabric docs hub: https://learn.microsoft.com/fabric/
- Power BI docs: https://learn.microsoft.com/power-bi/

---

## Optional discipline certifications (business analysis practice)

These strengthen general BA skills (elicitation, requirements, stakeholder mgmt.) but are not data/BI-specific:
- IIBA ECBA — Entry Certificate in Business Analysis
- IIBA CCBA — Certification of Capability in Business Analysis
- IIBA CBAP — Certified Business Analysis Professional
- PMI-PBA — Professional in Business Analysis

---

## Data  Analyst Tag Glossary (quick reference)

This glossary lists the tags used in this file. For broader definitions shared across roles, see `GLOSSARY.md`.

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-DA-Assoc][Delta-Basics] | Delta Lake basics | ACID transactions, schema enforcement, time travel for audits/rollback. Example: `SELECT * FROM t VERSION AS OF 3;` Tip: run `OPTIMIZE t; VACUUM t;` to reduce small files. Note: VACUUM default retention = 7 days. |
| [DBX-DA-Assoc][CopyInto-Awareness] | COPY INTO awareness | Use `COPY INTO` for idempotent batch loads. Example: `COPY INTO tgt FROM 'abfss://.../load/' FILEFORMAT = PARQUET;` Prefer Auto Loader for streaming/incremental. |
| [DBX-DA-Assoc][UC-RLS] | Unity Catalog RLS | Secure rows via dynamic views filtering on `current_user()`. Example: `CREATE VIEW v AS SELECT * FROM t WHERE region IN (SELECT r FROM map WHERE user=current_user());` Important: Grant access on the VIEW, not the base table: `GRANT SELECT ON VIEW v TO role analyst;`. |
| [DBX-DA-Assoc][UC-CLS] | Unity Catalog CLS | Hide or mask sensitive columns. Example: `CASE WHEN is_member('pii_readers') THEN ssn ELSE NULL END AS ssn_masked`. Combine with sensitivity labels for discovery. |
| [DBX-DA-Assoc][Dashboards] | Databricks SQL dashboards | Build dashboards from saved queries; parameterize; schedule refreshes. Tip: align tiles with KPIs and set alert rules on critical queries. |
| [DBX-DA-Assoc][Alerts] | Alerts | Create threshold or anomaly alerts. Example: alert when `error_rate > 1%`. Ensure query performance before enabling alerts. |
| [DBX-DA-Assoc][Viz-BestPractices] | Visualization best practices | Match chart to intent (trend: line; comparison: bar). Tip: limit decimals, use color intentionally, annotate benchmarks. Avoid dual axes unless justified. |
| [DBX-DA-Assoc][SQL-Basics] | SQL basics | Joins (INNER/LEFT/RIGHT), CTEs, NULL traps (`COALESCE`, `IS NULL`). Example: `SUM(CASE WHEN col IS NULL THEN 0 ELSE col END)`. Windowing: `SUM(sales) OVER (PARTITION BY region ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`. |
| [DBX-DA-Assoc][Maintenance] | Table maintenance | Use `OPTIMIZE` to compact files and `VACUUM` to purge old snapshots. Example: `OPTIMIZE sales ZORDER BY (customer_id);` Note: Z-ORDER availability varies by workspace/edition. |
| [MS-PL300][Prepare] | Prepare data | Power Query steps: profile, deduplicate, `Merge`, `Append`, `Replace Errors`. Example M: `Table.RemoveRowsWithErrors`. Tip: set data types early; plan for Incremental Refresh. |
| [MS-PL300][Model] | Model data | Star schema; one-to-many relationships; hide surrogate keys. Example DAX: `Sales YTD = TOTALYTD([Sales], 'Date'[Date])`. Avoid bi-directional relationships unless necessary. |
| [MS-PL300][Visualize] | Visualize and analyze | Use measures (not columns) for aggregations; bookmarks for narratives; drillthrough with context filters. Tip: optimize with summarization; avoid overplotting. |
| [MS-PL300][Secure] | Manage and secure | RLS roles with `USERPRINCIPALNAME()`. Example DAX filter: `Sales (Restricted) = CALCULATE([Sales], TREATAS(VALUES(Security[Region]), 'DimRegion'[Region]))`. Apply Sensitivity Labels; deploy with pipelines. |
| [MS-DP700][Workspaces] | Workspaces | Organize items (Lakehouse, Warehouse, Pipelines); manage roles/capacities. Tip: separate Dev/Test/Prod workspaces; enforce least privilege. |
| [MS-DP700][Pipelines] | Data Pipelines | Orchestrate ingestions/transforms with parameters, retries, failure paths. Tip: use pipeline activities for COPY INTO/notebooks; monitor run history. |
| [MS-DP700][Lakehouse] | Lakehouse | Use Delta/Parquet tables; stage with `COPY INTO`; notebooks for PySpark/SQL. Example: `CREATE TABLE ... USING DELTA;`. Prefer Lakehouse for heavy ELT. |
| [MS-DP700][Warehouse] | Warehouse | Model with views/T-SQL; tune with partitioning, stats. Example: `CREATE VIEW v AS SELECT ...`. Trade-off: Prefer Lakehouse for large ELT; use Warehouse for serving. |
| [MS-DP700][Modeling] | Semantic modeling | Star schema, conformed dimensions, calculation items (awareness), RLS in semantic models. Tip: adopt measure naming conventions; check relationship cardinality. |
| [MS-DP700][Reports] | Reports & dashboards | Direct Lake = big volumes + freshness; Import = perf stable; DirectQuery = external sources. Tip: document lineage; use metrics/scorecards for goals. |
| [MS-DP700][Governance] | Governance & security | Sensitivity labels, endorsements, access reviews; workspace roles. Tip: avoid sharing datasets widely; use Apps with audience targeting. |
| [MS-DP700][Deployment] | Deployment pipelines | Rules and parameters to swap connections across stages. Tip: track changes; validate before promote; monitor refresh/ingest failures post-deploy. |
