# Glossary (English)

Single source of truth for terms and acronyms used across the Business Case and Product Backlog.

## Acronyms (A–Z)

| Acronym | Classification | Explanation |
|---|---|---|
| ADLS (Gen2) | Platform/Storage | Azure Data Lake Storage Gen2, used for governed lake storage in enterprise setups. |
| AOV | Business Metric | Average Order Value = GMV / Orders. |
| AUC | Data Science Metric | Area Under the ROC curve; measures ranking quality for binary classifiers (e.g., churn). |
| AUCPR | Data Science Metric | Area Under the Precision–Recall curve; useful for imbalanced targets like churn. |
| BG/NBD | Data Science Model | Beta-Geometric/Negative Binomial model for repeat purchase frequency in non-contractual settings (used with Gamma–Gamma for CLV). |
| BK | Data Modeling | Business Key; stable real‑world identifier used for deduplication and joins. |
| bps | Finance/Analytics | Basis points (1 bps = 0.01%). Often used for margin deltas. |
| C360 (Customer 360) | Analytics | Unified customer view combining identities, behaviors, and scores (e.g., churn, CLV). |
| CDAO | Role | Chief Data & Analytics Officer. |
| CDP | Platform/Marketing | Customer Data Platform; referenced in learning resources (composable CDP). |
| CLV | Business/DS Metric | Customer Lifetime Value; expected margin or revenue over a defined horizon. |
| CMO | Role | Chief Marketing Officer. |
| COGS | Finance Metric | Cost of Goods Sold; direct costs associated with items sold (drives margin calculations). |
| CI (Confidence Interval) | Statistics | Interval estimate that quantifies uncertainty around a metric (e.g., AUC, RMSE). |
| CI/CD | DevOps | Continuous Integration / Continuous Delivery for automations and deployments. |
| DAX | BI Language | Data Analysis Expressions (Power BI); used for measures (e.g., GMV, AOV). |
| DBFS | Platform/Storage | Databricks File System; workspace-backed storage used in Free/Trial setups. |
| DBU | Platform/Billing | Databricks Unit; consumption/billing unit for compute on Databricks. |
| DLT | Data Engineering | Delta Live Tables (Databricks) for declarative pipelines (not available in Free edition). |
| DQ | Data Quality | Practices/metrics to assess and improve data accuracy, completeness, and consistency. |
| EDA | Data Science | Exploratory Data Analysis; profiling data to understand distributions, gaps, and patterns. |
| ECB | Finance/Data Source | European Central Bank; reference source for daily FX rates. |
| FX | Finance | Foreign Exchange; currency conversion to a common reporting currency (e.g., EUR). |
| F2 (Fabric Free) | Platform/SKU | Microsoft Fabric Free capacity tier used for learning/testing. |
| GMV | Business Metric | Gross Merchandise Value; total merchandise sales value (before returns/discounts). |
| HK | Data Modeling | Hash Key; hashed identifier derived from a Business Key (often used in Data Vault). |
| KPI | Business Metric | Key Performance Indicator; headline metric (e.g., GMV, AOV, margin, churn). |
| KS | Statistics | Kolmogorov–Smirnov test; used to compare distributions (e.g., drift checks). |
| Lakehouse | Architecture | Unified architecture combining data lake storage with warehouse/BI capabilities. |
| MAE | Data Science Metric | Mean Absolute Error; average absolute prediction error (regression). |
| MAPE | Data Science Metric | Mean Absolute Percentage Error; percentage‑based error metric (regression). |
| MLflow | MLOps | Experiment tracking, model registry, and artifacts for ML workflows. |
| OneLake | Platform | Microsoft Fabric's single logical data lake for all Fabric items. |
| PBIX | BI Artifact | Power BI Desktop report file format. |
| PSI | Statistics/Monitoring | Population Stability Index; measures distribution shifts (train vs serve). |
| R2 (R-squared) | Data Science Metric | Proportion of variance explained by a regression model. |
| RFM | Analytics/Segmentation | Recency, Frequency, Monetary value; classic customer segmentation approach. |
| RLS | Security/BI | Row‑Level Security; restricts data access by user role (e.g., brand managers). |
| RMSE | Data Science Metric | Root Mean Squared Error; square‑root of MSE (regression accuracy). |
| ROC | Statistics/DS | Receiver Operating Characteristic curve; plots TPR vs FPR across thresholds. |
| SCD2 | Data Modeling | Slowly Changing Dimension Type 2; tracks attribute history with effective date ranges. |
| SKU | Product | Stock Keeping Unit; unique product identifier. |
| SK | Data Modeling | Surrogate Key; technical key used in dimensional models. |
| UC (Unity Catalog) | Governance | Databricks governance layer for data/AI (catalogs, schemas, privileges, lineage). |
| UTC | Time/Standards | Coordinated Universal Time; recommended for storing timestamps. |
| WoW | Time Series | Week‑over‑Week comparison period. |

Notes
- Alphabetical, English‑only list aligned to the current Business Case and Product Backlog.
- Margin may be labeled "Estimated" when COGS isn't available; see Business Case and Backlog notes.

