# Data Engineer — Certifications Study Guides

This file consolidates study guides for the Data Engineer profile.

## Databricks Certified Data Engineer Associate — Study Guide (English)

Purpose: provide a concise, actionable structure to prepare for the Data Engineer Associate exam without reproducing any protected exam content. Aligned with the live exam guide as of July 25, 2025. Always verify the official page two weeks before your test for updates.

### 1) Audience and goals
- Goal: strengthen fundamentals for ingesting, transforming, and optimizing data on the Databricks Lakehouse.
- Audience: new or aspiring Data/Analytics Engineers using Spark/Delta.
- Helpful background: basic SQL, Spark DataFrame concepts, Parquet/Delta basics, notebooks and git.

### 2) Exam details (current guide references)
- Scored items: 45 multiple-choice questions
- Time limit: 90 minutes
- Registration fee: USD 200 (plus taxes as applicable)
- Delivery: online proctored; test aides not allowed
- Prerequisite: no formal prerequisites; hands-on experience recommended
- Validity: 2 years; recertification required by retaking the current exam
- Unscored content: some items may be unscored for statistical purposes (extra time is accounted for)
- Official page: https://www.databricks.com/learn/certification/data-engineering-certificates

### 3) Exam outline and weights

Section 1 — Databricks Intelligence Platform (10%)
- [DBX-DE-Assoc][Platform] Describe the platform value and workspace building blocks, and select the right compute (clusters, SQL warehouses, serverless) for a use case.
- [DBX-DE-Assoc][Platform] Enable and use features that simplify data layout choices and improve query performance (partitioning, file sizing, caching, relevant platform accelerators).

Section 2 — Development and Ingestion (30%)
- [DBX-DE-Assoc][Tooling] Use Databricks Connect in data engineering workflows.
- [DBX-DE-Assoc][Tooling] Identify notebook capabilities (versioning, repos integration, collaboration) and when to use each.
- [DBX-DE-Assoc][Autoloader] Classify valid Auto Loader sources and use cases; demonstrate Auto Loader syntax and options at a high level.
- [DBX-DE-Assoc][CopyInto] Choose COPY INTO for batch ingestion and explain when it is preferred over Auto Loader.
- [DBX-DE-Assoc][Tooling] Use built-in debugging tools to troubleshoot jobs and notebooks.

Section 3 — Data Processing and Transformations (31%)
- [DBX-DE-Assoc][Medallion] Explain the Medallion architecture (Bronze, Silver, Gold) and the purpose of each layer.
- [DBX-DE-Assoc][Platform] Choose cluster types/configurations for performance given a scenario.
- [DBX-DE-Assoc][DLT] Describe DLT (Delta Live Tables) concepts and implement basic pipelines with expectations and quality gates.
- [DBX-DE-Assoc][Delta-Basics] Identify core DDL/DML features in SQL and Delta.
- [DBX-DE-Assoc][Delta-MERGE] Implement an idempotent MERGE (UPSERT) on a business key.
- [DBX-DE-Assoc][Spark-Aggregations] Compute non-trivial aggregations and metrics with PySpark DataFrames and/or Spark SQL.

Section 4 — Productionizing Data Pipelines (18%)
- [DBX-DE-Assoc][Jobs] Compare Databricks Asset Bundles (DAB) to traditional deployment methods and identify bundle structure.
- [DBX-DE-Assoc][Jobs] Deploy workflows; repair and re-run failed tasks; schedule jobs effectively.
- [DBX-DE-Assoc][Platform] Use serverless for managed, auto-optimized compute when appropriate.
- [DBX-DE-Assoc][Spark-UI] Review Spark UI to reason about and optimize a query.

Section 5 — Data Governance and Quality (11%)
- [DBX-DE-Assoc][UC-Permissions] Differentiate managed vs external tables; apply Unity Catalog permissions and identify key roles.
- [DBX-DE-Assoc][UC-Permissions] Understand audit log storage patterns and use lineage.
- [DBX-DE-Assoc][Sharing] Use Delta Sharing; know types (Databricks-to-Databricks vs external), trade-offs, and cross-cloud cost considerations.
- [DBX-DE-Assoc][Federation] Identify Lakehouse Federation use cases when connecting to external sources.

