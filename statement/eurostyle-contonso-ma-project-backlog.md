# EuroStyle–Contoso M&A – Product Backlog (Databricks & Fabric)

## Table of Contents

- [Sprint Planning Matrix](#sprint-planning-matrix-45-days-per-sprint)
- [Epic-to-Sprint and Role Mapping](#epic-to-sprint-and-role-mapping)
- [Feature-to-Sprint and Role Mapping](#feature-to-sprint-and-role-mapping)
- [Databricks ↔ Microsoft Fabric — Interoperability](#databricks--microsoft-fabric--interoperability-by-edition-free-trialpremium-enterprise)
- Epics
  - [Epic 1 – Data Foundation Platform](#epic-1)
  - [Epic 2 – Machine Learning & Predictive Analytics](#epic-2)
  - [Epic 3 – Analytics & Business Intelligence](#epic-3)
  - [Epic 4 – Platform Integration (Databricks ↔ Fabric)](#epic-4)
  - [Epic 5 – Optional Extensions](#epic-5)
- Features
  - Epic 1: [Feature 1.1](#feature-1-1), [Feature 1.2](#feature-1-2), [Feature 1.3](#feature-1-3)
  - Governance: [Feature G.1](#feature-g-1)
  - Epic 2: [Feature 2.1](#feature-2-1), [Feature 2.2](#feature-2-2), [Feature 2.3](#feature-2-3), [Feature 2.4](#feature-2-4)
  - Epic 3: [Feature 3.1](#feature-3-1), [Feature 3.2](#feature-3-2), [Feature 3.3](#feature-3-3), [Feature 3.4](#feature-3-4)
  - Epic 4: [Feature 4.1](#feature-4-1), [Feature 4.2](#feature-4-2), [Feature 4.3](#feature-4-3)
  - Epic 5: [Feature 5.1](#feature-5-1), [Feature 5.2](#feature-5-2), [Feature 5.3](#feature-5-3), [Feature 5.4](#feature-5-4)


## Certifications — where to study and how this backlog maps

Role-based study guides are available:
- Data Engineer: `certification/data-engineer-certifications.md`
- Data Scientist: `certification/data-scientist-certifications.md` (also available as `ml-ai-engineer-certifications.md`)
- Data Business Analyst (preferred): `certification/data-business-analyst-certifications.md` (alias: `certification/analyst-bi-certifications.md`)

A certification‑compliant use case that maps backlog tasks to exam‑aligned competencies is here:
- `statement/eurostyle-contonso-ma-certification-compliant.md`

---

## Databricks ↔ Microsoft Fabric — Interoperability by Edition (Free, Trial/Premium, Enterprise)

This project was prototyped during class on free/trial tiers. Below is a clear, explicit guide to how data moves between Databricks and Microsoft Fabric in three cases, what governance (including Microsoft Purview) is possible, and how a prototype differs from production.

Definitions (naming clarity)
- Databricks Free Edition (formerly Community Edition): always-free classroom sandbox, outside your Azure tenant. No Unity Catalog; no enterprise identity; no VNet/Private Link.
- Azure Databricks Trial/Premium: time-limited trial or paid workspace in your tenant, with enterprise identity, Unity Catalog (Premium/Enterprise), Jobs/Workflows, etc.
- Microsoft Fabric
   - Fabric Free (F2) / Tenant Trial: small/time-limited capacity for learning/evaluation.
   - Fabric Capacity (F-SKUs/Premium): paid capacity for governed, production BI & data apps.

### Interop scenarios (choose the one that matches your environment)

#### Case A — Databricks Free Edition (classroom sandbox)
- How data moves: Export Parquet (+ optional manifest) from Databricks Free → manually upload into Fabric Lakehouse /Files.
- Why: Free Edition is outside your tenant and cannot authenticate to ADLS Gen2 / OneLake.
- Use when: Teaching, quick demos, offline practice.

#### Case B — Azure Databricks Trial/Premium (direct interop in your tenant)
- Path B1 — No-copy shortcut: Databricks writes Delta/Parquet to ADLS Gen2 → in Fabric, create a OneLake Shortcut to that ADLS path so data appears in the Lakehouse without moving it.
- Path B2 — Direct OneLake: From Azure Databricks, read/write directly to OneLake via its ADLS Gen2-compatible endpoint (service principal or Entra ID; Premium/Enterprise recommended).
- Use when: Integrated prototypes/pilots with minimal manual steps.

#### Case C — Enterprise (governed, automated pipelines)
- How data moves: Use Fabric Data Pipelines (or ADF/Synapse pipelines) to orchestrate Databricks ↔ Fabric with private networking, retries, monitoring, alerts, and approvals.
- Combine with: OneLake Shortcuts and/or Direct OneLake writes.
- Use when: Production reliability, cost control, lineage, CI/CD, SLAs are required.

### Purview governance — what's supported per case

#### Case A (Databricks Free Edition)
- Databricks Free: Not governable by Purview (not in your tenant).
- Fabric Lakehouse: If Purview is enabled in your tenant, you can register/scan Lakehouses (including Shortcut databases), apply sensitivity labels, and run data quality (DQ) on Fabric assets.

#### Case B (Azure Databricks Trial/Premium)
- ADLS Gen2: Register & scan in Purview (metadata, classification, lineage).
- Unity Catalog (Databricks): Register in Purview for discovery & lineage.
- Fabric (OneLake/Lakehouse/Shortcuts): Discover & govern; run DQ on Lakehouse tables and Shortcut databases.

#### Case C (Enterprise)
- Everything in Case B plus operational governance: labels/policies, monitored pipelines, private networking, CI/CD, environment promotion, audits.

### Comparison matrix (by case)

Aspect | Case A — Databricks Free Edition | Case B — Azure Databricks Trial/Premium | Case C — Enterprise (governed pipelines)
---|---|---|---
Workspace & Compute | Free Edition; single small cluster; session timeouts | Azure Databricks Premium/Enterprise; autoscaling; Jobs/Workflows | Same as B, with runbooks and SRE practices
Storage/Lakehouse | Local workspace storage; manual Parquet exports | ADLS Gen2 external locations (Unity Catalog) and/or direct OneLake | ADLS Gen2 + OneLake under governed namespaces; lifecycle policies
Governance/Catalog | No Unity Catalog; no Purview on DBX Free | Unity Catalog + Purview over ADLS/UC/Fabric | UC + Fabric governance + Purview end-to-end (incl. Power BI lineage)
Scheduling/Orchestration | No Jobs API/DLT; manual notebook runs | Databricks Jobs/Workflows; optional DLT | Fabric Data Pipelines / ADF; monitored with alerts/retries/approvals
ML lifecycle | MLflow tracking local to runs | MLflow Tracking + Model Registry; batch/real-time serving | Same as B, plus promotion gates, canary, SLIs/SLOs
Data movement Databricks ↔ Fabric | Manual: download from DBX → upload to Lakehouse /Files | B1: ADLS Gen2 → OneLake Shortcut (no-copy) * B2: Direct OneLake read/write from DBX | Pipelines orchestrate moves and/or register Shortcuts; optional CDC/partitioning; private networking
Fabric capacity & BI | Fabric Free/Trial; limited capacity/duration | Optional Fabric Capacity; Direct Lake/DirectQuery at pilot scale | Fabric Capacity (F-SKUs/Premium); Deployment Pipelines; RLS at scale; ALM/lineage
Security & Networking | Basic ACLs only; no Private Link/VNET | Entra ID/service principals; Key Vault; VNET/Private Link where applicable | Same as B, plus private endpoints, RBAC reviews, secrets rotation, audit
CI/CD | Documented manual steps | GitHub Actions/Azure DevOps; Databricks Repos; Fabric Deployment Pipelines | Full CI/CD across DBX + Fabric with approvals and environment parity
SLA & Scale | No SLA; small volumes; throttling risk | Higher scale; performance features available | Enterprise SLAs; horizontal scaling; capacity management & observability
Cost | $0 (class use) | Metered DBUs; optional Fabric Capacity | Metered DBUs + Fabric Capacity; enterprise licensing

Practical implications in this repo
- "Manual transfer (Free)" = Case A: export Parquet from Databricks Free (or Trial without storage auth) and upload into Fabric Lakehouse /Files.
- "Shortcut / no-copy" = Case B1 or C: Databricks writes to ADLS Gen2; Fabric uses a OneLake Shortcut to that path.
- "Direct OneLake" = Case B2 or C: Azure Databricks reads/writes via the ADLS Gen2–compatible OneLake endpoint with enterprise auth.
- "No Jobs/DLT (Free)" = Case A limitations; in Case B/C, use Jobs/Workflows, DLT, and/or Fabric Data Pipelines for scheduled, monitored runs.

---

 

## Sprint Planning Matrix (4.5 days per sprint)

This matrix summarizes the focus and concrete deliverables of each role — **Data Engineer (DE)**, **Data Scientist (DS)**, and **Data Business Analyst (DA)** — across all sprints.  
It provides a clear mapping of **who delivers what, and when**, ensuring no role is idle.

| Sprint | Data Engineer (DE) | Data Scientist (DS) | Data Business Analyst (DA) |
|--------|---------------------|---------------------|-------------------|
| **0 (0.5d)** | 🟥 Set up Databricks workspace and folder structure; define ingestion paths for EuroStyle & Contoso | 🟥 Define hypotheses for churn (inactivity >90 days) and Customer Lifetime Value (CLV); identify required features | 🟩 🟨 Define initial KPI Catalog v0.1 (GMV, AOV, margin, churn rate); map differences EuroStyle vs Contoso |
| **1 (4.5d)** | 🟥 Ingest EuroStyle & Contoso raw CSVs into Bronze Delta tables; add metadata (`ingest_ts`, `source_system`); kick off 🟦 Governance G.1 (Purview + UC setup: SQL Warehouse HTTP Path, system tables, credential) | 🟥 Perform **Exploratory Data Analysis (EDA)** on Bronze (Contoso first): distributions, missing values, brand overlap; draft churn & CLV definitions | 🟩 🟨 Build "First Look Dashboard" (Contoso first) with Bronze KPIs: **GMV (Gross Merchandise Value)**, **AOV (Average Order Value)**, order counts |
| **2 (4.5d)** | 🟥 Transform Bronze → Silver: deduplication, schema harmonization, standardize currencies, align product hierarchies; continue 🟦 Governance G.1 (run first Purview scan, verify lineage, capture evidence) | 🟥 Engineer features: **RFM (Recency, Frequency, Monetary value)**, basket diversity, cross-brand overlap; track feature sets in MLflow | 🟩 🟨 Redesign dashboards on Silver; compare Raw vs Silver KPIs; implement first **Row-Level Security (RLS)** rules |
| **3 (4.5d)** | 🟥 Build Gold marts: `sales_daily` (sales, GMV, AOV, margin), `category_perf`, `customer_360` with RFM base | 🟥 Train baseline models: Logistic Regression (churn), Random Forest (CLV regression); log experiments in MLflow | 🟩 🟨 Deliver **Executive Dashboard**: consolidated KPIs (GMV, AOV, margin), brand comparisons, North vs South splits |
| **4 (4.5d)** | 🟥→🟩 Export Gold marts to Fabric Lakehouse (Parquet + manifest, or Shortcuts); orchestrate ingestion with Fabric Data Pipelines | 🟥→🟩 Run batch scoring for churn & CLV; join scored tables into Gold `customer_360`; export to Fabric and validate metrics/skew | 🟩 🟨 Build full **Power BI Post-Merger Suite**: Executive + Customer Segmentation dashboards (with churn & CLV); deploy with Fabric pipelines |

Legend: 🟥 Databricks, 🟩 Fabric, 🟨 Power BI, 🟦 Governance, 🟥→🟩 Integration (handoff Databricks → Fabric)


---

## Epic-to-Sprint and Role Mapping

This table lists all epics, distributed by sprint and by profile (DE, DS, DA). It complements the Sprint Planning Matrix and provides a high-level view; ownership remains at the user story level within each epic.

| Sprint | DE (Data Engineer) | DS (Data Scientist) | DA (Data Business Analyst) |
|---|---|---|---|
| 0 | 🟥 [Epic 1 – Data Foundation Platform](#epic-1) (setup: workspace, folders, ingest paths) | 🟥 [Epic 2 – ML & Predictive](#epic-2) (hypotheses/requirements, MLflow init) | 🟩 🟨 [Epic 3 – Analytics & BI](#epic-3) (KPI Catalog v0.1, semantic draft) |
| 1 | 🟥 [Epic 1 – Data Foundation Platform](#epic-1) (Bronze: ES+Contoso, metadata, DirectQuery) + 🟦 Governance [G.1](#feature-g-1) (Purview + UC setup) | 🟥 [Epic 2 – ML & Predictive](#epic-2) (EDA: prevalence, drift, baselines) | 🟩 🟨 [Epic 3 – Analytics & BI](#epic-3) (First Look – Contoso: semantic model, measures, v1 report, KPI v0.2) |
| 2 | 🟥 [Epic 1 – Data Foundation Platform](#epic-1) (Silver: dedup, FX→EUR, IDs, schema contract) + 🟦 Governance [G.1](#feature-g-1) (scan + lineage + evidence) | 🟥 [Epic 2 – ML & Predictive](#epic-2) (Features: RFM, basket, versioning, leakage checks) | 🟩 🟨 [Epic 3 – Analytics & BI](#epic-3) (Raw vs Silver: deltas, toggles, RLS v1, DQ impacts) |
| 3 | 🟥 [Epic 1 – Data Foundation Platform](#epic-1) (Gold marts: sales_daily, category_perf, customer_360) | 🟥 [Epic 2 – ML & Predictive](#epic-2) (Model training: churn LR, CLV RF, calibration/CI) | 🟩 🟨 [Epic 3 – Analytics & BI](#epic-3) (Executive: consolidated KPIs, brand/region, RLS) |
| 4 | 🟥→🟩 [Epic 4 – Platform Integration](#epic-4) (Fabric export: Parquet+manifest, pipeline ingest) | 🟥→🟩 [Epic 2 – ML](#epic-2) (Batch scoring, join to Gold, explainability) + [Epic 4](#epic-4) (Export/validation) | 🟩 🟨 [Epic 3 – Analytics](#epic-3) (Segmentation) + [Epic 4](#epic-4) (Power BI Suite, pipeline promotion) |
| 5 (optional) | 🟥 [Epic 5 – Optional Extensions](#epic-5) (Data Vault light; E2E deployment sim) | 🟥 [Epic 5 – Optional Extensions](#epic-5) (Survival = time‑to‑churn; probabilistic repeat‑purchase model (Beta‑Geometric (BG)/Negative Binomial Distribution (NBD)) to estimate Customer Lifetime Value (CLV); export scores to Fabric and run validation checks (QA)) | 🟩 🟨 [Epic 5 – Optional Extensions](#epic-5) (Dynamic dashboards: what‑if/drill; deployment pipeline) |

Legend: 🟥 Databricks, 🟩 Fabric, 🟨 Power BI, 🟦 Governance, 🟥→🟩 Integration (handoff Databricks → Fabric)

Notes
- Optional extensions (Epic 5.x) are scheduled under Sprint 5 (optional) based on team capacity.
- For detailed deliverables, see the Features map below and the User Stories within each epic.


## Feature-to-Sprint and Role Mapping

This table lists all features, distributed by sprint and by profile (DE, DS, DA). Ownership is ultimately at the user story level; this is the primary owner per feature.

| Sprint | DE (Data Engineer) | DS (Data Scientist) | DA (Data Business Analyst) |
|---|---|---|---|
| 0 | — | — | — |
| 1 | 🟥 [1.1 Raw Data Ingestion](#feature-1-1) (Bronze Delta with ingest_ts/source_system; DQ summary; schema dictionary; runbook); 🟦 [G.1 Governance — Purview + UC Scanning](#feature-g-1) (UC/system tables, credential, source registration) | 🟥 [2.1 EDA, baselines & MLflow setup](#feature-2-1) (EDA readout; baselines; leakage/risk log; MLflow init) | 🟩 🟨 [3.1 First Look – Contoso](#feature-3-1) (semantic model; named measures; v1 report) |
| 2 | 🟥 [1.2 Silver Cleaning & Harmonization](#feature-1-2) (idempotent writes; Silver schema contract; FX normalization with ECB snapshot; DQ before/after); 🟦 [G.1 Governance — Purview + UC Scanning](#feature-g-1) (run scan, verify lineage, evidence) | 🟥 [2.1 EDA summary & risk log](#feature-2-1); 🟥 [2.2 Feature Engineering](#feature-2-2) (RFM; basket/cross‑brand; versioned feature tables; leakage checks; consumption contract) | 🟩 🟨 [3.2 Raw vs Silver – Contoso + EuroStyle](#feature-3-2) (side‑by‑side KPIs; delta measures; RLS draft; bookmarks/toggles) |
| 3 | 🟥 [1.3 Gold Business Marts](#feature-1-3) (sales_daily; customer_360; category_perf; margin proxy/notes) | 🟥 [2.3 Model Training](#feature-2-3) (LR churn; RF CLV; calibration/CIs; segment evaluation; registry notes) | 🟩 🟨 [3.3 Executive Post‑Merger Dashboard](#feature-3-3) (GMV/AOV/margin; brand & region splits; RLS configured; perf tuned) |
| 4 | 🟥→🟩 [4.1 Export Gold to Fabric](#feature-4-1) (Parquet + manifest/Shortcuts; Fabric Pipeline ingest; connectivity validated) | 🟥→🟩 [2.4 Batch Scoring & Integration](#feature-2-4), 🟥→🟩 [4.3 Scoring Export & Validation](#feature-4-3) (batch scoring churn/CLV; join to customer_360; export to Fabric; validate metrics/skew) | 🟩 🟨 [3.4 Customer Segmentation](#feature-3-4), 🟩 🟨 [4.2 Power BI Suite](#feature-4-2) (Executive + Segmentation dashboards; RLS; pipeline Dev→Test; publish suite) |
| 5 (optional) | 🟥 [5.1 Simplified Data Vault](#feature-5-1); 🟥→🟩 [5.4 Orchestration & E2E Deployment](#feature-5-4) (Airflow DAG + Fabric fallback; manifests/_SUCCESS; QA & notifications) | 🟥 [5.3 Survival/Probabilistic Models](#feature-5-3); 🟥→🟩 [5.4 Orchestration & E2E Deployment](#feature-5-4) (batch scoring export → Fabric ingest; alignment QA) | 🟩 🟨 [5.2 Advanced Segmentation](#feature-5-2); 🟩 🟨 [5.4 Orchestration & E2E Deployment](#feature-5-4) (promotion via Fabric pipelines/app; RLS/share checks) |

Legend: 🟥 Databricks, 🟩 Fabric, 🟨 Power BI, 🟦 Governance, 🟥→🟩 Integration (handoff Databricks → Fabric)

Notes
- Optional extensions (5.x) are grouped in Sprint 5 (optional): 5.1 (DE), 5.2 (DA), 5.3 (DS), and 5.4 (All, cross‑role).
- For exact division of work, see the User Stories within each feature.


## Backlog Structure
This backlog follows Agile methodology with hierarchical organization:
- **Epics**: Major business capabilities 
- **Features**: Functional components within epics
- **User Stories**: Specific user needs and outcomes
- **Tasks**: Technical implementation items

Conventions and shared non-functional requirements are centralized to avoid repetition. See Appendix C — Shared NFRs & Conventions.

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

- Databricks Free (formerly Community Edition) has no shared workspace → each engineer works in their own environment.
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





Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Engineer, I want to ingest EuroStyle and Contoso CSVs into Bronze so the teams can start analyzing real data.  

**Learning Resources**:  
- [Medallion Architecture](https://docs.databricks.com/aws/en/lakehouse/medallion)  
- [Delta Lake Basics](https://docs.databricks.com/en/delta/index.html)  
- [What is Delta Lake in Azure Databricks?](https://learn.microsoft.com/azure/databricks/delta/)
- [Apache Spark&trade; Tutorial: Getting Started with Apache Spark on Databricks](https://www.databricks.com/spark/getting-started-with-apache-spark/dataframes#visualize-the-dataframe)
- [PySpark DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)  
- [Tutorial: Build an ETL pipeline with Lakeflow Declarative Pipelines](https://learn.microsoft.com/azure/databricks/getting-started/data-pipeline-get-started)

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
 - Basic Data Quality (DQ) summary produced (missing values, duplicate rate on `(order_id, sku, customer_id, order_date)`, top countries/currencies). See Appendix A – DQ Thresholds & Tests.  
 - Mini schema dictionary and a short runbook (how to re-run ingestion, folder structure, naming conventions) added to repo.
 - Azure DevOps DQ tickets opened for any raw→Bronze variance >1% or material DQ issue; links captured in README and referenced by DA in Feature 3.2.

**Tasks**

1) 🟥 [DBX-DE-Assoc][Medallion][Platform]  
Create raw landing folders in DBFS (`/FileStore/retail/raw/contoso/`, `/FileStore/retail/raw/eurostyle/`) and document paths in the runbook.  

2) 🟥 [DBX-DE-Assoc][Medallion]  
Upload Contoso CSVs to the raw path; note file names, counts, and approximate sizes.  

3) 🟥 [DBX-DE-Assoc][Delta-Basics][Autoloader][CopyInto][Medallion]  
Ingest Contoso to Delta Bronze with lineage columns (`ingest_ts`, `source_system='CONTOSO'`) as `bronze.sales_contoso`.  

4) 🟥 [DBX-DA-Assoc][SQL-Basics][Dashboards]  
Create a BI-friendly Contoso view `bronze.v_sales_contoso` with trimmed/typed columns for Power BI DirectQuery.  

5) 🟥 [DBX-DE-Assoc][UC-Permissions]  
Register tables/views in the metastore (Unity Catalog or workspace) and add table comments.  

6) 🟥 [DBX-DE-Assoc][Delta-Basics]  
Validate Contoso types (dates/numerics), address corrupt records if any, and record issues.  

7) 🟨 [DBX-DA-Assoc][Dashboards][MS-PL300][Visualize]  
Perform a Power BI DirectQuery smoke test to `bronze.v_sales_contoso`; capture steps/screenshot in the README.  

8) 🟥 [DBX-DE-Assoc][Medallion]  
Upload EuroStyle CSVs to the raw path and capture source metadata (provenance, obtained date).  

9) 🟥 [DBX-DE-Assoc][Delta-Basics][Autoloader][CopyInto][Medallion]  
Ingest EuroStyle to Delta Bronze with lineage columns (`ingest_ts`, `source_system='EUROSTYLE'`) as `bronze.sales_eurostyle`.  

10) 🟥 [DBX-DE-Prof][Modeling]  
Create and check in `docs/column_mapping.csv` with `source_name, unified_name, target_type`.  

11) 🟥 [DBX-DE-Prof][Modeling]  
Apply initial schema alignment across brands using the mapping and naming conventions (snake_case, consistent date/decimal types); update the runbook.  

12) 🟥 [DBX-DE-Prof][Monitoring-Logs]  
Reconcile raw→Bronze row counts per brand (±1% tolerance or explained variance) and persist counts to `monitor.dq_bronze_daily`.  

13) 🟥 [DBX-DE-Prof][Monitoring-Logs]  
Compute a basic DQ summary: null rates on keys, duplicate rate on `(order_id, sku, customer_id, order_date)`, top countries/currencies; publish a one-pager.  

14) 🟥 [DBX-DE-Assoc][Delta-Basics]  
Enforce basic Delta constraints where feasible (NOT NULL on business keys, simple CHECKs); record violations.  

15) 🟥 [DBX-DE-Assoc][Delta-MERGE][Delta-Basics][Medallion]  
Implement an idempotent re-run strategy (deterministic overwrite by date window via `replaceWhere` or `MERGE` on business keys) and verify repeatability.  



**User Stories (breakdown)**  
- As a DA, I can connect to Contoso Bronze via DirectQuery on Day 1 to build the First Look.  
- As a DE, I ingest EuroStyle and Contoso to Bronze with lineage columns and parsable types.  
- As a DS, I receive a DQ summary on Bronze to kick off EDA.  
- As a DE, I publish a mini schema dictionary and runbook so the team can re‑run ingestion.

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 — Contoso live (covers Tasks 1–7): Create landing folders; upload Contoso; ingest to Bronze; create BI view; register; validate types; run Power BI DirectQuery smoke test.  
- Day 2 — EuroStyle ingestion (covers Tasks 8–10): Upload EuroStyle; ingest to Bronze; create `column_mapping.csv`.  
- Day 3 — Alignment & counts (covers Tasks 11–12): Apply initial schema alignment + naming conventions; update runbook; reconcile raw→Bronze counts and persist monitoring.  
- Day 4 — DQ & constraints (covers Tasks 13–14): Produce basic DQ summary; enforce Delta constraints and record violations.  
- Day 4.5 — Idempotence (covers Task 15): Implement and verify idempotent re‑run strategy; capture brief notes in the runbook.  

#### Mini notes — Feature 1.1 (how‑to)
- Ingest + DirectQuery
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
- Mapping + types
   - Keep a simple mapping CSV in `docs/column_mapping.csv` with `source_name, unified_name, target_type`.
   - Apply rename/cast (example in PySpark):
      ```python
      from pyspark.sql.functions import col
      mapping = {"InvoiceNo":"order_id","StockCode":"sku","CustomerID":"customer_id"}
      df = raw_df.select([col(c).alias(mapping.get(c,c)) for c in raw_df.columns])
      df = df.withColumn("order_date", col("order_date").cast("date")).withColumn("unit_price", col("unit_price").cast("decimal(18,2)"))
      ```
- Counts + DQ summary
   - Reconcile counts raw→bronze and persist a few metrics to `monitor.dq_bronze_daily` (row_count, null rates on keys, dup rate on BK, min/max date). Note any variance >1%.
- Idempotence + docs
   - Re‑run safely via `MERGE` on business keys or deterministic overwrite by date window (`replaceWhere`). Add NOT NULL/CHECK where useful. Commit `docs/bronze-schema-dictionary.md` and `docs/runbook-ingestion.md`.
- Pre‑aggregate view
   - Create/register a thin day view for DirectQuery performance and validate from Power BI.

---

<a id="feature-1-2"></a>
### Feature 1.2: Silver Cleaning & Harmonization (Sprint 2)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Engineer, I want Silver tables with clean, harmonized schemas so Analysts and Scientists can trust the data.  

**Learning Resources**:  
- [Schema Evolution in Delta](https://docs.databricks.com/delta/delta-batch.html#table-schema-evolution)  
- [Data Quality Management](https://www.databricks.com/discover/pages/data-quality-management)  
- [PySpark DataFrame API](https://api-docs.databricks.com/python/pyspark/latest/pyspark.sql/api/pyspark.sql.DataFrame.html)  
 - [Star schema guidance (natural/business vs surrogate keys)](https://learn.microsoft.com/power-bi/guidance/star-schema)  
 - [Delta Lake — overwrite specific partitions with replaceWhere](https://learn.microsoft.com/azure/databricks/delta/delta-batch#overwrite-specific-partitions-with-replacewhere)  
 - [Microsoft Purview — Connect Azure Databricks Unity Catalog](https://learn.microsoft.com/purview/register-scan-azure-databricks-unity-catalog)  
 - [Microsoft Purview — Classifications and sensitivity labels](https://learn.microsoft.com/en-us/purview/sensitivity-labels)  
 - [Microsoft Purview — Glossary and business terms](https://learn.microsoft.com/en-us/purview/purview-glossary)

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
 - DQ report updated (pre/post cleaning: duplicates removed %, nulls reduced %, FX normalization impact). See Appendix A – DQ Thresholds & Tests.  
 - FX snapshot table (`silver.fx_rates_eur`) versioned with valuation date and source metadata.
 - Azure DevOps DQ tickets opened/updated for any Raw→Silver residual issues discovered (e.g., orphan facts, missing FX rates); links added to README and referenced by DA in Feature 3.2.

**Tasks** 
1) 🟥 [DBX-DE-Prof][Modeling]  
Confirm target Silver table names and create empty schemas (or temp views) with expected columns and types for `sales_clean` and any dims (document in schema contract draft).  
2) 🟥 [DBX-DE-Prof][Modeling]  
Define and document business keys for deduplication (e.g., `order_id + sku + customer_id + order_date`); capture edge cases (null/invalid keys).  
3) 🟥 [DBX-DE-Assoc][Spark-Aggregations][Delta-Basics]  
Profile duplicate rates per brand; implement windowed dedup keeping latest by `ingest_ts`; persist intermediate results for audit.  
4) 🟥 [DBX-DE-Assoc][Delta-Basics]  
Normalize critical types across brands (dates to DATE, money to DECIMAL(18,2)); trim/uppercase IDs; standardize country/currency codes.  
5) 🟥 [DBX-DE-Prof][Modeling]  
Build and persist `silver.fx_rates_eur` snapshot with valuation date and source metadata (ECB suggested); validate coverage for encountered currencies.  
6) 🟥 [DBX-DE-Assoc][Spark-Aggregations][Delta-Basics]  
Convert all monetary amounts to EUR by joining FX "as‑of" valuation date; implement rounding policy (HALF_UP) and document precision.  
7) 🟥 [DBX-DE-Prof][Modeling]  
Create product and customer crosswalk CSVs in `docs` and register Delta mapping tables; specify collision handling rules.  
8) 🟥 [DBX-DE-Prof][Modeling]  
Normalize customer IDs across EuroStyle & Contoso using the crosswalk; resolve duplicates/collisions and record decisions.  
9) 🟥 [DBX-DE-Prof][Modeling]  
Align product hierarchy (category/brand) via mapping; backfill missing categories where possible; flag unresolved.  
10) 🟥 [DBX-DE-Prof][Modeling]  
Enforce referential checks (orphans) using anti‑joins; fix or quarantine with reason codes and counts.  
11) 🟥 [DBX-DE-Assoc][Delta-MERGE][Delta-Basics]  
Implement idempotent write strategy: `MERGE` on BKs or deterministic `replaceWhere` by date window; prove re‑run yields same end state.  
12) 🟥 [DBX-DE-Assoc][Delta-Basics]  
Add Delta constraints where feasible (NOT NULL on BKs, simple CHECK constraints); evaluate impact and violations.  
13) 🟥 [DBX-DE-Assoc][Platform][DBX-DE-Prof][Modeling]  
Partitioning/optimization: choose partition columns (e.g., `order_date`); consider OPTIMIZE/Z‑ORDER for common predicates; document choices.  
14) 🟥 [DBX-DE-Prof][Modeling]  
Publish the Silver schema contract (names, types, nullability) and mapping rules; include FX rounding/fallback policies.  
15) 🟥 [DBX-DE-Prof][Monitoring-Logs]  
Produce a DQ report (pre/post metrics: duplicate reduction %, nulls reduced %, FX conversion coverage, orphan counts); attach queries.  
16) 🟦 [Governance]  
Register Silver catalog/schema in Purview (UC connector), run scan, apply classifications for PII, and verify lineage from example notebook run.

**User Stories (breakdown)**  
- As a DE, I deliver Silver sales with duplicates removed and currencies normalized to EUR.  
- As a DE, I publish a Silver schema contract so DA/DS consume with confidence.  
- As a DE, I persist a versioned `fx_rates_eur` snapshot with a fixed valuation date.  
- As a DE, I ensure idempotent Silver writes so re‑runs are safe and deterministic.

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- **Day 1 — BKs, Dedup, Types (covers Tasks 1–4, 12 init):** Define BKs and dedup strategy; profile duplicates; create Silver schema skeletons; normalize core types; draft initial Delta constraints.
   - Outcome: documented BKs; first dedup pass per brand; type normalization applied; constraints plan drafted.

- **Day 2 — FX Snapshot & Conversion (covers Tasks 5–6):** Build `silver.fx_rates_eur` with valuation date/source; implement EUR conversion with rounding policy; measure FX coverage and note fallback rules.
   - Outcome: complete FX table; amounts in EUR; rounding/precision policy documented; FX coverage metrics captured.

- **Day 3 — Crosswalks & Referential Integrity (covers Tasks 7–10):** Create/register crosswalks; normalize customer IDs; align product hierarchy; run orphan checks and fix/quarantine; update mapping CSVs.
   - Outcome: unified customers/products; orphan issues addressed with counts and rationale.

- **Day 4 — Idempotence, Performance, Contract (covers Tasks 11–14):** Implement and validate idempotent writes; set partitioning and optional OPTIMIZE/Z‑ORDER; publish the Silver schema contract and mapping rules.
   - Outcome: deterministic re‑runs; documented performance choices; published schema contract.

- **Day 4.5 — DQ Readout (covers Task 15):** Produce the DQ report with pre/post metrics (duplicates, nulls, FX coverage, orphans); attach queries and store evidence.
   - Outcome: DQ evidence pack complete and ready for review.

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
    - See Appendix C — Shared NFRs & Conventions for typing and monetary precision; apply those here.
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

- Governance (Purview):
  - After initial Silver loads, trigger a Purview UC scan on the workspace URL + SQL Warehouse HTTP Path.
  - Store the Databricks PAT (or use Managed Identity/Service Principal) in Key Vault and grant Purview read of the secret.
  - Apply classifications (e.g., Email, Phone) and associate glossary terms to key Silver tables; capture a lineage screenshot for evidence.
      
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
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Engineer, I want Gold marts for sales and customers so the business gets reliable KPIs.  

**Learning Resources**:  
- [Star Schema Design](https://www.databricks.com/glossary/star-schema)  
- [Data mart](https://www.databricks.com/glossary/data-mart)
 - [Performance Optimization in Delta](https://learn.microsoft.com/en-us/azure/databricks/delta/best-practices)  
- [Recency, Frequency, Monetary (RFM) Segmentation](https://www.databricks.com/solutions/accelerators/rfm-segmentation)  
- [Retail Personalization with RFM Segmentation and the Composable CDP](https://www.databricks.com/blog/retail-personalization-rfm-segmentation-and-composable-cdp)
- [RFM Segmentation, Databricks Solution Accelerators](https://github.com/databricks-industry-solutions/rfm-segmentation)
- [What is a data mart? (Microsoft Learn)](https://learn.microsoft.com/azure/architecture/data-guide/relational-data/data-warehousing#data-marts)  
- [Datamarts overview (Power BI)](https://learn.microsoft.com/power-bi/transform-model/datamarts/datamarts-overview)  
- [Gross Merchandise Value (GMV): Meaning & Calculation](https://www.yieldify.com/blog/gross-merchandise-value-gmv)
- [Understanding GMV in ecommerce](https://getrecharge.com/blog/understanding-gmv-in-ecommerce/)
- [AOV vs CR vs RPV vs GMV in Ecommerce: Important Metrics You Should Know](https://www.mida.so/blog/important-ecommerce-metrics-aov-cr-rpv-gmv)
 - [Microsoft Purview — Connect Azure Databricks Unity Catalog](https://learn.microsoft.com/purview/register-scan-azure-databricks-unity-catalog) 
 - [Microsoft Purview — Data Quality for UC](https://learn.microsoft.com/purview/unified-catalog-data-quality-azure-databricks-unity-catalog)

**Key Concepts**:  
- Gold = business-ready, aggregated, and optimized marts (subject‑oriented curated datasets optimized for analytics).  
- Sales mart (subject‑oriented curated dataset) for financial KPIs (GMV, AOV, margin).  
- Category mart (subject‑oriented curated dataset) for product/category analysis.  
- Customer 360° mart (subject‑oriented curated dataset) enriched with RFM (Recency, Frequency, Monetary).  
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


**Tasks**

1) 🟥 [DBX-DE-Prof][Modeling]  
Define star schema contracts: fact grains, conformed dims, keys (surrogate vs natural), naming and formats (snake_case, DECIMAL scales).  

2) 🟥 [DBX-DE-Prof][Modeling][DBX-DE-Assoc][Delta-Basics]  
Create `gold.date_dim` and populate from Silver order_date window; add `date_key` (yyyymmdd), year/month/day.  

3) 🟥 [DBX-DE-Prof][Modeling][DBX-DE-Assoc][Delta-Basics]  
Create `gold.product_dim` with surrogate key (IDENTITY or hashed BK); populate attributes (product_code, category, brand).  

4) 🟥 [DBX-DE-Prof][Modeling][DBX-DE-Assoc][Delta-Basics]  
Create `gold.customer_dim` with surrogate key and unified customer identifier; include `source_system` where relevant.  

5) 🟥 [DBX-DE-Prof][Modeling][DBX-DE-Assoc][Spark-Aggregations][Delta-Basics]  
Specify the `gold.sales_daily` schema (keys/measures) and write the first load query (GMV, Orders, Units, Estimated Margin proxy).  

6) 🟥 [DBX-DE-Assoc][Spark-Aggregations][Delta-Basics]  
Implement `gold.sales_daily` load handling returns (negative qty → returns) and label margin as proxy when COGS absent.  

7) 🟥 [DBX-DE-Assoc][Delta-Basics]  
Add Delta constraints/checks to `gold.sales_daily` (NOT NULL on keys, non-negative checks on units/revenue).  

8) 🟥 [DBX-DE-Prof][Modeling][DBX-DE-Assoc][Spark-Aggregations]  
Define and build `gold.category_perf` (aggregations by product/category/brand/date; include GMV, Units, Orders).  

9) 🟥 [DBX-DE-Prof][Modeling][DBX-DE-Assoc][Spark-Aggregations]  
Define `gold.customer_360` base schema (one row per customer) and populate core aggregates (orders, units, GMV).  

10) 🟥 [DBX-DE-Assoc][Spark-Aggregations][DBX-DE-Prof][Modeling]  
Compute and attach RFM metrics to `gold.customer_360` (Recency, Frequency, Monetary) and optional RFM segment/bucket; carry `source_system`.  

11) 🟥 [DBX-DE-Assoc][Delta-MERGE][Delta-Basics]  
Make loads idempotent: choose MERGE or deterministic INSERT OVERWRITE by date/snapshot for each mart; validate repeatability.  

12) 🟥 [DBX-DE-Assoc][Platform]  
Partitioning/optimization: choose partitioning (e.g., by date), coalesce/compact files, and note file size targets.  

13) 🟥 [DBX-DE-Prof][Testing]  
Validate vs Silver: reconcile counts/KPIs, run orphan/RI checks, and execute smoke queries with DA/DS; capture results.  

14) 🟥 [DBX-DE-Prof][Modeling]  
Document schemas and assumptions: contracts for all marts, margin proxy method, and any caveats; update README.  

15) 🟥 [DBX-DE-Assoc][UC-Permissions]  
Register helper views (e.g., top-level selects), set table comments/permissions, and finalize hand-off notes.  

16) 🟦 [Governance] 
After first Gold load, run a Purview UC scan and validate assets and lineage for `gold.sales_daily`; attach evidence.




**User Stories (breakdown)**  
- As a DE, I deliver `sales_daily` with GMV/AOV/margin (proxy if needed).  
- As a DE, I publish `category_perf` and `customer_360` (with RFM base and source flags).  
- As a DA/DS, I can query Gold marts with documented schema and consistent keys.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- **Day 1 [Tasks 1–4]:** Define star schemas and contracts; decide keys; implement and populate `date_dim`, `product_dim`, and `customer_dim`.  
- **Day 2 [Tasks 5–7, 11 (init)]:** Build `sales_daily` (GMV/AOV/margin proxy), handle returns; add Delta constraints; start idempotent load pattern.  
- **Day 3 [Tasks 8–10]:** Build `category_perf` and `customer_360`; compute and attach RFM metrics; ensure one‑row‑per‑customer.  
- **Day 4 [Tasks 11 (final), 12–13]:** Finalize idempotent strategies; set partitioning/coalesce; validate vs Silver and run smoke queries with DA/DS.  
- **Day 4.5 [Tasks 14–15]:** Document schemas/assumptions (margin proxy); register helper views, set comments/permissions, and complete hand‑off.  

#### Mini examples — Star schema and `sales_daily` (start)

Define the star schema (concise)
- Grain: one row per day × product (optionally carry `source_system` for splits).
- Conformed dims: `gold.date_dim`, `gold.product_dim`, `gold.customer_dim` with stable business attributes.
- Keys: use surrogate keys on dims (IDENTITY for product/customer; `date_key` as `yyyymmdd` int). Facts store SKs.
- See Appendix C — Shared NFRs & Conventions for naming, keying, and typing conventions.

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
## Epic 2 – Machine Learning & Predictive Analytics
**Goal**: Develop churn and Customer Lifetime Value (CLV) models using merged Customer 360.

---

<a id="feature-2-1"></a>
### Feature 2.1: Exploratory Analysis (Sprint 1–2)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Scientist, I want to perform **Exploratory Data Analysis (EDA)** to understand customer behavior and overlaps.  

**Learning Resources**:  
- [EDA in Databricks](https://docs.databricks.com/exploratory-data-analysis/index.html)  
- [MLflow Tracking](https://mlflow.org/docs/latest/tracking.html)  
- [Churn Prediction Basics](https://www.databricks.com/solutions/accelerators/predict-customer-churn)  
 - [ydata-profiling (pandas-profiling) for quick profiling](https://ydata-profiling.ydata.ai/docs/master/index.html)  
 - [Great Expectations for Data quality use cases](https://docs.greatexpectations.io/docs/reference/learn/data_quality_use_cases/dq_use_cases_lp/)  
 - [Evidently AI for drift and data quality reports](https://docs.evidentlyai.com/)  
 - [Imbalanced-learn: handling class imbalance](https://imbalanced-learn.org/stable/user_guide.html)  
 - [Time-based and grouped CV (scikit-learn)](https://scikit-learn.org/stable/modules/cross_validation.html#cross-validation-iterators)  
 - [Delta Lake time travel for reproducibility](https://docs.delta.io/latest/delta-utility.html#time-travel)  
 
 - [Microsoft Purview — Connect Azure Databricks Unity Catalog](https://docs.delta.io/latest/delta-utility.html#time-travel)

**Key Concepts**:  
- **EDA (Exploratory Data Analysis)** = profiling data to find patterns, missing values, distributions.  
- Churn definition = customers inactive for more than 90 days.  
- **CLV (Customer Lifetime Value)** = net margin expected per customer over a defined horizon (e.g., 12 months).  
 - Dataset sequence: analyze Contoso first in Sprint 1 to establish baselines; integrate EuroStyle in Sprint 2 to study overlaps and brand differences.  
 - Bronze/Silver/Gold: start with Bronze (raw-ish), capture issues to inform Silver cleaning and Gold analytics.  
 - Leakage: any feature that uses future information relative to the label cutoff; avoid by fixing a global cutoff date and deriving features up to T-Δ.  
 - Non‑leaky splits: prefer time-based splits or GroupKFold by customer_id to prevent cross-contamination across train/validation/test.  

**Acceptance Criteria**:  
- Missing values, outliers, and overlaps documented.  
- Clear churn definition (>90 days inactivity).  
- Draft **CLV** formula validated with business stakeholders.  
 - EDA profiling summary produced (notebook and 1–2 page readout) with top data-quality issues and EuroStyle vs Contoso overlaps.  
 - Data risk log created (PII handling, potential label leakage, notable gaps) and shared with team.  
 - Baseline yardsticks defined: simple rule-based churn heuristic and RFM segmentation for comparison.  
 - Experiment scaffolding ready: MLflow experiment initialized; evaluation protocol (splits/CV, metrics: AUC for churn, RMSE for CLV) documented in repo.  
 - Sanity checks: churn prevalence computed; class balance assessed; non‑leaky split strategy chosen (time‑based or customer‑grouped); drift check between brands.  
 - Reproducibility: dataset snapshot date or Delta version recorded; random seed frozen; split artifacts saved (cutoff date and/or customer_id lists).  
 - EDA notebook and artifacts committed to repo; readout stored and linked in backlog.  
 - Data dictionary updated or created for key fields used in labels/features (e.g., last_activity_date, net_margin).  

**Tasks**:  

1) 🟥 [DBX-ML-Assoc][EDA]  
Load Bronze tables and sample safely for iteration (record table names, counts, and sample logic).  

1) 🟥 [DBX-ML-Assoc][EDA]  
Generate quick profiles (distributions, missingness, outliers) and capture shapes/head/tail for reproducibility.  

1) 🟥 [DBX-ML-Assoc][EDA][Feature-Engineering]  
Map entities/joins needed for churn and CLV (customers, transactions, products, brand dimension).  

1) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Define churn = inactivity > 90 days; compute last_activity_date per customer and create label churn_90d.  

1) 🟥 [DBX-ML-Assoc][EDA]  
Draft CLV definition (12-month net margin) and required inputs (gross revenue, returns, costs).  

1) 🟥 [DBX-ML-Assoc][EDA]  
Create leakage checklist; flag/remove fields with future info (e.g., cancellation_date after cutoff).  

1) 🟥 [DBX-ML-Assoc][Splits]  
Decide split protocol: time-based cutoff and/or GroupKFold by customer; freeze seed; persist split artifacts.  

1) 🟥 [DBX-ML-Assoc][Metrics]  
Implement rule-based churn baseline (e.g., inactive > X days) and compute AUC/PR-AUC on validation.  

1) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Compute RFM features and segment customers; record segment distributions.  

1)  🟥 [DBX-ML-Prof][Monitoring]  
Compare EuroStyle vs Contoso distributions; quantify overlaps; run drift checks (e.g., PSI/KS on top features).  

1)  🟥 [DBX-ML-Assoc][MLflow]  
Initialize MLflow experiment; log baseline runs, parameters (churn_horizon, cutoff_date), and artifacts (plots/tables).  

1)  🟥 [DBX-ML-Assoc][EDA]  
Compile prioritized data-quality issue list with owners/severity and proposed fixes (feeds Feature 2.2 and DE backlog).  

1)  🟥 [DBX-ML-Assoc][UC]  
Create data risk log (PII handling, leakage risks, gaps) and share in team space.  

1)  🟥 [DBX-ML-Assoc][EDA]  
Produce and commit an EDA notebook and a 1–2 page readout; link them in this backlog.  

1)  🟥 [DBX-ML-Assoc][EDA]  
Update data dictionary for key fields; note any ambiguous semantics to resolve with DA/DE.  