## Data Engineer Tag Glossary (quick reference)

This glossary lists the tags used in this file. For broader definitions shared across roles, see `GLOSSARY.md`.

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-DE-Assoc][Platform] | Databricks compute and performance | Clusters vs SQL Warehouses vs Serverless; partitioning, caching, file sizing. |
| [DBX-DE-Assoc][Tooling] | Engineering tooling | Databricks Connect, notebooks, repos, debugging tools. |
| [DBX-DE-Assoc][Autoloader] | Auto Loader ingestion | Sources, schema inference/evolution, syntax, core options. |
| [DBX-DE-Assoc][CopyInto] | COPY INTO ingestion | Declarative batch loading, idempotence, when to use vs Auto Loader. |
| [DBX-DE-Assoc][Delta-Basics] | Delta Lake fundamentals | DDL/DML, schema enforcement, constraints, time travel. |
| [DBX-DE-Assoc][Delta-MERGE] | Delta MERGE / UPSERT | MERGE INTO syntax, idempotence, handling duplicates. |
| [DBX-DE-Assoc][Medallion] | Medallion architecture | Bronze, Silver, Gold layers and contracts. |
| [DBX-DE-Assoc][Spark-Aggregations] | Aggregations and windows | SQL/DataFrame aggregations and window functions. |
| [DBX-DE-Assoc][DLT] | Delta Live Tables basics | Pipelines, expectations, quality gates. |
| [DBX-DE-Assoc][Jobs] | Jobs orchestration | Deploy, schedule, repair, re-run workflows. |
| [DBX-DE-Assoc][UC-Permissions] | Unity Catalog basics | Managed vs external tables, grants/roles, lineage. |
| [DBX-DE-Assoc][Sharing] | Delta Sharing | Internal vs external sharing, trade-offs and costs. |
| [DBX-DE-Assoc][Federation] | Lakehouse Federation | Connect external sources, cross-cloud considerations. |
| [DBX-DE-Assoc][Spark-UI] | Spark UI basics | Interpret stages/tasks, skew, spills, shuffles. |
| [DBX-DE-Prof][Tooling] | Databricks tooling | CLI, REST API, repos, notebooks, workflows. |
| [DBX-DE-Prof][DAB] | Databricks Asset Bundles | Package, configure, deploy across environments. |
| [DBX-DE-Prof][Spark-AQE] | Spark Adaptive Query Execution (AQE) | Broadcast joins, partition pruning, caching, runtime optimization. |
| [DBX-DE-Prof][Delta-CDC] | Delta Change Data Capture (CDC) | MERGE patterns, Change Data Feed, incremental upserts. |
| [DBX-DE-Prof][SCD2] | Slowly Changing Dimension Type 2 | Dimensional modeling with history tracking. |
| [DBX-DE-Prof][Modeling] | Modeling and contracts | Table properties, Z-ordering, schema evolution, SLAs. |
| [DBX-DE-Prof][UC-Advanced] | Advanced Unity Catalog governance | Permissions, dynamic views, secrets/tokens, federation. |
| [DBX-DE-Prof][Monitoring-Logs] | Observability | Spark UI, logs, metrics, alerts, SLAs. |
| [DBX-DE-Prof][Testing] | Testing | Data expectations, unit/integration tests. |
| [DBX-DE-Prof][CI-CD] | CI/CD deployment | Promote changes, parameterize configs, DAB-based workflows. |
| [MS-DP700][Workspaces] | Workspaces and settings | Spark, domains, OneLake, data workflows. |
| [MS-DP700][Lifecycle] | Lifecycle management | Version control, DB projects, environments. |
| [MS-DP700][Pipelines] | Fabric Pipelines | Orchestration, scheduling, triggers, parameters. |
| [MS-DP700][Governance-RLS] | Row-Level Security | Define roles/filters on semantic models. |
| [MS-DP700][Governance-CLS] | Column-Level Security | Restrict/mask sensitive columns, dynamic data masking. |
| [MS-DP700][Labels] | Sensitivity & endorsements | Sensitivity labels, endorsement, logging. |
| [MS-DP700][Modeling] | Modeling | Full vs incremental loads, dimensional prep. |
| [MS-DP700][Ingestion-Batch] | Batch ingestion | Stores, shortcuts, mirroring, pipelines. |
| [MS-DP700][Transform-PySpark] | PySpark transforms | Lakehouse transformations. |
| [MS-DP700][Transform-SQL] | SQL/KQL transforms | SQL Warehouse (T-SQL) and KQL patterns. |
| [MS-DP700][Ingestion-Streaming] | Streaming ingestion | Eventstreams, Real-Time Intelligence, Structured Streaming. |
| [MS-DP700][Monitoring] | Monitoring | Monitoring Hub, histories, alerts, troubleshooting. |
| [MS-DP700][Performance] | Performance optimization | Lakehouse, DW, Spark tuning in Fabric. |


## Data Scientist Tag Glossary (quick reference)

