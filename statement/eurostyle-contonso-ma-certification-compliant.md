# EuroStyle–Contoso M&A — Certification-Compliant Use Case Mapping

**Purpose**
- Provide a single use case that maps **backlog deliverables** to the certification skill areas you actually target in this repo:
  - **Databricks Data Engineer Associate (DBX-DE-Assoc)**
  - **Databricks Machine Learning Associate (DBX-ML-Assoc)**
  - **Microsoft PL-300 (Power BI Data Analyst)**
  - **Microsoft DP-700 (Implementing Analytics Solutions Using Microsoft Fabric)**
- Help learners collect concrete **evidence** from this repo to demonstrate hands-on competencies.

**How to use**
- Pick your role. For each sprint/feature in the backlog, complete the linked tasks and collect the **evidence artifacts** listed here.
- **Evidence** = short screenshots, table names/queries, MLflow run IDs, Fabric pipeline/report links, and a 1–2 paragraph reflection on what you did and why.
- Backlog referenced below: `./eurostyle-contonso-ma-project-backlog.md`

**Related certification guides (in repo)**
- Analyst: `certification/data-business-analyst-certifications.md`  _(PL-300, DP-700, DBX Data Analyst)_  
- Engineer: `certification/data-engineer-certifications.md`  _(DBX Data Engineer)_  
- Data Scientist: `certification/data-scientist-certifications.md`  _(DBX ML)_  

**Notes**
- This mapping paraphrases public "skills measured" domains and maps them to your backlog. No proprietary exam content is reproduced.
- If a guide is missing, you can still follow this mapping; add the guide later.

---

## Quick reference — skills categories per exam (used in this repo)

**Databricks Data Engineer Associate (DBX-DE-Assoc)**
- Platform & compute fundamentals (clusters, SQL warehouses, serverless)
- Development & ingestion (Auto Loader, COPY INTO, notebooks/Repos)
- Data processing (Delta basics, MERGE, medallion Bronze→Silver→Gold)
- Productionizing pipelines (Jobs/DLT concepts, Spark UI basics)
- Governance & quality (Unity Catalog, permissions, lineage, Delta constraints)

**Databricks Machine Learning Associate (DBX-ML-Assoc)**
- Databricks ML & AutoML; MLflow tracking/registry; Unity Catalog for ML
- ML workflows (parameters, datasets/versions, seeds, environment pinning)
- Model development (EDA, leakage control, features, metrics & calibration)
- Deployment (batch scoring, deterministic snapshots, idempotent writes)

**Microsoft PL-300 (Power BI Data Analyst)**
- Prepare data; Model data; Visualize & analyze; Deploy & maintain
- RLS, performance (aggregations/Direct Lake/DirectQuery), governance & sharing

**Microsoft DP-700 (Fabric)**
- Ingest & prepare (Data Pipelines/Dataflows Gen2; connectors)
- Implement Lakehouse/Warehouse; Shortcuts/OneLake concepts
- Transform & model; governance (Purview, sensitivity labels), deployment pipelines

---

## Backlog → Certification crosswalk
_All links point to features inside the backlog file._