1)  🟦 [Governance]  
Tag PII in Purview (classifications/labels) for customer fields surfaced in EDA; link glossary terms to churn/CLV concepts.  


**User Stories (breakdown)**  
- As a DS, I document churn prevalence and select a non‑leaky split protocol.  
- As a DS, I produce an EDA readout and a prioritized DQ issue list.  
- As a DS, I initialize MLflow with the evaluation plan and baselines.

**Deliverables**:  
- EDA notebook (with seed, cutoff, and dataset snapshot/version noted).  
- HTML/PDF export of profiling report (optional) and saved charts.  
- 1–2 page EDA readout (top issues, overlaps, recommendations).  
- Baseline metrics table (rule vs RFM) logged to MLflow.  
- Split protocol doc and artifacts (cutoff date, group lists, or date ranges).  
- Data risk log (PII, leakage, drift) and leakage checklist.  
- Updated data dictionary entries for core fields.  
 - EDA notebook artifact: `notebooks/feature_2_1_eda.ipynb` (synthetic fallback included; set USE_SYNTHETIC=False for real data).  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–3]: Load Bronze; run profiling (distributions, missingness, outliers); capture tables/shapes; note obvious data issues for DE/DA.  
- Day 2 [Tasks 4–7,10]: Define churn (inactivity horizon); compute prevalence by brand/period; select non‑leaky split (time/customer‑grouped) and freeze seed.  
- Day 3 [Tasks 8–9,12–13]: Implement naive baselines (rules/RFM); complete leakage checklist; start risk log (PII, drift, label quality).  
- Day 4 [Tasks 11,14–15]: Initialize MLflow experiment; log baseline runs and artifacts; draft EDA readout and align with DA/DE.  
- Day 4.5 [Polish]: Buffer; finalize notebooks and readout; link in backlog.  