This glossary lists the tags used in this file. For broader definitions shared across roles, see `GLOSSARY.md`.

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-ML-Assoc][EDA] | Exploratory Data Analysis (EDA) | Profile distributions, missingness, outliers, correlations; check label balance and leakage risks. Examples: `df.isna().mean()`, `y.value_counts(normalize=True)`. Tip: stratify or time‑aware splits. Warning: computing aggregates using target before split leaks information. |
| [DBX-ML-Assoc][Feature-Engineering] | Feature Engineering | Encode categorical, scale numeric, derive time‑based features; fit transformers on train only, then transform val/test. Examples: `OneHotEncoder(handle_unknown='ignore')`, `StandardScaler().fit(X_train)`. Tip: use `Pipeline` to avoid leakage. Warning: target encoding without proper CV leaks. |
| [DBX-ML-Assoc][AutoML] | Automated Machine Learning (AutoML) | Quickly baseline with automated search and generated notebooks; set primary metric and time/compute limits; exclude leaky columns (IDs, targets). Example: set metric `roc_auc`, timeout 15 min; review generated pipeline for correctness. Tip: treat AutoML as baseline, not final. |
| [DBX-ML-Assoc][MLflow] | MLflow Tracking/Registry | Log params/metrics/artifacts; register models with signatures and pinned dependencies for reproducibility. Examples: `mlflow.start_run(); mlflow.log_params(p)`, `mlflow.sklearn.log_model(model,'model')`. Tip: log dataset version (e.g., Delta `versionAsOf`). Warning: unpinned envs break redeploys. |
| [DBX-ML-Assoc][UC] | Unity Catalog (UC) | Govern access to feature tables, models, and notebooks; use catalog.schema names and roles. Example (SQL): `GRANT SELECT ON TABLE cat.sch.features TO ROLE analysts`. Tip: prefer managed locations for lineage. |
| [DBX-ML-Assoc][Batch-Scoring] | Batch Scoring | Use deterministic input snapshots (Delta time travel) and idempotent writes (partition overwrite). Examples: `spark.read.format('delta').option('versionAsOf',123).load(path)`, `df.write.format('delta').mode('overwrite').option('replaceWhere','dt=2025-08-30').save(path)`. Warning: schema drift and non‑deterministic UDFs hurt reproducibility. |
| [DBX-ML-Assoc][Metrics] | Evaluation Metrics | Choose metrics by task/imbalance: classification (AUC/ROC, PR‑AUC, F1, recall), regression (RMSE/MAE/R<sup>2</sup>). Examples: `roc_auc_score(y, p)`, `mean_squared_error(y, yhat, squared=False)`. Tip: calibrate thresholds; don't compare across different splits. |
| [DBX-ML-Assoc][Splits] | Data Splitting | Train/val/test with stratification; for time series use time‑based splits; use GroupKFold when entities repeat. Example: `train_test_split(X,y,stratify=y,random_state=42)`. Warning: random splits on temporal data leak future into past. |
| [DBX-ML-Assoc][Feature-Store] | Feature Store (UC) | Centralize features with governance and point‑in‑time correctness; reuse across teams. Example: `FeatureEngineeringClient().read_table('cat.sch.features')`. Tip: document keys and freshness; use point‑in‑time joins to avoid leakage. |
| [DBX-ML-Prof][Experimentation] | Experiment Management | Structure runs (names/seeds/tags), fix randomness, and compare candidates fairly with identical folds. Examples: `np.random.seed(42)`, `mlflow.log_params(params)`. Warning: peeking at test set biases results. |
| [DBX-ML-Prof][Registry] | Model Registry (MLflow) | Promote/demote with approvals; attach descriptions, aliases, and run links; enable rollback. Examples: `client.transition_model_version_stage(name,v,'Staging')`, `client.set_registered_model_alias(name,'prod','3')`. Tip: gate promotions on evaluated metrics and tests. |
| [DBX-ML-Prof][Deployment] | Deployment Patterns | Batch vs online; Blue/Green (two envs, switch traffic) and Canary (small subset first). Example (SQL canary): `SELECT * FROM data WHERE MOD(hash(id),20)=0`. Tip: isolate deps via model env (requirements). |
| [DBX-ML-Prof][Monitoring] | Monitoring | Log serving/batch metrics and latency; store predictions/features for audits; alert on SLO breaches. Tip: monitor both quality and data health. |
| [DBX-ML-Prof][Drift-Metrics] | Drift Detection Metrics | Detect covariate/label drift with PSI/KS and population share changes. Example: `from scipy.stats import ks_2samp; ks_2samp(a,b)`. Tip: compare to training baselines and recent windows; investigate upstream pipeline changes first. |
| [DBX-ML-Prof][CI-CD] | Model CI/CD | Automate tests (unit on features, smoke scoring), evaluate models in pipelines, and require approvals before registry promotion. Tip: pin library versions; fail fast on schema changes. |
| [DBX-ML-Prof][Governance] | Governance (Unity Catalog) | Enforce permissions on models/features; capture lineage; use catalog.schema for clarity. Example: `models:/cat.sch.model_name`. Tip: audit access and stage transitions. |

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
