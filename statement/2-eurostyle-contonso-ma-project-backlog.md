# EuroStyle–Contoso M&A – Product Backlog (Databricks & Fabric)

---

## Platform Architecture – Free vs Paid (Databricks ↔ Microsoft Fabric)

This section highlights the **architectural constraints** of the EuroStyle–Contoso M&A prototype (built in class on free tiers) versus how the same design would be implemented in an **enterprise-grade paid setup**.

| Aspect | Free / Trial (Prototype in class) | Paid / Enterprise (Production-ready) |
|--------|-----------------------------------|---------------------------------------|
| **Landing zone** | Manual upload into Fabric Lakehouse `/Files` | ADLS Gen2 landing zone (raw/bronze/silver/gold), accessible via Shortcuts |
| **Storage format** | Parquet files with `_SUCCESS` + `release_manifest.json` uploaded manually | Delta tables written by DLT/Jobs with atomic publish + manifest |
| **Data contract** | Convention: `/release/gold/{table}/{date}/vX.Y.Z/` with Parquet + JSON manifest | Same pathing, but automated; schema/hash validation enforced by Jobs & Fabric Pipelines |
| **Identity & Security** | User credentials; minimal workspace-level access | Managed Identity/Service Principals + Key Vault; RBAC in ADLS + Unity Catalog policies |
| **Catalog / Governance** | Hive metastore ad-hoc; manual schema docs | Unity Catalog: lineage, tags (PII), fine-grained access control |
| **Orchestration** | Manual export from Databricks, manual trigger in Fabric Pipeline | Databricks Workflows/Jobs for ETL + ML; Fabric Data Factory Pipelines scheduled or Event Grid-triggered |
| **Integration with Fabric** | Export → manual upload → Fabric Pipeline copies Parquet into Lakehouse tables | Fabric Shortcuts to ADLS (zero-copy Direct Lake); or Fabric Pipelines copy if schema reshaping needed; Delta Sharing optional |
| **Power BI mode** | Early sprints: DirectQuery to Databricks Bronze/Silver; Later: Direct Lake once data copied into Fabric | Direct Lake as default; fallback DirectQuery to Databricks SQL Warehouse or Import mode for snapshots |
| **Environments** | Single shared workspace | Separate Dev/Test/Prod workspaces (Databricks + Fabric); Deployment Pipelines in Fabric |
| **CI/CD** | None (manual steps only) | GitHub Actions/Azure DevOps for Databricks notebooks, Jobs, UC; Fabric Deployment Pipelines & APIs |
| **Monitoring** | Manual inspection of pipelines and dashboards | Azure Monitor + Log Analytics for Databricks & Fabric; alerts on SLAs, schema drift, data quality |
| **Security model** | Basic workspace access + Power BI Row-Level Security (RLS) | Private Endpoints, RBAC at ADLS & UC level, column/row-level masking; RLS in Power BI |

---

## Sprint Planning Matrix (4.5 days per sprint)

This matrix summarizes the focus and concrete deliverables of each role — **Data Engineer (DE)**, **Data Scientist (DS)**, and **Data Analyst (DA)** — across all sprints.  
It provides a clear mapping of **who delivers what, and when**, ensuring no role is idle.

| Sprint | Data Engineer (DE) | Data Scientist (DS) | Data Analyst (DA) |
|--------|---------------------|---------------------|-------------------|
| **0 (0.5d)** | Set up Databricks workspace and folder structure; define ingestion paths for EuroStyle & Contoso | Define hypotheses for churn (inactivity >90 days) and Customer Lifetime Value (CLV); identify required features | Define initial KPI Catalog v0.1 (GMV, AOV, margin, churn rate); map differences EuroStyle vs Contoso |
| **1 (4.5d)** | Ingest EuroStyle & Contoso raw CSVs into Bronze Delta tables; add metadata (`ingest_ts`, `source_system`) | Perform **Exploratory Data Analysis (EDA)** on Bronze (Contoso first): distributions, missing values, brand overlap; draft churn & CLV definitions | Build "First Look Dashboard" (Contoso first) with Bronze KPIs: **GMV (Gross Merchandise Value)**, **AOV (Average Order Value)**, order counts |
| **2 (4.5d)** | Transform Bronze → Silver: deduplication, schema harmonization, standardize currencies, align product hierarchies | Engineer features: **RFM (Recency, Frequency, Monetary value)**, basket diversity, cross-brand overlap; track feature sets in MLflow | Redesign dashboards on Silver; compare Raw vs Silver KPIs; implement first **Row-Level Security (RLS)** rules |
| **3 (4.5d)** | Build Gold marts: `sales_daily` (sales, GMV, AOV, margin), `category_perf`, `customer_360` with RFM base | Train baseline models: Logistic Regression (churn), Random Forest (CLV regression); log experiments in MLflow | Deliver **Executive Dashboard**: consolidated KPIs (GMV, AOV, margin), brand comparisons, North vs South splits |
| **4 (4.5d)** | Export Gold marts to Fabric Lakehouse (Parquet + manifest, or Shortcuts); orchestrate ingestion with Fabric Data Pipelines | Run batch scoring for churn & CLV; join scored tables into Gold `customer_360`; document model performance (accuracy, AUC, RMSE) and explainability | Build full **Power BI Post-Merger Suite**: Executive + Customer Segmentation dashboards (with churn & CLV); deploy with Fabric pipelines |


---

## Epic-to-Sprint and Role Mapping

This table lists all epics, distributed by sprint and by profile (DE, DS, DA). It complements the Sprint Planning Matrix and provides a high-level view; ownership remains at the user story level within each epic.