Note: Days are not strictly sequential—profiling and fixes may iterate; baselines can start as soon as a stable split exists.

#### Notes — Feature 2.1 (day-by-day + how-to)
Note: Days are not strictly sequential—profiling and fixes may iterate; baselines can start as soon as a stable split exists.

- Day 1 — Profiling  
   - Do: Profile distributions and missingness; save shapes and head/tail for reproducibility.  
   - How‑to: Set a single "cutoff date" (T). When deriving features, only use data before T (or T‑Δ if you want a small buffer). Record the dataset snapshot date or Delta table version you used.  

- Day 2 — Churn definition and splits  
   - Do: Fix churn horizon (e.g., > 90 days); compute prevalence by brand/period; freeze random seed.  
   - How‑to: Prefer time‑based splits (Train ≤ T1, Validate T1→T2, Test T2→T3). If the same customer may appear across periods/brands, group by customer_id to avoid cross‑contamination. Save the seed, date ranges, and the list of customer_ids per split as artifacts.  

- Day 3 — Baselines and risk log  
   - Do: Implement rule/RFM baselines; complete the leakage checklist; start the PII/leakage/drift risk log.  
   - How‑to: For churn, compute AUC and PR‑AUC for the inactivity rule. For CLV, use a simple 12‑month net‑margin baseline and report RMSE/MAE (when future data exists). Log these yardsticks to MLflow so later models can be compared.  

- Day 4 — MLflow runs and drift/overlap checks  
   - Do: Initialize MLflow; log baseline runs and artifacts (plots/tables).  
   - How‑to: Compare EuroStyle vs Contoso using KS (distribution difference) and PSI (shift magnitude). For identities, never store raw PII—if needed, compare hashed IDs to estimate overlap. Export figures/tables as artifacts.  

- Day 4.5 — Readout and reproducibility  
   - Do: Publish a 1–2 page EDA summary with top issues and recommended fixes.  
   - How‑to: Include the data snapshot or Delta version, key parameters (churn_horizon, cutoff_date, seed), and links to split files and small CSVs of key stats/plots so others can rerun and match your results.  

---

<a id="feature-2-2"></a>
### Feature 2.2: Feature Engineering (Sprint 2)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Scientist, I want RFM and behavioral features to build churn & CLV models.  

**Learning Resources**:  
- [RFM Analysis](https://clevertap.com/blog/rfm-analysis/)  
- [Feature Engineering Guide](https://www.databricks.com/glossary/feature-engineering)  
- [MLflow Tracking Features](https://docs.databricks.com/aws/en/mlflow/tracking)  
 - [Delta Lake: table versioning and time travel](https://docs.delta.io/latest/delta-utility.html#time-travel)  
 - [Databricks Feature Engineering/Store](https://docs.databricks.com/en/machine-learning/feature-store/index.html)  
 - [Great Expectations: data quality checks](https://docs.greatexpectations.io/docs/)  
 - [Evidently AI: data/drift reports](https://docs.evidentlyai.com/)  
 - [scikit-learn preprocessing (impute/scale/transform)](https://scikit-learn.org/stable/modules/preprocessing.html)  
 - [scikit-learn feature selection (mutual information, variance, etc.)](https://scikit-learn.org/stable/modules/feature_selection.html)  
 - [Microsoft Purview — Data Quality for UC](https://learn.microsoft.com/purview/unified-catalog-data-quality-azure-databricks-unity-catalog)  

**Key Concepts**:  
- **RFM** = **Recency, Frequency, Monetary** value (classic segmentation method).  
- Basket diversity = how many unique categories a customer buys from.  
- Cross-brand shopping = customers who purchased both EuroStyle & Contoso.  
- Features must be logged and versioned for reproducibility.  
 - As‑of date (T): derive features only using events that happened before T (or T‑Δ) to avoid leakage.  
 - Versioned Delta patterns: persist features with metadata columns (version, created_ts, source_snapshot, as_of_date).  
 - Train‑only fit: imputers/scalers must be fit on TRAIN split and applied to VAL/TEST consistently.  

**Acceptance Criteria**:  
- **RFM** metrics computed for all customers.  
- Basket diversity & cross-brand features available in Silver/Gold.  
- Feature sets tracked in **MLflow** or Delta tables.  
 - Features persisted as versioned Delta tables with metadata (version, created_ts, source snapshot) for reproducibility.  
 - Joinability/consumption contract drafted with DE/DA (score schema, business keys, refresh cadence).  
 - Leakage checks performed and documented for engineered features.  
 - If COGS is missing, the agreed CLV proxy approach is documented (see Gold notes) and reflected in downstream features.  
 - Sanity checks: high-correlation features identified and deduplicated; extreme cardinality/constant fields excluded; imputation/log transforms documented; all preprocessing fit on TRAIN only.
 - Data quality checks (nulls, ranges, freshness) pass for the feature tables; results stored as artifacts.  
 - Data dictionary updated for each feature (definition, window, unit, null policy).  
 - Join keys verified against Gold (`customer_360_gold`) with row counts and uniqueness checks.  


**Tasks**

1) 🟥 [DBX-ML-Assoc][EDA]  
Fix an as-of date (T) and feature windows; record source snapshot/Delta versions.  

2) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Compute RFM anchored at T (Recency days since last tx ≤ T; Frequency count in last 365d; Monetary sum/avg).  

3) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Add basket diversity (distinct categories in last 12m) and intensity ratios (category share).  

4) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Add cross-brand features (has_both_brands, brand_count, brand_switches).  

5) 🟥 [DBX-ML-Assoc][EDA]  
Run a leakage checklist for all engineered features; ensure they use only pre-T information.  

6) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Correlation and mutual-information screening; deduplicate highly similar features; log decisions.  

7) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Cardinality and constant checks; drop extreme high-card/constant fields; set thresholds and document.  

8) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Define imputation/log transforms; fit on TRAIN only; persist transform params (e.g., means/medians) as artifacts.  

9) 🟥 [DBX-ML-Assoc][Feature-Store]  
Persist features to Delta as versioned tables (e.g., `silver.features_rfm_v1`, `silver.customer_features_v1`) with metadata columns (version, created_ts, source_snapshot, as_of_date).  

10) 🟥 [DBX-ML-Assoc][MLflow]  
Track feature set metadata in MLflow (params: version, feature_count; artifacts: schema JSON, data dictionary).  

11) 🟥 [DBX-ML-Assoc][UC]  
Define consumption contract with DE/DA (schema, business keys, refresh cadence) for integration into `customer_360_gold`; validate joinability and counts.  

12) 🟥 [DBX-ML-Assoc][MLflow]  
Train quick baselines on sample data using the features; log metrics to MLflow; compare to rule/RFM yardsticks.  

13) 🟥 [DBX-ML-Prof][Monitoring]  
Run data quality checks (Great Expectations/Evidently) on feature tables (nulls, ranges, freshness); save reports.  

14) 🟥 [DBX-ML-Assoc][UC]  
Register access and documentation for the feature tables (owners, permissions, table comments).  


**User Stories (breakdown)**  
- As a DS, I compute and persist RFM and behavior features with versioning.  
- As a DS, I remove redundant/highly correlated features and document preprocessing.  
- As a DS, I define a consumption contract with DE/DA for scoring integration.

**Deliverables**:  
- Versioned Delta tables: `silver.features_rfm_v1`, `silver.customer_features_v1` (with version, created_ts, source_snapshot, as_of_date).  
- MLflow run(s) with feature set params (version, feature_count) and artifacts (schema.json, data_dictionary.csv).  
- Data quality reports (GE/Evidently) and correlation heatmap; screening decisions log.  
- Consumption contract doc: schema, keys, join examples to `customer_360_gold`, refresh cadence.  
- Leakage checklist results and preprocessing spec (imputations/transforms with train‑fit note).  
 - Feature engineering notebook artifact: `notebooks/feature_2_2_feature_engineering.ipynb` (synthetic fallback; Delta write attempted if Spark available).  
 - Governance evidence: Purview asset entries for feature tables and applied glossary terms (where applicable).

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–2, 9 (init)]: Compute RFM anchored at as‑of T; create `v1` Delta with metadata (version, created_ts, source_snapshot); register table.  
- Day 2 [Tasks 3–5, 9 (final)]: Add basket diversity and cross‑brand features; verify no leakage (pre‑T only); finalize versioned table(s).  
- Day 3 [Tasks 6–8, 13]: Run correlation/MI and cardinality screens; define imputations/log transforms (fit on TRAIN only); run data quality checks and save reports.  
- Day 4 [Tasks 10–12, 11]: Track feature set in MLflow; define consumption contract and validate joinability to `customer_360_gold`; train quick baselines and log metrics.  
- Day 4.5 [Polish]: Finalize docs, register ownership/permissions, and publish the README notes.  

#### Notes — Feature 2.2 (day-by-day + how-to)
Note: Days can overlap—persist `v1` early, then iterate.

- Day 1 — RFM and versioning  
   - Do: Compute RFM at a fixed as‑of date; persist `v1` with metadata.  
   - How‑to: Use only events ≤ T; add metadata columns (version, created_ts, source_snapshot, as_of_date). Record the Delta version/snapshot used.  

- Day 2 — Behavior features and leakage  
   - Do: Add basket diversity and cross‑brand features; ensure pre‑T only.  
   - How‑to: Define 12‑month windows anchored at T; run a leakage checklist before saving.  

- Day 3 — Screening and preprocessing  
   - Do: Correlation/MI screening; cardinality/constant checks; define imputations/transforms.  
   - How‑to: Fit imputers/scalers on TRAIN only; log thresholds and dropped columns; export a correlation heatmap.  

- Day 4 — Consumption contract and baselines  
   - Do: Draft schema/keys/refresh cadence with DE/DA; train quick baselines; log to MLflow.  
   - How‑to: Validate joins to `customer_360_gold` (row counts, uniqueness); log feature set metadata (version, feature_count) to MLflow.  

- Day 4.5 — Publish  
   - Do: Finalize docs, register ownership/permissions, publish README.  
   - How‑to: Include data dictionary entries for each feature and links to quality reports and MLflow runs.  

---

<a id="feature-2-3"></a>
### Feature 2.3: Model Training (Sprint 3)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Scientist, I want baseline models for churn and CLV so I can evaluate predictive power.  

**Learning Resources**:  
- Spark MLlib: [Classification & Regression](https://spark.apache.org/docs/latest/ml-classification-regression.html)  
- scikit-learn: [Model evaluation](https://scikit-learn.org/stable/modules/model_evaluation.html), [Calibration](https://scikit-learn.org/stable/modules/calibration.html), [Imbalanced data](https://scikit-learn.org/stable/modules/classes.html#module-sklearn.utils.class_weight)  
- MLflow: [Experiment Tracking](https://mlflow.org/docs/latest/tracking.html), [Model Registry](https://mlflow.org/docs/latest/model-registry.html)  
- Reliability/uncertainty: [Bootstrap confidence intervals](https://scikit-learn.org/stable/auto_examples/model_selection/plot_confidence_interval.html)  

**Key Concepts**:  
- Churn = binary classification (baseline: Logistic Regression).  
- CLV = regression (baseline: Random Forest Regressor).  
- Evaluate churn with AUC, AUCPR, accuracy, precision/recall @K; evaluate CLV with RMSE, MAE, R<sup>2</sup>, MAPE.  
- Calibration matters for churn probabilities (Brier score, reliability curve); choose operating thresholds by business objective (e.g., capture X% of churners).  
- Reproducibility: fixed seeds, pinned versions, and saved splits from Feature 2.1; train-only transforms from Feature 2.2.  
- Segment-wise evaluation (brand, region, lifecycle) to detect blind spots.  

**Acceptance Criteria**:  
- Churn LR and CLV RF baselines trained on TRAIN, validated on VALID, and tested on TEST aligned with Feature 2.1 splits.  
- For churn, model beats baseline classifier with 95% CI on AUC (CI not overlapping baseline). Calibration reported with Brier score and reliability plot.  
- For CLV, model reports RMSE, MAE, R<sup>2</sup> with bootstrap 95% CIs and outperforms mean baseline.  
- Segment-wise metrics (brand/region) computed and logged; any material gaps noted with next steps.  
- MLflow logs: params, metrics, ROC/PR curves, calibration curve, feature importance/permutation importances; artifacts saved; run IDs and experiment name documented.  
- Seeds fixed; code and data versions captured; no leakage (train-only fit for imputers/scalers, as-of filtering).  


**Tasks**

1) 🟥 [DBX-ML-Assoc][EDA]  
Load Feature 2.2 dataset(s) and 2.1 split artifacts; verify shapes and label presence; check class balance.  

2) 🟥 [DBX-ML-Assoc][Metrics]  
Establish baselines: churn majority-class and CLV mean predictor; compute baseline metrics.  

3) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Build churn pipeline: train-only imputers/scalers + Logistic Regression (class_weight as needed); train on TRAIN.  

4) 🟥 [DBX-ML-Assoc][Metrics]  
Evaluate churn on VALID/TEST: AUC, AUCPR, accuracy; plot ROC/PR; compute thresholds @K (e.g., top 10%).  

5) 🟥 [DBX-ML-Assoc][Metrics]  
Calibrate churn probabilities (Platt or Isotonic) on VALID; report Brier score and reliability curve; re-evaluate on TEST.  

6) 🟥 [DBX-ML-Prof][Experimentation]  
Bootstrap CIs for churn metrics (e.g., AUC, AUCPR) with 500 resamples; log CIs.  

7) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Build CLV model: Random Forest Regressor (or Gradient Boosting if RF unavailable); train on TRAIN.  

8) 🟥 [DBX-ML-Assoc][Metrics]  
Evaluate CLV on VALID/TEST: RMSE, MAE, R<sup>2</sup> (and MAPE if nonzero targets); bootstrap 95% CIs.  

9) 🟥 [DBX-ML-Prof][Hyperparameter-Tuning]  
Light tuning (1–2 hyperparams each) using VALID; document chosen params; avoid overfitting.  

10) 🟥 [DBX-ML-Prof][Monitoring]  
Segment-wise metrics: brand/region deciles for churn; error by segment for CLV; summarize deltas vs global.  

11) 🟥 [DBX-ML-Prof][Experimentation]  
Feature importance: permutation importances (or SHAP if available) for both models; log plots.  

12) 🟥 [DBX-ML-Assoc][MLflow]  
Persist artifacts: metrics CSV, ROC/PR images, calibration plot, importances; serialize pipelines; log to MLflow; record run IDs.  

13) 🟥 [DBX-ML-Assoc][EDA]  
Reproducibility check: re-run on fixed seed; metrics within tolerance; note environment versions.  

14) 🟥 [DBX-ML-Assoc][UC]  
Draft scoring contract preview (inputs/outputs) for Feature 2.4; align column names and dtypes.  

15) 🟥 [DBX-ML-Prof][Registry]  
Handoff summary: write a short model card (purpose, data, metrics, risks, thresholds).  


**Deliverables**  
- Notebook: `notebooks/feature_2_3_model_training.ipynb` (synthetic fallback supported).  
- MLflow runs for churn and CLV, with metrics, params, and artifacts (ROC/PR, calibration, importances).  
- Artifacts folder: metrics summary CSVs, calibration and importance plots, chosen thresholds, segment metrics.  
- Model card(s) and a brief readme with run IDs and seed/version info.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–4]: Data load, baselines, churn LR train + initial evaluation.  
- Day 2 [Tasks 5–8]: Calibration + CIs for churn; train/evaluate CLV RF with CIs.  
- Day 3 [Tasks 9–11]: Light tuning, segment-wise metrics, importances.  
- Day 4 [Tasks 12–14]: Persist/MLflow logging, reproducibility check, scoring contract.  
- Day 4.5 [Task 15]: Model card + handoff.  

#### Notes — Feature 2.3 (day-by-day + how-to)
- Calibration: Fit on VALID to avoid optimistic bias; prefer Isotonic if enough data; log pre/post Brier and save a reliability plot image for the run.  
- Thresholds: Pick operating points from VALID based on business goals (e.g., top 10% recall of churners or maximize F1); never pick thresholds on TEST.  
- CIs: Use bootstrap with stratification for churn and simple bootstrap for CLV; report median and 2.5/97.5 percentiles; store seeds and sample sizes in the artifact.  
- Imbalanced churn: use class_weight="balanced" as a starting point; compare to threshold tuning on VALID; emphasize AUCPR and recall@K when churn rate is low.  
- Segment checks: compute metrics by brand/region/lifecycle; flag any segment with >5% AUC drop vs global; capture in a CSV artifact and note remediation ideas.  
- CLV skew: winsorize/log-transform targets in training only if heavy tails; always report MAE alongside RMSE; consider MAPE only for strictly positive targets.  
- Leakage guardrails: ensure all imputers/scalers fit on TRAIN only; confirm features are computed using data ≤ as‑of date; rerun the leakage checklist from 2.1 if in doubt.  
- Determinism: fix seeds in split, model, numpy/random; pin package versions in the notebook header; log data snapshot/Delta version and MLflow run IDs in the model card.  

---