### Tag Reference Table — Databricks DE Associate

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-DE-Assoc][Platform] | Databricks compute and performance levers | Clusters vs Structured Query Language (SQL) warehouses vs serverless; how partitioning, caching, and file sizing impact cost and speed. |
| [DBX-DE-Assoc][Tooling] | Engineering tooling | Databricks Connect, notebooks, repos, debugging tools. |
| [DBX-DE-Assoc][Autoloader] | Auto Loader ingestion | Sources, schema inference/evolution, core options/syntax. |
| [DBX-DE-Assoc][CopyInto] | COPY INTO ingestion | Declarative batch loading command; when to prefer it over Auto Loader; idempotent re-runs. |
| [DBX-DE-Assoc][Delta-Basics] | Delta Lake fundamentals | Data Definition Language (DDL) / Data Manipulation Language (DML), schema enforcement and constraints, and time travel to audit/restore. |
| [DBX-DE-Assoc][Delta-MERGE] | Delta MERGE / UPSERT | How MERGE INTO works to upsert on keys, avoid duplicates, and keep pipelines idempotent. |
| [DBX-DE-Assoc][Medallion] | Medallion architecture | Purpose of Bronze, Silver, Gold layers. |
| [DBX-DE-Assoc][Spark-Aggregations] | Aggregations and windows | Structured Query Language (SQL) / DataFrames aggregations and window functions; when to push logic to SQL vs code. |
| [DBX-DE-Assoc][DLT] | Delta Live Tables (DLT) basics | What DLT pipelines are, using expectations and quality gates to catch bad data early. |
| [DBX-DE-Assoc][Jobs] | Jobs orchestration | Deploy, schedule, repair, and re-run workflows. |
| [DBX-DE-Assoc][UC-Permissions] | Unity Catalog (UC) basics | UC object model (catalog/schema/table), managed vs external tables, roles/grants, and lineage. |
| [DBX-DE-Assoc][Sharing] | Delta Sharing | Internal vs external sharing, trade-offs and costs. |
| [DBX-DE-Assoc][Federation] | Lakehouse Federation | When to connect to external sources. |
| [DBX-DE-Assoc][Spark-UI] | Spark User Interface (UI) basics | How to read stages/tasks; identify skew, spills, and shuffles to tune jobs. |

Note: section names and weights mirror the July 25, 2025 guide; wording here is paraphrased for study purposes.

### 4) Recommended training (current guide)
- Instructor-led: Data Engineering with Databricks — https://www.databricks.com/learn/training/catalog/data-engineering
- Self-paced (Databricks Academy):
  - Data Ingestion with LakeFlow Connect
  - Deploy Workloads with LakeFlow Jobs
  - Build Data Pipelines with LakeFlow Declarative Pipelines
  - Data Management and Governance with Unity Catalog

### 5) Hands-on mapping to this repository
- **Medallion and Delta**
  - [DBX-DE-Assoc][Medallion] [DBX-DE-Assoc][Delta-Basics] See `statement/2-eurostyle-contonso-ma-project-backlog.md` (Epics 1 and 4) for contracts, idempotence, and export manifests.
- **Ingestion**
  - [DBX-DE-Assoc][Autoloader] [DBX-DE-Assoc][CopyInto] Adapt ingestion (Auto Loader vs COPY INTO) from Epic 1 into practice notebooks.
- **Streaming**
  - Build a small file-to-Delta streaming pipeline (checkpointing and idempotence).
- **DLT concepts**
  - [DBX-DE-Assoc][DLT] Transpose the medallion design into DLT definitions; otherwise document the approach.
- **Optimization**
  - [DBX-DE-Assoc][Platform] [DBX-DE-Assoc][Delta-Basics] Practice repartition/coalesce, file size targeting, and Delta constraints; review feature notes.
- **Unity Catalog**
  - [DBX-DE-Assoc][UC-Permissions] Prefer catalog.schema.table naming when UC is available (simulate hierarchy otherwise).

