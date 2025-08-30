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
1. SQL and Analytics Fundamentals — 22%
2. Data Management and Governance — 20%
3. Data Analysis and Visualization — 29%
4. SQL Power Users — 18%
5. SQL Advanced — 11%

Core topics
- Lakehouse and Delta basics: ACID, time travel, constraints; COPY INTO vs Auto Loader (awareness), OPTIMIZE/VACUUM.
- Unity Catalog: catalogs/schemas/tables, grants, dynamic views for RLS/CLS.
- Databricks SQL: dashboards, alerts, queries, visualization best practices.
- SQL patterns: joins, windows, aggregations, CTEs, subqueries, NULL handling; performance tips.

### 4) Recommended training
- Databricks SQL for Data Analysts — https://www.databricks.com/training/catalog/databricks-sql-for-data-analysts-2311
- Data Analysis with Databricks SQL — https://www.databricks.com/training/catalog/data-analysis-with-databricks-sql-2756

### 5) Hands‑on mapping to this repository
- Epic 3 (Analytics/BI): build queries and dashboards on curated Delta tables; add RLS via dynamic views in UC.
- Add a small “Analyst SQL” folder with reusable query snippets and a dashboard spec.

### 6) 7‑day study plan (example)
- Day 1: Delta lakehouse fundamentals; constraints/time travel.
- Day 2: SQL review — joins, windows, CTEs, NULLs.
- Day 3: Unity Catalog permissions and dynamic views for RLS.
- Day 4: Databricks SQL objects — queries, dashboards, alerts.
- Day 5: Performance tips — partitions, file sizes, OPTIMIZE/VACUUM.
- Day 6: Visualization UX and storytelling.
- Day 7: Mock test and notes.

### 7) Skills checklist
- [ ] Write robust SQL with windows/aggregations and handle NULLs.
- [ ] Use Delta features (time travel, constraints) and manage table maintenance.
- [ ] Build dashboards and alerts in Databricks SQL.
- [ ] Implement RLS/CLS using UC dynamic views and grants.

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
- Prepare data: profile, clean, transform in Power Query; data sources; incremental refresh basics.
- Model data: star schema, DAX basics, relationships, calculation groups (awareness).
- Visualize/analyze: visuals, measures, bookmarks, drillthrough; Q&A; optimize performance.
- Manage/secure: workspaces, roles (RLS), sensitivity labels, deployment pipelines.

### 3) Recommended training
- Microsoft Learn collection (PL‑300): https://learn.microsoft.com/training/browse/?expanded=power-bi&resource_type=learning%20path&roles=data-analyst
- Power BI learning catalog: https://learn.microsoft.com/power-bi/learning-catalog/

### 4) Hands‑on mapping to this repository
- Create a Power BI report over curated Delta tables (via Direct Lake/Fabric awareness or Databricks SQL connector) and implement RLS.

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
- Ingest and prepare data in Fabric
  - Data Pipelines vs Dataflows Gen2; connectors; scheduling; parameters; error handling.
  - OneLake concepts; Shortcuts; Lakehouse Files vs Tables; staging with COPY INTO.
- Implement Lakehouse/Warehouse
  - Lakehouse: tables, Delta/Parquet; notebooks; SQL endpoints.
  - Warehouse: T‑SQL objects; views; stored procedures (awareness); performance (indexes/optimizations where applicable).
- Transform and model
  - Notebook transformations (PySpark/SQL); Dataflows Gen2 transformations.
  - Semantic model design (star schema, relationships, calculation items awareness); RLS.
- Build analytics artifacts
  - Reports and dashboards; Direct Lake vs Import vs DirectQuery trade‑offs.
  - Metrics, scorecards (awareness), and data lineage.
- Secure, deploy, and manage
  - Workspaces, roles, and permissions; sensitivity labels; endorsed datasets.
  - Deployment Pipelines (Dev → Test → Prod); rules, parameters; ALM considerations.
  - Monitoring and optimization; capacities; usage metrics.

### 3) Recommended training
- Microsoft Learn — Fabric learning paths and modules (DP‑700 collection):
  - https://learn.microsoft.com/training/browse/?expanded=fabric&roles=data-analyst&resource_type=learning%20path
  - https://learn.microsoft.com/fabric/
- Power BI and Fabric governance/security:
  - Sensitivity labels: https://learn.microsoft.com/power-bi/enterprise/service-security-sensitivity-label-overview
  - RLS in semantic models: https://learn.microsoft.com/power-bi/enterprise/row-level-security

### 4) Hands‑on mapping to this repository
- From Databricks Gold to Fabric Lakehouse:
  - Export curated Delta/Parquet from Databricks Gold; in Fabric, create a Lakehouse and add a Shortcut or ingest via Data Pipeline.
- Build a semantic model on top of Fabric Warehouse/Lakehouse tables with star schema and named measures.
- Create a Power BI report using Direct Lake where possible; implement RLS and sensitivity labels.
- Set up a Deployment Pipeline (Dev → Test) and document promotion steps and rules.

### 5) 7‑day study plan (example)
- Day 1: Fabric fundamentals — OneLake, workspaces, capacities, items (Lakehouse, Warehouse, Data Pipeline, Semantic Model, Report).
- Day 2: Ingest — Data Pipelines vs Dataflows Gen2; connectors; scheduling; parameters; retry/error handling.
- Day 3: Lakehouse/Warehouse — tables, SQL endpoints; Warehouse T‑SQL objects; COPY INTO; performance basics.
- Day 4: Modeling — star schema, relationships, RLS; Direct Lake vs Import vs DirectQuery.
- Day 5: Governance — workspaces, roles, sensitivity labels, endorsements; lineage.
- Day 6: Deployment — Deployment Pipelines; rules/parameters; ALM; monitoring and optimization.
- Day 7: Mock review — end‑to‑end build (ingest → model → report → secure → deploy) and notes.

### 6) Skills checklist
- [ ] Configure OneLake Shortcuts and ingest with Data Pipelines/Dataflows Gen2.
- [ ] Create and manage Lakehouse tables and a Fabric Warehouse for reporting.
- [ ] Design a robust semantic model (star schema, relationships, named measures).
- [ ] Choose and justify Direct Lake vs Import vs DirectQuery.
- [ ] Implement RLS and apply sensitivity labels; manage workspace roles.
- [ ] Configure Deployment Pipelines and promotion rules.
- [ ] Monitor usage/performance; optimize capacity utilization.

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