<a id="feature-g-1"></a>
### Feature G.1: Governance — Purview + Unity Catalog Scanning (Sprint 1–2)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Platform team, we want Microsoft Purview to catalog and govern our Azure Databricks Unity Catalog assets (metadata, classification, and lineage) so stakeholders can search and trust governed data.  

**Learning Resources**:  
- [Microsoft Purview — Connect Azure Databricks Unity Catalog](https://learn.microsoft.com/purview/register-scan-azure-databricks-unity-catalog)  
- [Microsoft Purview — Data Quality for Unity Catalog](https://learn.microsoft.com/purview/unified-catalog-data-quality-azure-databricks-unity-catalog)  
- [Azure Databricks — Unity Catalog setup and privileges](https://learn.microsoft.com/azure/databricks/data-governance/unity-catalog/)  



**Context**:  
- Workspace is Azure Databricks Trial Premium in our subscription (not Community Edition).  
- Unity Catalog is required; scanning uses a Databricks SQL Warehouse HTTP Path and authenticates via PAT/Managed Identity/Service Principal.  
- Lineage requires enabling system tables and SELECT on `system.access.table_lineage` and `system.access.column_lineage`.  

**Acceptance Criteria**:  
- Purview registered source "Azure Databricks Unity Catalog" points to our workspace URL and SQL Warehouse HTTP Path.  
- Credential created (PAT in Key Vault or Managed Identity/Service Principal) and test connection succeeds.  
- At least one catalog successfully scanned; assets (metastore, catalogs, schemas, tables/views/columns) visible in Purview search.  
- Lineage appears for a sample notebook/SQL run across at least one table/view.  
- Optional: Data profiling or Data Quality scan configured for a representative UC table.  
- README updated with steps, links to Purview account, and scan schedule.  

**Tasks**:  

1) 🟥 [DBX-DE-Assoc][Platform]  
Verify workspace is UC-enabled and attached to the intended metastore; record metastore ID and default catalog.  

2) 🟥 [DBX-DE-Assoc][Platform]  
Create or reuse a SQL Warehouse; capture Workspace URL and HTTP Path; grant "Can Use" to the scanning identity.  

3) 🟥 [DBX-DE-Assoc][UC-Permissions]  
Enable system tables and grant SELECT on `system.access.table_lineage` and `system.access.column_lineage` to the scanning identity.  

4) 🟦 [Governance]  
Create Microsoft Purview account (if missing) and Azure Key Vault; grant Purview access to read secrets in Key Vault.  

5) 🟦 [Governance]  
Generate a Databricks PAT (or configure Managed Identity/Service Principal); store secret in Key Vault with clear naming/versioning.  

6) 🟦 [Governance]  
Register source "Azure Databricks Unity Catalog" in Purview; create/select credential; input Workspace URL + HTTP Path; toggle lineage; Test connection.  

7) 🟦 [Governance]  
Scope catalogs/schemas for the first scan; run on-demand; confirm asset count and classifications appear.  

8) 🟥 [DBX-DE-Prof][Monitoring-Logs]  
Execute a small UC notebook/SQL that reads/writes between two tables; re-run scan (or wait for schedule) and verify lineage graph in Purview.  

9) 🟦 [Workspaces]  
If private networking is required, configure Managed vNet or self-hosted Integration Runtime and private endpoints for Databricks/Key Vault.  

10) 🟦 [Governance]  
Optional: Configure Unified Catalog Data Quality profiling/scan on one table; save results as artifacts.  

11) 🟥 [DBX-DE-Prof][Monitoring-Logs]  
Document setup (identity, permissions, warehouse, HTTP Path, IR mode) and add Purview links/screenshots to evidence folder; update README.  
 

**Deliverables**:  
- Purview source registration with successful scan and lineage visualization.  
- Credential in Purview (PAT/MI/SP) referencing a Key Vault secret.  
- Evidence pack: screenshots of scan, assets, and lineage; brief README notes and links.  
- Optional: Data profiling/quality report for one UC table.  


<a id="feature-2-4"></a>
### Feature 2.4: Batch Scoring & Integration (Sprint 4)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Scientist, I want to score churn/CLV and join them into Customer 360 so Analysts can use them.  

**Learning Resources**:  
- MLflow: [Model Registry](https://mlflow.org/docs/latest/model-registry.html), [Loading models for inference](https://mlflow.org/docs/latest/models.html#model-deployment)  
- Databricks: [Batch inference patterns](https://docs.databricks.com/machine-learning/model-inference/index.html), [Delta MERGE](https://docs.databricks.com/delta/merge.html)  
- Explainability: [Interpretable ML](https://christophm.github.io/interpretable-ml-book/)  
- Data quality & drift: [Evidently](https://docs.evidentlyai.com/) (PSI, drift), Great Expectations for schema checks  
 - [Microsoft Purview — Connect Azure Databricks Unity Catalog](https://learn.microsoft.com/purview/register-scan-azure-databricks-unity-catalog)  

**Key Concepts**:  
- Idempotent batch scoring: partition by `as_of_date` and write with MERGE/overwrite-by-partition; include `_SUCCESS`/manifest when exporting.  
- Stable scoring contract: keys, dtypes, nullability, plus metadata (`model_version`, `feature_version`, `as_of_date`, `scored_ts`).  
- Train/serve skew: compare scoring inputs vs training distribution (PSI or simple quantiles).  
- Explainability at scoring time: global importances and simple per-row explanations if feasible.  

**Acceptance Criteria**:  
- `customer_scores_gold` created with schema: `customer_id`, `churn_score` (0–1), `churn_bucket` (e.g., decile), `clv_pred` (≥0), `model_version`, `feature_version`, `as_of_date`, `scored_ts`.  
- Write is idempotent and partition-aware (no duplicates across re-runs); primary key uniqueness validated.  
- Train/serve skew report produced and logged; bounds checks pass (no NaNs, churn within [0,1], non-negative CLV).  
- Join with `customer_360_gold` validated (counts and keys) and documented for DA.  
- Model and feature versions, plus MLflow run IDs, recorded in readme.  

**Tasks (numbered)**:  
1) 🟥 [DBX-ML-Assoc][MLflow]  
Freeze model artifacts/versions and feature set version; record MLflow run IDs and URIs.  

2) 🟥 [DBX-ML-Assoc][EDA]  
Load Feature 2.2 table(s) at target `as_of_date`; validate schema matches scoring contract.  

3) 🟥 [DBX-ML-Assoc][MLflow]  
Build loaders with MLflow pyfunc or direct deserialization for churn and CLV models; set seeds for determinism.  

4) 🟥 [DBX-ML-Assoc][Spark-Aggregations]  
Score churn probabilities and CLV values in batches/partitions; handle memory with repartition/coalesce.  

5) 🟥 [DBX-ML-Assoc][Feature-Engineering]  
Derive `churn_bucket` (deciles or business thresholds) and any auxiliary flags needed by DA.  

6) 🟥 [DBX-ML-Assoc][Monitoring]  
Compare scoring inputs to training distributions (PSI or quantile deltas) to detect train/serve skew; log artifacts.  

7) 🟥 [DBX-ML-Assoc][Modeling]  
Assemble output DataFrame with required columns and metadata (`as_of_date`, timestamps, versions).  

8) 🟥 [DBX-ML-Assoc][Delta-MERGE][Delta-Basics]  
Write `customer_scores_gold` idempotently (overwrite partition or MERGE on `customer_id` + `as_of_date`); validate uniqueness.  

9) 🟥 [DBX-ML-Assoc][Modeling]  
Join results into `customer_360_gold` or create a view for DA; verify row counts and key coverage.  

10) 🟥 [DBX-ML-Assoc][Explainability]  
Compute and log global importances; include a small per-row example if feasible.  

11) 🟥 [DBX-ML-Assoc][Monitoring]  
Run quality checks: null rates ≤ thresholds; churn within [0,1]; CLV ≥ 0; dtypes match contract; save a QA report.  

12) 🟥 [DBX-DE-Assoc][UC-Permissions]  
Register table/view, set permissions, and document location; add a consumption snippet for DA/BI.  

13) 🟥→🟩 [Platform][CI-CD]  
Write a short operational runbook: inputs, outputs, schedule, idempotency strategy, and recovery steps.  

14) 🟥→🟩 [Platform][Lakehouse]  
Optional export manifest for Fabric ingestion (paths, schema, `_SUCCESS`).  

**Deliverables**  
- Notebook: `notebooks/feature_2_4_batch_scoring.ipynb` (synthetic fallback supported).  
- `customer_scores_gold` table/view with schema contract and version columns.  
- Skew/QA report artifacts; explainability summary; consumption guide (paths, sample queries).  
- Runbook with idempotency and recovery steps; versions and run IDs documented.  
 - Governance evidence: Purview lineage for scoring write into `customer_scores_gold` and updated classifications.

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–3]: Freeze versions, load features, implement model loaders.  
- Day 2 [Tasks 4–7]: Batch scoring, buckets, skew check, assemble output.  
- Day 3 [Tasks 8–9]: Persist `customer_scores_gold` and join/validate in `customer_360_gold`.  
- Day 4 [Tasks 10–13]: Explainability, QA report, permissions, and runbook.  
- Day 4.5 [Task 14]: Optional Fabric export manifest and polish docs.  

#### Notes — Feature 2.4 (day-by-day + how-to)
- Idempotency: prefer overwrite-by-partition (as_of_date) or MERGE on key + date; always validate no duplicates post-write.  
- Skew checks: PSI is nice-to-have; simple side-by-side histograms/quantiles often suffice; store the report as an artifact.  
- Resource use: repartition/coalesce appropriately; avoid collecting to driver; cache when reusing feature DataFrames.  
- Contracts: put the schema (name, dtype, nullability) in a markdown/JSON and link it; enforce with a schema validator if possible.  
- Handoff: supply DA with the table/view name, data dictionary, refresh cadence, and example queries.  
 - Schema evolution: avoid adding/removing columns mid-release; if needed, bump `feature_version` and reflect it in the contract and view.  
 - Retries & checkpoints: wrap batch scoring in small partitions with retries; write to a temp location then atomically swap/merge into Gold.  
 - Partitioning: use `as_of_date` partitioning; for large volumes, add secondary partitioning (e.g., brand) cautiously to avoid small-file problems.  
 - Monitoring: record per-batch row counts, null rates, and write durations; keep a lightweight log table for operational visibility.  
 - Quick SQL tests: count distinct keys, check score bounds (0–1, >=0), and verify recent `as_of_date`; include sample queries in the README for DA.  

---

<a id="epic-3"></a>
## Epic 3 – Analytics & Business Intelligence
**Goal**: Provide dashboards for executives and marketing with unified KPIs.

---

<a id="feature-3-1"></a>
### Feature 3.1: First Look – Contoso (Sprint 1)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
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
1) 🟨 [DBX-DA-Assoc][MS-PL300][Metrics]  
Compute GMV (Gross Merchandise Value).  

2) 🟨 [DBX-DA-Assoc][MS-PL300][Metrics]  
Compute AOV (Average Order Value).  

3) 🟨 [DBX-DA-Assoc][Dashboards]  
Build dashboard with Raw/Bronze metrics.  

4) 🟨 [DBX-DA-Assoc][Modeling]  
Define relationships (star-like), hide technical columns, set sort-by columns, configure formats and display folders.  

5) 🟨 [DBX-DA-Assoc][MS-PL300][Metrics]  
Create named measures (GMV, AOV, Orders) and design a landing page wireframe with 2–3 visuals.  

6) 🟨 [DBX-DA-Assoc][Monitoring]  
Run Performance Analyzer; document and apply quick improvements (reduce visuals, limit bidirectional filters).  

7) 🟨 [DBX-DA-Assoc][Documentation]  
Draft KPI Catalog and a lightweight data dictionary (fields, definitions, units).  

8) 🟨 [DBX-DA-Assoc][Security]  
Prepare a draft RLS matrix (who sees what) for future sprints; no enforcement yet.

 - **Provide insights: Storytelling one‑liners (Feature 3.1)**  
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
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
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

#### Mini notes — Feature 3.1 (with examples)
- Measures (DAX):
   ```DAX
   GMV = SUMX('Sales Bronze', 'Sales Bronze'[Quantity] * 'Sales Bronze'[Unit Price])
   Orders = DISTINCTCOUNT('Sales Bronze'[Order ID])
   AOV = DIVIDE([GMV], [Orders], 0)
   GMV_vs_last_week = DIVIDE([GMV] - CALCULATE([GMV], DATEADD('Date'[Date], -7, DAY)), CALCULATE([GMV], DATEADD('Date'[Date], -7, DAY)), 0)
   AOV_7d_avg = AVERAGEX(DATESINPERIOD('Date'[Date], MAX('Date'[Date]), -7, DAY), [AOV])
   ```
- Visuals:
   - Cards for GMV, AOV, Orders; line chart for GMV by day; table for Top 10 products with GMV and % of total (use a measure like `GMV_pct = DIVIDE([GMV], CALCULATE([GMV], ALL('Product')) )`).
- Selection & formatting:
   - Hide technical columns, set display folders; format GMV as currency and AOV with 2 decimals; use thousands separators.
- Story helpers:
   - Tooltip with "vs last week" and "vs 7-day avg" using the measures above; a small card for "Today looks normal?" with logic `ABS([GMV] - [GMV_7d_avg]) / [GMV_7d_avg] <= 0.05`.

---

<a id="feature-3-2"></a>
### Feature 3.2: Raw vs Silver – Contoso + EuroStyle (Sprint 2)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Analyst, I want to compare KPIs Raw vs Silver to highlight data cleaning impact.  

**Learning Resources**:  
- [Data Quality Management](https://www.databricks.com/discover/pages/data-quality-management)  
- [Power BI Comparison Techniques](https://learn.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-combo-chart)  
 - [Power BI Bookmarks (toggle Raw/Silver views)](https://learn.microsoft.com/power-bi/create-reports/desktop-bookmarks)  
 - [Selection pane and layering (show/hide visuals)](https://learn.microsoft.com/power-bi/create-reports/desktop-using-the-selection-pane)  
 - [Sync slicers across pages](https://learn.microsoft.com/power-bi/create-reports/desktop-slicers-sync)  
 - [Report page tooltips and custom tooltips](https://learn.microsoft.com/power-bi/create-reports/desktop-report-page-tooltips)  
 - [Row-level security (RLS) with Power BI Desktop](https://learn.microsoft.com/power-bi/transform-model/desktop-rls)  
 - [Performance Analyzer for report tuning](https://learn.microsoft.com/power-bi/create-reports/desktop-performance-analyzer)  
 - [Storage modes (Import, DirectQuery, Dual)](https://learn.microsoft.com/power-bi/connect-data/desktop-storage-mode)  
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
 - At least three material data-quality impacts quantified (e.g., % duplicate reduction, FX normalization impact on GMV). See Appendix A – DQ Thresholds & Tests.  
 - First RLS pass configured on Silver (brand-level roles) and validated on 1–2 visuals.  
 - Azure DevOps cards created for top data-quality fixes, linked in the dashboard/readme.

**Tasks**

1) 🟨 [DBX-DA-Assoc][MS-PL300][Metrics]  
Build DAX measures for Raw vs Silver comparisons and deltas; ensure consistent formatting and tooltips.  

2) 🟨 [DBX-DA-Assoc][MS-PL300][Metrics]  
Implement return-rate measures with consistent handling (negative quantities or credit notes).  

3) 🟨 [DBX-DA-Assoc][MS-PL300][Metrics]  
Pair measures as *_raw, *_silver, *_delta; add optional last-week comparators for tooltips.  

4) 🟨 [DBX-DA-Assoc][Dashboards]  
Create dashboard pages with GMV, AOV, and return rates before/after cleaning.  

5) 🟨 [DBX-DA-Assoc][Dashboards]  
Implement bookmarks and toggles for Raw vs Silver views; annotate key differences.  

6) 🟨 [DBX-DA-Assoc][Dashboards]  
Sync slicers across pages; align layouts and tooltips for comparability.  

7) 🟨 [DBX-DA-Assoc][Monitoring]  
Quantify impacts (duplicates removed, FX normalization effects, schema harmonization effects).  

8) 🟨 [DBX-DA-Assoc][Documentation]  
Document and present differences; summarize findings in README.  

9) 🟨 [DBX-DA-Assoc][Documentation]  
Capture confidence notes (margin proxy coverage and decision tolerance).  

10) 🟩 [DBX-DA-Assoc][Security]  
Configure and test RLS roles on Silver (brand managers vs executives).  

11) 🟨 [DBX-DA-Assoc][Monitoring]  
Log Azure DevOps items for identified data-quality issues and link them from the report or README.  

12) 🟨 [DBX-DA-Assoc][Storytelling]  
Draft one-liners: GMV differs by X%; duplicates dropped by Y%; FX normalization changed totals by Z%.  

13) 🟨 [DBX-DA-Assoc][Storytelling]  
Describe AOV movement from X to Y; explain drivers (e.g., fewer inflated orders, corrected prices); note return-rate changes and Contoso limitations.  

14) 🟨 [DBX-DA-Assoc][Storytelling]  
Highlight biggest deltas by brand, region, or category; add "today normal?" note and margin proxy confidence.  


**User Stories (breakdown)**  
- As a DA, I compare Raw vs Silver KPIs with clear delta measures and toggles.  
- As a DA, I quantify data-quality impacts and log issues to DevOps.  
- As a DA, I configure first RLS roles on Silver and validate.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- **Day 1 (MM1–MM3, UX1):** Connect to both Raw and Silver (consistent fields/units); implement paired measures (`*_raw`, `*_silver`, `*_delta`); ensure returns handling is consistent; scaffold first page.  
- **Day 2 (UX1–UX3, MM refinements):** Build side‑by‑side pages and bookmark toggles; sync slicers across pages; align layouts and tooltips for comparability.  
- **Day 3 (DQ1–DQ2, INS1):** Quantify impacts (% dup reduction, FX normalization effect, schema harmonization); annotate visuals; summarize findings in README.  
- **Day 4 (RLS1, OPS1):** Configure brand‑level RLS on Silver; validate with "View as role"; open DevOps items for data‑quality issues and link from report/README.  
- **Day 4.5 (INS2–INS3, DQ3):** Stakeholder walkthrough; finalize insights one‑liners; add confidence note and polish visuals/documentation.  

#### Mini notes — Feature 3.2 (per day)
- Day 1: Import both models (Raw and Silver) with consistent field names/units; create paired measures `*_raw`, `*_silver`, and delta measures; avoid mixed grains.
   - Example DAX:
      ```DAX
      GMV_raw = SUMX('Raw Sales', 'Raw Sales'[Quantity] * 'Raw Sales'[Unit Price])
      GMV_silver = SUMX('Silver Sales', 'Silver Sales'[Quantity] * 'Silver Sales'[Unit Price EUR])
      GMV_delta = [GMV_silver] - [GMV_raw]
      GMV_delta_pct = DIVIDE([GMV_delta], [GMV_raw], 0)
      ```
   - Returns (if negatives used):
      ```DAX
      ReturnRate_raw = DIVIDE( ABS( SUMX( FILTER('Raw Sales', 'Raw Sales'[Quantity] < 0), 'Raw Sales'[Quantity] ) ),
                               SUMX( FILTER('Raw Sales', 'Raw Sales'[Quantity] > 0), 'Raw Sales'[Quantity] ), 0 )
      ```
- Day 2: Use bookmarks + selection pane to toggle Raw/Silver views; sync date/brand slicers across pages.
   - Example steps: group visuals into "grp Raw" and "grp Silver" in Selection pane; create bookmarks "View: Raw" (show Raw/hide Silver) and "View: Silver" (inverse); assign each to a button.
- Day 3: Quantify % duplicate reduction and FX impact; annotate visuals/tooltips with caveats.
   - Example measures:
      ```DAX
      Rows_raw = COUNTROWS('Raw Sales')
      Rows_silver = COUNTROWS('Silver Sales')
      DupReduction_pct = DIVIDE([Rows_raw] - [Rows_silver], [Rows_raw], 0)
      ```
   - FX impact idea: compute a version of GMV before FX normalization (or simulate) and show `FX_impact_pct = DIVIDE([GMV_silver] - [GMV_silver_noFX], [GMV_silver_noFX], 0)` with a tooltip note on valuation date.
- Day 4: Define brand-level roles; validate with "View as"; ensure measures respect filter context under RLS.
   - Example: Role "Brand – EuroStyle" with table filter `'Dim Brand'[Brand] = "EuroStyle"`; test "View as" EuroStyle and Contoso.
- Day 4.5: Walk stakeholders through deltas; capture actions into the backlog.
   - Story helpers:
      - Tooltips: show Raw vs Silver deltas in plain text, e.g., "GMV −3.4% (−dup 4.1%, +FX +0.7%)"; add a methods banner (returns rule, FX valuation date) on hover.
      - "Today looks normal? (Silver)":
         ```DAX
         GMV_7d_avg_silver = AVERAGEX(DATESINPERIOD('Date'[Date], MAX('Date'[Date]), -7, DAY), [GMV_silver])
         TodayNormal_silver = ABS([GMV_silver] - [GMV_7d_avg_silver]) / [GMV_7d_avg_silver] <= 0.05
         GMV_silver_vs_last_week = DIVIDE([GMV_silver] - CALCULATE([GMV_silver], DATEADD('Date'[Date], -7, DAY)), CALCULATE([GMV_silver], DATEADD('Date'[Date], -7, DAY)), 0)
         ```
   - Example one‑liner: "After cleaning: GMV −3.4% (−dup 4.1%, +FX +0.7%); biggest delta in Footwear (ES)."

##### Feature 3.1 vs feature 3.2 (quick comparison)
| Aspect | Feature 3.1: First Look (Contoso, Bronze) | Feature 3.2: Raw vs Silver (EuroStyle + Contoso) |
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