### 6) 10-day study plan (example)
- Days 1–2: Delta fundamentals (create/read/write, schema/enforcement, time travel, MERGE/UPSERT).
- Days 3–4: Ingestion (Auto Loader vs COPY INTO), schema evolution, Bronze→Silver contracts.
- Days 5–6: Transformations with SQL/DataFrames (windows, aggregations) and lightweight quality checks.
- Day 7: Structured Streaming basics (triggers, checkpoints, watermarks) writing to Delta.
- Day 8: Orchestration (Jobs, DLT concepts), small-files mitigation, partitioning.
- Day 9: Unity Catalog, permissions/roles, SQL Warehouse and BI connectivity.
- Day 10: Full review + gap-filling and a tiny end-to-end practice project.

### 7) Skills checklist (tick as you go)
- [ ] Create/read/write Delta tables; perform time travel and restores.
- [ ] Explain schema evolution and constraints, and when to use them.
- [ ] Choose between Auto Loader and COPY INTO for a scenario.
- [ ] Implement an idempotent MERGE (UPSERT) on a business key.
- [ ] Write non-trivial aggregations and window functions in SQL/DataFrames.
- [ ] Describe streaming triggers, checkpoints, and watermarks.
- [ ] Outline DLT expectations and bronze/silver/gold patterns.
- [ ] Reduce small files and select reasonable partitioning.
- [ ] Apply UC object model basics and permissions.
- [ ] Connect a SQL Warehouse to a BI tool and validate a query.

### 8) Quick reference snippets (generic)
- Delta MERGE (UPSERT):
  - `MERGE INTO target t USING source s ON t.key = s.key WHEN MATCHED THEN UPDATE SET * WHEN NOT MATCHED THEN INSERT *`
- Auto Loader (PySpark skeleton):
  - `spark.readStream.format("cloudFiles").option("cloudFiles.format","json").load(input)`
- Structured Streaming to Delta:
  - `df.writeStream.format("delta").option("checkpointLocation", chk).start(path)`
- Partitioning and file sizing: aim for reasonable file sizes (e.g., 128–512 MB) and balanced partitions for your volume.

### 9) Registration and resources
- Register/sign in on the exam delivery platform from the official page.
- Review technical requirements and run a system check for online proctoring.
- Official certification pages:
  - Data Engineer Associate: https://www.databricks.com/learn/certification/data-engineer-associate
  - Certification overview: https://www.databricks.com/learn/certification/data-engineering-certificates
- Product docs:
  - Delta Lake: https://docs.databricks.com/delta/
  - Auto Loader: https://docs.databricks.com/ingestion/auto-loader/
  - Structured Streaming: https://docs.databricks.com/structured-streaming/
  - Delta Live Tables: https://docs.databricks.com/delta-live-tables/
  - Unity Catalog: https://docs.databricks.com/data-governance/unity-catalog/