| Sprint | DE (Data Engineer) | DS (Data Scientist) | DA (Data Analyst) |
|---|---|---|---|
| 0 | [Epic 1 – Data Foundation Platform](#epic-1) (setup: workspace, folders, ingest paths) | [Epic 3 – ML & Predictive](#epic-3) (hypotheses/requirements, MLflow init) | [Epic 2 – Analytics & BI](#epic-2) (KPI Catalog v0.1, semantic draft) |
| 1 | [Epic 1 – Data Foundation Platform](#epic-1) (Bronze: ES+Contoso, metadata, DirectQuery) | [Epic 3 – ML & Predictive](#epic-3) (EDA: prevalence, drift, baselines) | [Epic 2 – Analytics & BI](#epic-2) (First Look – Contoso: semantic model, measures, v1 report, KPI v0.2) |
| 2 | [Epic 1 – Data Foundation Platform](#epic-1) (Silver: dedup, FX→EUR, IDs, schema contract) | [Epic 3 – ML & Predictive](#epic-3) (Features: RFM, basket, versioning, leakage checks) | [Epic 2 – Analytics & BI](#epic-2) (Raw vs Silver: deltas, toggles, RLS v1, DQ impacts) |
| 3 | [Epic 1 – Data Foundation Platform](#epic-1) (Gold marts: sales_daily, category_perf, customer_360) | [Epic 3 – ML & Predictive](#epic-3) (Model training: churn LR, CLV RF, calibration/CI) | [Epic 2 – Analytics & BI](#epic-2) (Executive: consolidated KPIs, brand/region, RLS) |
| 4 | [Epic 4 – Platform Integration](#epic-4) (Fabric export: Parquet+manifest, pipeline ingest) | [Epic 3 – ML](#epic-3) (Batch scoring, join to Gold, explainability) + [Epic 4](#epic-4) (Export/validation) | [Epic 2 – Analytics](#epic-2) (Segmentation) + [Epic 4](#epic-4) (Power BI Suite, pipeline promotion) |
| 5 (optional) | [Epic 5 – Optional Extensions](#epic-5) (Data Vault light; E2E deployment sim) | [Epic 5 – Optional Extensions](#epic-5) (Survival/BG‑NBD; export/validation) | [Epic 5 – Optional Extensions](#epic-5) (Dynamic dashboards: what‑if/drill; deployment pipeline) |

Notes
- Optional extensions (Epic 5.x) are scheduled under Sprint 5 (optional) based on team capacity.
- For detailed deliverables, see the Features map below and the User Stories within each epic.


## Feature-to-Sprint and Role Mapping

This table lists all features, distributed by sprint and by profile (DE, DS, DA). Ownership is ultimately at the user story level; this is the primary owner per feature.

| Sprint | DE (Data Engineer) | DS (Data Scientist) | DA (Data Analyst) |
|---|---|---|---|
| 0 | — | — | — |
| 1 | [1.1 Raw Data Ingestion](#feature-1-1) (Bronze Delta with ingest_ts/source_system; DQ summary; schema dictionary; runbook) | [3.1 EDA, baselines & MLflow setup](#feature-3-1) (EDA readout; baselines; leakage/risk log; MLflow init) | [2.1 First Look – Contoso](#feature-2-1) (semantic model; named measures; v1 report) |
| 2 | [1.2 Silver Cleaning & Harmonization](#feature-1-2) (idempotent writes; Silver schema contract; FX normalization with ECB snapshot; DQ before/after) | [3.1 EDA summary & risk log](#feature-3-1); [3.2 Feature Engineering](#feature-3-2) (RFM; basket/cross‑brand; versioned feature tables; leakage checks; consumption contract) | [2.2 Raw vs Silver – Contoso + EuroStyle](#feature-2-2) (side‑by‑side KPIs; delta measures; RLS draft; bookmarks/toggles) |
| 3 | [1.3 Gold Business Marts](#feature-1-3) (sales_daily; customer_360; category_perf; margin proxy/notes) | [3.3 Model Training](#feature-3-3) (LR churn; RF CLV; calibration/CIs; segment evaluation; registry notes) | [2.3 Executive Post‑Merger Dashboard](#feature-2-3) (GMV/AOV/margin; brand & region splits; RLS configured; perf tuned) |
| 4 | [4.1 Export Gold to Fabric](#feature-4-1) (Parquet + manifest/Shortcuts; Fabric Pipeline ingest; connectivity validated) | [3.4 Batch Scoring & Integration](#feature-3-4), [4.3 Scoring Export & Validation](#feature-4-3) (batch scoring churn/CLV; join to customer_360; export to Fabric; validate metrics/skew) | [2.4 Customer Segmentation](#feature-2-4), [4.2 Power BI Suite](#feature-4-2) (Executive + Segmentation dashboards; RLS; pipeline Dev→Test; publish suite) |
| 5 (optional) | [5.1 Simplified Data Vault](#feature-5-1); [5.4 E2E Deployment](#feature-5-4) (Hubs/Links/Sats; manual SCD2; deployment docs/pipeline outline) | [5.3 Survival/Probabilistic Models](#feature-5-3); [5.4 E2E Deployment](#feature-5-4) (Cox/KM; BG/NBD + Gamma‑Gamma; compare; scoring pipeline docs) | [5.2 Advanced Segmentation](#feature-5-2); [5.4 E2E Deployment](#feature-5-4) (dynamic parameters; drill‑through; segment pages; publish/promotion scripts) |

Notes
- Optional extensions (5.x) are grouped in Sprint 5 (optional): 5.1 (DE), 5.2 (DA), 5.3 (DS), and 5.4 (All, cross‑role).
- For exact division of work, see the User Stories within each feature.


## Backlog Structure
This backlog follows Agile methodology with hierarchical organization:
- **Epics**: Major business capabilities 
- **Features**: Functional components within epics
- **User Stories**: Specific user needs and outcomes
- **Tasks**: Technical implementation items

Note – Working board (Kanban)
- Platform: Azure DevOps Boards.
- Columns: Backlog → Selected for Sprint → In Progress → In Review → Done (optional: Blocked).
- Ownership: Product Owner prioritizes; Scrum Master maintains flow; each DE/DA/DS member updates cards daily and links notebooks/tables/dashboards.

<a id="agility"></a>
## Agility in the EuroStyle–Contoso Prototype

The project will follow an agile approach adapted to the constraints of Databricks Free Edition and Microsoft Fabric free/student capacity. Even if the technical environments are not shared, the agile mindset remains central: short sprints, incremental delivery, and continuous improvement.

### Roles and responsibilities

- Product Owner: responsible for the backlog and prioritization. Normally this role is taken by a data analyst; if none is available, a data engineer may temporarily assume it.
- Scrum Master: runs the agile process, maintains the Kanban board, enforces WIP limits, and facilitates ceremonies. The role rotates among data engineers each sprint.
- Team Members (DE/DA/DS): update card status daily, link deliverables (notebooks, data tables, dashboards), and participate in reviews and retrospectives.

### Backlog and Kanban

- Platform: Azure DevOps Boards.
- Columns: Backlog → Selected for Sprint → In Progress → In Review → Done (optional: "Blocked").
- Card content: each card describes a deliverable (not a personal to‑do) and includes Acceptance Criteria, Definition of Done, and links to code/dashboards. Use sub‑tasks when several members collaborate.

#### DQ tickets (Azure DevOps) — lightweight template

- When to open: any reconciliation variance >1%, material null/duplication spikes, orphan facts, missing FX, or parsing errors blocking DA/DS.
- Work item type: Bug (tag: `DQ`).
- Title: short, specific (e.g., "DQ: EuroStyle vs Bronze count variance 2.3% on 2025‑08‑01").
- Description: what is wrong, why it matters, scope (brand/date/tables).
- Evidence: paste queries, row counts, and 3–5 sample rows.
- Owner / ETA / Severity: assign a DE; set realistic ETA; severity P1–P3.
- Tags: `DQ`, `Bronze`/`Silver`, `EuroStyle`/`Contoso`.
- Links: add notebook/table paths; paste link in README under "Data Quality Issues".

### Sprint cadence

- Duration: 4.5 days per sprint.
- Day 1 – Sprint Planning: select cards from the backlog into scope.
- Daily – Stand‑up: each member reports progress, blockers, and next steps.
- Final day – Sprint Review: present completed deliverables to stakeholders.
- Immediately after – Retrospective: reflect on what worked, what didn't, and actions to improve.

### Collaboration model

- Databricks Community Edition has no shared workspace → each engineer works in their own environment.
- Synchronization: code and notebooks are synced through GitHub.
- Source of truth: the Kanban board ensures coordination, visibility, and accountability across roles.

### KPI Catalog versioning

- v0.1 (Sprint 0): initial KPI list and business definitions captured by DA; note EuroStyle vs Contoso differences.
- v0.2 (Sprint 1): refined definitions with named measures, formats, and a mini data dictionary; aligned to the Contoso-first dashboard.
- v1.0 (Sprint 3–4): consolidated, brand‑agnostic definitions validated on Gold marts; margin notes clarified (COGS or proxy); final naming and display standards.



---


<a id="epic-1"></a>
## Epic 1 – Data Foundation Platform
**Goal**: Build a robust Medallion architecture (Bronze → Silver → Gold) unifying EuroStyle & Contoso.

---

<a id="feature-1-1"></a>
### Feature 1.1: Raw Data Ingestion (Sprint 1)
**User Story**:  
As a Data Engineer, I want to ingest EuroStyle and Contoso CSVs into Bronze so the teams can start analyzing real data.  

**Learning Resources**:  
- [Medallion Architecture](https://docs.databricks.com/en/lakehouse/medallion-architecture.html)  
- [Delta Lake Basics](https://docs.databricks.com/en/delta/index.html)  
- [What is Delta Lake in Azure Databricks?](https://learn.microsoft.com/azure/databricks/delta/)
- [Apache Spark&trade; Tutorial: Getting Started with Apache Spark on Databricks](https://www.databricks.com/spark/getting-started-with-apache-spark/dataframes#visualize-the-dataframe)
- [PySpark DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)  
- [Tutorial: Build an ETL pipeline with Lakeflow Declarative Pipelines](https://learn.microsoft.com/azure/databricks/getting-started/data-pipeline-get-started)
- [Power BI Databricks connector – DirectQuery](https://learn.microsoft.com/power-bi/connect-data/desktop-azure-databricks?tabs=directquery)
- [Unity Catalog – create/manage tables](https://docs.databricks.com/aws/en/tables/managed)
- [Databricks SQL – CREATE VIEW syntax](https://learn.microsoft.com/azure/databricks/sql/language-manual/sql-ref-syntax-ddl-create-view)
- [PySpark DataFrame.withColumnRenamed](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.DataFrame.withColumnRenamed.html)
- [PySpark Column.cast](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/api/pyspark.sql.Column.cast.html)
- [Delta schema evolution](https://learn.microsoft.com/azure/databricks/delta/delta-batch#table-schema-evolution)
- [SQL identifier naming rules](https://learn.microsoft.com/azure/databricks/sql/language-manual/sql-ref-names)
 - [Delta MERGE INTO (upserts)](https://learn.microsoft.com/azure/databricks/delta/merge)
 - [Delta constraints (NOT NULL, CHECK)](https://learn.microsoft.com/azure/databricks/delta/delta-constraints)

**Key Concepts**:  
- Bronze = raw data "as delivered" (no cleaning yet).  
- Add metadata columns (`ingest_ts`, `source_system`) for lineage.  
- Use Delta format instead of CSV for reliability and performance.  

**Acceptance Criteria**:  
- EuroStyle & Contoso CSVs uploaded and stored in `/FileStore/retail/raw/...`.  
- Bronze Delta tables created with correct schema.  
- Metadata fields (`ingest_ts`, `source_system`) added.  
- Row counts match raw source files.  
 - Contoso Bronze available by Day 1 for DA DirectQuery; connection validated from Power BI.  
 - Dates and numeric columns parse correctly; consistent column naming applied where feasible across brands.  
 - Basic Data Quality (DQ) summary produced (missing values, duplicate rate on `(order_id, sku, customer_id, order_date)`, top countries/currencies).  
 - Mini schema dictionary and a short runbook (how to re-run ingestion, folder structure, naming conventions) added to repo.
 - Azure DevOps DQ tickets opened for any raw→Bronze variance >1% or material DQ issue; links captured in README and referenced by DA in Feature 2.2.

**Tasks**:  
- Upload EuroStyle dataset (Online Retail II) into `/FileStore/retail/raw/eurostyle/`  
- Upload Contoso dataset (European Fashion Store Multitable) into `/FileStore/retail/raw/contoso/`  
- Create Bronze Delta tables with schema inference.  
- Add metadata columns (`ingest_ts`, `source_system`).  
 - Expose tables/views for DirectQuery and perform a smoke test from Power BI.  
 - Produce a one‑page Data Quality (DQ) summary (nulls, duplicates, row counts), and reconcile raw→Bronze counts (±1% tolerance or documented variance).  
 - Publish a mini schema dictionary and a short runbook for re‑runs.
 - Open Azure DevOps "DQ" tickets for any reconciliation variance >1% or material DQ issue; include evidence (counts, sample rows), severity, owner, and ETA; paste the work item links into the README.

**User Stories (breakdown)**  
- As a DA, I can connect to Contoso Bronze via DirectQuery on Day 1 to build the First Look.  
- As a DE, I ingest EuroStyle and Contoso to Bronze with lineage columns and parsable types.  
- As a DS, I receive a DQ summary on Bronze to kick off EDA.  
- As a DE, I publish a mini schema dictionary and runbook so the team can re‑run ingestion.

### Sprint day plan (4.5 days)
- **Day 1:** Ingest Contoso → Bronze (with `ingest_ts`, `source_system`), validate types/dates, expose for DirectQuery (publish a thin SQL view or Delta table with Power BI‑friendly types, register in the metastore, and validate a Power BI Desktop DirectQuery connection via the Databricks connector — see Learning Resources), DA smoke test from Power BI.  
- **Day 2:** Ingest EuroStyle → Bronze, align obvious column names/types across brands (build a simple mapping table or dict: `source_name → unified_name`, plus `target_type`; apply with `withColumnRenamed`/`selectExpr` and `cast`; store mapping CSV in `docs/` and reference it in the runbook; prefer snake_case, consistent date/decimal types — see Learning Resources), update mapping notes and folder structure.  
 - **Day 3:** Reconcile raw→Bronze row counts; compute a basic DQ summary (nulls, dup rate on business key, top dims); persist key metrics in a small monitoring table (e.g., `monitor.dq_bronze_daily`) and note any variance >1%; open Azure DevOps DQ tickets for any variance >1% or material issue and link them in the README.  
- **Day 4:** Prove idempotent re‑run (same inputs → same end state). Use deterministic overwrite by date/partition or a MERGE on business keys to avoid duplicates; enforce basic constraints (NOT NULL/CHECK) where useful. Finalize docs: commit a mini schema dictionary at `docs/bronze-schema-dictionary.md` (use `docs/data-dictionary-template.md`) and a runbook at `docs/runbook-ingestion.md` (steps, paths, re-run notes). Address issues raised by DA/DS.  
- **Day 4.5:** Buffer and hand‑off; optional pre‑aggregate view: create a thin day‑level view for faster DirectQuery (e.g., `CREATE VIEW bronze.sales_contoso_daily AS SELECT order_date, COUNT(*) AS orders, SUM(quantity*unit_price) AS revenue FROM bronze.sales_contoso GROUP BY order_date;`) and register it (see CREATE VIEW in Learning Resources).

#### Mini notes — Feature 1.1 (per day)
- Day 1 — Ingest + DirectQuery
   - Read CSV to Delta, add lineage columns:
      ```sql
      CREATE OR REPLACE TABLE bronze.sales_contoso AS
      SELECT *, current_timestamp() AS ingest_ts, 'CONTOSO' AS source_system
      FROM read_files('dbfs:/FileStore/retail/raw/contoso/*.csv', format => 'csv', header => true);
      ```
   - Expose a BI‑friendly view (types trimmed):
      ```sql
      CREATE OR REPLACE VIEW bronze.v_sales_contoso AS
      SELECT CAST(order_date AS DATE) AS order_date,
                CAST(quantity AS INT)    AS quantity,
                CAST(unit_price AS DECIMAL(18,2)) AS unit_price,
                order_id, sku, customer_id, source_system, ingest_ts
      FROM bronze.sales_contoso;
      ```
   - In Power BI, connect via Databricks (Token, Hostname, HTTP Path), storage mode = DirectQuery; DA runs a smoke visual.

- Day 2 — Mapping + types
   - Keep a simple mapping CSV in `docs/column_mapping.csv` with `source_name, unified_name, target_type`.
   - Apply rename/cast (example in PySpark):
      ```python
      from pyspark.sql.functions import col
      mapping = {"InvoiceNo":"order_id","StockCode":"sku","CustomerID":"customer_id"}
      df = raw_df.select([col(c).alias(mapping.get(c,c)) for c in raw_df.columns])
      df = df.withColumn("order_date", col("order_date").cast("date")).withColumn("unit_price", col("unit_price").cast("decimal(18,2)"))
      ```

- Day 3 — Counts + DQ summary
   - Reconcile counts raw→bronze and persist a few metrics to `monitor.dq_bronze_daily` (row_count, null rates on keys, dup rate on BK, min/max date). Note any variance >1%.

- Day 4 — Idempotence + docs
   - Re‑run safely via `MERGE` on business keys or deterministic overwrite by date window (`replaceWhere`). Add NOT NULL/CHECK where useful. Commit `docs/bronze-schema-dictionary.md` and `docs/runbook-ingestion.md`.

- Day 4.5 — Pre‑aggregate view
   - Create/register a thin day view for DirectQuery performance and validate from Power BI.

---

<a id="feature-1-2"></a>
### Feature 1.2: Silver Cleaning & Harmonization (Sprint 2)
**User Story**:  
As a Data Engineer, I want Silver tables with clean, harmonized schemas so Analysts and Scientists can trust the data.  

**Learning Resources**:  
- [Schema Evolution in Delta](https://docs.databricks.com/delta/delta-batch.html#table-schema-evolution)  
- [Data Quality Management](https://www.databricks.com/discover/pages/data-quality-management)  
- [PySpark DataFrame API](https://api-docs.databricks.com/python/pyspark/latest/pyspark.sql/api/pyspark.sql.DataFrame.html)  
 - [Star schema guidance (natural/business vs surrogate keys)](https://learn.microsoft.com/power-bi/guidance/star-schema)  
 - [Delta Lake — overwrite specific partitions with replaceWhere](https://learn.microsoft.com/azure/databricks/delta/delta-batch#overwrite-specific-partitions-with-replacewhere)  

**Key Concepts**:  
- Silver = cleaned and standardized layer.  
- Deduplication using business keys (e.g., `order_id + sku + customer_id`).  
- Standardize currencies (convert all to EUR).  
- Use mapping tables for product hierarchy alignment.  
- Normalize customer IDs across EuroStyle & Contoso.  
 - FX (Foreign Exchange) = converting source currency amounts into a single reporting currency (e.g., EUR) using documented reference rates and a fixed valuation date for reproducibility. Example sources: European Central Bank (ECB) reference rates (https://www.ecb.europa.eu/stats/eurofxref/), XE.com or OANDA APIs, Yahoo Finance API (historical).

**Acceptance Criteria**:  
- Duplicates removed with correct logic.  
- All currencies expressed in EUR.  
- Product hierarchy aligned across both datasets.  
- Customer IDs unified and cross-brand duplicates resolved.  
- Documentation of cleaning steps added in notebook.  
   - Note: Currency conversion reproducibility — store a reference FX table (e.g., European Central Bank (ECB) daily rates) and use a fixed valuation snapshot/date for the sprint; persist it in Silver (e.g., `silver.fx_rates_eur`).
 - Idempotent writes: re‑running the Silver job yields the same results (deterministic windowed writes or replaceWhere strategy).  
 - Silver data contract published (schema with types/nullability and mapping rules).  
 - DQ report updated (pre/post cleaning: duplicates removed %, nulls reduced %, FX normalization impact).  
 - FX snapshot table (`silver.fx_rates_eur`) versioned with valuation date and source metadata.
 - Azure DevOps DQ tickets opened/updated for any Raw→Silver residual issues discovered (e.g., orphan facts, missing FX rates); links added to README and referenced by DA in Feature 2.2.

**Tasks**:  
- Deduplicate data using business keys.  
- Standardize currencies (conversion → EUR).  
- Align product hierarchies using mapping table.  
- Normalize customer IDs across EuroStyle & Contoso.  
 - Create and persist an `fx_rates_eur` reference table with the chosen valuation date and FX source (e.g., European Central Bank (ECB)).
 - Implement idempotent write logic (e.g., overwrite by date window or equivalent) and document it.  
 - Publish the Silver schema contract (names, types, nullability) and mapping rules.  
 - Refresh and attach the DQ report highlighting Raw→Silver improvements.
 - Create/refresh Azure DevOps DQ tickets for residual data issues (e.g., orphans, invalid codes, missing FX); attach evidence queries and assign owners with ETA; paste links in README.

**User Stories (breakdown)**  
- As a DE, I deliver Silver sales with duplicates removed and currencies normalized to EUR.  
- As a DE, I publish a Silver schema contract so DA/DS consume with confidence.  
- As a DE, I persist a versioned `fx_rates_eur` snapshot with a fixed valuation date.  
- As a DE, I ensure idempotent Silver writes so re‑runs are safe and deterministic.

### Sprint day plan (4.5 days)
- **Day 1:** Define business keys and dedup strategy (dedup = remove duplicate rows so only one remains per business key; use a window over keys ordered by `ingest_ts` to keep latest); profile duplicate rates per brand; normalize types (dates/decimals), trim/uppercase IDs; capture edge cases (null/invalid keys).  
  
- **Day 2:** Build and persist `silver.fx_rates_eur` snapshot (valuation date, source, currency, rate); join-as-of date to convert to EUR; handle missing currencies with fallback/exclusion; document rounding/precision and null-handling in notes.  
- **Day 3:** Create customer/product crosswalks (case-trim, resolve collisions); store mapping CSVs in `docs/` and register Delta mapping tables; enforce referential checks (orphan sales) and fix before proceeding.  
- **Day 4:** Implement idempotent writes (`replaceWhere` by date window or `MERGE` on business keys); publish Silver schema contract (names, types, nullability) and mapping rules; refresh DQ report with pre/post metrics.  
- **Day 4.5:** Buffer; quantify Raw→Silver impacts (% duplicate reduction, FX impact), run sample queries with DA/DS, and hand-off.

#### Mini notes — definitions & examples (Silver)

- Business key (BK): stable, real‑world identifier used to deduplicate and join (e.g., order_id+sku+customer_id+order_date). Surrogates are technical IDs added later if needed. See Star schema guidance in Learning Resources.

- fx_rates_eur (starter):
   ```sql
   CREATE OR REPLACE TABLE silver.fx_rates_eur (
      valuation_date DATE    NOT NULL,
      source         STRING  NOT NULL,
      currency       STRING  NOT NULL,
      rate_to_eur    DECIMAL(18,8) NOT NULL
   ) USING DELTA;

   INSERT INTO silver.fx_rates_eur (valuation_date, source, currency, rate_to_eur) VALUES
      (date'2025-08-01', 'ECB', 'EUR', 1.00000000),
      (date'2025-08-01', 'ECB', 'USD', 0.91500000),
      (date'2025-08-01', 'ECB', 'GBP', 1.17000000);
   ```
   Join rule: convert amounts by matching `order_date` (or chosen valuation date) and `currency`.

- Rounding/precision and null‑handling (what to document):
   - Types: use DECIMAL(18,2) for money amounts, DECIMAL(18,8) for FX rates; avoid FLOAT for currency.
   - Rounding: round at the final amount step to 2 decimals; state the function (e.g., `ROUND(x, 2)`) and rounding mode (Spark `round` is HALF_UP). Example SQL:
      ```sql
      SELECT ROUND(quantity * unit_price * rate_to_eur, 2) AS revenue_eur
      FROM silver.sales_clean sc
      JOIN silver.fx_rates_eur fx ON fx.currency = sc.currency AND fx.valuation_date = DATE(sc.order_date);
      ```
      PySpark example:
      ```python
      from pyspark.sql import functions as F
      df = df.withColumn("revenue_eur", F.round(F.col("quantity")*F.col("unit_price")*F.col("rate_to_eur"), 2))
      ```
   - Null‑handling: define a fallback if `rate_to_eur` is missing (e.g., previous business day, default to EUR=1 when currency='EUR', or exclude and log). Record counts of affected rows in DQ metrics and note the policy in the schema contract.
   - Contract note: explicitly write the chosen scales (`DECIMAL(18,2)` amounts, `DECIMAL(18,8)` rates), rounding step (final vs intermediate), and fallback policy.

- Crosswalks (customer/product): mapping tables to align source codes/IDs to unified ones across brands.
   - Example structure: `silver.product_xwalk(source_system, product_code_src, product_code_unified)` and `silver.customer_xwalk(source_system, customer_id_src, customer_id_unified)`.
   - Use them to rename/normalize and to detect collisions (two sources mapping to the same unified code unexpectedly).

- Referential checks: ensure facts reference existing dims/unified IDs; detect orphans via anti‑joins.
   ```sql
   -- Orphan sales on product
   SELECT s.*
   FROM silver.sales_clean s
   LEFT JOIN silver.product_xwalk x
      ON s.source_system = x.source_system AND upper(trim(s.product_code)) = x.product_code_src
   WHERE x.product_code_unified IS NULL;
   ```

- Idempotent writes (what/why/how): same inputs → same end state; prevents duplicate rows on re‑runs.
   - How: either `MERGE` on BKs …
      ```sql
      MERGE INTO silver.sales_clean t
      USING tmp_updates u
      ON t.order_id = u.order_id AND t.sku = u.sku AND t.customer_id = u.customer_id AND t.order_date = u.order_date
      WHEN MATCHED THEN UPDATE SET *
      WHEN NOT MATCHED THEN INSERT *;
      ```
   - … or overwrite a window deterministically with `replaceWhere` (e.g., by date):
      ```sql
      df.write.format("delta")
         .option("replaceWhere", "order_date BETWEEN '2025-08-01' AND '2025-08-31'")
         .mode("overwrite").saveAsTable("silver.sales_clean");
      ```

- Interaction with DA/DS: 
   - Day 2: align FX valuation date and currency list with DA/DS (reporting expectations).
   - Day 3: agree crosswalk columns and unify naming; confirm impact on analyses/features.
   - Day 4: share the Silver schema contract + DQ deltas; DA updates model; DS updates feature joins.
   - Day 4.5: run sample queries together to validate KPIs and feature readiness.

---

<a id="feature-1-3"></a>
### Feature 1.3: Gold Business Marts (Sprint 3)
**User Story**:  
As a Data Engineer, I want Gold marts for sales and customers so the business gets reliable KPIs.  

**Learning Resources**:  
- [Star Schema Design](https://www.databricks.com/glossary/star-schema)  
 - [Performance Optimization in Delta](https://learn.microsoft.com/en-us/azure/databricks/delta/best-practices)  
- [Recency, Frequency, Monetary (RFM) Segmentation](https://www.databricks.com/solutions/accelerators/rfm-segmentation)  
- [Retail Personalization with RFM Segmentation and the Composable CDP](https://www.databricks.com/blog/retail-personalization-rfm-segmentation-and-composable-cdp)
- [RFM Segmentation, Databricks Solution Accelerators](https://github.com/databricks-industry-solutions/rfm-segmentation)
- [Gross Merchandise Value (GMV): Meaning & Calculation](https://www.yieldify.com/blog/gross-merchandise-value-gmv)
 - [Understanding GMV in ecommerce](https://getrecharge.com/blog/understanding-gmv-in-ecommerce/)
- [AOV vs CR vs RPV vs GMV in Ecommerce: Important Metrics You Should Know](https://www.mida.so/blog/important-ecommerce-metrics-aov-cr-rpv-gmv)

**Key Concepts**:  
- Gold = business-ready, aggregated, and optimized marts.  
- Sales mart for financial KPIs (GMV, AOV, margin).  
- Category mart for product/category analysis.  
- Customer 360° mart enriched with RFM (Recency, Frequency, Monetary).  
- `source_system` flag to track EuroStyle vs. Contoso origin.  

**Acceptance Criteria**:  
- `sales_daily` mart contains GMV, AOV, and margin by day.  
- `category_perf` mart aggregates sales by product and category.  
- `customer_360` mart built with RFM metrics and source_system flag.  
- All marts validated against Silver consistency checks.  
    - Note: Margin calculation requires Cost of Goods Sold (COGS: direct costs to acquire/produce items, e.g., purchase cost, manufacturing, inbound freight). If unavailable in the source datasets, either (a) defer margin to a stretch goal, or (b) use a documented proxy (e.g., assumed margin rates by category) and clearly label as "Estimated Margin".

#### If COGS is missing - proxy margin methods (guidance)

Example proxy methods:

- Apply an assumed margin rate by product category (e.g., Apparel = 35%, Footwear = 40%, Accessories = 50%).
- Use a flat benchmark margin rate across all items (e.g., 40%).
- Define a synthetic cost table where COGS = unit_price × (1 – assumed_margin_rate).

Important: All proxy-based calculations must be explicitly documented (e.g., "margin = revenue × 0.4 proxy") so stakeholders understand they are estimates, not accounting-accurate.

Example in SQL (proxy margin rate = 40% flat):

```sql
-- Assume unit_price is revenue per item
SELECT
   order_id,
   sku,
   quantity,
   unit_price,
   quantity * unit_price AS revenue,
   quantity * unit_price * 0.4 AS estimated_margin
FROM silver.sales_clean;
```

**Tasks**:  
- Build `sales_daily` (GMV, AOV, margin).  
- Build `category_perf` (sales by product/category).  
- Build `customer_360` (RFM analysis + source_system flag).  
- Validate marts and document schema.  

**User Stories (breakdown)**  
- As a DE, I deliver `sales_daily` with GMV/AOV/margin (proxy if needed).  
- As a DE, I publish `category_perf` and `customer_360` (with RFM base and source flags).  
- As a DA/DS, I can query Gold marts with documented schema and consistent keys.  

### Sprint day plan (4.5 days)
- **Day 1:** Define **star schemas** (grain, conformed dims, keys); decide surrogate vs natural keys; set naming/format rules; pre-create reference dims (date, product, customer).  
- **Day 2:** Build `sales_daily`: derive revenue, apply margin proxy if COGS missing (label clearly); handle returns/negatives; partition/coalesce sensibly; validate totals against Silver.  
- **Day 3:** Build `category_perf` and `customer_360` (include RFM base); ensure one-row-per-customer, dedupe/keys consistent across brands; snapshot any slowly changing attributes if needed.  
- **Day 4:** Reconcile counts and KPIs vs Silver; add basic constraints (NOT NULL, CHECK ranges); document schemas and assumptions (e.g., margin proxy).  
- **Day 4.5:** Light tuning (partitioning/coalesce), create a few helper views (and register them), run smoke queries with DA/DS, and hand-off.

#### Mini examples — Star schema and `sales_daily` (start)

Define the star schema (concise)
- Grain: one row per day × product (optionally carry `source_system` for splits).
- Conformed dims: `gold.date_dim`, `gold.product_dim`, `gold.customer_dim` with stable business attributes.
- Keys: use surrogate keys on dims (IDENTITY for product/customer; `date_key` as `yyyymmdd` int). Facts store SKs.
- Naming/formats: snake_case; dates as DATE; money as DECIMAL(18,2); avoid nullable keys.

Starter SQL — reference dimensions
```sql
-- DATE DIM (populate from Silver dates; tighten to your window)
CREATE OR REPLACE TABLE gold.date_dim (
   date_key   INT    NOT NULL,    -- yyyymmdd
   date_value DATE   NOT NULL,
   year       INT,
   month      INT,
   day        INT
) USING DELTA;

INSERT OVERWRITE gold.date_dim
SELECT DISTINCT
   CAST(date_format(CAST(order_date AS DATE), 'yyyyMMdd') AS INT) AS date_key,
   CAST(order_date AS DATE) AS date_value,
   year(order_date)  AS year,
   month(order_date) AS month,
   day(order_date)   AS day
FROM silver.sales_clean;

-- PRODUCT DIM (surrogate key via identity)
CREATE OR REPLACE TABLE gold.product_dim (
   product_sk   BIGINT GENERATED ALWAYS AS IDENTITY,
   product_code STRING NOT NULL,
   category     STRING,
   brand        STRING
) USING DELTA;

INSERT INTO gold.product_dim
SELECT DISTINCT
   upper(trim(product_code)) AS product_code,
   upper(trim(category))     AS category,
   upper(trim(brand))        AS brand
FROM silver.products_clean;
```

Starter SQL — `sales_daily` (fact)
```sql
-- CONTRACT (sales_daily)
-- Grain: day × product (per source_system)
-- Keys: date_key (INT yyyymmdd), product_sk (BIGINT), source_system (STRING)
-- Measures: orders, units, revenue, estimated_margin (proxy if COGS missing)

CREATE OR REPLACE TABLE gold.sales_daily (
   date_key         INT     NOT NULL,
   product_sk       BIGINT  NOT NULL,
   source_system    STRING  NOT NULL,
   orders           INT,
   units            BIGINT,
   revenue          DECIMAL(18,2),
   estimated_margin DECIMAL(18,2),
   CONSTRAINT chk_nonneg CHECK (units >= 0 AND revenue >= 0)
) USING DELTA;

-- First load (proxy margin 40%; treat negative quantities as returns)
INSERT OVERWRITE gold.sales_daily
WITH s AS (
   SELECT
      CAST(date_format(CAST(order_date AS DATE), 'yyyyMMdd') AS INT) AS date_key,
      upper(trim(product_code)) AS product_code,
      source_system,
      order_id,
      CAST(quantity AS BIGINT) AS qty,
      CAST(unit_price AS DECIMAL(18,2)) AS price
   FROM silver.sales_clean
), p AS (
   SELECT product_sk, product_code FROM gold.product_dim
)
SELECT
   s.date_key,
   p.product_sk,
   s.source_system,
   COUNT(DISTINCT s.order_id)                                        AS orders,
   SUM(GREATEST(s.qty, 0))                                           AS units,
   SUM(GREATEST(s.qty, 0) * s.price)                                 AS revenue,
   SUM(GREATEST(s.qty, 0) * s.price * 0.40)                          AS estimated_margin
FROM s JOIN p USING (product_code)
GROUP BY s.date_key, p.product_sk, s.source_system;
```

Notes
- Swap the margin proxy when COGS is available (join a cost table or per‑category rate).
- If identity columns aren't desired, compute SKs from stable BKs (e.g., `md5(upper(trim(product_code)))`).
- Keep idempotent loads: use `INSERT OVERWRITE` by date window or write via `MERGE` on `(date_key, product_sk, source_system)`.


---

<a id="epic-2"></a>
## Epic 2 – Analytics & Business Intelligence
**Goal**: Provide dashboards for executives and marketing with unified KPIs.

---

<a id="feature-2-1"></a>
### Feature 2.1: First Look – Contoso (Sprint 1)
**User Story**:  
As a Data Analyst, I want KPIs from Bronze so I can deliver a "First Look" dashboard.  

**Learning Resources**:  
- [Power BI Fundamentals](https://learn.microsoft.com/en-us/power-bi/fundamentals/)
 - [Work with the legacy Hive metastore alongside Unity Catalog](https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/hive-metastore)  
- [DirectQuery to Databricks](https://learn.microsoft.com/en-us/azure/databricks/partners/bi/power-bi)  
- [Data Visualization Best Practices](https://www.tableau.com/learn/articles/data-visualization)  

**Key Concepts**:  
- Bronze = raw, uncleaned but complete data.  
- GMV (Gross Merchandise Value) = total sales value.  
- AOV (Average Order Value) = GMV / number of orders.  
- Dashboards at this stage focus on **"quick wins"** with limited transformations.  
 - Dataset sequence: start with Contoso in Sprint 1 to deliver the first dashboard quickly; add EuroStyle in Sprint 2 for Raw vs Silver comparisons and consolidated views.

Scope (Sprint 1)
- Dataset: Contoso only, from Bronze (DirectQuery to Databricks).
- Grain: day-level KPIs (GMV, AOV, Orders) with ability to drill into top products/categories.
- Visuals (minimal viable): KPI cards (GMV, AOV, Orders), line chart (GMV by day), table (Top 10 products or categories).
- Measures: named DAX measures for GMV, AOV, Orders; no logic embedded in visuals.
- Filters: date range slicer (and brand fixed to Contoso at this stage).

Out of scope (Sprint 1)
- Silver cleaning/harmonization and FX normalization (addressed in Sprint 2).
- EuroStyle integration (added in Sprint 2).
- RLS enforcement (only a draft matrix is prepared in Sprint 1).
- Advanced DAX (e.g., time intelligence beyond simple day-level trends).

Deliverables
- Report: "First Look – Contoso" (PBIX or Fabric report) with 1 landing page + 1 detail page.
- KPI Catalog v0.2 (refining v0.1): GMV, AOV, Orders defined with DAX measure names and display formats; mini data dictionary (fields, units, formats) in the repo.
- Performance notes: 2–3 quick wins captured from Performance Analyzer.

**Acceptance Criteria**:  
- Dashboard created in Power BI with GMV, AOV, and order counts.  
- Data source connected directly to Databricks Bronze (DirectQuery).  
- First insights available even before cleaning.  
   - Note: In Power BI Desktop, authenticate to Databricks using a Personal Access Token (Authentication method = Token). Use Server Hostname and HTTP Path from the cluster's JDBC/ODBC settings.
 - KPI Catalog v0.2 drafted (refining v0.1): business definitions, grain, and initial DAX formula templates with measure names.  
 - Semantic model established: tables imported, relationships defined, key columns sorted/hidden, display folders, and basic formatting (thousands separators, currency).  
 - Named measures created for GMV, AOV, Orders (no hard-coded logic in visuals).  
 - Performance pass executed (Performance Analyzer) and at least two quick wins documented (e.g., reduce slicers, disable unnecessary interactions).  
 - Accessibility basics: color contrast checked and alt text set on key visuals.  
 - Mini data dictionary for exposed fields added to the repo.

**Tasks**:  
- Compute **GMV (Gross Merchandise Value)**.  
- Compute **AOV (Average Order Value)**.  
- Build dashboard with Raw/Bronze metrics.  
 - Model work: define relationships (star-like), hide technical columns, set sort-by columns, configure formats and display folders.  
 - Create named measures (GMV, AOV, Orders) and a landing page wireframe with 2–3 visuals.  
 - Run Performance Analyzer; document and apply quick improvements (e.g., reduce visuals on a page, limit bidirectional filters).  
 - Draft KPI Catalog and a lightweight data dictionary (fields, definitions, units).  
 - Prepare a draft RLS matrix (who sees what) for future sprints; no enforcement yet.

 - **Provide insights: Storytelling one‑liners (Feature 2.1)**  
    - GMV changed by X% vs last week; orders moved by Y% and AOV by Z%.  
    - Yesterday's GMV was X; top category [Category] contributed Y% and [Top Product] led sales.  
    - AOV is X (±Y% vs 7‑day average); customers bought Z items per order on average.  
    - GMV peaked on [Date] driven by [Category] in [Country]; orders up X%.  
    - Top 10 products generated X% of GMV; [P1], [P2], [P3] explain most of the gain.  
    - [Country/Region] accounts for X% of GMV; [Second] is Y% — focus remains [Top Region].  
    - New vs returning: returning customers generated X% of GMV; AOV returning is Y% higher.  
    - Today looks normal: GMV within ±X% of 7‑day average; no unusual spikes.  

**User Stories (breakdown)**  
- As a DA, I build a v1 report using Contoso Bronze with named measures and a clear semantic model.  
- As a DA, I document KPI Catalog v0.2 and mini data dictionary.  
- As a DA, I capture perf/accessibility quick wins and a draft RLS matrix.  

### Sprint day plan (4.5 days)
- **Day 1:** Connect via Databricks DirectQuery; set storage mode; define relationships; hide technical columns; create base DAX measures (GMV, AOV, Orders) and build a simple landing page.  
   - Story focus: add simple deltas vs last week (GMV, Orders, AOV) and 7‑day averages for "normal day" checks.  
   - Prepare Top Category and Top Product (share of GMV) for the one‑liners; keep one small table per item.  
- **Day 2:** Add visuals (cards, line, table); refine measures (formats, divide-by-zero guards); organize display folders; configure sort-by and cross-highlighting behavior.  
   - Story focus: show Top 10 products with cumulative %; add a region share bar; annotate peak day on the GMV line.  
   - Add Units per order to explain AOV changes (items/order).  
- **Day 3:** Run Performance Analyzer; reduce expensive visuals/filters; avoid high-cardinality slicers; apply accessibility basics (contrast, alt text); iterate layout.  
   - Story focus: create a "Today looks normal?" status (GMV within ±X% of 7‑day avg); surface in a small card.  
   - Keep tooltips that display "vs last week" and "vs 7‑day avg" for GMV/AOV/Orders.  
- **Day 4:** Update KPI Catalog v0.2 and mini data dictionary in repo; annotate assumptions/limitations; add simple navigation/bookmarks; prep demo flow.  
   - Story focus: document the eight one‑liners and which visuals/measures feed each sentence.  
   - Optional: add a text box that reads the current context (date/region) to prefill a headline.  
- **Day 4.5:** Buffer; publish to Fabric workspace; verify dataset credentials; collect stakeholder feedback and log actions.  
   - Story focus: capture the one‑liners for the last 7 days (or last week) and paste into the README for hand‑off.  

---

<a id="feature-2-2"></a>
### Feature 2.2: Raw vs Silver – Contoso + EuroStyle (Sprint 2)
**User Story**:  
As a Data Analyst, I want to compare KPIs Raw vs Silver to highlight data cleaning impact.  

**Learning Resources**:  
- [Data Quality Management](https://www.databricks.com/discover/pages/data-quality-management)  
- [Power BI Comparison Techniques](https://learn.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-combo-chart)  
 - [Power BI Bookmarks (toggle Raw/Silver views)](https://learn.microsoft.com/power-bi/create-reports/desktop-bookmarks)  
 - [Selection pane and layering (show/hide visuals)](https://www.youtube.com/watch?v=mSvJQdHLOAw)  
 - [Sync slicers across pages](https://learn.microsoft.com/en-us/power-bi/developer/visuals/enable-sync-slicers)  
 - [Report page tooltips and custom tooltips](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-tooltips)  
 - [Row-level security (RLS) with Power BI Desktop](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security)  
 - [Performance Analyzer for report tuning](https://learn.microsoft.com/power-bi/create-reports/desktop-performance-analyzer)  
 - [Storage modes (Import, DirectQuery, Dual)](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-storage-mode)  
 - [DAX function reference (e.g., DIVIDE, FORMAT)](https://learn.microsoft.com/dax/dax-function-reference)  
 - [Power BI star schema guidance (avoid mixed grains)](https://learn.microsoft.com/power-bi/guidance/star-schema)

**Key Concepts**:  
- Silver = cleaned, harmonized data.  
- Comparing Raw vs Silver highlights impact of deduplication, standardization, and harmonization.  
- Useful to **build trust** in the cleaning process.  
 - Dataset scope: Contoso + EuroStyle; compare Raw vs Silver per brand and quantify differences; keep visuals consistent across brands.

**Acceptance Criteria**:  
- Dashboard compares Raw vs Silver KPIs: GMV, AOV, return rates.  
- Documentation highlights the differences (e.g., reduced duplicates).  
- Stakeholders understand the value of Silver over Raw.  
   - Note: Online Retail II captures returns (credit notes/negative quantities). If the Contoso dataset lacks explicit returns, either simulate a conservative return flag or exclude return-rate comparisons for Contoso and document the limitation.
 - Comparison measures implemented (e.g., `GMV_raw`, `GMV_silver`, `GMV_delta`, `AOV_delta`, `return_rate_delta`) with clear labeling.  
 - Side-by-side (or toggle/bookmark) view implemented to switch between Raw and Silver.  
 - At least three material data-quality impacts quantified (e.g., % duplicate reduction, FX normalization impact on GMV).  
 - First RLS pass configured on Silver (brand-level roles) and validated on 1–2 visuals.  
 - Azure DevOps cards created for top data-quality fixes, linked in the dashboard/readme.

**Tasks**:  
- Create dashboard with GMV, AOV, return rates (before/after cleaning).  
- Document and present differences.  
 - Build DAX measures for Raw vs Silver comparisons and deltas; ensure consistent formatting and tooltips.  
 - Implement bookmarks/toggles for Raw vs Silver views; annotate differences.  
 - Quantify impacts (duplicates removed, currency standardization effects, schema harmonization effects).  
 - Configure and test RLS roles on Silver (brand managers vs executives).  
 - Log Azure DevOps items for identified data-quality issues and link them from the report/README.

 - Provide insights: Storytelling one‑liners (Feature 2.2)  
    - After cleaning, GMV differs by X%; duplicates dropped by Y% and FX normalization changed totals by Z%.  
    - AOV moved from X to Y after removing duplicates; impact comes from [reason: fewer inflated orders or corrected prices].  
    - Return rate changed from X% to Y% due to consistent handling of negative quantities/credit notes; note if Contoso lacks returns.  
    - Biggest delta is in [brand/region/category]; drivers are [dup removal, FX to EUR, SKU mapping].  
    - Today's delta is small: KPIs within ±X% of Raw; Silver is safe for executive views.  
    - Confidence note: margin is proxy for W% of rows; decisions within ±V% tolerance.  

**User Stories (breakdown)**  
- As a DA, I compare Raw vs Silver KPIs with clear delta measures and toggles.  
- As a DA, I quantify data-quality impacts and log issues to DevOps.  
- As a DA, I configure first RLS roles on Silver and validate.  

### Sprint day plan (4.5 days)
- **Day 1:** Connect to both Raw and Silver (consistent fields/units); implement paired measures (`*_raw`, `*_silver`, `*_delta`); ensure returns handling is consistent.  
- **Day 2:** Build side‑by‑side pages and bookmark toggles; sync slicers across pages; align layouts and tooltips for comparability.  
- **Day 3:** Quantify impacts (% dup reduction, FX normalization effect); annotate visuals; summarize findings in README.  
- **Day 4:** Configure brand-level RLS on Silver; validate with "View as role"; open DevOps items for data-quality issues.  
- **Day 4.5:** Buffer; stakeholder walkthrough; polish visuals and documentation.

#### Mini notes — Feature 2.2 (per day)
- Day 1: Import both models (Raw and Silver) with consistent field names/units; create paired measures `*_raw`, `*_silver`, and delta measures; avoid mixed grains.
- Day 2: Use bookmarks + selection panes to toggle Raw/Silver views; sync date/brand slicers across pages.
- Day 3: Quantify % duplicate reduction and FX impact (note methods); annotate visuals/tooltips with caveats.
- Day 4: Define brand-level roles; validate with "View as"; ensure measures respect filter context under RLS.
- Day 4.5: Walk stakeholders through deltas; capture actions into the backlog.

##### Feature 2.1 vs feature 2.2 (quick comparison)
| Aspect | Feature 2.1: First Look (Contoso, Bronze) | Feature 2.2: Raw vs Silver (EuroStyle + Contoso) |
|---|---|---|
| Goal | Tell what happened (performance snapshot). | Explain what changed after cleaning (data‑quality impact). |
| Scope | Contoso only. | Contoso + EuroStyle. |
| Data layer | Bronze (raw). | Bronze vs Silver (cleaned/harmonized). |
| Measures | GMV, AOV, Orders (named DAX). | Paired KPIs: `*_raw`, `*_silver`, `*_delta`, plus `return_rate_delta`. |
| Visuals | KPI cards, daily GMV line, Top 10 products. | Before/After pages, toggle/bookmarks, DQ impact table (dup %, FX effect). |
| One‑liners | "GMV X; Orders Y; AOV Z; Top category/product." | "After cleaning: GMV −X% (−dup Y%, +FX Z%); biggest delta in [brand/region]." |
| Caveats | Minimal (raw snapshot). | Methods banner: returns rule, FX valuation date, margin proxy note. |
| RLS | Draft only. | Basic RLS on Silver (brand manager vs exec). |
| Output | v1 report + KPI Catalog v0.2 + perf notes. | Comparison page + delta measures + DQ tickets. |

---

<a id="feature-2-3"></a>
### Feature 2.3: Executive Post-Merger Dashboard (Sprint 3)
**User Story**:  
As an Executive, I want consolidated GMV, AOV, and margin so I can track EuroStyle + Contoso performance.  

**Learning Resources**:  
- [Row-Level Security in Power BI](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security)  
- [Performance Optimization in Power BI](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-performance-analyzer)  

**Key Concepts**:  
- Gold = business-ready marts with consistent KPIs.  
- Consolidated KPIs unify EuroStyle & Contoso for board-level decisions.  
- RLS (Row-Level Security) = ensures managers see only their brand while executives see both.  

**Acceptance Criteria**:  
- Dashboard includes consolidated GMV, AOV, and margin.  
- Brand comparison available (EuroStyle vs Contoso).  
- Regional splits included (North vs South Europe).  
- RLS configured and validated.  

**Tasks**:  
- Add brand comparison (EuroStyle vs Contoso).  
- Add regional splits (North vs South Europe).  
- Apply **RLS (Row-Level Security)** for managers vs executives.  

**User Stories (breakdown)**  
- As an Executive, I see consolidated GMV/AOV/margin with brand/regional splits.  
- As a DA, I enforce RLS for managers vs executives.  

### Sprint day plan (4.5 days)
- **Day 1:** Connect to Gold marts; outline pages/sections; confirm grain and relationships; stub key measures with proper formats.  
- **Day 2:** Implement brand/regional comparisons (consistent axes, legends); add drill targets (brand→region→product).  
- **Day 3:** Add margin (proxy/final); run Performance Analyzer; consider Power BI aggregation tables or summarizations if needed.  
- **Day 4:** Configure/validate RLS (brand manager vs exec; use "View as"); create demo bookmarks; rehearse narrative.  
- **Day 4.5:** Buffer; finalize and publish; verify sharing and permissions.

#### Mini notes — Feature 2.3 (per day)
- Day 1: Confirm fact/dim relationships on Gold; stub measures and formatting; set consistent date table.
- Day 2: Build brand/region comparisons with aligned axes; add drill targets and verify cross-highlighting.
- Day 3: If slow, consider aggregation tables or summarize to daily grain; re-run Performance Analyzer.
- Day 4: Implement RLS (brand manager vs exec); validate with "View as"; save role definitions.
- Day 4.5: Publish; verify dataset credentials and audience access; document the demo flow.

---

<a id="feature-2-4"></a>
### Feature 2.4: Customer Segmentation Dashboard (Sprint 4)
**User Story**:  
As a Marketing Manager, I want to see customer segments & churn risk so I can design campaigns.  

**Learning Resources**:  
- [RFM Analysis](https://clevertap.com/blog/rfm-analysis/) 
 - [Databricks Solution Accelerator - Predict Customer Churn](https://www.databricks.com/solutions/accelerators/predict-customer-churn)  
- [Databricks Intelligence Platform for C360: Reducing Customer Churn](https://www.databricks.com/resources/demos/tutorials/lakehouse-platform/c360-platform-reduce-churn)
- [Power BI in Fabric](https://learn.microsoft.com/en-us/fabric/get-started/microsoft-fabric-overview)  

**Key Concepts**:  
- Customer segmentation = group customers by behavior (RFM).  
- Churn prediction = probability a customer will stop purchasing.  
- **CLV (Customer Lifetime Value)** = expected revenue/margin over a defined horizon.  
- Integration of DS outputs (scores) into dashboards closes the loop between **data science and business action**.  

**Acceptance Criteria**:  
- Customer 360 dashboard shows segments (RFM).  
- Churn risk and CLV tiers integrated from DS outputs.  
- Dashboard published in Fabric and shared with marketing.  

**Tasks**:  
- Integrate churn & CLV scores (from Data Science team).  
- Build Customer Segmentation dashboard.  
- Publish dashboards in Fabric (Power BI).  

**User Stories (breakdown)**  
- As a Marketing Manager, I explore segments (RFM, churn risk, CLV tiers) and drill‑through to details.  
- As a DA, I wire What‑if parameters and publish via Fabric.  

### Sprint day plan (4.5 days)
- **Day 1:** Integrate churn/CLV scored tables; define segment rules (RFM buckets, risk tiers); design navigation and landing tiles.  
- **Day 2:** Build segment visuals (treemaps/tables) and KPIs; use field parameters for flexible dimension toggles.  
- **Day 3:** Implement drill‑through to customer detail; add What‑if parameters for thresholds and bind into measures.  
- **Day 4:** Publish in Fabric; test RLS interactions (use "View as") and cross-highlighting; validate performance on typical filters.  
- **Day 4.5:** Buffer; capture screenshots and document segmentation logic.

#### Mini notes — Feature 2.4 (per day)
- Day 1: Align segment rules with DS; map fields from scored tables; design landing tiles for quick nav.
- Day 2: Use field parameters for dimension toggles; build segment KPIs and summary visuals.
- Day 3: Add drill-through to customer detail; wire back buttons; add tooltip pages where helpful.
- Day 4: Publish; validate RLS interactions with "View as"; test typical filters for performance.
- Day 4.5: Screenshot key views; document segmentation rules and thresholds in README.


---

<a id="epic-3"></a>
## Epic 3 – Machine Learning & Predictive Analytics
**Goal**: Develop churn and Customer Lifetime Value (CLV) models using merged Customer 360.

---

<a id="feature-3-1"></a>
### Feature 3.1: Exploratory Analysis (Sprint 1–2)
**User Story**:  
As a Data Scientist, I want to perform **Exploratory Data Analysis (EDA)** to understand customer behavior and overlaps.  

**Learning Resources**:  
- [EDA in Databricks](https://docs.databricks.com/exploratory-data-analysis/index.html)  
- [MLflow Tracking](https://mlflow.org/docs/latest/tracking.html)  
- [Churn Prediction Basics](https://www.databricks.com/solutions/accelerators/predict-customer-churn)  

**Key Concepts**:  
- **EDA (Exploratory Data Analysis)** = profiling data to find patterns, missing values, distributions.  
- Churn definition = customers inactive for more than 90 days.  
- **CLV (Customer Lifetime Value)** = net margin expected per customer over a defined horizon (e.g., 12 months).  
 - Dataset sequence: analyze Contoso first in Sprint 1 to establish baselines; integrate EuroStyle in Sprint 2 to study overlaps and brand differences.

**Acceptance Criteria**:  
- Missing values, outliers, and overlaps documented.  
- Clear churn definition (>90 days inactivity).  
- Draft **CLV** formula validated with business stakeholders.  
 - EDA profiling summary produced (notebook and 1–2 page readout) with top data-quality issues and EuroStyle vs Contoso overlaps.  
 - Data risk log created (PII handling, potential label leakage, notable gaps) and shared with team.  
 - Baseline yardsticks defined: simple rule-based churn heuristic and RFM segmentation for comparison.  
 - Experiment scaffolding ready: MLflow experiment initialized; evaluation protocol (splits/CV, metrics: AUC for churn, RMSE for CLV) documented in repo.  
 - Sanity checks: churn prevalence computed; class balance assessed; non‑leaky split strategy chosen (time‑based or customer‑grouped); drift check between brands.  

**Tasks**:  
- Perform **EDA** on Bronze (distributions, missing values, overlaps).  
- Define churn = inactivity > 90 days.  
- Draft **CLV** definition (12 months net margin).  
 - Publish an EDA summary with visuals and a prioritized data-quality issue list.  
 - Create and fill a leakage checklist; exclude leaky fields from labels/features.  
 - Implement simple baselines (rule-based churn risk, RFM segments) and record baseline performance.  
 - Initialize MLflow experiment; define train/validation/test split strategy and log runs with metrics/params.  
 - Quantify churn rate by brand/period; verify class balance; compare key distributions EuroStyle vs Contoso.

**User Stories (breakdown)**  
- As a DS, I document churn prevalence and select a non‑leaky split protocol.  
- As a DS, I produce an EDA readout and a prioritized DQ issue list.  
- As a DS, I initialize MLflow with the evaluation plan and baselines.

### Sprint day plan (4.5 days)
- **Day 1:** Load Bronze; run profiling (distributions, missingness, outliers); capture tables/shapes; note obvious data issues for DE/DA.  
- **Day 2:** Define churn (inactivity horizon); compute prevalence by brand/period; select non‑leaky split (time/customer‑grouped) and freeze seed.  
- **Day 3:** Implement naive baselines (rules/RFM); complete leakage checklist; start risk log (PII, drift, label quality).  
- **Day 4:** Initialize MLflow experiment; log baseline runs and artifacts; draft EDA readout and align with DA/DE.  
- **Day 4.5:** Buffer; finalize notebooks and readout; link in backlog.

#### Mini notes — Feature 3.1 (per day)
- Day 1: Profile with distributions and missingness; save shapes and head/tail for reproducibility.
- Day 2: Fix churn horizon (e.g., >90 days); compute prevalence by brand/period; freeze random seed.
- Day 3: Implement rule/RFM baselines; complete leakage checklist; start the risk log.
- Day 4: Initialize MLflow experiment; log baseline runs and artifacts (plots/tables).
- Day 4.5: Publish a 1–2 page EDA summary with top issues and recommended fixes.

---

<a id="feature-3-2"></a>
### Feature 3.2: Feature Engineering (Sprint 2)
**User Story**:  
As a Data Scientist, I want RFM and behavioral features to build churn & CLV models.  

**Learning Resources**:  
- [RFM Analysis](https://clevertap.com/blog/rfm-analysis/)  
- [Feature Engineering Guide](https://www.databricks.com/glossary/feature-engineering)  
- [MLflow Tracking Features](https://docs.databricks.com/aws/en/mlflow/tracking)  

**Key Concepts**:  
- **RFM** = **Recency, Frequency, Monetary** value (classic segmentation method).  
- Basket diversity = how many unique categories a customer buys from.  
- Cross-brand shopping = customers who purchased both EuroStyle & Contoso.  
- Features must be logged and versioned for reproducibility.  

**Acceptance Criteria**:  
- **RFM** metrics computed for all customers.  
- Basket diversity & cross-brand features available in Silver/Gold.  
- Feature sets tracked in **MLflow** or Delta tables.  
 - Features persisted as versioned Delta tables with metadata (version, created_ts, source snapshot) for reproducibility.  
 - Joinability/consumption contract drafted with DE/DA (score schema, business keys, refresh cadence).  
 - Leakage checks performed and documented for engineered features.  
 - If COGS is missing, the agreed CLV proxy approach is documented (see Gold notes) and reflected in downstream features.  
 - Sanity checks: high-correlation features identified and deduplicated; extreme cardinality/constant fields excluded; imputation/log transforms documented; all preprocessing fit on TRAIN only.

**Tasks**:  
- Compute **RFM (Recency, Frequency, Monetary value)** metrics.  
- Add basket diversity & cross-brand shopping signals.  
- Track feature sets in MLflow.  
 - Persist feature tables as versioned Delta (e.g., `silver.features_rfm_v1`) including schema/version metadata.  
 - Define and document the scoring schema and join keys with DE/DA for integration into `customer_360`/Gold; propose refresh cadence.  
 - Train first simple baselines on sample data and log to MLflow; compare against rule-based/RFM yardsticks.  
 - Document leakage assessment and run a quick feature-importance sanity check.  
 - Run correlation screening and cardinality checks; document imputation strategy; ensure transformations are fit on TRAIN only.

**User Stories (breakdown)**  
- As a DS, I compute and persist RFM and behavior features with versioning.  
- As a DS, I remove redundant/highly correlated features and document preprocessing.  
- As a DS, I define a consumption contract with DE/DA for scoring integration.

### Sprint day plan (4.5 days)
- **Day 1:** Compute RFM with a fixed as‑of date; persist `v1` Delta with metadata (version, created_ts, source snapshot); register for team access.  
- **Day 2:** Add basket diversity (distinct categories) and cross‑brand flags; ensure only pre‑as‑of window info to avoid leakage.  
- **Day 3:** Run correlation/cardinality screening; drop constant/high‑card features; document imputation/log transforms (fit on TRAIN only).  
- **Day 4:** Define consumption contract (schema, keys, cadence) with DE/DA; train quick baselines and log to MLflow for sanity.  
- **Day 4.5:** Buffer; finalize feature tables and docs.

#### Mini notes — Feature 3.2 (per day)
- Day 1: Use a fixed as-of date; persist `v1` features with version metadata; document source snapshot.
- Day 2: Add basket diversity and cross-brand features; avoid leakage (pre-as-of info only).
- Day 3: Run correlation/cardinality screens; drop constants/high-card fields; note imputations.
- Day 4: Define consumption contract (schema, keys, cadence) with DE/DA; train quick baselines.
- Day 4.5: Version the feature table; note joins and refresh cadence in README.

---

<a id="feature-3-3"></a>
### Feature 3.3: Model Training (Sprint 3)
**User Story**:  
As a Data Scientist, I want baseline models for churn and CLV so I can evaluate predictive power.  

**Learning Resources**:  
- [MLlib Classification](https://spark.apache.org/docs/latest/ml-classification-regression.html)  
- [MLflow Experiment Tracking](https://mlflow.org/docs/latest/tracking.html)  
- [Model Evaluation Metrics](https://scikit-learn.org/stable/modules/model_evaluation.html)  

**Key Concepts**:  
- Logistic Regression = baseline classification model for churn (yes/no).  
- Random Forest = regression model for **CLV (predicting value)**.  
- Model evaluation uses **Accuracy, AUC (Area Under Curve)** for churn, **RMSE (Root Mean Squared Error)** for CLV.  

**Acceptance Criteria**:  
- **Logistic Regression** churn model trained and logged.  
- Random Forest **CLV** regression trained and logged.  
- Experiments tracked in MLflow with metrics and parameters.  
 - Sanity checks: models outperform baselines (e.g., AUC > baseline with 95% CI); calibration curve assessed (Brier score or reliability plot); seeds fixed for reproducibility.

**Tasks**:  
- **Train Logistic Regression** for churn.  
- Train **Random Forest for CLV**.  
- Log all experiments in **MLflow**.  
 - Compute baseline metrics and confidence intervals; generate calibration plots; fix random seeds; save artifacts.

**User Stories (breakdown)**  
- As a DS, I deliver churn and CLV models that beat baselines with evidence.  
- As a DS, I log metrics/params/artifacts in MLflow, including calibration and CI.

### Sprint day plan (4.5 days)
- **Day 1:** Train churn LR baseline with fixed split/seed; log pipeline, metrics, and artifacts; check class balance and thresholds.  
- **Day 2:** Train CLV Random Forest baseline; handle skew (winsorize/log if needed); log feature importance and errors.  
- **Day 3:** Light tuning; bootstrap CIs; calibration (Brier/reliability plot); select operating points.  
- **Day 4:** Segment‑wise eval (brand/region); record results; register models/names and document versioning.  
- **Day 4.5:** Buffer; review and hand‑off for scoring.

#### Mini notes — Feature 3.3 (per day)
- Day 1: Train LR churn baseline with fixed split; check class balance; log to MLflow.
- Day 2: Train RF for CLV; handle skew (winsorize/log); log importance and error metrics.
- Day 3: Light tuning; bootstrap CIs; calibration (Brier/reliability plot).
- Day 4: Segment-wise eval (brand/region); register models and document versions.
- Day 4.5: Summarize results vs baselines; decide next scoring steps.

---

<a id="feature-3-4"></a>
### Feature 3.4: Batch Scoring & Integration (Sprint 4)
**User Story**:  
As a Data Scientist, I want to score churn/CLV and join them into Customer 360 so Analysts can use them.  

**Learning Resources**:  
- [MLflow Model Registry](https://mlflow.org/docs/latest/model-registry.html)  
- [Databricks Batch Scoring](https://docs.databricks.com/machine-learning/model-inference/index.html)  
- [Getting Started with Databricks - Building a Forecasting Model on Databricks](https://community.databricks.com/t5/get-started-guides/getting-started-with-databricks-building-a-forecasting-model-on/ta-p/69301)
- [Responsible AI with the Databricks Data Intelligence Platform](https://www.databricks.com/blog/responsible-ai-databricks-data-intelligence-platform)
- [Explainability Methods](https://christophm.github.io/interpretable-ml-book/)  

**Key Concepts**:  
- Batch scoring = apply trained models to full customer base.  
- Scores stored in Gold (`customer_scores_gold`).  
- Document model performance with **Accuracy, AUC, RMSE**.  
- Explainability = feature importance to justify predictions.  

**Acceptance Criteria**:  
- Churn probabilities and CLV values scored for all customers.  
- Scored datasets joined into `customer_360_gold`.  
- **Model performance documented** (Accuracy, AUC, RMSE).  
- Feature importance/explainability shared with analysts.  
 - Sanity checks: contract of scoring schema validated (keys, types, nullability); train/serve skew check executed; model + feature versions recorded; small E2E test on 1k rows passes (bounded scores, low nulls).

**Tasks**:  
- Batch scoring → `customer_scores_gold`.  
- Publish scored tables to Gold marts.  
- Document performance (Accuracy, AUC, RMSE) and explainability.  
 - Validate train/serve schema alignment; record versions; run sample E2E assertions on scored outputs.

**User Stories (breakdown)**  
- As a DS, I score and publish churn/CLV with schema and versioning contracts.  
- As a DS, I validate train/serve skew and run E2E checks before hand‑off to DA.

### Sprint day plan (4.5 days)
- **Day 1:** Freeze model versions; prepare scoring pipeline (UDFs/loader) and output schema contract (keys, types, nullability).  
- **Day 2:** Run batch scoring; partition to manage scale; write idempotently; persist `customer_scores_gold`.  
- **Day 3:** Join into `customer_360_gold`; QA nulls/distributions; verify counts and keys.  
- **Day 4:** Train/serve skew checks (PSI/simple comparisons); add explainability notes (feature importances); finalize schema/versions.  
- **Day 4.5:** Buffer; align with DA; publish tables and links.

#### Mini notes — Feature 3.4 (per day)
- Day 1: Freeze model and feature versions; define output schema; write a tiny E2E test plan.
- Day 2: Batch score with partitions; write idempotently; persist `customer_scores_gold`.
- Day 3: Join into `customer_360_gold`; validate counts/keys; sanity-check distributions.
- Day 4: Check train/serve skew (PSI/simple compares); add feature importances/explainability notes.
- Day 4.5: Publish outputs and docs; align with DA on dashboard bindings.

---

<a id="epic-4"></a>
## Epic 4 – Platform Integration (Databricks ↔ Fabric)
**Goal**: Demonstrate end-to-end integration between Databricks and Microsoft Fabric, even on Free Editions.

---

<a id="feature-4-1"></a>
### Feature 4.1: Export Gold to Fabric (Sprint 4)
**User Story**:  
As a Data Engineer, I want Gold marts exported to Fabric so dashboards can consume them via Direct Lake.  

**Learning Resources**:  
- [Fabric Lakehouse Overview](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)  
- [Fabric Data Pipelines](https://learn.microsoft.com/en-us/fabric/data-factory/)  
- [Databricks Parquet & Delta Export](https://docs.databricks.com/delta/delta-batch.html)  

For your information
- [Integrate OneLake with Azure Databricks](https://learn.microsoft.com/en-us/fabric/onelake/onelake-azure-databricks)
- [Understand medallion lakehouse architecture for Microsoft Fabric with OneLake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-medallion-lakehouse-architecture)
- [Microsoft Fabric documentation](https://learn.microsoft.com/en-us/fabric)

**Key Concepts**:  
- **Gold marts** = final curated tables for analytics (sales_daily, customer_360, etc.).  
- **Parquet + manifest + _SUCCESS** = ensures consistent export contract.  
- **Fabric Lakehouse Files** (Free path) = manual upload from Databricks to Fabric.  
- **Delta in Fabric** = ingestion into tables ready for Direct Lake mode.  

**Acceptance Criteria**  
- Gold marts exported as Parquet with manifest and success marker.  
- **Export tested using manual download from Databricks Free Edition and manual upload into Fabric Lakehouse (no automated integration possible in free tier).**  
- Fabric Data Pipeline ingests and creates Delta tables.  
- Datasets are queryable in Power BI.  

**Tasks**  
- Export Gold marts as Parquet + manifest.  
- **Manually download files from Databricks Free Edition and upload them into Fabric Lakehouse `/Files/dropzone/...`.**  
- Ingest with Fabric Data Pipeline → Delta tables.  

**User Stories (breakdown)**  
- As a DE, I export Gold marts with a reproducible Parquet+manifest contract.  
- As a DE, I ingest them into Fabric Lakehouse tables via Data Pipelines.  

### Sprint day plan (4.5 days)
- **Day 1:** Define export contract (paths, `_SUCCESS`, `release_manifest.json`, schema); dry‑run on one small table and verify re‑ingest.  
- **Day 2:** Package all Gold marts; coalesce to reasonable file sizes; compute row counts and optional checksums; bundle manifest.  
- **Day 3:** Manually transfer to Fabric Lakehouse `/Files`; configure Data Pipeline mappings and create Delta tables.  
- **Day 4:** Validate counts/schemas post‑ingest; test Power BI connectivity (Direct Lake) and basic visuals.  
- **Day 4.5:** Buffer; document steps, limitations, and troubleshooting.

#### Mini notes — Feature 4.1 (per day)
- Day 1: Define export paths and manifest fields; do a tiny dry-run end-to-end.
- Day 2: Coalesce files to reasonable sizes; compute counts/checksums; finalize manifest.
- Day 3: Manual transfer to Fabric `/Files`; map columns in Data Pipeline.
- Day 4: Validate counts/schemas; test Direct Lake connectivity with a simple visual.
- Day 4.5: Document manual steps and limits for Free tier; add troubleshooting tips.


---

<a id="feature-4-2"></a>
### Feature 4.2: Power BI Suite (Sprint 4)
**User Story**:  
As a Data Analyst, I want Power BI dashboards published through Fabric so executives can access the post-merger suite.  

**Learning Resources**:  
- [Power BI Service](https://learn.microsoft.com/en-us/power-bi/fundamentals/)  
- [Understand medallion lakehouse architecture for Microsoft Fabric with OneLake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-medallion-lakehouse-architecture)
- [Data Factory documentation in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/data-factory/)  
- [Row-Level Security (RLS)](https://learn.microsoft.com/en-us/fabric/data-warehouse/row-level-security)  

**Key Concepts**:  
- **Executive Dashboard** = EuroStyle vs Contoso, unified GMV/AOV/margin view.  
- **Customer Segmentation Dashboard** = churn risk, CLV segments, campaign targeting.  
- **RLS (Row-Level Security)** = managers see only their brand, executives see both.  
- **Fabric Deployment Pipelines** = promote dashboards across Dev → Test → Prod.  

**Acceptance Criteria**:  
- Executive dashboard published in Power BI (Fabric).  
- Customer segmentation dashboard includes churn + CLV scores.  
- Dashboards tested with RLS (brand vs consolidated view).  
- Dashboards deployed through Fabric pipeline.  

**Tasks**:  
- Build Executive Dashboard (EuroStyle + Contoso).  
- Build Customer Segmentation Dashboard (with churn & CLV).  
- Deploy dashboards via Fabric pipelines.  

**User Stories (breakdown)**  
- As an Executive/Marketing, I access executive and segmentation dashboards with RLS applied.  
- As a DA, I deploy via Fabric pipelines across stages.  

### Sprint day plan (4.5 days)
- **Day 1:** Build Executive pages (theme, navigation, KPI cards); ensure consistent formats and tooltips.  
- **Day 2:** Build Segmentation pages; integrate scored tables; validate cross‑highlighting behavior.  
- **Day 3:** Configure RLS roles and map to groups; validate with "View as".  
- **Day 4:** Promote via Fabric Deployment Pipeline Dev → Test; validate connections and parameters.  
- **Day 4.5:** Buffer; polish visuals, documentation, and sharing settings.

#### Mini notes — Feature 4.2 (per day)
- Day 1: Apply a report theme (colors/number formats); add navigation (buttons/bookmarks); place KPI cards for GMV, AOV, margin; set formats (currency/decimal) and standard tooltips; hide technical columns.
- Day 2: Add Segmentation pages; connect to `customer_scores_gold`; confirm relationships (customer/date); test cross-highlighting between segment charts and KPI cards; avoid high-cardinality slicers.
- Day 3: Create roles (e.g., `BrandManager` filters brand='Contoso'); map roles to security groups; test with "View as" for both manager and exec; verify measures behave correctly under RLS.
- Day 4: Use Fabric Deployment Pipeline to promote Dev→Test; validate dataset parameters (Lakehouse, workspace); refresh and check all visuals; log any broken lineage.
- Day 4.5: Review sharing (audience, app access); add README pointers (dataset, dashboards, pipeline URL); capture screenshots for hand‑off.

---
<a id="feature-4-3"></a>
## Feature 4.3: Model Scoring Export & Validation in Fabric (Sprint 4)  
**User Story**:  
As a Data Scientist, I want churn and CLV scores exported from Databricks into Fabric so that business dashboards can consume and validate predictive insights.  

**Learning Resources**:  
- [Batch Scoring on Databricks](https://docs.databricks.com/en/machine-learning/model-inference/index.html)  
- [MLflow Model Registry](https://mlflow.org/docs/latest/model-registry.html)  
- [Fabric Data Pipelines](https://learn.microsoft.com/en-us/fabric/data-factory/)  

**Key Concepts**:  
- Batch-scored outputs (`customer_id`, churn probability, CLV value) must be stored in Gold.  
- Export scored tables as Parquet with manifest for ingestion into Fabric.  
- Validation in Fabric ensures alignment between Databricks predictions and Power BI dashboards.  
- This closes the loop between Data Science and BI.  

**Acceptance Criteria**:  
- Scored churn and CLV tables saved in `customer_scores_gold`.  
- Files exported as Parquet + manifest for Fabric.  
- Export process documented and tested **using manual download from Databricks Free Edition and manual upload into Fabric Lakehouse** (no automated integration in free tier).  
- Fabric Data Pipeline ingests scores into Lakehouse tables.  
- Power BI dashboards (Feature 4.2) consume these tables for segmentation and risk views.  

**Tasks**:  
- Run batch scoring in Databricks Free Edition for churn and CLV models.  
- Save outputs to Gold (`customer_scores_gold`).  
- Export as Parquet + manifest + `_SUCCESS`.  
- **Manually download Parquet files from Databricks Free Edition and upload them into Fabric Lakehouse `/Files` folder.**  
- Ingest with Fabric Data Pipeline → Delta tables.  
- Validate alignment of predictions between Databricks and Fabric dashboards.   

**User Stories (breakdown)**  
- As a DS/DE, I export scored tables with manifest and validate Fabric ingestion.  
- As a DA, I confirm dashboards consume the new tables consistently.  

### Sprint day plan (4.5 days)
- **Day 1:** Define scored output schemas/partitions and export plan (manifest fields, `_SUCCESS`); confirm table list with DA.  
- **Day 2:** Export Parquet + manifest; upload to Fabric `/Files`; configure Pipeline mappings for each table.  
- **Day 3:** Validate Lakehouse tables (schema/row counts) and Power BI bindings; refresh visuals.  
- **Day 4:** Document validations and edge cases (type coercions, time zones, rounding); capture before/after metrics.  
- **Day 4.5:** Buffer; finalize evidence links and ownership.

#### Mini notes — Feature 4.3 (per day)
- Day 1: Confirm scored schema (keys/types); list export fields and `_SUCCESS`.
- Day 2: Export Parquet+manifest; upload to Fabric; configure mappings per table.
- Day 3: Validate row counts and dashboard bindings; refresh visuals.
- Day 4: Log validation notes (types/time zones/rounding); record pre/post metrics.
- Day 4.5: Link evidence and owners; close the loop with DA.


---

<a id="epic-5"></a>
## Optional Extensions

<a id="feature-5-1"></a>
### Feature 5.1 (DE) – Simplified Data Vault in Silver  

**User Story**  
As a Data Engineer, I want a simplified Data Vault (Hubs, Links, Satellites) in the Silver layer so downstream Gold marts are consistent, modular, and easy to evolve.

#### Why Data Vault in Silver? (Benefits)

- Change-tolerant model: hubs/links/satellites decouple core identities from changing attributes, so source schema tweaks impact only the affected satellite.
- Consistent keys across brands: stable, hashed business keys unify EuroStyle and Contoso identifiers despite differing source systems and formats.
- Built-in historization: satellites track attribute changes over time (SCD2), enabling both "current" and "as-of date" analytics downstream.
- Reusable semantic layer: multiple Gold marts reuse the same conforming hubs/links/satellites, reducing duplication and drift.
- Clear lineage and governance: record_source, load_ts, and hub/link relationships make provenance and audit simple.
- M&A friendly: isolates integration pain (mapping, late-arriving keys, overlaps) while keeping downstream models stable.
- Scales incrementally: easy to append new sources or attributes by adding satellites without refactoring existing marts.

Trade-offs and when to skip
- Overhead: adds modeling/ETL effort; if the scope is short-lived or schemas are stable, a straight dimensional model may be sufficient.
- Complexity: requires naming and keying conventions; in free-tier setups SCD2 is manual.
- Guidance for this project: keep it "light" (a few hubs/links, at least one satellite). If time is tight, prioritize Medallion + conformed dimensions and treat this feature as optional.



**Learning Resources**  
- [Medallion Architecture (Databricks)](https://docs.databricks.com/lakehouse/medallion.html)  
- [Delta Lake Best Practices (Azure Databricks)](https://learn.microsoft.com/en-us/azure/databricks/delta/best-practices)  
- [Data Vault (Databricks glossary)](https://www.databricks.com/glossary/data-vault)  
- [Prescriptive guidance for Data Vault on Lakehouse (Databricks blog)](https://www.databricks.com/blog/2022/06/24/prescriptive-guidance-for-implementing-a-data-vault-model-on-the-databricks-lakehouse-platform.html)  
- [Hash functions in Databricks SQL: md5](https://docs.databricks.com/sql/language-manual/functions/md5.html), [sha2](https://docs.databricks.com/sql/language-manual/functions/sha2.html)

**Key Concepts**  
- **Hub**: master entities with stable business keys (customers, products, calendar).  
- **Link**: transactional/relational tables joining hubs (sales: customer ↔ product ↔ date).  
- **Satellite**: descriptive and evolving attributes for hubs or links (country, segment, category) with simple SCD2 fields (`effective_from`, `effective_to`, `is_current`).  
- Objective: a "light" Data Vault in Silver that feeds `sales_daily`, `category_perf`, and `customer_360` in Gold.

**Acceptance Criteria**  
- `silver.customer_hub`, `silver.product_hub`, `silver.calendar_hub` created with stable hash keys from business keys.  
- `silver.sales_link` joins customer, product, and date hubs for cleaned sales.  
- At least one satellite operational (e.g., `silver.customer_satellite` with SCD2 columns).  
- Joins across hub/link/satellite validated (cardinality, sample checks).  
- Short README section explaining schema, keys, and historization policy.

**Tasks**  
1. Build Hubs  
   - `customer_hub`: deduplicate, harmonize `customer_id`, compute `customer_hk` (hash).  
   - `product_hub`: harmonize `sku/product_code`, compute `product_hk`.  
   - `calendar_hub`: generate a date hub and `date_hk` (or keep natural date key).  
2. Build Link  
   - `sales_link`: from cleaned sales, resolve FK to hubs, optionally compute `sales_lk`.  
3. Build at least one Satellite  
   - `customer_satellite`: descriptive columns (country, segment) with SCD2 fields.  
4. Validate  
   - Join samples, row counts, date consistency.  
5. Document  
   - ASCII/Mermaid schema, naming conventions, key logic, SCD policy.

**User Stories (breakdown)**  
- As a DE, I create hubs/links/satellites that integrate with existing Silver/Gold contracts.  
- As a DA/DS, I query hubs/links for consistent keys and history.  

### Sprint day plan (4.5 days)
- **Day 1:** Build `customer_hub`, `product_hub`, `calendar_hub`; choose hash function and key normalization; ensure idempotent population.  
- **Day 2:** Build `sales_link`; resolve FK lookups; handle null/late‑arriving keys; confirm transaction granularity.  
- **Day 3:** Build a first satellite (e.g., `customer_satellite`) with SCD2 fields; implement change detection and closing/opening rows.  
- **Day 4:** Validate joins/cardinality, orphan detection, and date consistency; fix issues and re‑run.  
- **Day 4.5:** Document schema, keys, and SCD policy (diagram + notes).

#### Mini notes — Feature 5.1 (per day)
- Day 1: Normalize BKs; hash to SKs; ensure idempotent hub loads.
- Day 2: Build sales_link; resolve FK lookups; handle late/unknowns.
- Day 3: Implement SCD2 change detection; set effective_from/to; flag is_current.
- Day 4: Validate joins and cardinality; detect orphans; iterate fixes.
- Day 4.5: Document schema and SCD2 policy with a small diagram.

**Minimal SQL Example** (adapt if needed)
```sql
-- CUSTOMER HUB
CREATE OR REPLACE TABLE silver.customer_hub AS
SELECT
  md5(upper(trim(customer_id))) AS customer_hk,
  upper(trim(customer_id))      AS customer_bk,
  current_timestamp()           AS load_ts,
  'silver_customers'            AS record_source
FROM silver.customers_clean
GROUP BY upper(trim(customer_id));

-- PRODUCT HUB
CREATE OR REPLACE TABLE silver.product_hub AS
SELECT
  md5(upper(trim(product_code))) AS product_hk,
  upper(trim(product_code))      AS product_bk,
  current_timestamp()            AS load_ts,
  'silver_products'              AS record_source
FROM silver.products_clean
GROUP BY upper(trim(product_code));

-- CALENDAR HUB
CREATE OR REPLACE TABLE silver.calendar_hub AS
SELECT
  CAST(order_date AS DATE)               AS date_bk,
  md5(CAST(order_date AS STRING))        AS date_hk,
  current_timestamp()                    AS load_ts,
  'derived_calendar'                     AS record_source
FROM (SELECT DISTINCT CAST(order_date AS DATE) AS order_date
      FROM silver.sales_clean);

-- SALES LINK (customer–product–date)
CREATE OR REPLACE TABLE silver.sales_link AS
SELECT
  md5(concat_ws('||', ch.customer_hk, ph.product_hk, cal.date_hk,
                coalesce(cast(s.order_id as string), ''))) AS sales_lk,
  ch.customer_hk, ph.product_hk, cal.date_hk, s.order_id,
  current_timestamp() AS load_ts, 'silver_sales' AS record_source
FROM silver.sales_clean s
JOIN silver.customer_hub ch ON upper(trim(s.customer_id)) = ch.customer_bk
JOIN silver.product_hub  ph ON upper(trim(s.product_code)) = ph.product_bk
JOIN silver.calendar_hub cal ON CAST(s.order_date AS DATE) = cal.date_bk;

-- CUSTOMER SATELLITE (simple SCD2 initialization)
CREATE OR REPLACE TABLE silver.customer_satellite AS
SELECT
  ch.customer_hk,
  upper(trim(c.country))                           AS country,
  upper(trim(coalesce(c.segment, 'UNKNOWN')))      AS segment,
  current_timestamp()                              AS effective_from,
  timestamp'9999-12-31 23:59:59'                   AS effective_to,
  true                                             AS is_current,
  current_timestamp()                              AS load_ts,
  'silver_customers'                               AS record_source
FROM silver.customer_hub ch
JOIN silver.customers_clean c ON ch.customer_bk = upper(trim(c.customer_id));
```

Free Edition Limitations (Databricks Free Edition + Fabric Student)

- No Delta Live Tables (DLT) or Jobs API: transformations must be run manually; no native scheduled pipelines.
- No Unity Catalog: no centralized governance, lineage, or fine-grained policies; rely on naming conventions and workspace scopes.
- Limited compute and session lifetime: keep data volumes modest; avoid heavy SHAP or deep nets on large samples.
- Limited optimization features: if OPTIMIZE/Z-ORDER options are unavailable, compact data via write patterns (e.g., coalesce/repartition) and keep file sizes reasonable.
- No Airflow jobs in Fabric free/student and no Databricks tokens in CE: CI/CD and orchestration must be simulated (documented steps, local GitHub Actions for tests only).
- SCD2 management is manual: track changes with effective dates and handle historical data in the application logic.

<a id="feature-5-2"></a>
### Feature 5.2 (DA) – Advanced Segmentation & Dynamic Dashboards  

**User Story**  
As a Data Analyst, I want to implement advanced segmentation logic and dynamic drill-through dashboards so that business stakeholders can interactively explore customer behavior (RFM segments, churn risk, CLV tiers) across multiple dimensions.

**Learning Resources**  
- [Power BI What-if parameters](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-what-if)  
- [Drillthrough in Power BI](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-drillthrough)  

**Key Concepts**  
- Advanced segmentation = grouping customers dynamically by RFM, churn risk, CLV tiers.  
- Drill-through dashboards = allowing navigation from high-level KPIs (GMV, AOV) into segment-level details.  
- Dynamic filters = enabling end-users to adjust thresholds (e.g., recency window, churn probability cutoff) with What-if parameters.  

**Acceptance Criteria**  
- Dashboard includes an interactive segmentation view: customers bucketed by RFM, churn risk, CLV.  
- Dynamic thresholds (e.g., inactivity > 90 days vs > 120 days) controlled by What-if parameters.  
- Drill-through implemented: from executive KPIs → customer segment → individual customer record.  
- Dashboard published in Fabric and linked to Gold `customer_360` and `customer_scores_gold`.  
- Documentation in README with screenshots and explanation of the segmentation logic.  

**Tasks**  
1. Define dynamic segmentation rules (RFM buckets, churn cutoff, CLV tiers).  
2. Implement What-if parameters in Power BI for recency window and churn cutoff.  
3. Create drill-through pages for customer segments and individual records.  
4. Connect dashboards to Gold `customer_360` and `customer_scores_gold`.  
5. Document segmentation rules and dashboard navigation in README. 

**User Stories (breakdown)**  
- As a DA, I deliver dynamic segmentation with What‑if parameters and drill‑through.  
- As a Marketing user, I can navigate from KPIs to segment to customer.  

### Sprint day plan (4.5 days)
- **Day 1:** Define segmentation logic (bins/thresholds) and What‑if parameter ranges; align with stakeholders.  
- **Day 2:** Build dynamic visuals (field parameters/small multiples) and segment pages; ensure consistent legends.  
- **Day 3:** Implement drill‑through to detail with back buttons; add tooltip pages where useful.  
- **Day 4:** Connect to Gold tables; test interactions/performance; consider aggregated tables if needed.  
- **Day 4.5:** Buffer; document rules and navigation.

<a id="feature-5-3"></a>
### Feature 5.3 (DS) – Survival & Probabilistic Models for Churn and CLV  

**User Story**  
As a Data Scientist, I want to implement advanced survival analysis and probabilistic models so that stakeholders gain deeper insights into customer lifetime and churn timing, beyond standard classification/regression.  

**Learning Resources**  
- [Survival Analysis in Python (lifelines)](https://lifelines.readthedocs.io/en/latest/)  
- [BG/NBD – step-by-step derivation (Fader, Hardie & Lee, 2019, PDF)](https://www.brucehardie.com/notes/039/bgnbd_derivation__2019-11-06.pdf)  
- [The Gamma-Gamma Model of Monetary Value)](https://www.brucehardie.com/notes/025/gamma_gamma.pdf)
- [Sequential Deep Learning with PyTorch](https://pytorch.org/tutorials/beginner/basics/intro.html)  
- [BTYD models notebook on Databricks](https://www.databricks.com/notebooks/Customer%20Lifetime%20Value%20Virtual%20Workshop/02%20The%20BTYD%20Models.html)

**Key Concepts**  
- **Survival models** predict *time until churn*, producing hazard curves and probabilities per customer.  
- **BG/NBD & Gamma-Gamma models** estimate CLV using probabilistic purchase frequency and monetary value.  
- **Sequential deep learning (optional)** models customer purchase history as a sequence for richer churn signals.  

**Acceptance Criteria**  
- Train a Cox Proportional Hazards or BG/NBD model for churn timing.  
- Fit Gamma-Gamma or Bayesian model for CLV distribution.  
- Visualize survival curves and CLV probability distributions for segments.  
- Compare survival/CLV outputs against RFM-based baselines.  
- Document in README with plots and interpretation (e.g., "50% of Segment A expected to churn within 6 months").  

**Tasks**  
1. Prepare survival dataset (event = churn, duration = days since last purchase).  
2. Train Cox model or Kaplan-Meier survival curves using `lifelines`.  
3. Implement BG/NBD and Gamma-Gamma CLV model with the `lifetimes` package.  
4. Generate visualizations (hazard curves, CLV distributions).  
5. (Optional) Prototype a sequential NN model (LSTM) for churn prediction.  
6. Document findings and compare with baseline tree-based models.  

**User Stories (breakdown)**  
- As a DS, I estimate churn timing and CLV distributions and compare to baselines.  
- As a DA, I receive segment‑level visuals (survival/CLV).  

### Sprint day plan (4.5 days)
- **Day 1:** Prepare datasets with censoring rules and time origin; validate horizons and event definitions; sanity checks.  
- **Day 2:** Train Cox/Kaplan‑Meier; test proportional hazards assumptions; evaluate by segment.  
- **Day 3:** Train BG/NBD and Gamma‑Gamma; initialize sensibly; check convergence and plausibility.  
- **Day 4:** Build survival/CLV visuals; compute quantiles and calibration; compare to baselines.  
- **Day 4.5:** Document results, seeds, and reproducibility notes.

<a id="feature-5-4"></a>
### Feature 5.4 (All) – End-to-End Deployment (Databricks + Fabric)

**User Story**  
As a project team (DE, DA, DS), we want to simulate an end-to-end deployment pipeline across Databricks and Microsoft Fabric so that data pipelines, ML models, and dashboards can be versioned, validated, and promoted, even if some steps remain manual in Free Editions.

**Learning Resources**  
- [Databricks Repos and GitHub integration](https://learn.microsoft.com/en-us/azure/databricks/repos)  
- [CI/CD on Databricks with GitHub Actions](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/ci-cd)  
- [Fabric Deployment Pipelines](https://learn.microsoft.com/en-us/power-bi/create-reports/deployment-pipelines-overview)  
- [Row-level security in Fabric](https://learn.microsoft.com/en-us/fabric/data-warehouse/tutorial-row-level-security)  


**Key Concepts**  
- **Databricks (Enterprise)**: normally supports CI/CD with Jobs, Workflows, Unity Catalog, and GitHub Actions.  
- **Databricks Free Edition**: lacks Jobs API, Unity Catalog, and secure tokens → deployment is **manual** (export notebooks, run pipelines interactively).  
- **Fabric Free/Student**: supports Lakehouse + Dashboards + Deployment Pipelines, but capacity and automation are limited.  
- **CI/CD Simulation**: GitHub Actions runs schema checks and produces artifacts (notebooks, PBIX, configs), but "CD" (deployment) is **manual** in Free tiers.  

**Acceptance Criteria**  
- A Fabric deployment pipeline created with Dev and Test stages.  
- Gold marts (sales_daily, customer_360, customer_scores_gold) exported from Databricks Free Edition and ingested into Fabric Dev, then promoted to Test.  
- At least one Power BI dashboard published and promoted across stages.  
- RLS validated across environments.  
- **Export and deployment steps explicitly documented as manual for Free Edition (Databricks exports, Fabric promotions).**  
- Documentation highlights which steps are automated vs. manual.  
- Limitations of Databricks Free Edition explicitly listed in README.  

**Tasks**  
1. **Databricks**  
   - Export Gold marts as Parquet + `_SUCCESS`.  
   - **Manually download files from Databricks Free Edition and upload them into Fabric Lakehouse.**  
   - (Optional in Enterprise) integrate with GitHub Actions + Jobs API for automated runs.  
2. **Fabric**  
   - Configure Deployment Pipeline (Dev + Test).  
   - Ingest Gold marts into Lakehouse Dev → promote to Test.  
   - Connect dashboards to Test Lakehouse and validate KPIs.  
   - Apply RLS rules in Test.  
3. **CI/CD Simulation**  
   - Create GitHub Actions workflow that runs schema checks or linting on notebooks.  
   - Store artifacts (exported notebooks, dashboards) in GitHub for reproducibility.  
   - **Document manual promotion steps in Free Edition instead of automated CD.**  
4. **Documentation**  
   - Write README section:  
     - "Databricks Enterprise vs Free Edition deployment"  
     - "Fabric deployment steps in Free Edition (manual)"  
     - Screenshots of Fabric pipeline promotions.  

**Databricks Free Edition Limitations (explicit)**  

**User Stories (breakdown)**  
- As a team, we simulate CI for checks and execute manual CD with documented steps.  
- As stakeholders, we can trace artifacts and promotions across environments.  

### Sprint day plan (4.5 days)
- **Day 1:** Structure repo/artifacts; define CI checks (lint notebooks, schema checks, docs build); decide version tags.  
- **Day 2:** Produce/export artifacts (notebooks, PBIX, configs); tag versions; include manifests and changelogs.  
- **Day 3:** Set up Fabric pipeline (Dev); perform manual deployment steps; configure rules/parameters.  
- **Day 4:** Promote to Test; validate RLS, data bindings, and KPIs; capture issues.  
- **Day 4.5:** Capture screenshots and finalize documentation (what's automated vs manual).
- No Jobs API → cannot schedule or trigger pipelines automatically.  
- No Unity Catalog → no centralized governance or lineage.  
- Limited compute → must work on small datasets.  
- Manual export/import only → users must download Parquet from DBFS and upload into Fabric.  
- GitHub Actions usable for **static checks only** (no direct deployment).  


---

## Acronyms

| Acronym | Meaning |
|---|---|
| ADLS | Azure Data Lake Storage |
| AOV | Average Order Value |
| API | Application Programming Interface |
| AUC | Area Under the ROC Curve |
| BG/NBD | Beta Geometric / Negative Binomial Distribution |
| CE | Community Edition (Databricks) |
| CI/CD | Continuous Integration / Continuous Delivery |
| CLV | Customer Lifetime Value |
| CR | Conversion Rate |
| CSV | Comma-Separated Values |
| DA | Data Analyst |
| DQ | Data Quality |
| DBFS | Databricks File System |
| DE | Data Engineer |
| Dev/Test/Prod | Development / Test / Production |
| DLT | Delta Live Tables |
| DS | Data Scientist |
| ECB | European Central Bank |
| EDA | Exploratory Data Analysis |
| ETL | Extract, Transform, Load |
| FX | Foreign Exchange |
| GMV | Gross Merchandise Value |
| KPI | Key Performance Indicator |
| LSTM | Long Short-Term Memory |
| NN | Neural Network |
| PBIX | Power BI Desktop report file format |
| PII | Personally Identifiable Information |
| RBAC | Role-Based Access Control |
| RFM | Recency, Frequency, Monetary value |
| RLS | Row-Level Security |
| RMSE | Root Mean Squared Error |
| RPV | Revenue Per Visitor |
| SCD2 | Slowly Changing Dimension Type 2 |
| SLA | Service Level Agreement |
| SQL | Structured Query Language |
| UC | Unity Catalog |

---

## Educational note (BeCode Data Analytics & AI Bootcamp)

This Product Backlog is provided solely for educational purposes as part of the BeCode Data Analytics & AI Bootcamp. Names, datasets, and scenarios are illustrative for training only and are not production guidance.