<a id="feature-3-3"></a>
### Feature 3.3: Executive Post-Merger Dashboard (Sprint 3)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As an Executive, I want consolidated GMV, AOV, and margin so I can track EuroStyle + Contoso performance.  

**Learning Resources**:  
- [RLS in Power BI Desktop (define roles)](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security)  
- [Performance Analyzer (optimize visuals)](https://learn.microsoft.com/power-bi/create-reports/desktop-performance-analyzer)  
- [Bookmarks (demo flow)](https://learn.microsoft.com/power-bi/create-reports/desktop-bookmarks)  
- [Aggregate data in a visualization (sum, average, etc.)](https://learn.microsoft.com/en-us/power-bi/create-reports/service-aggregates)  
- [Small multiples for brand/region comparisons](https://learn.microsoft.com/power-bi/visuals/power-bi-visualization-small-multiples)  
- [Field parameters (flexible dimensions)](https://learn.microsoft.com/power-bi/create-reports/power-bi-field-parameters)
- [Create report bookmarks in Power BI to share insights and build stories](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-bookmarks)

**Key Concepts**:  
- Gold = business-ready marts (subject‑oriented curated datasets optimized for analytics) with consistent KPIs.  
- Consolidated KPIs unify EuroStyle & Contoso for board-level decisions.  
- RLS (Row-Level Security) = ensures managers see only their brand while executives see both.  

**Acceptance Criteria**:  
- Dashboard includes consolidated GMV, AOV, and margin.  
- Brand comparison available (EuroStyle vs Contoso).  
- Regional splits included (North vs South Europe).  
- RLS configured and validated.  
 - Methods banner present on the Executive page (date range, currency/FX note, and margin method disclosure). See Business Case – Governance, NFRs, and Security.
 - Performance budget on Executive page met (target visual refresh ≤ 3–5s on typical filters).  
 - Accessibility basics applied (contrast, meaningful titles and alt text, tab order).  
 - RLS validated in Power BI Service (View as role) and sharing permissions verified.  

**Tasks**:  
1) 🟨 [DBX-DA-Assoc][Dashboards]  
Add brand comparison (EuroStyle vs Contoso).  

2) 🟨 [DBX-DA-Assoc][Dashboards]  
Add regional splits (North vs South Europe).  

3) 🟩 [DBX-DA-Assoc][Security]  
Apply RLS (Row-Level Security) for managers vs executives 

 - **Provide insights: Storytelling one‑liners (Feature 3.3)**  
    - Board view: GMV X, AOV Y, margin Z; EuroStyle vs Contoso: X% gap.  
    - North vs South: North is X% of GMV; South grew Y% WoW; margin tighter in [Region].  
    - Today looks normal: KPIs within ±X% of last 7 days; no anomalies flagged.  
    - Biggest swing: [Brand/Region] moved by X%; driver: [category/channel].  
    - Focus: Top three products contribute X% of GMV and Y% of margin.  
    - Risk note: Margin is proxy on COGS; decisions within ±V% tolerance.
   - Share: EuroStyle holds X% of GMV (+Y pp WoW); Contoso at Z%.
   - Margin rate: X% (vs Y% last week); [Category] −Z pp; [Region] +W pp.
   - Top region: [Region] GMV X; WoW +Y%; watch [Second Region] softness.
   - Mix: Product mix added X bps to margin; units/order Y; price/mix driver noted.
   - Concentration: Top 5 products = X% of GMV; dependency risk flagged.
   - Returns: steady at X% (±Y pp band); no outliers.
   - Run‑rate: on pace for X GMV this week (±Y%).
   - Data quality: Silver vs Raw delta X%; exec KPIs unaffected today.

**User Stories (breakdown)**  
- As an Executive, I see consolidated GMV/AOV/margin with brand/regional splits.  
- As a DA, I enforce RLS for managers vs executives.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- **Day 1:** Connect to Gold marts; outline pages/sections; confirm grain and relationships; stub key measures with proper formats.  
- **Day 2:** Implement brand/regional comparisons (consistent axes, legends); add drill targets (brand→region→product).  
- **Day 3:** Add margin (proxy/final); run Performance Analyzer; consider Power BI aggregation tables or summarizations if needed.  
- **Day 4:** Configure/validate RLS (brand manager vs exec; use "View as"); create demo bookmarks; rehearse narrative.  
- **Day 4.5:** Buffer; finalize and publish; verify sharing and permissions.

#### Mini notes — Feature 3.3 (per day)
- Day 1: Confirm fact/dim relationships on Gold; stub measures and formatting; set consistent date table.
   - Example DAX:
      ```DAX
      GMV = SUM('gold.sales_daily'[revenue])
      Orders = SUM('gold.sales_daily'[orders])
      AOV = DIVIDE([GMV], [Orders], 0)
      Margin = SUM('gold.sales_daily'[estimated_margin])  -- swap to true COGS when available
      ```
   - Formatting: set GMV/Margin as currency; AOV with 2 decimals; thousands separators.
- Day 2: Build brand/region comparisons with aligned axes; add drill targets and verify cross-highlighting.
   - Visuals: clustered bar (EuroStyle vs Contoso), small multiples by Region; ensure same y‑axis across panels.
   - Drill path: Brand → Region → Product; enable "Show data" for detail checks.
- Day 3: If slow, consider aggregation tables or summarize to daily grain; re-run Performance Analyzer.
   - Aggregations: create a daily summary table and map it as Import with relationships to Direct Lake/DirectQuery base if needed.
   - Performance: reduce slicers, disable unnecessary interactions; cache tooltips or simplify measures.
- Day 4: Implement RLS (brand manager vs exec); validate with "View as"; save role definitions.
   - Example roles: Brand Manager (filter `'gold.dim_brand'[brand] = "EuroStyle"`); Executive (no filter).
   - Test "View as" both roles; confirm KPIs and comparisons adjust correctly.
- Day 4.5: Publish; verify dataset credentials and audience access; document the demo flow.
   - Methods banner (top‑right text box):
      - Include: Date range, Brand(s) in context, Currency (EUR), FX valuation date or note, Margin method (Proxy vs Actual COGS), Data version.
      - Example DAX (adjust table/column names to your model):
         ```DAX
         MethodsBanner = 
            "Date: " & FORMAT(MIN('Date'[Date]), "yyyy-MM-dd") & " → " & FORMAT(MAX('Date'[Date]), "yyyy-MM-dd") &
            " | Brand: " & CONCATENATEX(VALUES('Dim Brand'[Brand]), 'Dim Brand'[Brand], ", ") &
            " | Currency: EUR" &
            " | FX: " & COALESCE(FORMAT(SELECTEDVALUE('FX'[valuation_date]), "yyyy-MM-dd"), "n/a") &
            " | Margin: " & COALESCE(SELECTEDVALUE('Config'[MarginMethod]), "Proxy")
         ```
      - Place as a single‑line text visual; keep font small and consistent across pages.
   - Bookmarks: create "Executive Overview", "Brand Details", "Region Focus"; wire next/prev buttons.
   - Share: assign audience access; verify RLS in Service; attach quick demo script in README.

##### Feature 3.2 vs Feature 3.3 (quick comparison)
| Aspect | Feature 3.2: Raw vs Silver (EuroStyle + Contoso) | Feature 3.3: Executive Post‑Merger |
|---|---|---|
| Goal | Validate Silver vs Raw data, reconcile KPIs, surface DQ issues | Present consolidated GMV, AOV, Margin with brand/region splits |
| Scope | Data reconciliation and diagnostics; Contoso+EuroStyle parity | Board‑level view; EuroStyle vs Contoso; North vs South |
| Data layer | Raw + Silver side‑by‑side; deltas, returns, and FX checks | Gold marts: curated facts/dims for executive KPIs |
| Measures | Delta GMV/Orders/Margin, Returns rate, FX adjustments | GMV, Orders, AOV, Margin; brand share; region contribution |
| Visuals | Side‑by‑side cards, delta bars, exception tables, tooltip "Today normal?" | KPI cards, brand/region bars, small multiples, bookmarks |
| Audience | Data/BI team; QA; DA/DE collaboration | Executives, senior leadership; brand/regional managers |
| RLS | Not primary (QA focus); optional for sanity | Required: brand manager vs executive roles validated in Service |
| Performance | Moderate; focus on clarity for deltas and diagnostics | Tight: 3–5s target; prefer model aggregations and aligned axes |
| Output | DQ ticket links + README notes; clear pass/fail on parity | Published exec report with methods banner + demo bookmarks |
| One‑liners | "Silver matches Raw within ±X%", "Returns steady", "No FX gaps" | "Board view GMV X, margin Z", "Brand gap X%", "Today looks normal" |


---

<a id="feature-3-4"></a>
### Feature 3.4: Customer Segmentation Dashboard (Sprint 4)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Marketing Manager, I want to see customer segments & churn risk so I can design campaigns.  

**Learning Resources**:  
- [RFM Analysis](https://clevertap.com/blog/rfm-analysis/) 
 - [Databricks Solution Accelerator - Predict Customer Churn](https://www.databricks.com/solutions/accelerators/predict-customer-churn)  
- [Databricks Intelligence Platform for C360: Reducing Customer Churn](https://www.databricks.com/resources/demos/tutorials/lakehouse-platform/c360-platform-reduce-churn)
- [Power BI in Fabric](https://learn.microsoft.com/en-us/fabric/get-started/microsoft-fabric-overview)  
 - [Field parameters](https://learn.microsoft.com/en-us/power-bi/create-reports/power-bi-field-parameters)  
 - [Bookmarks and Selection pane](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-bookmarks)  
 - [Performance Analyzer](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-performance-analyzer)  
 - [Accessibility in Power BI](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-accessibility-creating-reports)  
 - [Row-level security (RLS) in Power BI models](https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-rls)  
 - [Direct Lake overview (Fabric)](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview)  

**Key Concepts**:  
- Customer segmentation = group customers by behavior (RFM).  
- Churn prediction = probability a customer will stop purchasing.  
- **CLV (Customer Lifetime Value)** = expected revenue/margin over a defined horizon.  
- Integration of DS outputs (scores) into dashboards closes the loop between **data science and business action**.  

**Acceptance Criteria**:  
- Customer 360 dashboard shows segments (RFM).  
- Churn risk and CLV tiers integrated from DS outputs.  
- Dashboard published in Fabric and shared with marketing.  
- Methods banner visible on key pages (active thresholds, snapshot date).  
- Field parameters allow switching dimension (Brand/Region/Segment) and measure family (Risk%, CLV, Txns).  
- RLS validated in Service using "View as" (BrandManager vs Executive); measures behave under role filters.  
- Performance: median visual time improved ≥ 30% vs baseline; no visual > 2s on typical filters.  
- Accessibility: color contrast ≥ 4.5:1, keyboard focus order set, alt text on key visuals, consistent currency/percent formats.  

**Tasks**:  

1) 🟨 [DBX-DA-Assoc][Dashboards]  
Map inputs and integrate DS outputs: connect to `customer_360_gold` and `customer_scores_gold`; validate relationships and row counts.  

2) 🟨 [DBX-DA-Assoc][Dashboards]  
Define segmentation rules (RFM buckets, churn risk bands, CLV tiers) with defaults; align with DS.  

3) 🟨 [DBX-DA-Assoc][Dashboards]  
Implement What–if parameters (recency window, churn cutoff, CLV tier split points) and bind to measures.  

4) 🟨 [DBX-DA-Assoc][Dashboards]  
Build parameter/measure tables; create field parameters for dimension and measure switching.  

5) 🟨 [DBX-DA-Assoc][Dashboards]  
Design the landing page: navigation tiles, KPIs (segment counts, GMV, margin), and a methods banner.  

6) 🟨 [DBX-DA-Assoc][Dashboards]  
Build segment visuals (treemaps/tables) and summary cards; ensure consistent legends and formats.  

7) 🟨 [DBX-DA-Assoc][Dashboards]  
Create drill–through pages (Segment detail, Customer detail) with Back buttons; maintain filter context.  

8) 🟨 [DBX-DA-Assoc][Dashboards]  
Add tooltip pages (mini customer profile: last purchase, risk band, CLV tier).  

9) 🟩 [DBX-DA-Assoc][RLS]  
Implement RLS roles (BrandManager, Executive) and validate with "View as" in Desktop and Service.  

10) 🟨 [DBX-DA-Assoc][Dashboards]  
Optimize performance: limit visuals per page, avoid high–cardinality slicers, consider aggregated tables if needed.  

11) 🟨 [DBX-DA-Assoc][Dashboards]  
Configure bookmarks and sync slicers; verify cross–highlighting/interactions behave as intended.  

12) 🟨 [DBX-DA-Assoc][Dashboards]  
Accessibility pass: contrast, focus order, alt text, titles/tooltips, number formats.  

13) 🟨 [DBX-DA-Assoc][Dashboards]  
Validation: totals vs slicers, empty/ALL segment states, mobile layout sanity.  

14) 🟨 [DBX-DA-Assoc][Dashboards]  
Documentation: README with segmentation rules, thresholds, screenshots, navigation map, and RLS notes.  

15) 🟨 [DBX-DA-Assoc][Dashboards]  
(Optional) Add a "Focus list" page for top–risk/low–CLV segments with exportable table.  


**User Stories (breakdown)**  
- As a Marketing Manager, I explore segments (RFM, churn risk, CLV tiers) and drill‑through to details.  
- As a DA, I wire What‑if parameters and publish via Fabric.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- **Day 1:** Integrate churn/CLV scored tables; define segment rules (RFM buckets, risk tiers); design navigation and landing tiles.  
- **Day 2:** Build segment visuals (treemaps/tables) and KPIs; use field parameters for flexible dimension toggles.  
- **Day 3:** Implement drill‑through to customer detail; add What‑if parameters for thresholds and bind into measures.  
- **Day 4:** Publish in Fabric; test RLS interactions (use "View as") and cross-highlighting; validate performance on typical filters.  
- **Day 4.5:** Buffer; capture screenshots and document segmentation logic.

 

#### Mini notes — Feature 3.4 (per day)
- Day 1: Align segment rules with DS; map fields from scored tables; design landing tiles for quick nav.
- Day 2: Use field parameters for dimension toggles; build segment KPIs and summary visuals.
- Day 3: Add drill-through to customer detail; wire back buttons; add tooltip pages where helpful.
- Day 4: Publish; validate RLS interactions with "View as"; test typical filters for performance.
- Day 4.5: Screenshot key views; document segmentation rules and thresholds in README.

#### Advanced notes — DAX patterns, performance, RLS (Feature 3.4)

- DAX snippets (adapt to your model)
    - RFM bin:
       ```
       RFM Bin =
          VAR R = [RecencyDays]
          VAR F = [Frequency365d]
          VAR M = [AvgOrderValue]
          VAR rBin = SWITCH(TRUE(), R <= 30, "R3", R <= 90, "R2", "R1")
          VAR fBin = SWITCH(TRUE(), F >= 6, "F3", F >= 2, "F2", "F1")
          VAR mBin = SWITCH(TRUE(), M >= 100, "M3", M >= 40, "M2", "M1")
          RETURN rBin & fBin & mBin
       ```
    - Churn risk bands (using What‑if param `ChurnCutoff%`):
       ```
       Churn Risk Band =
          VAR p = [Churn Probability 90d]
          VAR cutoff = SELECTEDVALUE('ChurnCutoff%[ChurnCutoff Value]', 0.30)
          RETURN IF(p >= cutoff, "High", IF(p >= cutoff*0.67, "Med", "Low"))
       ```
    - CLV tiers:
       ```
       CLV Tier =
          VAR v = [CLV 12m]
          RETURN SWITCH(TRUE(), v>=1000,"T1", v>=500,"T2", v>=200,"T3", "T4")
       ```
    - Methods banner:
       ```
       Methods Banner =
          "Segmentation: RFM=" & [RFM Threshold Label] &
          " | ChurnCutoff=" & FORMAT(SELECTEDVALUE('ChurnCutoff%[ChurnCutoff Value]',0.3), "0%") &
          " | Snapshot=" & FORMAT([Snapshot Date], "yyyy-mm-dd")
       ```

- Field parameters
    - Create two: Dimension switcher (Brand, Region, Segment) and Measure switcher (Risk%, CLV, Txns); apply consistent formats/colors.

- Performance
    - Prefer Direct Lake; if DirectQuery, use aggregations and limit visuals; enable query reduction; avoid high‑cardinality slicers.
    - Use Performance Analyzer; aim ≥ 30% median improvement; keep visuals < 2s.

- RLS
    - Roles: BrandManager (brand filter), Executive (no brand filter). Validate with "View as"; ensure drill‑through respects RLS.

- Testing
    - Edge cases: empty/ALL segments; cross‑highlight behavior; totals with slicers; mobile layout sanity.


##### Feature 3.3 vs Feature 3.4 (quick comparison)
| Aspect | Feature 3.3: Executive Post‑Merger | Feature 3.4: Customer Segmentation |
|---|---|---|
| Goal | Board‑level view of consolidated GMV, AOV, margin with brand/region splits | Marketing view of segments (RFM), churn risk, and CLV for action |
| Scope | EuroStyle vs Contoso; North vs South; executive summary | Segments, cohorts, drill‑through to customer details |
| Data layer | Gold marts: `gold.sales_daily`, `gold.category_perf` | Gold + DS outputs: `customer_360_gold` with churn/CLV scores |
| Measures | GMV, Orders, AOV, Margin; brand/region comparisons | Segment KPIs (count, GMV, margin), churn rate, CLV tiers |
| Visuals | KPI cards, brand/region bars, small multiples, bookmarks | Treemaps/tables, drill‑through, field parameters, What‑if sliders |
| Audience | Executives, senior leadership | Marketing/CRM, campaign owners |
| RLS | Brand manager vs executive | Segment/campaign scopes; customer‑level protections as needed |
| Performance | Prefer model aggregations; aligned axes; 3–5s target | Optimize drill‑through; limit high‑cardinality slicers |
| Output | Executive overview page + demo bookmarks + methods banner | Segmentation dashboard + logic/thresholds documented |
| One‑liners | Brand gap, normal day, biggest swing, top contributors | Segment mix, high‑risk cohort, CLV distribution, focus list |


---
<a id="epic-4"></a>
## Epic 4 – Platform Integration (Databricks ↔ Fabric)
**Goal**: Demonstrate end-to-end integration between Databricks and Microsoft Fabric, even on Free Editions.

---

<a id="feature-4-1"></a>
### Feature 4.1: Export Gold to Fabric (Sprint 4)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Engineer, I want Gold marts exported to Fabric so dashboards can consume them via Direct Lake.  

**Learning Resources**:  
- [Fabric Lakehouse Overview](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)  
- [Differences between Azure Data Factory and Fabric Data Factory](https://learn.microsoft.com/en-us/fabric/data-factory/compare-fabric-data-factory-and-azure-data-factory)  
- [Databricks Parquet & Delta Export](https://docs.databricks.com/delta/delta-batch.html)  

For your information
- [Integrate OneLake with Azure Databricks](https://learn.microsoft.com/en-us/fabric/onelake/onelake-azure-databricks)
- [Understand medallion lakehouse architecture for Microsoft Fabric with OneLake](https://learn.microsoft.com/en-us/fabric/onelake/onelake-medallion-lakehouse-architecture)
- [Microsoft Fabric documentation](https://learn.microsoft.com/en-us/fabric)

**Key Concepts**:  
- **Gold marts** (subject‑oriented curated datasets optimized for analytics) = final curated tables for analytics (sales_daily, customer_360, etc.).  
- **Parquet + manifest + _SUCCESS** = ensures consistent export contract.  
- **Fabric Lakehouse Files** (Free path) = manual upload from Databricks to Fabric.  
- **Delta in Fabric** = ingestion into tables ready for Direct Lake mode.  

**Acceptance Criteria**  
- Gold marts exported as Parquet with schema-stable contract, release `manifest.json`, and `_SUCCESS` marker.  
- Manual export path validated for Free Edition: files manually downloaded from Databricks and uploaded to Fabric Lakehouse `/Files/dropzone/...`.  
- Fabric Data Pipeline ingests to Delta tables with correct dtypes, partitioning (if applicable), and primary keys validated.  
- Row counts and optional checksums match source within tolerance; sampling spot-checks pass.  
 - Datasets are queryable from Power BI (Direct Lake) and a tiny visual loads without refresh errors. Follow Ops runbook (Appendix B) for validation checklist.  


**Tasks**  

1) 🟥 [DBX-DE-Assoc][Platform]  
List Gold tables to export (e.g., `sales_daily_gold`, `customer_360_gold`, `customer_scores_gold`) and confirm owners.  

2) 🟥 [DBX-DE-Assoc][Platform]  
Define export layout: base path per table, partitioning (if any), file size targets, and naming (snake_case, datestamps).  

3) 🟥 [DBX-DE-Assoc][Delta-Basics]  
Generate Parquet files; coalesce to 128–512MB per file; write `_SUCCESS`.  

4) 🟥 [DBX-DE-Assoc][Testing]  
Compute row counts per table/partition; optionally compute file-level checksums (md5) and store alongside.  

5) 🟥 [DBX-DE-Prof][Modeling][Governance]  
Create `release_manifest.json` capturing dataset name, version, tables, schema (name, dtype, nullability), partitions, file lists, counts, checksums, created_ts, and source snapshot (Delta version or commit).  

6) 🟥 [DBX-DE-Assoc][Testing]  
Dry-run export on one small table; locally verify Parquet opens and schema matches expectations.  