Books (O'Reilly):
- Learning Spark, 2nd Edition — Jules S. Damji, Brooke Wenig, Tathagata Das, Denny Lee (2020): https://www.oreilly.com/library/view/learning-spark-2nd/9781492050032/
- Spark: The Definitive Guide — Bill Chambers, Matei Zaharia (2018): https://www.oreilly.com/library/view/spark-the-definitive/9781491912201/
- High Performance Spark — Holden Karau, Rachel Warren (2017): https://www.oreilly.com/library/view/high-performance-spark/9781491943199/
- Streaming Systems — Tyler Akidau, Slava Chernyak, Reuven Lax (2018): https://www.oreilly.com/library/view/streaming-systems/9781491983867/
- Designing Data-Intensive Applications — Martin Kleppmann (2017): https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/

---

## Databricks Certified Data Engineer Professional — Study Guide (English)

Purpose: actionable prep for advanced data engineering on Databricks. This guide paraphrases the live exam outline and details (as of Aug 30, 2025). Always verify the official page before booking.

### 1) Audience and goals
- Goal: design, build, optimize, secure, and operate production-grade pipelines on Databricks.
- Audience: Data Engineers with 1+ year hands-on Databricks experience (Spark, Delta, Jobs, UC).
- Useful background: strong Spark SQL/DataFrames, Delta Lake features, CI/CD, observability basics.

### 2) Assessment details
- Questions: 60 multiple-choice
- Time limit: 120 minutes
- Fee: USD 200 (plus taxes)
- Delivery: online proctored; no test aides
- Languages: English, Japanese, Portuguese BR, Korean
- Prerequisites: none; 1+ year experience recommended
- Validity: 2 years; recertification by retaking the current exam
- Unscored content: some items may be unscored; extra time is included
- Note: Code examples primarily in Python; Delta functionality referenced in SQL
- Official page: https://www.databricks.com/learn/certification/data-engineer-professional
- Exam guide PDF: https://www.databricks.com/sites/default/files/2025-02/databricks-certified-data-engineer-professional-exam-guide-1-mar-2025.pdf

### 3) Exam outline and weights
**Section 1 — Databricks Tooling (20%)**
- [DBX-DE-Prof][Tooling] Use Databricks CLI and REST API (auth, common operations).
- [DBX-DE-Prof][Tooling] Work with Repos, notebooks (versioning, collaboration), and Git workflows.
- [DBX-DE-Prof][DAB] Use Databricks Asset Bundles (DAB) for packaging, configuration, environments, and deployment.
- [DBX-DE-Prof][Tooling] Manage and troubleshoot Workflows (Jobs), task dependencies, parameters, retries, and serverless options.

**Section 2 — Data Processing (30%)**
- [DBX-DE-Prof][Spark-AQE] Optimize Spark SQL/DataFrame jobs (joins, aggregations, windowing); choose cluster/warehouse types.
- [DBX-DE-Prof][Spark-AQE] Apply performance techniques: AQE, broadcast hints, partition pruning, caching, file sizing.
- [DBX-DE-Prof][Spark-AQE] Build robust batch and streaming pipelines (sources/sinks, checkpoints, watermarks, state, idempotence) on Delta.
- [DBX-DE-Prof][Delta-CDC] Handle CDC with Delta (MERGE, Change Data Feed) and incremental patterns.

**Section 3 — Data Modeling (20%)**
- [DBX-DE-Prof][SCD2] Model lakehouse tables for analytics (dimensional/star, slowly changing dimensions, surrogate keys).
- [DBX-DE-Prof][Modeling] Apply table properties, constraints, Z-ordering (where available), and schema evolution.
- [DBX-DE-Prof][Tooling] Design Bronze/Silver/Gold contracts and SLAs.

**Section 4 — Security and Governance (10%)**
- [DBX-DE-Prof][UC-Advanced] Enforce Unity Catalog permissions (catalog/schema/table, views), grants, and object ownership.
- [DBX-DE-Prof][UC-Advanced] Apply row/column-level controls (dynamic views), secrets, tokens, and credential passthrough patterns.
- [DBX-DE-Prof][UC-Advanced] [DBX-DE-Prof][Monitoring-Logs] Use audit logs and lineage at a high level; understand Delta Sharing concepts and Lakehouse Federation basics.

**Section 5 — Monitoring and Logging (10%)**
- [DBX-DE-Prof][Monitoring-Logs] Interpret Spark UI (stages/tasks, skew, spills, shuffle) to diagnose performance.
- [DBX-DE-Prof][Monitoring-Logs] Use job run logs, metrics, and system tables for observability.
- [DBX-DE-Prof][Monitoring-Logs] Set alerts and notifications for failures and SLAs.

**Section 6 — Testing and Deployment (10%)**
- [DBX-DE-Prof][Testing] Validate data quality with expectations (DLT/SQL constraints) and sanity checks.
- [DBX-DE-Prof][Testing] Implement unit/integration tests for transformations; promote through environments.
- [DBX-DE-Prof][DAB] [DBX-DE-Prof][CI-CD] Deploy reliably with DAB/Workflows; parameterize and use environment-specific configs.

### Tag Reference Table — Databricks DE Professional

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-DE-Prof][Tooling] | Databricks tooling | Command-Line Interface (CLI) and REST API usage; Repos, notebooks, and Jobs operations to automate tasks. |
| [DBX-DE-Prof][DAB] | Databricks Asset Bundles (DAB) | How to package code/config for repeatable deployments across environments (dev/test/prod). |
| [DBX-DE-Prof][Spark-AQE] | Spark performance and Adaptive Query Execution (AQE) | Tuning joins, partition pruning, caching, and file sizing; AQE adapts plans at runtime. |
| [DBX-DE-Prof][Delta-CDC] | Delta Change Data Capture (CDC) | Use MERGE and Change Data Feed (CDF) to process only changes and keep tables in sync. |
| [DBX-DE-Prof][SCD2] | Slowly Changing Dimension Type 2 (SCD2) | Track history in dimensions with effective dates and current flags; create surrogate keys. |
| [DBX-DE-Prof][Modeling] | Table design properties | Choose table properties, define constraints, apply Z-ordering (if available), and evolve schemas safely. |
| [DBX-DE-Prof][UC-Advanced] | Unity Catalog (UC) advanced governance | Permissions and dynamic views; manage secrets/tokens; when to use federation/sharing. |
| [DBX-DE-Prof][Monitoring-Logs] | Observability | Use Spark UI, run logs, and metrics; set alerts to catch failures and SLA breaches. |
| [DBX-DE-Prof][Testing] | Testing | Write data expectations and unit/integration tests so pipelines fail fast on bad data. |
| [DBX-DE-Prof][CI-CD] | Continuous Integration/Continuous Delivery (CI/CD) | Promote changes with approvals; parameterize configs when deploying with DAB/Workflows. |

