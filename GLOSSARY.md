# Glossary — EuroStyle–Contoso (Databricks & Fabric)

Purpose
- Common, repo-wide vocabulary for Data Engineer (DE), Data Scientist (DS), and Data Business Analyst (DA).
- Neutral definitions with light vendor context (Databricks, Microsoft Fabric/Power BI). FR notes inline where useful.

How to use
- Terms are grouped; use headings or Ctrl+F. Cross‑links point to files in this repo.

---

## Lakehouse & Storage
- Lakehouse: Architecture combining data lake flexibility with warehouse management/performance. Databricks implements this with Delta Lake; Fabric adds Lakehouse/Warehouse items. FR: "lakehouse".
- Delta Lake (Delta): Storage layer over Parquet with ACID transactions and time travel. Key ops: MERGE, OPTIMIZE, VACUUM. Docs: `docs` not yet present; see backlog Feature 1.x.
- Parquet: Columnar open file format optimized for analytics. FR: "format colonne".
- Time travel: Query a table at a past version/timestamp. Example: SELECT ... VERSION AS OF 3.
- External location: UC object mapping to cloud storage with access policies.
- OneLake: Fabric's single logical data lake across workspaces. Shortcuts can reference external data (e.g., ADLS/Databricks output).
- Shortcut: OneLake pointer to data stored elsewhere; avoids copy.

## Governance & Security
- Unity Catalog (UC): Databricks governance for data/AI (catalogs, schemas, tables, permissions, lineage). FR: "catalogue d'unité".
- Catalog/Schema/Table: Three‑level namespace in UC (catalog.schema.table). FR: "catalogue/schéma/table".
- Dynamic view: SQL view applying row/column filters (RLS/CLS) at query time (often using current_user()).
- RLS/CLS: Row‑Level/Column‑Level Security. RLS filters rows per role/user; CLS masks or restricts columns.
- Sensitivity label: Power BI/Fabric classification (e.g., Confidential) enforcing protection.
- Workspace (Fabric): Container for items (Lakehouse, Warehouse, Semantic Model, Report, Pipeline). FR: "espace de travail".

## Processing & Orchestration
- Auto Loader: Incremental file ingestion to Delta using cloud notifications/listing. FR: "chargement automatique".
- COPY INTO: Bulk load SQL command into tables from files.
- Structured Streaming: Micro‑batch/stream processing API in Spark.
- Delta Live Tables (DLT): Declarative pipelines for building reliable Delta flows with expectations (data quality checks).
- Jobs/Workflows: Databricks scheduler for notebooks/SQL/pipelines with dependencies and retries.
- Fabric Data Pipeline: Orchestration pipeline in Fabric (copy/transform/schedule). FR: "pipeline de données".

## Modeling & Analytics
- Medallion architecture: Bronze (raw) → Silver (cleaned) → Gold (curated marts). FR: "architecture médaillon".
- Star schema: Fact and dimension modeling for analytics. FR: "schéma en étoile".
- Semantic model (Power BI): Dataset/model containing tables, relationships, measures (DAX), RLS.
- Direct Lake / DirectQuery / Import: Power BI/Fabric connection modes (performance vs freshness trade‑offs).
- Measures (DAX): Calculations evaluated at query time (e.g., GMV, AOV).
- KPI Catalog: Canonical list of business metrics with definitions. See backlog.

## Machine Learning & MLOps
- MLflow: Experiment tracking, models, and registry for ML lifecycle.
- Feature table: Persisted table of machine‑learning features (often in UC Feature Store; awareness if not enabled in trial).
- Batch scoring: Periodic prediction job writing results to tables.

## Performance & Maintenance
- OPTIMIZE: Compacts small files for read performance; with Z‑ORDER to cluster by a column.
- VACUUM: Removes old files (per retention) to free storage; ensure time travel needs are considered.
- Partitioning: Physically organize table files by a key (e.g., date) to prune scans.

## DevEx & Deployment
- Databricks Repos: Git‑backed folder integration in a workspace.
- DAB (Databricks Asset Bundles): YAML‑defined packaging/deployment for jobs, pipelines, and other assets.
- Fabric Deployment Pipeline: Dev→Test→Prod promotion with rules/parameters.

## Agile & Project Terms
- Epic/Feature/User Story/Task: Backlog hierarchy. FR: "épopée/fonctionnalité/histoire utilisateur/tâche". See `statement/2-eurostyle-contonso-ma-project-backlog.md`.
- DoD (Definition of Done): Criteria to mark a work item complete.
- DQ (Data Quality): Checks and thresholds; see backlog Appendix A.

## Metrics & Commerce (context)
- GMV (Gross Merchandise Value): Total merchandise sales value before returns/discounts.
- AOV (Average Order Value): GMV divided by order count.
- Margin (proxy): Estimated margin when COGS is unavailable; clearly labeled as estimate.

## Exams & Certifications
- PL‑300: Microsoft Power BI Data Analyst.
- DP‑700: Implementing Analytics Solutions Using Microsoft Fabric.
- Databricks Data Analyst Associate: Databricks SQL & dashboards.
- Databricks Data Engineer Associate/Professional: Engineering track for Delta/Spark/Jobs.
- IIBA ECBA/CCBA/CBAP; PMI‑PBA: Business analysis practice certs (not data/BI‑specific).

---

Contributing
- Add terms used in code/notebooks/backlog. Keep vendor‑neutral definitions and link to repo files where helpful.