7) 🟥→🟩 [DBX-DE-Assoc][Platform][Ops]  
Export to Fabric Lakehouse `/Files/dropzone/<release>/...`  
   - **Case A – Community Edition / Free:** Download Parquet + manifest from Databricks FileStore and manually upload into Fabric Lakehouse (no direct connector available).  
   - **Case B – Trial Premium / Full Workspace:** Configure OneLake or ADLS Gen2 mount/shortcut from Databricks and write Parquet/Delta directly into Fabric Lakehouse (recommended for automation).  

8) 🟩 [DBX-DE-Assoc][Platform]  
In Fabric Data Pipelines: configure file source → Lakehouse table mappings; set column types; create Delta tables.  

9) 🟩 [DBX-DE-Assoc][Testing]  
Validate ingestion: compare counts vs manifest; check nullability/dtypes; ensure partition columns are correct.  

10) 🟩 [DBX-DA-Assoc][Dashboards][Testing]  
Create/verify shortcuts or views if needed for Power BI; test Direct Lake connectivity with a basic visual.  

11) 🟥→🟩 [DBX-DE-Prof][Ops][Governance]  
Capture evidence (screenshots/links), store manifest and a README with steps, and note any edge cases.  

12) 🟥→🟩 [DBX-DE-Prof][Ops]  
Document re-run/idempotency guidance and ownership (who exports, who ingests, cadence).  

13) 🟩 [Governance]  
Apply sensitivity labels and ownership metadata; add table comments/Descriptions in the Lakehouse.  

14) 🟨 [DBX-DA-Assoc][Dashboards][Testing]  
Build a tiny Direct Lake smoke report (1–2 visuals) and capture Performance Analyzer notes/screenshots.  

15) 🟥→🟩 [DBX-DE-Prof][Ops][Governance]  
Establish versioned releases and a `current` pointer/view; document rollback steps and tolerance thresholds.  


**Deliverables**  
- Export folder structure per table with Parquet files, `_SUCCESS`, and `release_manifest.json`.  
- Row count summary and optional checksums.  
- Fabric Data Pipeline mapping (screenshots or config) and created Delta tables.  
- Quickstart README: export paths, manual transfer steps (Free Edition), ingestion steps, validation checklist, and troubleshooting.  
- Schema contract: see `docs/release_manifest.schema.json` for the release manifest fields.  

**User Stories (breakdown)**  
- As a DE, I export Gold marts with a reproducible Parquet+manifest contract.  
- As a DE, I ingest them into Fabric Lakehouse tables via Data Pipelines.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–5]: Define export contract (tables/layout), file sizing, manifest fields; dry‑run on one small table.  
- Day 2 [Tasks 6–9]: Package all Gold marts; manual transfer to Fabric; configure Data Pipeline mappings and create Delta tables.  
- Day 3 [Tasks 10–12]: Validate ingestion and partitions; create views/shortcuts; test Direct Lake connectivity.  
- Day 4 [Tasks 13–14]: Apply sensitivity/ownership metadata; run smoke report and capture performance notes.  
- Day 4.5 [Tasks 15]: Set `current` pointer and rollback guidance; finalize docs and hand‑off.  

#### Notes — Feature 4.1 (day-by-day + how-to)
- Exports: prefer stable column order and names; avoid schema drift between releases; add version tags into the manifest.  
- File sizing: coalesce to 128–512MB; too many small files degrade ingestion performance.  
- Manual transfer (Free): download from Databricks workspace file browser; upload to Fabric Lakehouse `/Files/dropzone/<release>/...`.  
- Ingestion: map data types explicitly in Data Pipelines; verify any partition columns; document Lakehouse table names.  
- Validation: row counts within tolerance; quick SQL in Lakehouse to sanity check; a simple Power BI visual confirms connectivity.  
 - Manifest details: include `dataset`, `version`, `tables`, `schema` (name, dtype, nullability), `partitions`, `files`, `row_counts`, optional `checksums`, `created_ts`, and `source_snapshot` (Delta version).  
 - Temp staging: export to a dated staging folder first; review counts/checksums; then mark release by copying to `/dropzone/<release>` and writing `_SUCCESS`.  
 - Error handling: if a table fails ingest, isolate by table; correct data types/mappings; re-run ingestion only for the affected folder.  
 - Rowcount/checksums: keep a tiny CSV summary next to the manifest; use it during Fabric QA to quickly compare pre/post counts.  
 - Documentation: update a short README with paths, table names, schema links, and troubleshooting steps; link to the Fabric Pipeline and Lakehouse items.  
   - See also `docs/DA_BI_README.md` and `docs/fabric_lakehouse_qa.sql` for DA handoff and QA queries.  

---

<a id="feature-4-2"></a>
### Feature 4.2: Power BI Suite (Sprint 4)
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
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
 
**Tasks (numbered)**:  


1) 🟥 [DBX-DA-Assoc][Platform]  
Set up Fabric workspace artifacts (Lakehouse, semantic model) and connect to Gold tables.  

2) 🟥 [DBX-DA-Assoc][Dashboards]  
Build Executive pages: theme, navigation, KPI cards (GMV, AOV, margin) with consistent currency formats and tooltips.  

3) 🟥 [DBX-DA-Assoc][Dashboards]  
Build Segmentation pages: connect to `customer_scores_gold`; define relationships (customer/date); design segments and slicers.  

4) 🟥 [DBX-DA-Assoc][Dashboards][Testing]  
Validate cross-highlighting behavior and performance; avoid excessively high-cardinality slicers.  

5) 🟥 [DBX-DA-Assoc][RLS]  
Define RLS roles (e.g., `BrandManager` brand filter, `Executive` unrestricted); map to security groups.  

6) 🟥 [DBX-DA-Assoc][RLS][Testing]  
Test RLS with "View as" for both roles; verify measures behave correctly and visuals respect filters.  

7) 🟥 [DBX-DA-Assoc][Platform][Ops]  
Prepare Fabric Deployment Pipeline (Dev → Test); parameterize dataset connections if needed.  

8) 🟥 [DBX-DA-Assoc][Platform][Ops]  
Promote to Test; validate dataset parameters, refresh, and fix any broken lineage.  

9) 🟥 [DBX-DA-Assoc][Dashboards][Testing]  
Polish visuals, accessibility (titles/alt text), and page performance (optimize visuals, fields).  

10) 🟥 [DBX-DA-Assoc][Ops][Governance]  
Document sharing (audience, app access), dataset/dashboards URLs, and pipeline links; capture screenshots for hand-off.  

11) 🟩 [DBX-DA-Assoc][Platform]  
Create and publish a Fabric App with audiences; configure navigation and app permissions.  

12) 🟩 [DBX-DA-Assoc][Ops][Platform]  
Configure dataset refresh schedules and parameters/secrets (e.g., workspace/Lakehouse bindings); verify post-promotion refresh.  

13) 🟩 [Governance]  
Apply sensitivity labels and endorse/certify the dataset; add descriptions and ownership metadata.  

14) 🟨 [DBX-DA-Assoc][Dashboards][Testing]  
Run Performance Analyzer and document actions; reduce heavy visuals/queries and optimize interactions.  

15) 🟩 [DBX-DA-Assoc][Dashboards][Ops]  
Add a "How to use" + QA checklist page; verify responsiveness and accessibility; finalize hand-off pack.  


**Deliverables**  
- Published dashboards (Executive and Segmentation) with stable URLs.  
- RLS role definitions and group mappings documentation.  
- Fabric Deployment Pipeline configuration and promotion evidence.  
- Short README with dataset connections, parameters, and troubleshooting notes.  
- DA handoff pack: `docs/DA_BI_README.md` with links and QA checklist.  

**User Stories (breakdown)**  
- As an Executive/Marketing, I access executive and segmentation dashboards with RLS applied.  
- As a DA, I deploy via Fabric pipelines across stages.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–4]: Build Executive and initial Segmentation pages; ensure consistent formats/tooltips; validate basic interactions/performance.  
- Day 2 [Tasks 5–7]: Configure RLS roles, test with "View as" (first pass), and prepare Deployment Pipeline (Dev → Test).  
- Day 3 [Tasks 8–10]: Promote to Test; validate connections/parameters/lineage; polish visuals and document sharing/links.  
- Day 4 [Tasks 11–13]: Publish Fabric App; configure refresh schedules/parameters; apply sensitivity labels and endorsement.  
- Day 4.5 [Tasks 14–15]: Performance Analyzer wrap‑up; add "How to use" + QA checklist; finalize hand‑off.  

#### Notes — Feature 4.2 (day-by-day + how-to)
- Formatting: apply a consistent theme; standardize currency/decimal formats; hide technical columns from visuals.  
- Relationships: confirm model relationships (customer/date); ensure cross-filtering direction supports intended interactions.  
- RLS: keep role filters simple; test DAX measures under each role; verify row-level filters don't break totals.  
- Promotion: parameterize Lakehouse/workspace if needed; after promotion, refresh datasets and verify lineage.  
- Sharing: use Fabric App audiences; include a README with URLs and owner contacts.  
 - Semantic model hygiene: use a star schema; hide surrogate/technical keys; keep measures in a dedicated Measures table; adopt clear naming (e.g., GMV, AOV, Margin%).  
 - Measures and DAX: create explicit measures (avoid implicit); set format strings and descriptive tooltips; add a proper Date table and mark it as Date; disable Auto date/time.  
 - Performance: limit visuals per page; avoid high-cardinality slicers; pre-aggregate if needed; test with Performance Analyzer; prefer Direct Lake-friendly patterns (no overly complex composite models).  
 - RLS best practices: apply filters on dimension tables (not facts); avoid bi-directional relationships with RLS; minimize number of roles; document role intent and filters.  
 - Promotion specifics: configure Deployment Pipeline rules to rebind Lakehouse/workspace per stage; after promotion, rebind, refresh, and validate in Lineage view; log any broken items.  
 - Governance & sharing: apply sensitivity labels if required; certify/endorse the dataset; publish an App with distinct audiences and a short "How to use" page.  
 - Accessibility: ensure color contrast, meaningful titles/alt text, logical tab order; validate on small screens; prefer text + icons over color-only cues.  
 - Ops runbook: list owners, refresh cadence, known dependencies, and a quick troubleshooting checklist (failed refresh, missing permissions, broken lineage).  

---
<a id="feature-4-3"></a>
### Feature 4.3: Model Scoring Export & Validation in Fabric (Sprint 4)  
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**:  
As a Data Scientist, I want churn and CLV scores exported from Databricks into Fabric so that business dashboards can consume and validate predictive insights.  

**Learning Resources**:  
- [Batch Scoring on Databricks](https://docs.databricks.com/en/machine-learning/model-inference/index.html)  
- [MLflow Model Registry](https://mlflow.org/docs/latest/model-registry.html)  
- [Fabric Data Factory](https://learn.microsoft.com/en-us/fabric/data-factory/)  

**Key Concepts**:  
- Batch-scored outputs (`customer_id`, churn probability, CLV value) must be stored in Gold.  
- Export scored tables as Parquet with manifest for ingestion into Fabric.  
- Validation in Fabric ensures alignment between Databricks predictions and Power BI dashboards.  
- This closes the loop between Data Science and BI.  

**Acceptance Criteria**:  
- Scored churn and CLV tables saved in `customer_scores_gold`.  
 - Files exported as Parquet + manifest for Fabric. Include `_SUCCESS` and follow Ops runbook (Appendix B) for manual transfer on free tiers.  
- Export process documented and tested **using manual download from Databricks Free Edition and manual upload into Fabric Lakehouse** (no automated integration in free tier).  
- Fabric Data Pipeline ingests scores into Lakehouse tables.  
- Power BI dashboards (Feature 4.2) consume these tables for segmentation and risk views.  

**Tasks (15 tasks, numbered)**  
🟥 1) Confirm scored output schemas and partitions; align with DA on fields/buckets needed in dashboards.  
🟥 2) Fix model/feature versions; record MLflow run IDs and registry versions for traceability.  
🟥 3) Run batch scoring in Databricks Free Edition; write outputs to Gold `customer_scores_gold` with version columns.  
🟥 4) Validate the Gold write in Databricks (row counts, nullability); snapshot a small sample for later alignment.  
🟥 5) Export scored tables to Parquet and write `_SUCCESS` in the release folder.  
🟥 6) Generate `scores_manifest.json` (schema, files, counts, checksums optional, versions, run_ids, created_ts, as_of_date).  
🟥→🟩 7) Package a versioned release structure under `/Files/<release>/scores/...` and document folder conventions.  
🟥→🟩 8) Manually transfer Parquet + manifest from Databricks Free to Fabric Lakehouse `/Files/<release>/scores/...`.  
🟩 9) Configure Fabric Data Pipeline mappings to create/overwrite Delta tables for scores; set dtypes and keys.  
🟩 10) Run the pipeline; validate counts and basic bounds in the Lakehouse; fix dtype/precision mismatches.  
🟩 11) Bind dashboards to ingested tables; refresh visuals; confirm segments/KPIs align (formatting/time zones consistent).  
🟥→🟩 12) Run spot checks (e.g., 100 rows) between Databricks and Fabric with tolerance (e.g., 1e-6 for floats); record a QA report.  
🟥→🟩 13) Document validations, limitations, and caveats (types/time zones/rounding); capture before/after screenshots.  
🟥→🟩 14) Finalize evidence links, ownership, and re-run/rollback guidance; maintain versioned releases and a `current` pointer/view.  
🟥→🟩 15) Stakeholder walkthrough with DA/DS; capture follow-ups and open DevOps items if discrepancies remain.  

**Deliverables**  
- `customer_scores_gold` in Databricks and Fabric Lakehouse Delta tables.  
- Parquet export + `_SUCCESS` + `scores_manifest.json`.  
- Fabric Data Pipeline mapping config/evidence and QA validation report.  
- Short README detailing schema, transfer steps, and dashboard binding verification.  
- Schema contract: see `docs/scores_manifest.schema.json`; Fabric QA: see `docs/fabric_lakehouse_qa.sql`.  

**User Stories (breakdown)**  
- As a DS/DE, I export scored tables with manifest and validate Fabric ingestion.  
- As a DA, I confirm dashboards consume the new tables consistently.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–4]: Confirm schemas/versions; run batch scoring to Gold; initial validation and sample snapshot.  
- Day 2 [Tasks 5–8]: Export Parquet + `_SUCCESS`; generate manifest; package release; manual transfer to Fabric `/Files`.  
- Day 3 [Tasks 9–11]: Configure/run Fabric Pipeline; validate Lakehouse tables; bind dashboards and refresh.  
- Day 4 [Tasks 12–14]: Spot checks with tolerance; document validations; finalize evidence/ownership and rollback guidance.  
- Day 4.5 [Tasks 15]: Stakeholder walkthrough; capture follow-ups and open DevOps items if needed.  

#### Notes — Feature 4.3 (day-by-day + how-to)
- Scores schema: include `model_version`, `feature_version`, `as_of_date`, `scored_ts`; define buckets if used in visuals.  
- Transfer: Free Edition requires manual download/upload; maintain the same folder structure under `/Files/<release>/`.  
- Ingestion: prefer overwrite for a release; validate dtypes and key uniqueness in the Lakehouse.  
- Alignment: compare sample predictions between Databricks and Fabric after ingestion; check rounding/time zone impacts.  
- Evidence: keep a short checklist with counts, value bounds, and a link to the dashboard that uses the ingested table.  
 - Versioning & lineage: record MLflow run IDs, model registry versions, feature set version, and training data snapshot/Delta version in the `scores_manifest.json`.  
 - Bucketing reproducibility: if using deciles/thresholds, include bucket edges in the manifest so Fabric reproduces the same buckets; avoid recomputing deciles on a different population.  
 - Manifest fields (scores): `table`, `schema` (name, dtype, nullability), `files`, `row_counts`, optional `checksums`, `model_version`, `feature_version`, `created_ts`, `as_of_date`, `run_ids`, and sample size used for spot checks.  
 - Dtype/time zone mapping: map floating scores to DOUBLE/DECIMAL consistently; store timestamps in UTC; document any conversions (UTC → local) and rounding rules used in dashboards.  
   - QA in Fabric (quick SQLs): check distinct `customer_id`, null rates, bounds (`0<=churn_score<=1`, `clv_pred>=0`), distribution by `churn_bucket`, and latest `as_of_date`. See Appendix A – DQ Thresholds & Tests for acceptance thresholds.  
 - Spot checks: randomly sample 100 rows before/after ingestion and compare values within a small tolerance (e.g., 1e-6 for floats); save the diff summary as an artifact.  
 - Error triage & rollback: keep releases in versioned folders; if ingestion for a table fails, fix dtype/mapping and re-run only that table; maintain a `current` pointer (shortcut or view) to the latest good release.  
 - Security/PII: export only needed columns (`customer_id`, scores, versions, dates); avoid leaking raw attributes not required by dashboards.  
 - Dashboard alignment: confirm measures/format strings (percentage/decimal places) and time zone usage match between Databricks samples and Fabric visuals to avoid perceived discrepancies.  
 - Evidence package: link to manifest, Pipeline run, Lakehouse table, and dashboard; attach screenshots of a validation visual and the QA report.  


---

<a id="epic-5"></a>
## Optional Extensions

<a id="feature-5-1"></a>
### Feature 5.1 (DE) – Simplified Data Vault in Silver  
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
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

**Tasks (15 tasks, numbered)**  
**Tasks (numbered)**  

1) 🟥 [DBX-DE-Prof][Modeling][Governance]  
Define Data Vault standards: naming conventions, BK normalization (upper/trim), hash algorithm (e.g., sha2), delimiter policy, null handling, `record_source`, and audit columns (`load_ts`, `batch_id`).  

2) 🟥 [DBX-DE-Assoc][Delta-Basics][Modeling]  
Build `silver.customer_hub`: deduplicate/harmonize business keys, compute `customer_hk`, enforce uniqueness (constraints/checks), add lineage/audit fields.  

3) 🟥 [DBX-DE-Assoc][Delta-Basics][Modeling]  
Build `silver.product_hub`: normalize `sku/product_code`, compute `product_hk`, enforce uniqueness, and add lineage/audit fields.  

4) 🟥 [DBX-DE-Assoc][Modeling]  
Build `silver.calendar_hub`: generate required date range, decide natural vs hashed key (`date_key` vs `date_hk`), and persist attributes (year, month, day).  

5) 🟥 [DBX-DE-Assoc][Delta-MERGE][Testing]  
Implement idempotent hub loads: MERGE on BK hashes or deterministic `replaceWhere` windows; validate re-run yields identical end state.  

6) 🟥 [DBX-DE-Assoc][Modeling]  
Design `silver.sales_link`: define grain (e.g., order_line), compute `sales_lk` as hash of participating hub keys, carry minimal invariants (e.g., source_system).  

7) 🟥 [DBX-DE-Assoc][Testing]  
Resolve FKs from cleaned sales to hubs: handle late-arriving/unknown keys with sentinel HKs, log exceptions, and persist a reconciliation table.  

8) 🟥 [DBX-DE-Assoc][Delta-MERGE][Testing]  
Load `silver.sales_link` idempotently: apply constraints (non-null HKs), RI checks (anti-joins), and uniqueness on `sales_lk`; measure violations and fix.  

9) 🟥 [DBX-DE-Prof][Modeling]  
Design `silver.customer_satellite` (SCD2): choose descriptive attributes (country, segment), define SCD2 columns (`effective_from`, `effective_to`, `is_current`), and compute change hash.  

10) 🟥 [DBX-DE-Assoc][Spark-Aggregations][Testing]  
Implement SCD2 change detection: window over BK, compare change hashes, close/open rows with correct timestamps; ensure no overlaps and time-travel correctness.  

11) 🟥 [DBX-DE-Assoc][Modeling]  
Add a second satellite (optional but recommended): `silver.product_satellite` for category/brand with SCD2 handling and change hash.  

12) 🟥 [DBX-DE-Assoc][Platform][Optimization]  
Performance & storage: choose partitioning/Z-ORDER (e.g., by `effective_from` or `order_date`), compact small files, set table properties (e.g., retention/VACUUM policy).  

13) 🟥 [DBX-DE-Prof][Testing][Monitoring-Logs]  
Data quality & RI validation: cardinality checks (1:1 hubs, 1:N link), orphan detection, duplicate rates; publish a DV QA report table with metrics per entity.  

14) 🟥 [DBX-DE-Prof][Governance][Docs]  
Documentation & contracts: publish DV schema contracts, Mermaid diagram (hubs/links/sats), BK→HK rules, SCD2 policy, and integration notes for Gold derivations.  

15) 🟥 [DBX-DE-Prof][Testing][Ops]  
Integration validation: derive a thin Gold (e.g., `sales_daily`) from DV components and reconcile KPIs vs existing Gold; write a short runbook and rollback steps.  


**User Stories (breakdown)**  
- As a DE, I create hubs/links/satellites that integrate with existing Silver/Gold contracts.  
- As a DA/DS, I query hubs/links for consistent keys and history.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- **Day 1 [Tasks 1–5]:** Define DV standards; build hubs (customer/product/calendar); implement idempotent hub load and validate re-run.  
- **Day 2 [Tasks 6–8]:** Design/load `sales_link`; resolve FKs and unknowns; enforce RI/uniqueness and idempotent link loads.  
- **Day 3 [Tasks 9–11]:** Design/implement SCD2 for `customer_satellite`; add `product_satellite`; validate no overlaps.  
- **Day 4 [Tasks 12–14]:** Tune partitioning/compaction; run DV QA (cardinality/orphans/dupes); finalize contracts and diagrams.  
- **Day 4.5 [Task 15]:** Derive thin Gold from DV and reconcile KPIs; document runbook and rollback steps.  

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
- No Airflow jobs in Fabric free/student and no Databricks tokens in Databricks Free: CI/CD and orchestration must be simulated (documented steps, local GitHub Actions for tests only).
- SCD2 management is manual: track changes with effective dates and handle historical data in the application logic.

