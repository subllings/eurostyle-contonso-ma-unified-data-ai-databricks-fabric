# EuroStyle–Contoso – Certification‑Compliant Use Case

This document maps the project narrative (two companies, two datasets) to role‑based certification objectives so learners can practice tasks that align with real exam outlines while staying vendor‑neutral in content.

Scope
- No exam content is reproduced. We paraphrase public outlines and point to official pages.
- Hands‑on steps reuse this repository's backlog and deliverables.

## How to use this guide
- Choose your role or target exam, then complete the tasks in the corresponding track.
- Each task references the backlog (Epics/Features) and adds an exam‑aligned note so you understand what competency it reinforces.

## Track A — Data Engineer (Databricks DE Associate/Professional; Microsoft DP‑700 awareness)

A1) Bronze ingestion (Backlog: Feature 1.1)
- Outcome: Bronze Delta with lineage columns; counts reconciled; mini runbook.
- Exam alignment: Delta fundamentals, ingestion patterns, idempotence basics.
Tags: [DBX-DE-Assoc][Delta-Basics] [DBX-DE-Assoc][Autoloader] [DBX-DE-Assoc][CopyInto] [DBX-DE-Assoc][Medallion]

A2) Silver cleaning & harmonization (Backlog: Feature 1.2)
- Outcome: deduplication on BKs; FX to EUR with documented rounding; crosswalks; idempotent writes.
- Exam alignment: schema evolution, Delta constraints, performance (partitioning), governance basics.
Tags: [DBX-DE-Assoc][Delta-Basics] [DBX-DE-Assoc][Delta-MERGE] [DBX-DE-Assoc][Platform] [DBX-DE-Assoc][UC-Permissions] [MS-DP700][Lakehouse]

A3) Gold marts (Backlog: Feature 1.3)
- Outcome: curated marts (sales_daily, category_perf, customer_360).
- Exam alignment: modeling for analytics, contracts, SLAs, BI connectivity.
Tags: [DBX-DE-Prof][Modeling] [DBX-DE-Prof][SCD2] [DBX-DE-Assoc][Medallion] [DBX-DE-Assoc][Spark-Aggregations] [MS-DP700][Warehouse]

A4) Export to Fabric (Backlog: Epic 4)
- Outcome: Parquet + manifest (prototype) or Shortcuts (enterprise); pipeline ingest.
- Exam alignment: orchestration, integration patterns; DP‑700 awareness (workspaces, pipelines, governance).
Tags: [DBX-DE-Assoc][Jobs] [DBX-DE-Prof][DAB] [DBX-DE-Assoc][Sharing] [DBX-DE-Assoc][Federation] [MS-DP700][Pipelines]

A5) Observability and CI/CD (Optional Extensions)
- Outcome: basic run logs, query history, and a minimal DAB bundle.
- Exam alignment: operations, DAB packaging, environment configs.
Tags: [DBX-DE-Prof][Monitoring-Logs] [DBX-DE-Prof][DAB] [DBX-DE-Prof][CI-CD] [DBX-DE-Assoc][Spark-UI] [MS-DP700][Monitoring]

## Tag Reference Table — Track A (Data Engineer)

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-DE-Assoc][Delta-Basics] | Delta fundamentals | ACID, schema enforcement, time travel. |
| [DBX-DE-Assoc][CopyInto] | COPY INTO | Batch ingestion, idempotence. |
| [DBX-DE-Assoc][Autoloader] | Auto Loader | Streaming ingestion with schema evolution. |
| [DBX-DE-Assoc][Medallion] | Medallion architecture | Bronze, Silver, Gold layers. |
| [DBX-DE-Assoc][Delta-MERGE] | Delta MERGE | UPSERTs, idempotence, keys. |
| [DBX-DE-Assoc][Spark-Aggregations] | Spark aggregations | Joins, windows, partitioning. |
| [DBX-DE-Assoc][Platform] | Compute & performance selection | Choose cluster/SQL warehouse/serverless; partitioning, caching, file sizes. |
| [DBX-DE-Assoc][Jobs] | Jobs orchestration | Deploy, schedule, repair workflows. |
| [DBX-DE-Assoc][UC-Permissions] | Unity Catalog basics | Grants/roles, managed vs external tables, lineage. |
| [DBX-DE-Assoc][Sharing] | Delta Sharing | Internal/external sharing options and trade‑offs. |
| [DBX-DE-Assoc][Federation] | Lakehouse Federation | Connect external sources, cross‑cloud access. |
| [DBX-DE-Assoc][Spark-UI] | Spark UI basics | Read stages/tasks, spot skew/spills/shuffles. |
| [DBX-DE-Prof][Spark-AQE] | Adaptive Query Execution | Partition pruning, broadcast hints. |
| [DBX-DE-Prof][Modeling] | Modeling & contracts | Table properties, schema evolution, SLAs. |
| [DBX-DE-Prof][SCD2] | Slowly Changing Dimensions | History tracking with effective dates and flags. |
| [DBX-DE-Prof][DAB] | Asset Bundles | Packaging/config for deployment. |
| [DBX-DE-Prof][UC-Advanced] | Unity Catalog advanced | RLS, CLS, secrets, tokens. |
| [DBX-DE-Prof][Monitoring-Logs] | Observability | Spark UI, logs, alerts. |
| [MS-DP700][Lakehouse] | Fabric Lakehouse (awareness) | Tables, Delta/Parquet, COPY INTO concepts mirrored in Lakehouse. |
| [MS-DP700][Warehouse] | Fabric Warehouse (awareness) | T-SQL objects/views; performance considerations. |
| [MS-DP700][Pipelines] | Fabric Pipelines (awareness) | Orchestrate ingestion/transform; parameters and schedules. |
| [MS-DP700][Monitoring] | Fabric monitoring (awareness) | Run history, alerting for Fabric items. |