Note: Names/weights mirror the official guide; bullets are paraphrased for study.

### 4) Recommended training
- Instructor-led: Advanced Data Engineering with Databricks — https://www.databricks.com/learn/training/catalog/advanced-data-engineering
- Self-paced (Academy):
  - Databricks Streaming and Delta Live Tables — https://www.databricks.com/learn/training/catalog/databricks-streaming-and-delta-live-tables
  - Databricks Data Privacy — https://www.databricks.com/learn/training/catalog/databricks-data-privacy
  - Databricks Performance Optimization — https://www.databricks.com/learn/training/catalog/databricks-performance-optimization
  - Automated Deployment with Databricks Asset Bundles — https://www.databricks.com/learn/training/catalog/automated-deployment-with-databricks-asset-bundles

### 5) Hands-on mapping to this repository
- **Modeling and Delta**
  - [DBX-DE-Prof][SCD2] [DBX-DE-Prof][Delta-CDC] `statement/2-eurostyle-contonso-ma-project-backlog.md` (Epics 1, 4) — extend with CDF-based upserts and SCD2.
- **Performance**
  - [DBX-DE-Prof][Spark-AQE] Add notebooks to compare joins (broadcast vs shuffle), partitioning, and small-file mitigation.
- **Streaming**
  - [DBX-DE-Prof][Spark-AQE] Implement a stateful stream with watermarks and exactly-once to Delta (repair/restart scenarios).
- **CI/CD**
  - [DBX-DE-Prof][DAB] [DBX-DE-Prof][CI-CD] Create a minimal DAB bundle to deploy a Workflow with env configs (dev/test/prod) and parameters.
- **Governance**
  - [DBX-DE-Prof][UC-Advanced] Add a permission matrix (roles → catalog.schema.table) and a dynamic view example for RLS/CLS.
- **Observability**
  - [DBX-DE-Prof][Monitoring-Logs] Capture job run logs and query history; summarize hot stages from Spark UI.

### 6) 12-day study plan (example)
- Days 1–2: Tooling (CLI, REST, Repos) and Workflows (dependencies, retries, serverless).
- Days 3–4: Spark performance (AQE, joins, partition pruning, caching; file sizing on Delta).
- Days 5–6: Streaming (state, watermarks, checkpoints) and robust batch incrementals (MERGE, CDF).
- Days 7–8: Data modeling (star/SCD2, contracts, constraints/Z-order) and UC governance (permissions, secrets).
- Day 9: Monitoring (Spark UI, logs, metrics, system tables) and alerting.
- Day 10: Testing (unit/integration, expectations) and deployment with DAB.
- Days 11–12: Capstone — build and deploy a small end-to-end pipeline with CI/CD and runbook.