<a id="feature-5-2"></a>
### Feature 5.2 (DA) – Advanced Segmentation & Dynamic Dashboards  
Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**  
As a Data Analyst, I want to implement advanced segmentation logic and dynamic drill-through dashboards so that business stakeholders can interactively explore customer behavior (RFM segments, churn risk, CLV tiers) across multiple dimensions.

**Learning Resources**  
- [Power BI What-if parameters](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-what-if)  
- [Drillthrough in Power BI](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-drillthrough)  
 - [Field parameters](https://learn.microsoft.com/en-us/power-bi/create-reports/power-bi-field-parameters)  
 - [Bookmarks and Selection pane](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-bookmarks)  
 - [Performance Analyzer](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-performance-analyzer)  
 - [Accessibility in Power BI](https://learn.microsoft.com/en-us/power-bi/create-reports/desktop-accessibility-creating-reports)  
 - [Row-level security (RLS) in Power BI models](https://learn.microsoft.com/en-us/power-bi/enterprise/service-admin-rls)  


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
 - Methods banner visible on every page (active thresholds/snapshot).  
 - Field parameters toggle measure and dimension families.  
 - RLS validated in Service using "View as"; measures behave under role filters.  
 - Performance: median visual time improved ≥ 30% vs baseline; no visual > 2s.  
 - Accessibility: color contrast ≥ 4.5:1, keyboard focus order set, alt text on key visuals, consistent formats.  

**Tasks**  

1) 🟨 [DBX-DA-Assoc][Modeling]
Define dynamic segmentation rules (RFM buckets, churn cutoff, CLV tiers); document defaults.

2) 🟨 [DBX-DA-Assoc][Dashboards]
Implement What-if parameters (recency window, churn cutoff, CLV tier cutpoints).

3) 🟨 [DBX-DA-Assoc][Dashboards][Modeling]
Build parameter/measure tables; bind measures to parameters.

4) 🟨 [DBX-DA-Assoc][Dashboards][Modeling]
Create field parameters for dimension and measure switching; wire to visuals.

5) 🟨 [DBX-DA-Assoc][Dashboards]
Create drill-through pages (Segment detail, Customer detail) with Back buttons.

6) 🟨 [DBX-DA-Assoc][Dashboards]
Add tooltip pages (mini profile).

7) 🟨 [DBX-DA-Assoc][Dashboards][Docs]
Add a Methods banner (DAX) with active thresholds and snapshot.

8) 🟩 [DBX-DA-Assoc][Platform][Modeling]
Connect to Gold customer_360 and customer_scores_gold; validate relationships/counts.

9) 🟩 [DBX-DA-Assoc][Governance][Security]
Implement and test RLS (BrandManager, Executive) in Desktop/Service.

10) 🟨 [DBX-DA-Assoc][Optimization][Performance]
Optimize performance (reduce visuals, aggregations if needed, avoid high-card slicers).

11) 🟨 [DBX-DA-Assoc][Dashboards]
Configure bookmarks and sync slicers; verify interactions.

12) 🟨 [DBX-DA-Assoc][Accessibility]
Accessibility pass (contrast, focus order, alt text, formats).

13) 🟨 [DBX-DA-Assoc][Testing][Dashboards]
Validate cross-highlighting and edge cases (empty/ALL segments, mobile).

14) 🟨 [DBX-DA-Assoc][Docs][Governance]
Document thresholds, navigation map, screenshots, RLS notes in README.

15) 🟨 [DBX-DA-Assoc][Modeling][Optional]
(Optional) Calculation groups for dynamic formatting/switching.

**User Stories (breakdown)**  
- As a DA, I deliver dynamic segmentation with What‑if parameters and drill‑through.  
- As a Marketing user, I can navigate from KPIs to segment to customer.  

### Sprint day plan (4.5 days)
Note: plan ~70% capacity for committed tasks and reserve ~30% for buffer, unplanned work, and spillover.
- Day 1 [Tasks 1–3]: Define segmentation logic and default thresholds; set up What‑if parameters and parameter/measure tables; align with stakeholders.  
- Day 2 [Tasks 4, 11 (init), 13 (init)]: Build dynamic visuals with field parameters and wire measure/dimension switching; start bookmarks/sync slicers; verify cross‑highlighting on main pages.  
- Day 3 [Tasks 5–6, 11 (back nav)]: Create drill‑through pages (Segment and Customer detail) with Back buttons; add tooltip pages; refine bookmarks/navigation flows.  
- Day 4 [Tasks 8–10, 7, 12, 11 (final), 13 (edge cases)]: Connect to Gold tables and validate relationships/counts; implement and test RLS; optimize performance (aggregations if needed); add Methods banner with active thresholds/snapshot; run accessibility pass; finalize bookmarks/sync; test edge cases and mobile.  
- Day 4.5 [Tasks 14, 15 (optional)]: Buffer; document thresholds, navigation map, screenshots, and RLS notes in README; consider calculation groups for dynamic formatting/switching.  

Note: Some items intentionally span days (bookmarks/interactions and cross‑highlighting) to align with RLS and performance tuning.

#### Advanced notes — Dynamic segmentation, DAX patterns, performance/RLS

- DAX snippets (adapt names to your model)
    - RFM bucket (example thresholds):
       ```
       RFM Bin =
          VAR R = [RecencyDays]
          VAR F = [Frequency365d]
          VAR M = [AvgOrderValue]
          VAR rBin = SWITCH(TRUE(), R <= 30, "R3", R <= 90, "R2", "R1")
          VAR fBin = SWITCH(TRUE(), F >= 6, "F3", F >= 2, "F2", "F1")
          VAR mBin = SWITCH(TRUE(), M >= 100, "M3", M >= 40, "M2", "M1")
          RETURN rBin & fBin & mBin
       ```
    - What‑if binding example (parameter `ChurnCutoff%`):
       ```
       Churn Risk Band =
          VAR p = [Churn Probability 90d]
          VAR cutoff = SELECTEDVALUE('ChurnCutoff%[ChurnCutoff Value]', 0.30)
          RETURN IF(p >= cutoff, "High", IF(p >= cutoff*0.67, "Med", "Low"))
       ```
    - CLV tiers (simple tiers):
       ```
       CLV Tier =
          VAR v = [CLV 12m]
          RETURN SWITCH(TRUE(), v>=1000,"T1", v>=500,"T2", v>=200,"T3", "T4")
       ```
    - Methods banner:
       ```
       Methods Banner =
          "Segmentation: RFM=" & [RFM Threshold Label] &
          " | ChurnCutoff=" & FORMAT(SELECTEDVALUE('ChurnCutoff%[ChurnCutoff Value]',0.3), "0%") &
          " | Snapshot=" & FORMAT([Snapshot Date], "yyyy-mm-dd")
       ```

- Field parameters
    - Two parameters: Dimension switcher (Brand, Region, Segment) and Measure switcher (Risk%, CLV, Txns).

- Performance
    - Prefer Direct Lake or Import for key visuals; if DirectQuery, use aggregations and limit visuals; enable query reduction.
   See **Appendix C — Shared NFRs & Conventions**.



<a id="feature-5-3"></a>
### Feature 5.3 (DS) – Survival & Probabilistic Models for Churn and CLV  

Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**  
As a Data Scientist, I want to implement advanced survival analysis and probabilistic models so that stakeholders gain deeper insights into customer lifetime and churn timing, beyond standard classification/regression.  

 

#### Learning Resources (Standard)  
- [Survival Analysis in Python (lifelines)](https://lifelines.readthedocs.io/en/latest/)  
- [BG/NBD – step-by-step derivation (Fader, Hardie & Lee, 2019, PDF)](https://www.brucehardie.com/notes/039/bgnbd_derivation__2019-11-06.pdf)  
- [The Gamma-Gamma Model of Monetary Value](https://www.brucehardie.com/notes/025/gamma_gamma.pdf)  
- [Sequential Deep Learning with PyTorch](https://pytorch.org/tutorials/beginner/basics/intro.html)  
- [BTYD models notebook on Databricks](https://www.databricks.com/notebooks/Customer%20Lifetime%20Value%20Virtual%20Workshop/02%20The%20BTYD%20Models.html)  
- [scikit-survival documentation (Cox PH, IBS, calibration)](https://scikit-survival.readthedocs.io)  
- [Therneau — Proportional Hazards tests (cox.zph vignette)](https://cran.r-project.org/package=survival)  
- [lifetimes (Python) docs — BG/NBD & Gamma-Gamma](https://lifetimes.readthedocs.io)  
- [Fader & Hardie BTYD resource hub](https://www.brucehardie.com)  
- [scikit-learn — Probability calibration (reliability curves)](https://scikit-learn.org/stable/modules/calibration.html)  
- [MLflow — Tracking and Model Registry](https://mlflow.org/docs/latest/tracking.html)  
- [Delta Lake — MERGE, constraints, replaceWhere](https://docs.databricks.com/delta/)  

#### PhD-Level / Advanced References  
- [Harrell (2015) — Regression Modeling Strategies (Springer, 2nd ed.)](https://link.springer.com/book/10.1007/978-3-319-19425-7)  
- [Klein & Moeschberger (2005) — Survival Analysis: Techniques for Censored and Truncated Data (Springer)](https://link.springer.com/chapter/10.1007/0-387-21645-6_13)  
- [Hosmer, Lemeshow & May (2008) — Applied Survival Analysis: Regression Modeling of Time-to-Event Data (Wiley)](https://www.wiley.com/en-us/Applied+Survival+Analysis%3A+Regression+Modeling+of+Time+to+Event+Data%2C+2nd+Edition-p-9780471754992)  
- [Bishop (2006) — Pattern Recognition and Machine Learning (Springer)](https://www.springer.com/gp/book/9780387310732)  
- [Goodfellow, Bengio & Courville (2016) — Deep Learning (MIT Press)](https://www.deeplearningbook.org/)  

**Key Concepts**  
- **Survival models** predict *time until churn*, producing hazard curves and probabilities per customer.  
- **BG/NBD (Beta-Geometric/Negative Binomial Distribution) & Gamma-Gamma models** estimate **CLV (Customer Lifetime Value)** using probabilistic purchase frequency and monetary value.  
- **Sequential deep learning (optional)** models customer purchase history as a sequence for richer churn signals.  

##### Explanation
- Why survival? We often don't observe churn for everyone (right-censoring). Survival models estimate the time-to-event and produce calibrated risk by horizon (30/60/90d).  
- Hazard vs survival: hazard is instantaneous risk at time t; survival S(t) is probability the customer remains active by t. Churn probability by horizon ≈ 1 − S(h).  
- BG/NBD + Gamma-Gamma intuition: in non-contractual settings we infer "alive" status from purchase patterns. Combine BG/NBD (frequency) with Gamma-Gamma (monetary value) to estimate **CLV (Customer Lifetime Value)**.  
- Censoring and leakage: fix an as-of date; build features only from data before it; label churn using a forward inactivity window (e.g., 90 days).  
- Calibration matters: risk buckets should match observed rates; check reliability plots and adjust thresholds accordingly.  
- Choose the tool: need churn timing bands → survival; need expected purchases/CLV → BG/NBD + Gamma-Gamma; need richer patterns → optional sequence model (LSTM/Transformer).  

**Acceptance Criteria**  
- Train a Cox Proportional Hazards or BG/NBD model for churn timing.  
- Fit Gamma-Gamma or Bayesian model for CLV distribution.  
- Visualize survival curves and CLV probability distributions for segments.  
- Compare survival/CLV outputs against RFM-based baselines.  
- Document in README with plots and interpretation (e.g., "50% of Segment A expected to churn within 6 months").  

**Tasks**  
1) 🟥 [DBX-DS-Assoc][DataPrep] Prepare survival dataset (event = churn, duration = days since last purchase).  
2) 🟥 [DBX-DS-Assoc][Modeling][Lifelines] Train Cox model or Kaplan-Meier survival curves using lifelines.  
3) 🟥 [DBX-DS-Assoc][Modeling][BTYD] Implement BG/NBD and Gamma-Gamma CLV model with the lifetimes package.  
4) 🟥 [DBX-DS-Assoc][Visualization][Docs] Generate visualizations (hazard curves, CLV distributions).  
5) 🟥 [DBX-DS-Prof][Modeling][DeepLearning] (**PhD-level - Optional**) Prototype a sequential NN model (LSTM/Transformer) for churn prediction.  
6) 🟥 [DBX-DS-Assoc][Docs][Evaluation] Document findings and compare with baseline tree-based models.  
7) 🟥 [DBX-DS-Assoc][Governance][DataPrep] Fix as-of date, churn horizon, and censoring rules; implement leakage guardrails (features pre as-of only, labels from forward inactivity window).  
8) 🟥 [DBX-DS-Assoc][Modeling][Platform] Build survival and BTYD modeling frames; persist feature views with version metadata (snapshot, schema hash).  
9) 🟥 [DBX-DS-Assoc][Testing][Evaluation] Create temporal splits with rolling-origin backtests; include segment-wise evaluation (brand/region).  
10) 🟥 [DBX-DS-Prof][Testing][Evaluation] Validate assumptions: Cox PH tests; BG/NBD and Gamma-Gamma convergence/identifiability; record diagnostics.  
11) 🟥 [DBX-DS-Assoc][Metrics][Evaluation] Compute metrics: C-index, IBS, calibration/reliability plots; lift/gains for top-N; CLV error (MAPE/RMSE).  
12) 🟥 [DBX-DS-Assoc][Calibration][Evaluation] Calibrate and set acceptance thresholds and operating points by horizon (30/60/90d).  
13) 🟥 [DBX-DS-Assoc][Ops][Tracking] Track runs in MLflow (params, metrics, artifacts, seeds); record data snapshot IDs and environment details.  
14) 🟥 [DBX-DS-Assoc][Ops][Platform] Score full population; write customer_scores_gold idempotently (MERGE/replaceWhere); enforce Delta constraints (keys, bounds 0–1).  
15) 🟥→🟩 [DBX-DS-Assoc][Testing][Ops] Run E2E checks: bounds/nulls/joins; BI spot-checks in Power BI; verify "Today looks normal?" banner behavior.  
16) 🟥→🟩 [DBX-DS-Assoc][Governance][Docs] Hand-off to Feature 3.4: field list (risk bands, CLV tiers), RLS awareness, and dashboard binding notes.  
17) 🟥 [DBX-DS-Prof][Monitoring][Testing] (**Advanced**) Monitoring: feature drift (PSI), performance stability by brand/region, fairness checks; set weekly report and alert thresholds.  
18) 🟥 [DBX-DS-Assoc][Docs][Governance] Documentation: plots, acceptance thresholds, runbook, risks/mitigations, reproducibility notes (seeds, as-of, schema).  
19) 🟥 [DBX-DS-Prof][Modeling][DeepLearning] (**PhD-level - Optional**) Prototype sequence model (LSTM/Transformer) as comparator; document performance/calibration deltas.  
20) 🟥 [DBX-DS-Prof][Bayesian][Modeling] (**PhD-level - Optional**) Implement Bayesian survival analysis (e.g., PyMC, Stan) for churn timing; compare posterior intervals with frequentist estimates.  
21) 🟥 [DBX-DS-Prof][CausalInference][Modeling] (**PhD-level - Optional**) Apply causal inference to churn interventions (e.g., uplift modeling, treatment effect estimation); test campaign targeting strategies.  
22) 🟥 [DBX-DS-Prof][Explainability][Evaluation] (**PhD-level - Optional**) Use SHAP/Integrated Gradients for survival & CLV models; document how feature effects vary over time and by horizon.  
23) 🟥 [DBX-DS-Prof][Fairness][Monitoring] (**PhD-level - Optional**) Audit churn models for bias/fairness across segments; log fairness metrics in monitoring pipeline.  
24) 🟥 [DBX-DS-Prof][Research][Docs] (**PhD-level - Optional**) Write a research-style technical note (5–10 pages) summarizing methodology, statistical assumptions, diagnostics, and managerial implications.  
 

**User Stories (breakdown)**  
- As a DS, I estimate churn timing and CLV distributions and compare to baselines.  
- As a DA, I receive segment-level visuals (survival/CLV).  

### Sprint day plan (4.5 days)

- **Day 1 (Tasks 1, 7, 8):** Prepare datasets with censoring rules and define the time origin. Validate churn horizons and event definitions, and perform sanity checks.  
- **Day 2 (Tasks 2, 9, 10):** Train Cox/Kaplan-Meier models, run proportional hazards tests, and start rolling-origin backtests with initial segment-level evaluations.  
- **Day 3 (Tasks 3, 10):** Implement BG/NBD and Gamma-Gamma models, initialize parameters, and check convergence and plausibility against observed patterns.  
- **Day 4 (Tasks 4, 11, 12):** Build survival and CLV visualizations, compute quantiles and calibration metrics, compare against baselines, and define operating thresholds by horizon.  
- **Day 4.5 (Tasks 13, 18):** Consolidate documentation, capture seeds and reproducibility notes (MLflow run IDs, snapshot IDs), and finalize acceptance thresholds.  
We'll commit ~70% of capacity and treat ~30% as stretch ('Free time') to protect quality; anything not done flows forward without blame.

> This 4.5-day plan focuses on the **core deliverables** that can be realistically achieved within the sprint.  
> More advanced tasks — such as deep learning, Bayesian survival, causal inference, or fairness audits — are intentionally excluded from this tight timeline.  
> They remain available as **optional explorations** for those who are curious and motivated to go further, either during the sprint if time allows, or afterwards as part of continuous learning and professional growth.

#### Advanced notes — Survival / BTYD / Deep Learning / Bayesian / Causal / Fairness (PhD-level)

- **Survival (time-to-churn)**  
   - Time origin: first purchase vs cohort entry; clock resets on purchase or uses renewal-type survival; define censoring at snapshot.  
   - Models: Kaplan-Meier (non-param), Cox PH (semi-param; check PH via Schoenfeld residuals), AFT (log-normal/log-logistic), time-varying covariates for recency/frequency windows.  
   - Outputs per customer: S(t) survival curve, hazard(t), churn_prob_30d/60d/90d, expected time-to-churn (E[T|x]).  
   - Metrics: concordance index (C-idx), IBS (Integrated Brier Score), calibration by horizon (reliability), segment C-idx deltas.  

- **BTYD (repeat-purchase CLV)**  
   - BG/NBD for purchase frequency: parameters {r, α, a, b}; initialization via method-of-moments then MLE; guardrails: r, a, b > 0; α > 0.  
   - Gamma-Gamma for monetary value: parameters {p, q, γ}; validate independence from frequency.  
   - Outputs: prob_alive, expected_txns_H (e.g., 90d/180d/365d), clv_H (combine with Γ-Γ), credible intervals via param bootstrap.  
   - Diagnostics: QQ plots of monetary, KS on inter-purchase times, posterior checks; lift vs RFM.  

- **Sequential Deep Learning (optional)**  
   - Sequence building: sessionized purchases; embeddings for product/brand/channel; positional encodings; masking.  
   - Models: LSTM, GRU, Transformer encoder.  
   - Training: truncated backprop through time, padding/masking, dropout for regularization.  
   - Outputs: next-event prediction, churn probability, expected horizon.  
   - Risks: overfitting small datasets; interpretability (explain with SHAP/attention weights).  

- **Bayesian Survival & CLV**  
   - Tools: PyMC, Stan, or TensorFlow Probability.  
   - Survival: Bayesian Cox or Weibull models; posterior intervals capture churn horizon uncertainty.  
   - CLV: hierarchical Gamma-Poisson (BG/NBD) or Gamma-Gamma with priors on heterogeneity; posterior predictive checks required.  
   - Advantages: full uncertainty quantification, flexible priors for business knowledge.  
   - Outputs: posterior distributions for churn timing, CLV, and segment-level heterogeneity.  

- **Causal Inference for Churn Interventions**  
   - Framing: uplift modeling / treatment effect estimation (who benefits from a retention campaign?).  
   - Methods: causal forests, doubly-robust estimators, propensity score weighting, CATE (Conditional Average Treatment Effect).  
   - Evaluation: Qini and uplift curves, policy gain metrics.  
   - Business value: identify "persuadables" (customers at high churn risk but campaign-sensitive).  

- **Explainability & Interpretability**  
   - Tools: SHAP, Integrated Gradients, LIME adapted for survival models.  
   - Survival: partial dependence of hazard with respect to covariates; horizon-specific SHAP values.  
   - CLV: drivers of high/low CLV (price sensitivity, frequency, tenure).  
   - Output: "Top features driving churn in 90d vs CLV uplift segments."  

- **Fairness & Monitoring**  
   - Metrics: disparate impact, equal opportunity difference, calibration parity across segments.  
   - Monitoring: PSI drift per feature, churn prevalence drift, fairness drift across gender/region/brand.  
   - Ops: weekly fairness report, alerts when metrics exceed tolerance.  
   - Goal: avoid biased churn predictions that systematically over/underestimate risk for sub-groups.  

- **Research & Documentation**  
   - Deliverables: a research-style technical note (5–10 pages) structured like an academic paper (Intro, Methods, Results, Discussion).  
   - Content: statistical assumptions, diagnostics, managerial implications, limitations, reproducibility (seed, snapshot, version).  
   - Bonus: prepare slides with hazard curves, uplift charts, and fairness dashboards → useful for job interviews and portfolio.  

#### PhD Enhancements — Survival / BTYD / Advanced DS

To extend the advanced notes into true PhD-level depth, students should also:

- **Mathematical Derivations**
  - Write out the **partial likelihood** of the Cox PH model and derive the score equations.
  - Derive the **BG/NBD likelihood function** from first principles (purchase process + dropout process).
  - Work through the **Gamma–Gamma model** assumption of independence between frequency and monetary value, and test this assumption empirically.