## Track B — Data Scientist (Databricks ML Associate/Professional)

B1) EDA and baselines (Backlog: Feature 2.1)
- Outcome: leakage checks, target logic, baseline model; MLflow init.
- Exam alignment: ML workflows, experiment tracking.
Tags: [DBX-ML-Assoc][EDA] [DBX-ML-Assoc][Splits] [DBX-ML-Assoc][Metrics] [DBX-ML-Assoc][AutoML] [DBX-ML-Assoc][MLflow]

B2) Feature engineering (Backlog: Feature 2.2)
- Outcome: RFM and product overlap features; versioned feature table; schema contract.
- Exam alignment: feature engineering, reproducibility, data access controls.
Tags: [DBX-ML-Assoc][Feature-Engineering] [DBX-ML-Assoc][Feature-Store] [DBX-ML-Assoc][UC] [DBX-ML-Assoc][Splits]

B3) Model training and selection (Backlog: Feature 2.3)
- Outcome: tuned models; metrics; candidate selection; register best model.
- Exam alignment: model development, registry basics.
Tags: [DBX-ML-Prof][Hyperparameter-Tuning] [DBX-ML-Assoc][Metrics] [DBX-ML-Prof][Experimentation] [DBX-ML-Prof][Registry] [DBX-ML-Assoc][MLflow]

B4) Batch scoring and rollout (Backlog: Feature 2.4)
- Outcome: scheduled batch scoring to Gold; export scored tables to Fabric; simple staged rollout; validation report (metrics/skew).
- Exam alignment: deployment, monitoring setup, rollback plan.
Tags: [DBX-ML-Assoc][Batch-Scoring] [DBX-ML-Prof][Deployment] [DBX-ML-Prof][Monitoring] [MS-DP700][Lakehouse]

B5) Drift monitoring (Optional)
- Outcome: small telemetry job capturing feature/score drift; alert thresholds.
- Exam alignment: solution/data monitoring.
Tags: [DBX-ML-Prof][Monitoring] [DBX-ML-Prof][Drift-Metrics] [DBX-ML-Prof][Governance]

## Tag Reference Table — Track B (Data Scientist)

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-ML-Assoc][EDA] | Exploratory Data Analysis | Profiling, distributions, leakage avoidance. |
| [DBX-ML-Assoc][Feature-Engineering] | Feature Engineering | Feature creation, transformation, reproducibility. |
| [DBX-ML-Assoc][AutoML] | Automated ML | Baseline models, leaderboard, limits of automation. |
| [DBX-ML-Assoc][MLflow] | MLflow basics | Track params, metrics, artifacts, registry. |
| [DBX-ML-Assoc][Batch-Scoring] | Batch Scoring | Scheduled inference jobs, reproducibility. |
| [DBX-ML-Assoc][Metrics] | Evaluation Metrics | Choose AUC/PR‑AUC/F1 for classification; RMSE/MAE for regression. |
| [DBX-ML-Assoc][Splits] | Data Splitting | Stratified/time‑based; GroupKFold when entities repeat. |
| [DBX-ML-Assoc][Feature-Store] | Feature Store | Governed feature tables and point‑in‑time joins. |
| [DBX-ML-Prof][Experimentation] | Experiment Management | Reproducibility, naming conventions, parameters. |
| [DBX-ML-Prof][Registry] | Model Registry | Staging/Prod, approvals, rollback. |
| [DBX-ML-Prof][Deployment] | Deployment Patterns | Batch vs online, blue/green, canary rollout. |
| [DBX-ML-Prof][Monitoring] | Monitoring & Drift | PSI/KS, drift alerts, incident handling. |
| [DBX-ML-Prof][Governance] | Governance (UC) | Permissions, lineage, compliance. |
| [DBX-ML-Prof][Hyperparameter-Tuning] | Hyperparameter Tuning | CV/Bayesian/Hyperopt; consistent folds, logged search. |
| [DBX-ML-Prof][Drift-Metrics] | Drift Metrics | PSI/KS/population shift detection and thresholds. |
| [MS-DP700][Lakehouse] | Fabric Lakehouse (awareness) | Export/validate scored tables; lineage awareness. |