### 7) Skills checklist
- [ ] Use CLI/REST to manage jobs, clusters, repos; authenticate securely.
- [ ] Package and deploy with DAB across environments; parameterize configs.
- [ ] Optimize Spark queries (broadcast/AQE/partition pruning/caching) and reason via Spark UI.
- [ ] Implement MERGE/CDF incrementals; design SCD2.
- [ ] Build stateful Structured Streaming with watermarks to Delta (idempotent, recoverable).
- [ ] Define UC permissions and dynamic views for RLS/CLS; manage secrets.
- [ ] Instrument pipelines with logs/metrics; set alerts for failures/SLAs.
- [ ] Write tests for transformations and data expectations; wire into CI/CD.

### 8) Quick reference snippets (generic)
- Broadcast join hint (SQL):
  - `SELECT /*+ BROADCAST(dim) */ f.* FROM fact f JOIN dim ON f.key = dim.key`
- MERGE with CDF (pattern):
  - `MERGE INTO tgt t USING src s ON t.id = s.id WHEN MATCHED THEN UPDATE SET * WHEN NOT MATCHED THEN INSERT *`
- Structured Streaming to Delta:
  - `df.writeStream.format("delta").option("checkpointLocation", chk).start(path)`
- AQE enable (session-level):
  - `SET spark.sql.adaptive.enabled = true;`

### 9) Getting ready
- Review the exam guide and take related training.
- Register and verify online proctoring requirements; run a system check.
- Re-review the outline to spot gaps; study to fill them.
- Practice with a small end-to-end, production-minded pipeline.

### 10) Registration and resources
- Professional page: https://www.databricks.com/learn/certification/data-engineer-professional
- Credentials portal: https://credentials.databricks.com/
- FAQ: https://www.databricks.com/learn/certification/faq
- Docs: Delta, Structured Streaming, DLT, Unity Catalog, Asset Bundles

