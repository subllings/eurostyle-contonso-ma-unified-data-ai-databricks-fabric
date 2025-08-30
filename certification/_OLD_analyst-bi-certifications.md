# Analyst / BI — Certifications Study Guides

Note: This file has been superseded by `data-business-analyst-certifications.md` (preferred naming). Please use that guide; this file remains as an alias/redirect to avoid broken links.

This file consolidates study guides for the Analyst / BI profile.

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
- Add a small "Analyst SQL" folder with reusable query snippets and a dashboard spec.

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