## Track C — Data Business Analyst (Databricks Data Analyst Associate; Microsoft PL‑300; DP‑700 awareness)

C1) First Look – Contoso (Backlog: Feature 3.1)
- Outcome: DirectQuery to Bronze; GMV/AOV/Orders with named measures; performance notes.
- Exam alignment: prepare/model/visualize, workspace connections.
Tags: [DBX-DA-Assoc][SQL-Basics] [DBX-DA-Assoc][Dashboards] [DBX-DA-Assoc][Viz-BestPractices] [MS-PL300][Visualize] [MS-DP700][Reports]

C2) Raw vs Silver – Contoso + EuroStyle (Backlog: Feature 3.2)
- Outcome: paired measures (raw/silver/delta); bookmarks/toggles; RLS draft.
- Exam alignment: modeling, visualization, RLS, documentation.
Tags: [DBX-DA-Assoc][SQL-Basics] [DBX-DA-Assoc][Dashboards] [DBX-DA-Assoc][UC-RLS] [MS-PL300][Model] [MS-PL300][Visualize]

C3) Executive Post‑Merger (Backlog: Feature 3.3)
- Outcome: consolidated GMV/AOV/margin; brand/region splits; RLS validated; accessibility.
- Exam alignment: manage and secure, performance tuning, storytelling.
Tags: [DBX-DA-Assoc][UC-RLS] [DBX-DA-Assoc][Viz-BestPractices] [DBX-DA-Assoc][Dashboards] [MS-PL300][Secure]

C4) Fabric Deployment (Backlog: Feature 4.2)
- Outcome: publish via Fabric pipelines; Dev→Test promotion.
- Exam alignment: deployment pipelines, governance, endorsements.
Tags: [MS-DP700][Pipelines] [MS-DP700][Deployment] [MS-DP700][Governance] [MS-DP700][Reports]

C5) Fabric Optimization & Governance (Backlog: Feature 4.2 / 5.2)
- Outcome: apply sensitivity labels and endorsements; validate lineage; configure Monitoring Hub alerts on refresh/ingestion; run Dev→Test promotion checks and access reviews.
- Exam alignment: DP-700 governance & deployment; PL-300 manage/secure.
Tags: [MS-DP700][Governance] [MS-DP700][Deployment] [MS-PL300][Secure] [MS-DP700][Reports] [DBX-DA-Assoc][UC-RLS]

## Tag Reference Table — Track C (Data Business Analyst)

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-DA-Assoc][SQL-Basics] | SQL basics | Joins, windows, aggregations, CTEs, NULLs. |
| [DBX-DA-Assoc][Dashboards] | Dashboards | Build and parameterize dashboards, align KPIs. |
| [DBX-DA-Assoc][Viz-BestPractices] | Visualization best practices | Chart selection, consistent scales, color and annotation guidance. |
| [DBX-DA-Assoc][UC-RLS] | RLS with UC | Restrict rows via dynamic views. |
| [DBX-DA-Assoc][UC-CLS] | CLS with UC | Hide/mask sensitive columns. |
| [DBX-DA-Assoc][Alerts] | Alerts | Query-based alerts, thresholds. |
| [MS-PL300][Prepare] | Prepare data | Profile, clean, incremental refresh. |
| [MS-PL300][Model] | Model data | Star schema, DAX, relationships. |
| [MS-PL300][Visualize] | Visualize | Measures, bookmarks, drillthrough. |
| [MS-PL300][Secure] | Secure data | Workspaces, roles, labels, pipelines. |
| [MS-DP700][Pipelines] | Pipelines | Ingest/transform with scheduling and parameters. |
| [MS-DP700][Lakehouse] | Lakehouse | Tables, Delta/Parquet, COPY INTO. |
| [MS-DP700][Warehouse] | Warehouse | Views, T-SQL objects, performance. |
| [MS-DP700][Reports] | Reports | Direct Lake vs Import vs DirectQuery, lineage. |
| [MS-DP700][Governance] | Governance | Sensitivity labels, endorsed datasets. |
| [MS-DP700][Deployment] | Deployment | Pipelines, ALM, monitoring. |

## References
- Role guides: see `certification/data-engineer-certifications.md`, `certification/data-scientist-certifications.md` (alias: `certification/ml-ai-engineer-certifications.md`), `certification/data-business-analyst-certifications.md` (alias: `certification/analyst-bi-certifications.md`).
- Backlog: `statement/2-eurostyle-contonso-ma-project-backlog.md`.
- Business case: `statement/1-eurostyle-contonso-ma-business-case.md`.