Books (O'Reilly):
- Learning Spark, 2nd Edition — Jules S. Damji, Brooke Wenig, Tathagata Das, Denny Lee (2020): https://www.oreilly.com/library/view/learning-spark-2nd/9781492050032/
- Spark: The Definitive Guide — Bill Chambers, Matei Zaharia (2018): https://www.oreilly.com/library/view/spark-the-definitive/9781491912201/
- High Performance Spark — Holden Karau, Rachel Warren (2017): https://www.oreilly.com/library/view/high-performance-spark/9781491943199/
- Streaming Systems — Tyler Akidau, Slava Chernyak, Reuven Lax (2018): https://www.oreilly.com/library/view/streaming-systems/9781491983867/
- Designing Data-Intensive Applications — Martin Kleppmann (2017): https://www.oreilly.com/library/view/designing-data-intensive-applications/9781491903063/

---

## Microsoft DP-700 — Implementing Data Engineering Solutions Using Microsoft Fabric — Study Guide (English)

Purpose: concise, actionable prep for DP-700. Paraphrased from the official study guide (as of Apr 21, 2025). Always verify the live page before booking.

### 1) Exam overview
- Role: Fabric Data Engineer — ingest/transform data, implement and manage analytics solutions, monitor/optimize.
- Question format: multiple choice; passing score 700/1000; proctored online.
- Official study guide: https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/dp-700

### 2) Skills measured (at a glance)
- Implement and manage an analytics solution (30–35%)
- Ingest and transform data (30–35%)
- Monitor and optimize an analytics solution (30–35%)

### 3) What to study (paraphrased outline)
Implement and manage an analytics solution
- Configure workspace settings (Spark, domains, OneLake, data workflows). [MS-DP700][Workspaces]
- Implement lifecycle management: version control, database projects, deployment pipelines. [MS-DP700][Lifecycle] [MS-DP700][Pipelines]
- Configure security and governance: workspace and item access, RLS/CLS/object/file-level controls, dynamic data masking, sensitivity labels, endorsement, logging. [MS-DP700][Governance-RLS] [MS-DP700][Governance-CLS] [MS-DP700][Labels]
- Orchestrate processes: choose pipeline vs notebook; schedules, event triggers; parameters and dynamic expressions. [MS-DP700][Pipelines]

Ingest and transform data
- Design loading patterns: full vs incremental; prep for dimensional models; streaming loads. [MS-DP700][Modeling]
- Batch: choose stores; pick between Dataflows/Notebooks/KQL/T‑SQL; shortcuts and mirroring; pipelines; transform with PySpark/SQL/KQL; denormalize; aggregates; handle duplicates/missing/late data. [MS-DP700][Ingestion-Batch] [MS-DP700][Transform-PySpark] [MS-DP700][Transform-SQL] [MS-DP700][Pipelines]
- Streaming: pick a streaming engine; native vs mirrored vs shortcuts in Real-Time Intelligence; eventstreams; Spark Structured Streaming; KQL; windowing. [MS-DP700][Ingestion-Streaming]

Monitor and optimize an analytics solution
- Monitor ingestion, transformation, and semantic model refresh; configure alerts. [MS-DP700][Monitoring]
- Diagnose and resolve errors across pipelines, dataflows, notebooks, eventhouse/stream, and T‑SQL. [MS-DP700][Monitoring]
- Optimize performance: lakehouse tables, pipelines, data warehouses, eventstreams/houses, Spark, and query performance. [MS-DP700][Performance]

### Tag Reference Table — Microsoft DP-700

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [MS-DP700][Workspaces] | Workspaces and settings | Configure workspace roles and settings, Spark runtimes, domains, OneLake permissions, and data workflows. |
| [MS-DP700][Lifecycle] | Lifecycle management | Version control, database projects, environments. |
| [MS-DP700][Pipelines] | Fabric Pipelines | Orchestrate tasks on a schedule or event; use parameters and expressions for reusable flows. |
| [MS-DP700][Governance-RLS] | Row-Level Security (RLS) | Define roles and filters so users only see their permitted rows in models and warehouses. |
| [MS-DP700][Governance-CLS] | Column-Level Security (CLS) | Restrict or mask sensitive columns; apply dynamic data masking where appropriate. |
| [MS-DP700][Labels] | Sensitivity labels and endorsements | Mark sensitivity, set endorsements, and record access to support governance and audits. |
| [MS-DP700][Modeling] | Data modeling | Full vs incremental loads, dimensional prep. |
| [MS-DP700][Ingestion-Batch] | Batch ingestion | Choose storage types; use Shortcuts/Mirroring and Pipelines for predictable batch loads. |
| [MS-DP700][Transform-PySpark] | Transform with PySpark | Notebooks and Lakehouse transformations. |
| [MS-DP700][Transform-SQL] | Transform with SQL/Kusto Query Language (KQL) | Use SQL Warehouse (T‑SQL) and KQL for set-based transformations. |
| [MS-DP700][Ingestion-Streaming] | Streaming ingestion | Use Eventstreams and Real-Time Intelligence; apply Spark Structured Streaming for continuous loads. |
| [MS-DP700][Monitoring] | Monitoring | Monitoring Hub, run histories, alerting, troubleshooting. |
| [MS-DP700][Performance] | Performance optimization | Improve Lakehouse/Data Warehouse/Query performance; basics of Spark tuning within Fabric. |

### 4) Recommended training and resources
- Study guide (official): https://learn.microsoft.com/en-us/credentials/certifications/resources/study-guides/dp-700
- Learning paths: Microsoft Fabric — Data engineering on Microsoft Learn.
- Practice assessment and exam sandbox: linked from the study guide page.
- Docs: Fabric (Lakehouse, Pipelines, Notebooks, Real-Time Intelligence), OneLake, Security/Governance, SQL Warehouse.

### 5) Optional mapping to this repository
- The two-company narrative can be realized on Fabric Lakehouse (OneLake) in parallel to Databricks. Mirror ingestion/transform contracts; add Fabric pipelines/notebooks equivalents.

---

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
---
 Additional resource: [secloudis.com](https://secloudis.com) – articles and notes on cloud, data, analytics, and artificial intelligence (optional external reference).