### Epic 1 — Data Foundation Platform
**Feature 1.1 — Raw Data Ingestion** → _DBX-DE-Assoc; PL-300 (consumption smoke test)_  
- Backlog: [Feature 1.1](./eurostyle-contonso-ma-project-backlog.md#feature-1-1)  
- **DBX-DE-Assoc:** COPY INTO/Auto Loader (awareness), Delta Bronze, lineage columns, reproducible paths.  
- **PL-300:** DirectQuery/Direct Lake connectivity smoke test to a thin BI view.  
- **Evidence:** Bronze table names & schema; ingestion query; DQ one-pager; Power BI connectivity screenshot.

**Feature 1.2 — Silver Cleaning & Harmonization** → _DBX-DE-Assoc; DP-700 (Purview scan if tenanted)_  
- Backlog: [Feature 1.2](./eurostyle-contonso-ma-project-backlog.md#feature-1-2)  
- **DBX-DE-Assoc:** dedup keys, FX normalization, schema contracts, `replaceWhere`/MERGE idempotence.  
- **DP-700:** Purview scan/lineage on Lakehouse/UC (when not on DBX Free).  
- **Evidence:** Silver contract (schema JSON), FX snapshot table, before/after DQ metrics, Purview screenshot.

**Feature 1.3 — Gold Business Marts** → _DBX-DE-Assoc; PL-300_  
- Backlog: [Feature 1.3](./eurostyle-contonso-ma-project-backlog.md#feature-1-3)  
- **DBX-DE-Assoc:** star schema, aggregates/partitions, idempotent loads.  
- **PL-300:** clear grains/measures consumed by BI.  
- **Evidence:** `gold.sales_daily` / `customer_360` creation SQL, validation queries, margin proxy notes.

**Governance G.1 — Purview + Unity Catalog** → _DP-700; DBX-DE-Assoc (UC)_  
- Backlog: [Feature G.1](./eurostyle-contonso-ma-project-backlog.md#feature-g-1)  
- **DP-700:** register/scan Lakehouse/Shortcuts; sensitivity labels, lineage.  
- **DBX-DE-Assoc:** UC object model & permissions.  
- **Evidence:** "Test connection successful", lineage graph, short governance README.

---

### Epic 2 — Machine Learning & Predictive Analytics
**Feature 2.1 — Exploratory Analysis** → _DBX-ML-Assoc_  
- Backlog: [Feature 2.1](./eurostyle-contonso-ma-project-backlog.md#feature-2-1)  
- **DBX-ML-Assoc:** EDA, label prevalence, leakage checks, experiment init in MLflow.  
- **Evidence:** EDA notebook, prevalence table, split artifacts, MLflow link.

**Feature 2.2 — Feature Engineering** → _DBX-ML-Assoc_  
- Backlog: [Feature 2.2](./eurostyle-contonso-ma-project-backlog.md#feature-2-2)  
- **DBX-ML-Assoc:** versioned feature tables on Delta; fit-on-train-only transforms; basic DQ checks.  
- **Evidence:** `silver.features_*_v1` tables; schema JSON; data dictionary; GE/Evidently report.

**Feature 2.3 — Model Training** → _DBX-ML-Assoc_  
- Backlog: [Feature 2.3](./eurostyle-contonso-ma-project-backlog.md#feature-2-3)  
- **DBX-ML-Assoc:** baselines, calibration, intervals; segment metrics; model card.  
- **Evidence:** ROC/PR charts; metrics CSV; model card with run IDs & seed.

**Feature 2.4 — Batch Scoring & Integration** → _DBX-ML-Assoc; DBX-DE-Assoc (idempotence)_  
- Backlog: [Feature 2.4](./eurostyle-contonso-ma-project-backlog.md#feature-2-4)  
- **DBX-ML-Assoc:** batch scoring on deterministic snapshots; skew checks.  
- **DBX-DE-Assoc:** idempotent MERGE/overwrite to Gold `customer_360`.  
- **Evidence:** `customer_scores_gold` table; skew/QA report; brief runbook.

---

### Epic 3 — Analytics & Business Intelligence
**Feature 3.1 — First Look (Contoso)** → _PL-300_  
- Backlog: [Feature 3.1](./eurostyle-contonso-ma-project-backlog.md#feature-3-1)  
- **PL-300:** visuals & measures, semantic basics, performance quick wins.  
- **Evidence:** PBIX/Fabric report link; named measures; Performance Analyzer screenshot.

**Feature 3.2 — Raw vs Silver Comparison** → _PL-300_  
- Backlog: [Feature 3.2](./eurostyle-contonso-ma-project-backlog.md#feature-3-2)  
- **PL-300:** paired measures/deltas, bookmarks/toggles, **RLS draft**.  
- **Evidence:** delta measures list; "View as role" screenshot; DQ tickets link.

**Feature 3.3 — Executive Post-Merger Dashboard** → _PL-300_  
- Backlog: [Feature 3.3](./eurostyle-contonso-ma-project-backlog.md#feature-3-3)  
- **PL-300:** consolidated KPIs; RLS; performance tuning; "methods" banner.  
- **Evidence:** executive page screenshots; RLS roles; before/after perf.

**Feature 3.4 — Customer Segmentation** → _PL-300; DBX-ML-Assoc (consumption)_  
- Backlog: [Feature 3.4](./eurostyle-contonso-ma-project-backlog.md#feature-3-4)  
- **PL-300:** field parameters, what-if, drill-through; Direct Lake/DirectQuery notes.  
- **DBX-ML-Assoc:** consumes churn/CLV outputs in BI.  
- **Evidence:** segmentation page; parameter tables; RLS validation; logic README.

---

### Epic 4 — Platform Integration (Databricks ↔ Fabric)
**Feature 4.1 — Export Gold to Fabric** → _DP-700; DBX-DE-Assoc_  
- Backlog: [Feature 4.1](./eurostyle-contonso-ma-project-backlog.md#feature-4-1)  
- **DP-700:** Data Pipelines/Shortcuts, ingestion validation, pipeline runs.  
- **DBX-DE-Assoc:** release manifest and export contracts.  
- **Evidence:** `release_manifest.json` snippet; Fabric ingest success; counts vs manifest.

**Feature 4.2 — Power BI Suite (Exec + Segmentation)** → _PL-300; DP-700_  
- Backlog: [Feature 4.2](./eurostyle-contonso-ma-project-backlog.md#feature-4-2)  
- **PL-300:** app/pipelines, RLS, sharing, promotion.  
- **DP-700:** Fabric deployment pipelines & workspace strategy.  
- **Evidence:** pipeline screenshots; app audience; RLS test.

**Feature 4.3 — Scoring Export & Validation** → _DBX-ML-Assoc; DP-700_  
- Backlog: [Feature 4.3](./eurostyle-contonso-ma-project-backlog.md#feature-4-3)  
- **DBX-ML-Assoc:** export scored tables + explainability summary.  
- **DP-700:** data movement validation, contracts, QA.  
- **Evidence:** scoring export path; validation queries; explainability plot.

---

### Epic 5 — Optional Extensions
**Feature 5.1 — Simplified Data Vault** → _DBX-DE-Assoc_  
- Backlog: [Feature 5.1](./eurostyle-contonso-ma-project-backlog.md#feature-5-1)  
- **Evidence:** model sketch; load pattern; constraints.

**Feature 5.2 — Advanced Segmentation (BI UX)** → _PL-300_  
- Backlog: [Feature 5.2](./eurostyle-contonso-ma-project-backlog.md#feature-5-2)  
- **Evidence:** field parameters tables; UX flow; perf notes.

**Feature 5.3 — Survival & Probabilistic Models** → _DBX-ML-Assoc (optionally Prof)_  
- Backlog: [Feature 5.3](./eurostyle-contonso-ma-project-backlog.md#feature-5-3)  
- **Evidence:** model notebook; metrics; calibration & assumptions.

**Feature 5.4 — Orchestration & E2E Deployment** → _DP-700; DBX-DE-Assoc; DBX-ML-Assoc_  
- Backlog: [Feature 5.4](./eurostyle-contonso-ma-project-backlog.md#feature-5-4)  
- **Evidence:** DAG/runbook; manifests/_SUCCESS; QA checklist; promotion notes.

---

## Role-based evidence checklists

### DBX-DE-Assoc (Data Engineer) — minimum evidence
- **Medallion & Delta**
  - Bronze/Silver/Gold screenshots & schemas (1.1–1.3)
  - Idempotent strategy (MERGE or `replaceWhere`) snippet (1.2/1.3)
- **Governance & quality**
  - UC permissions/objects (G.1)
  - DQ metrics before/after cleaning (1.2)
- **Integration**
  - Release manifest + Fabric ingestion proof (4.1)
  - Export/import counts & QA (4.1/4.3)

### DBX-ML-Assoc (Data Scientist) — minimum evidence
- **Prep & experiments**
  - EDA + split artifacts + MLflow experiment (2.1)
  - Versioned features with metadata (2.2)
- **Modeling**
  - Baseline metrics with calibration/intervals (2.3)
  - Segment metrics + model card (2.3)
- **Deployment**
  - Batch scoring table + skew/QA report (2.4)
  - Explainability plot + short runbook (2.4 / 4.3)

### PL-300 (Data Analyst) — minimum evidence
- **Model & visuals**
  - First Look report with named measures (3.1)
  - Raw vs Silver delta visuals + bookmarks (3.2)
- **Security & performance**
  - RLS roles and "View as" screenshots (3.2/3.3/3.4)
  - Performance Analyzer before/after (3.3/3.4)
- **Deployment**
  - Fabric app/pipeline evidence; audience/sharing (4.2)

### DP-700 (Fabric) — minimum evidence
- **Pipelines & Lakehouse**
  - Data Pipeline runs (screenshots/logs) and Lakehouse/Shortcut setup (4.1/4.2)
- **Governance**
  - Purview scan/lineage on Fabric assets (G.1)
- **Promotion**
  - Deployment Pipelines: Dev→Test (4.2) with notes on RLS/labels

---

## Capstone submission template (copy/paste)

**Role:** DBX-DE-Assoc | DBX-ML-Assoc | PL-300 | DP-700  
**Name:** <your name>  
**Dates:** <start – end>

1) What you built (2–3 sentences)  
2) Key artifacts (paths/links)  
   - Tables/views: <names>  
   - Notebooks/reports/pipelines: <paths>  
   - MLflow run IDs (if any): <ids>  
3) Skills demonstrated (bullet list)  
4) Risks/limitations and next steps (2–4 bullets)

---

## Appendix — anchor quicklinks
_Backlog file:_ `./eurostyle-contonso-ma-project-backlog.md`

- [Feature 1.1](./eurostyle-contonso-ma-project-backlog.md#feature-1-1) · [Feature 1.2](./eurostyle-contonso-ma-project-backlog.md#feature-1-2) · [Feature 1.3](./eurostyle-contonso-ma-project-backlog.md#feature-1-3)  
- [Feature G.1](./eurostyle-contonso-ma-project-backlog.md#feature-g-1)  
- [Feature 2.1](./eurostyle-contonso-ma-project-backlog.md#feature-2-1) · [Feature 2.2](./eurostyle-contonso-ma-project-backlog.md#feature-2-2) · [Feature 2.3](./eurostyle-contonso-ma-project-backlog.md#feature-2-3) · [Feature 2.4](./eurostyle-contonso-ma-project-backlog.md#feature-2-4)  
- [Feature 3.1](./eurostyle-contonso-ma-project-backlog.md#feature-3-1) · [Feature 3.2](./eurostyle-contonso-ma-project-backlog.md#feature-3-2) · [Feature 3.3](./eurostyle-contonso-ma-project-backlog.md#feature-3-3) · [Feature 3.4](./eurostyle-contonso-ma-project-backlog.md#feature-3-4)  
- [Feature 4.1](./eurostyle-contonso-ma-project-backlog.md#feature-4-1) · [Feature 4.2](./eurostyle-contonso-ma-project-backlog.md#feature-4-2) · [Feature 4.3](./eurostyle-contonso-ma-project-backlog.md#feature-4-3)  
- [Feature 5.1](./eurostyle-contonso-ma-project-backlog.md#feature-5-1) · [Feature 5.2](./eurostyle-contonso-ma-project-backlog.md#feature-5-2) · [Feature 5.3](./eurostyle-contonso-ma-project-backlog.md#feature-5-3) · [Feature 5.4](./eurostyle-contonso-ma-project-backlog.md#feature-5-4)