- **Simulation Studies**
  - Simulate censored survival data with known hazard rates (e.g., exponential, Weibull) and verify recovery of parameters by Cox PH and AFT models.
  - Generate synthetic purchase data (Poisson–Gamma mixtures) and check if BG/NBD recovers true parameters.
  - Stress test calibration: simulate non-stationary hazards and show when survival models mis-calibrate.

- **Theoretical Assumptions**
  - Explore **proportional hazards violations** (time-varying covariates, non-linear effects).
  - Test independence assumptions in BTYD models using correlation and posterior predictive checks.
  - Formalize **prior elicitation** for Bayesian survival/BTYD (e.g., Gamma priors for rates, Dirichlet for mixtures).

- **Proof-of-Concept Code / Research Repos**
  - Replicate examples from:
    - [`scikit-survival`](https://scikit-survival.readthedocs.io/) (Cox, AFT, IBS).
    - [`lifetimes`](https://lifetimes.readthedocs.io/) (BG/NBD, Gamma-Gamma).
    - [`lifelines`](https://lifelines.readthedocs.io/en/latest/) (Kaplan–Meier, Cox, Aalen).
  - Extend notebooks by adding bootstrap confidence intervals, posterior predictive checks, or causal adjustments.

- **Canonical Book References**
  - Klein & Moeschberger — *Survival Analysis: Techniques for Censored and Truncated Data* (Springer, 2003)  
  - Hosmer, Lemeshow & May — *Applied Survival Analysis: Regression Modeling of Time-to-Event Data* (Wiley, 2008)  
  - Harrell — *Regression Modeling Strategies* (Springer, 2015)  
  - Fader & Hardie — *Customer Base Analysis with Probability Models* (various working papers, 2005–2019)  
  - Gelman et al. — *Bayesian Data Analysis* (CRC Press, 2013)  
  - Pearl, Glymour & Jewell — *Causal Inference in Statistics: A Primer* (Wiley, 2016)  

- **Extra PhD-Level Research Directions**
  - Investigate **causal survival analysis** (treatment effects on churn with time-to-event outcomes).
  - Explore **hierarchical BTYD models** (brand/region random effects).
  - Compare **Bayesian vs frequentist calibration** for churn probabilities.
  - Prototype **sequence models** (RNNs/Transformers) with time-gap embeddings, and benchmark vs BTYD survival curves.

---

## Appendices

### Appendix A — DQ Thresholds & Tests (Prototype)

Scope: minimal, consistent checks to build trust. Apply at layer handoffs and export.

- Row count reconciliation: Raw→Bronze and Bronze→Silver within ±1.0% unless explained; list exclusions explicitly.  
- Duplicate rate on BK (order_id, sku, customer_id, order_date): ≤ 0.5% after Silver; document residuals.  
- Nulls on business keys: ≤ 0.1% in Silver; none allowed in Gold facts/dims (enforce NOT NULL).  
- FX coverage: ≥ 99.5% of monetary rows have a matching FX rate for the chosen valuation date; missing handled per policy, counts reported.  
- Monetary precision: amounts DECIMAL(18,2); rates DECIMAL(18,8); rounding HALF_UP at final step.  
- Score bounds (Feature 4.3): 0 ≤ churn_score ≤ 1; clv_pred ≥ 0; no NaN/Inf; bucket definitions fixed per manifest.  
- Fabric ingestion QA: counts match manifest within tolerance; dtype/nullability preserved; latest `as_of_date` present; partition uniqueness holds.  

Outputs and evidence
- Persist a small `monitor.*` table per layer (e.g., `monitor.dq_bronze_daily`, `monitor.dq_silver_daily`) with counts and key null/dup metrics.  
- Store a one‑pager per sprint with the metrics and variances; link any Azure DevOps DQ bugs.  
- For exports, attach `release_manifest.json`/`scores_manifest.json` and a tiny CSV summary of counts/checksums.

### Appendix B — Ops & Observability Runbook (Free/Trial tiers)

Purpose: codify manual steps and health checks in free/trial environments.

Run patterns
- Idempotent writes: MERGE on keys or deterministic overwrite by date window (`replaceWhere`).  
- Export contract: Parquet files coalesced to 128–512MB, `_SUCCESS` marker, versioned manifest with schema/counts/checksums.  
- Manual transfer: download from Databricks, upload to Fabric Lakehouse `/Files/dropzone/<release>/...`; keep folder structure identical.  

Health checks (post‑write/post‑ingest)
- Row counts within Appendix A tolerance; primary key uniqueness; partition completeness; file count sanity.  
- Score bounds and dtypes; timestamps in UTC; latest `as_of_date` available.  
- Power BI smoke: a small visual reads the dataset without errors; Performance Analyzer notes captured.

Recovery steps
- If counts drift > threshold: rerun the affected window; compare manifest vs Lakehouse; reopen DQ bug with evidence.  
- If dtype mismatch: adjust Fabric mapping and re‑ingest the specific table; do not mass‑recreate if avoidable.  
- If dashboard broken: rebind dataset; refresh; verify lineage; consult Methods banner and RLS matrix.

Ownership & cadence
- DE owns exports/ingest; DA owns dashboards; DS owns scores; PO reviews evidence weekly.  
- Cadence: daily refresh target; promotion via Fabric Deployment Pipelines when applicable.


<a id="feature-5-4"></a>
### Feature 5.4 (All) – Orchestration & E2E Deployment (Airflow + Fabric)

Owner | Status | Effort | Dependencies
---|---|---|---
*Single-threaded owner* | *Progress state (Draft / Planned / In Progress / Blocked / Done)* | *T-shirt sizing (S / M / L / XL)* | *Prereqs or links to other features (anchor or note)*
TBD | Draft | M | -
**User Story**  
As a Data Engineer, I want to orchestrate the end‑to‑end Databricks → Fabric workflow so releases are reproducible, observable, and easy to re‑run. Airflow is used as an external orchestrator, with a native Fabric Data Pipeline fallback when Airflow is not available.

**Learning Resources**  
- Apache Airflow — DAGs, operators, retries, SLAs: https://airflow.apache.org/  
- Airflow Providers (Azure/AAD/HTTP operators): https://airflow.apache.org/docs/apache-airflow-providers/  
- Microsoft Fabric — Data Pipelines: https://learn.microsoft.com/fabric/data-factory/  
- Fabric Lakehouse overview: https://learn.microsoft.com/fabric/data-engineering/lakehouse-overview  
- Databricks — reliable Delta exports (Parquet, manifests, MERGE/replaceWhere): https://learn.microsoft.com/azure/databricks/delta/

**Key Concepts**  
- Two orchestration modes:
   - External (Airflow): define a DAG that (1) runs Databricks jobs/notebooks to produce Parquet + manifest + _SUCCESS, (2) transfers/places artifacts for Fabric, (3) triggers a Fabric Data Pipeline ingestion, and (4) runs light QA and notifications.
   - Native (Fabric): use Fabric Data Pipelines to orchestrate ingest and promotion; Databricks steps are documented/manual in Free tier.
- Free/Trial constraints: Databricks Free and Fabric Trial/Free typically lack enterprise automation (tokens/Jobs/DLT). When APIs/creds aren't available, simulate steps with manual tasks clearly called out in the runbook and DAG (e.g., a "Manual step" sensor or external task marker).
- Contracts first: rely on release manifests and `_SUCCESS` markers from Features 4.1/4.3 to keep orchestration idempotent and testable.

**Acceptance Criteria**  
- An Airflow DAG exists (or a skeleton with placeholders) that models the E2E flow: export → transfer/place → Fabric ingest → QA → notify.  
- Each step is idempotent, with success markers and clear rerun behavior; retries and failure paths are defined.  
- A native Fabric fallback path is documented (Data Pipeline-only orchestration) for environments without Airflow.  
- A short runbook describes secrets, environment variables, parameters, and manual steps for Free/Trial constraints.  
- Evidence: one dry‑run (or simulated run) captured with logs/screenshots and a QA checklist (row counts vs manifest).

**Tasks**  
🟥→🟩 1) Decide orchestration mode(s) in scope: Airflow external, Fabric native fallback, or both; document constraints (Free/Trial vs Enterprise).  
🟥→🟩 2) Define orchestration contract: inputs (Gold tables), export artifacts (Parquet, `_SUCCESS`, `release_manifest.json`/`scores_manifest.json`), and success/failure signals per stage.  
🟥 3) Parameterize export notebooks/jobs in Databricks (date window, release version); ensure idempotent writes (MERGE/`replaceWhere`) and `_SUCCESS` markers (Feature 4.1/4.3).  
🟥 4) Create a small QA script/notebook to compute row counts and optional checksums pre/post export; write results next to the manifest.  
🟥→🟩 5) Initialize an Airflow DAG (daily or on‑demand) with default args (retries/backoff, SLA, owner); add a "manual gate" boolean param for Free mode.  
🟥 6) Implement task "dbx_export" (Databricks): preferred path is Databricks Jobs/API; Free mode uses a placeholder operator with instructions to run the notebook manually and drop artifacts to the export folder.  
🟥→🟩 7) Implement task "place_artifacts_for_fabric": in Enterprise, automate transfer (e.g., to staging/OneLake/Blob); in Free mode, document manual upload to Fabric Lakehouse `/Files/dropzone/<release>/...` and add a sensor/wait step.  
🟩 8) Implement task "trigger_fabric_ingest": call Fabric Data Pipeline (API/UI). If API access isn't available, mark this as a manual step with a checklist and a confirmation flag in the DAG.  
🟩 9) Implement task "wait_for_fabric_ingest": poll status (API) or use a time‑boxed sensor in Free mode; log outcome and timings.  
🟩 10) Implement task "post_ingest_qa": compare Lakehouse counts vs manifest; verify schema/dtypes and latest partition/date; record a QA report artifact.  
🟥→🟩 11) Implement notifications: success/failure messages to email/Teams/Slack (provider available) with links to manifest, pipeline run, and dashboard.  
🟥→🟩 12) Document secrets/creds: where tokens/Service Principals would live in Enterprise; provide Free‑safe alternatives (manual steps, local env vars).  
🟥→🟩 13) Publish an operations runbook: parameters, schedules, rerun/rollback steps, ownership, and common failure modes; link to Features 4.1/4.3 contracts.  
🟩 14) Provide a native Fabric pathway: a Data Pipeline definition (source: `/Files/dropzone/<release>/...` → Lakehouse tables) and promotion steps; list rules to rebind across stages.  
🟥→🟩 15) Capture evidence: one dry‑run (or simulated Free run) with logs/screenshots, QA checklist, and links; open backlog tickets for any gaps (e.g., API enablement, secrets vault).

**User Stories (breakdown)**  
- As a DE, I can re‑run the E2E flow deterministically via an Airflow DAG or with a documented Fabric pipeline fallback.  
- As a DA/DS, I rely on manifests and QA checks to trust that data in Fabric matches Databricks exports.  
- As an operator, I have a runbook for parameters, retries, and rollback.

**Sprint day plan (4.5 days)**  
- Day 1 [Tasks 1–4]: Choose mode(s), finalize contracts, parameterize exports, and produce QA pre/post scripts.  
- Day 2 [Tasks 5–7]: Scaffold Airflow DAG with export and artifact‑placement steps; wire manual/sensor gates for Free mode.  
- Day 3 [Tasks 8–10]: Trigger/poll Fabric ingest; implement post‑ingest QA and record a results file; handle typical errors.  
- Day 4 [Tasks 11–14]: Add notifications; write secrets/creds guidance; draft runbook; define the Fabric‑only orchestration fallback and promotion notes.  
- Day 4.5 [Task 15]: Perform a dry‑run/simulation; capture evidence; open follow‑up backlog items (e.g., automate transfer in Enterprise).

#### Notes — Airflow vs Fabric (when to use what)
- Start with Fabric Data Pipelines when orchestrating only inside Fabric and manual export from Databricks is acceptable (Free mode).  
- Use Airflow when you need cross‑platform orchestration (Databricks + Fabric + QA + notifications) or plan to evolve to enterprise automation (Jobs/Service Principals, CI/CD).  
- Keep orchestration steps contract‑driven (manifests, `_SUCCESS`) to simplify testing, retries, and promotion.
      - Architectures: LSTM/GRU or Transformer encoder; objectives: horizon churn (BCE) and next‑k purchase count (Poisson/NB) multi‑task.
      - Regularization: dropout, weight decay; early stopping on temporal validation; calibration via temperature scaling.

- Data contracts (inputs/outputs)
   - Inputs (minimum):
      - transactions(customer_id, order_id, order_ts, net_revenue, quantity, brand, region, channel)
      - customers(customer_id, first_order_ts, segment_rfm, cohort, region, brand_affinity, marketing_flags)
      - fx(optional)(date, from_ccy, to_ccy, rate)
   - Feature view (derived): recency_days, frequency_365d, avg_order_value, tenure_days, brand_share, region_onehots, seasonality indexes.
   - Outputs table (Gold) `customer_scores_gold` (partitioned by snapshot_date):
      - snapshot_date, customer_id, model_family(survival|btyd|seq), model_name, model_version, train_start_dt, train_end_dt, scored_at_ts
      - prob_alive, churn_prob_30d, churn_prob_60d, churn_prob_90d
      - exp_txns_90d, exp_txns_180d, exp_txns_365d, clv_180d, clv_365d, clv_12m
      - segments(rfm_bin, churn_risk_band, clv_tier), explain_key(optional JSON: top_features, attributions)

- Export mechanics (Delta Lake)
   - Partition by snapshot_date; idempotent write per snapshot using replaceWhere or MERGE on (snapshot_date, customer_id).
   - Example patterns:
      ```sql
      -- Idempotent upsert
   MERGE INTO customer_scores_gold AS t
      USING tmp_scores AS s
      ON t.snapshot_date = s.snapshot_date AND t.customer_id = s.customer_id
      WHEN MATCHED THEN UPDATE SET *
      WHEN NOT MATCHED THEN INSERT *;

      -- Or overwrite a single snapshot
      -- spark.conf.set("spark.databricks.delta.replaceWhere.validation.enabled", true)
      -- df.write.format("delta").mode("overwrite")
      --   .option("replaceWhere", "snapshot_date = '2025-08-28'")
   --   .saveAsTable("customer_scores_gold")
      ```
   - Schema enforcement: set Delta column constraints (NOT NULL on keys; valid range checks on probabilities 0–1).

- Validation protocol (offline → business)
   - Splits: temporal train/val/test with multiple backtests (rolling origin: k=3+ windows).
   - Survival: report C‑idx and IBS per backtest; calibration plots by horizon (30/60/90d) and by brand/region; fail if PH assumption violated materially (global test p < 0.01) without mitigation (time‑varying effects/stratification).
   - BTYD: holdout transactions; compare expected vs actual purchases (RMSE/MAE per decile); monetary calibration for Γ‑Γ; lift/gains for top‑N targeting.
   - Business checks: top 10% risk captures ≥ X% of churn; CLV top decile explains ≥ Y% of GMV; stability deltas by brand/region within ±Z pp week‑over‑week.
   - Acceptance thresholds must be documented in README and referenced in the feature's ACs.

- Monitoring & governance
   - MLflow: log params, metrics (C‑idx, IBS, lift), artifacts (plots), and register models with stage tags; pin conda/requirements.
   - Drift: PSI for key features; population and performance drift alerts; weekly evaluation job with report to DevOps board.
   - Bias/fairness: segment‑level parity checks (risk and CLV by protected proxies if applicable); document mitigations.

- Reproducibility & ops
   - Random seeds fixed; data snapshots (as‑of dates) logged; notebook versions and data schema hashes stored.
   - Deterministic joins; timezone normalization; FX locking at valuation_date.

- Deliverables
   - Notebooks: survival_train, btyd_train, score_export, validation_report.
   - Tables: customer_scores_gold, gold.model_metrics (by snapshot/model), gold.validation_plots (path refs).
   - README: methodology, assumptions, acceptance thresholds, runbook for incident response.

#### Implementation stubs and contracts (make it concrete)

- Cox PH (lifelines) — minimal training and scoring
   ```python
   # survival_train.py
   import pandas as pd
   from lifelines import CoxPHFitter

   df = pd.read_parquet("/dbfs/mnt/silver/survival_frame.parquet")
   # Columns expected: duration, event, and covariates (e.g., recency_days, freq_365d, aov, region_*, brand_*)
   covars = [c for c in df.columns if c not in ["customer_id", "duration", "event", "snapshot_date"]]

   cph = CoxPHFitter(penalizer=0.01)
   cph.fit(df[["duration", "event", *covars]], duration_col="duration", event_col="event")

   # Score horizons (days)
   import numpy as np
   H = [30, 60, 90]
   surv = cph.predict_survival_function(df[covars], times=H)
   # churn_prob_h = 1 - S(h)
   scores = df[["customer_id"]].copy()
   for h in H:
       scores[f"churn_prob_{h}d"] = 1.0 - surv.loc[h].values
   ```

- BG/NBD + Gamma‑Gamma (lifetimes)
   ```python
   # btyd_train.py
   import pandas as pd
   from lifetimes import BetaGeoFitter, GammaGammaFitter

   # Required columns for customer summary: frequency, recency, T (customer age), monetary_value
   x = pd.read_parquet("/dbfs/mnt/silver/btyd_summary.parquet")

   bgf = BetaGeoFitter(penalizer_coef=0.0)
   bgf.fit(x["frequency"], x["recency"], x["T"])  # all in same time units

   ggf = GammaGammaFitter(penalizer_coef=0.0)
   mask = x["frequency"] > 0
   ggf.fit(x.loc[mask, "frequency"], x.loc[mask, "monetary_value"])  # assumes MV independent of frequency

   horizon = 90
   x["prob_alive"] = bgf.conditional_probability_alive(x["frequency"], x["recency"], x["T"])
   x["exp_txns_90d"] = bgf.conditional_expected_number_of_purchases_up_to_time(horizon, x["frequency"], x["recency"], x["T"]) 
   x["exp_spend"] = ggf.customer_lifetime_value(bgf, x["frequency"], x["recency"], x["T"], x["monetary_value"], time=12, discount_rate=0.01)
   ```

- Scoring contract (JSON example)
   ```json
   {
     "snapshot_date": "2025-08-28",
     "customer_id": "C_000123",
     "model_family": "survival",
     "model_name": "cox_ph_v1",
     "model_version": "1.0.3",
     "train_start_dt": "2024-08-01",
     "train_end_dt": "2025-07-31",
     "scored_at_ts": "2025-08-28T06:30:00Z",
     "prob_alive": 0.78,
     "churn_prob_30d": 0.12,
     "churn_prob_60d": 0.21,
     "churn_prob_90d": 0.28,
     "exp_txns_90d": 0.9,
     "clv_12m": 142.55,
     "segments": { "rfm_bin": "R2F3M2", "churn_risk_band": "High", "clv_tier": "T2" },
     "explain_key": { "top_features": ["recency_days", "aov", "freq_365d"], "attributions": {"recency_days": -0.42} }
   }
   ```

- Acceptance thresholds (set concrete defaults; tune later)
   - Survival: C‑idx ≥ 0.70 on holdout; IBS ≤ 0.15; well‑calibrated within ±5 pp at 30/60/90d; no major PH violations without mitigation.
   - BTYD: MAPE ≤ 20% for 90‑day transactions at customer‑decile level; Γ‑Γ monetary calibration slope 0.9–1.1.
   - Business lift: Top 10% risk bucket captures ≥ 35% of churn events; CLV top decile explains ≥ 50% of GMV.
   - Stability: Brand/region deltas within ±3 pp week‑over‑week for risk band proportions.

- BI integration hand‑off (to Feature 3.4)
   - Fields used: churn_prob_30d/60d/90d, prob_alive, clv_12m, exp_txns_90d, rfm_bin, churn_risk_band, clv_tier.
   - Visuals: risk band distribution, CLV tier treemap, top‑N focus table with bookmarks; tooltip shows survival curve snapshot.
   - RLS: respect existing brand/region scoping; do not leak customer PII across roles.

- Risks & mitigations
   - Sparse/irregular histories → add hierarchical pooling or shrinkage (penalizers); cap extreme inter‑purchase intervals.
   - Non‑stationary monetary values → segment by era or use time‑varying scaling; audit promotion effects.
   - Data drift → weekly PSI and recalibration; freeze FX and timezones; document schema changes.



## Changelog

2025-08-31
- Added TOC
- Deduplicated Feature 5.3 & Backlog Structure
- Consolidated NFRs (Appendix C)
- Added feature meta headers
- Normalized sprint plan
- Removed patch markers + After it runs — quick checks
- Promoted normalized copy to canonical (overwrote original file)

### Appendix C — Shared NFRs & Conventions

This appendix centralizes repeated guidance. In feature sections, replace repeated bullets with: "See Appendix C — Shared NFRs & Conventions."

- Naming & typing conventions: snake_case; stable business keys; dates as DATE; currency amounts as DECIMAL(18,2); FX rates as DECIMAL(18,8). Avoid FLOAT for currency.
- Idempotency & contracts: re-runs must yield the same end state (MERGE on BKs or overwrite-by-window with replaceWhere); publish schema/data contracts with keys, types, nullability.
- Security & governance: prefer Unity Catalog with Purview scans and classifications; store secrets in Key Vault; apply sensitivity labels; capture lineage evidence.

## Acronyms

| Acronym | Meaning |
|---|---|
| ADLS | Azure Data Lake Storage |
| AOV | Average Order Value |
| API | Application Programming Interface |
| AUC | Area Under the ROC Curve |
| BG/NBD | Beta Geometric / Negative Binomial Distribution |
| CE | Former Community Edition (Databricks) — now referred to as Databricks Free |
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



