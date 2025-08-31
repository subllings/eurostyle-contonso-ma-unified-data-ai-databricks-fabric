# EuroStyle–Contoso M&A — Certification‑Compliant Use Case Mapping

Purpose
- Provide a single use case that maps backlog deliverables to Microsoft certification skill areas for three roles:
  - Data Engineer Associate (DP‑203)
  - Data Scientist Associate (DP‑100)
  - Data Analyst Associate (PL‑300)
- Help learners collect concrete "evidence" from this repo to demonstrate hands‑on competencies.

How to use
- Pick your role. For each sprint/feature in the backlog, complete the linked tasks and collect evidence artifacts listed here.
- Evidence = short screenshots, table names/queries, MLflow run IDs, report links, and a 1–2 paragraph reflection on what you did and why.
- When a file/link is referenced, it points to the canonical backlog at:
  statement/eurostyle-contonso-ma-project-backlog.md

Related certification guides (if present in repo)
- Data Engineer: certification/data-engineer-certifications.md
- Data Scientist: certification/data-scientist-certifications.md
- Data Business Analyst: certification/data-business-analyst-certifications.md

Notes
- This mapping uses public "skills measured" categories. It does not reproduce proprietary exam content.
- If a referenced certification guide file is missing, you can still follow this mapping; create guides later if needed.

---

## Quick reference — skills categories per exam

- DP‑203 (Azure Data Engineer Associate)
  - Design and implement data storage
  - Develop data processing
  - Secure, monitor, and optimize data storage and processing
  - Integrate, orchestrate, and manage data solutions

- DP‑100 (Azure Data Scientist Associate)
  - Explore and prepare data for modeling
  - Develop models
  - Deploy and manage models
  - Responsible AI and monitoring

- PL‑300 (Power BI Data Analyst Associate)
  - Prepare data
  - Model data
  - Visualize and analyze data
  - Deploy and maintain assets (including RLS, performance)

---

## Backlog → Certification crosswalk
All links point to features inside the backlog file.

### Epic 1 — Data Foundation Platform
- Feature 1.1 Raw Data Ingestion — DP‑203, PL‑300
  - Backlog: [Feature 1.1](./eurostyle-contonso-ma-project-backlog.md#feature-1-1)
  - DP‑203: Develop data processing (ingest CSV→Delta); Design storage (Bronze tables); Secure/monitor (constraints, DQ summary)
  - PL‑300: Prepare data (DirectQuery to Databricks); basic semantic setup for First Look
  - Evidence: Bronze table names and schema; DQ one‑pager; screenshot of Power BI DirectQuery smoke test

- Feature 1.2 Silver Cleaning & Harmonization — DP‑203
  - Backlog: [Feature 1.2](./eurostyle-contonso-ma-project-backlog.md#feature-1-2)
  - DP‑203: Develop processing (dedup, FX normalization); Storage design (contracts, replaceWhere/MERGE); Governance (Purview scan)
  - Evidence: Silver schema contract; FX snapshot table; pre/post DQ metrics; Purview scan screenshot

- Feature 1.3 Gold Business Marts — DP‑203, PL‑300
  - Backlog: [Feature 1.3](./eurostyle-contonso-ma-project-backlog.md#feature-1-3)
  - DP‑203: Star schema, idempotent loads, performance partitioning
  - PL‑300: Data model consumption and well‑defined grains/measures
  - Evidence: `gold.sales_daily`/`customer_360` creation queries; validation vs Silver; margin proxy note

- Governance G.1 Purview + Unity Catalog — DP‑203
  - Backlog: [Feature G.1](./eurostyle-contonso-ma-project-backlog.md#feature-g-1)
  - DP‑203: Secure/monitor (Purview source, credentials, lineage); Catalog governance
  - Evidence: Purview connection "Test successful" screenshot; lineage graph; README steps

### Epic 2 — Machine Learning & Predictive Analytics
- Feature 2.1 Exploratory Analysis — DP‑100
  - Backlog: [Feature 2.1](./eurostyle-contonso-ma-project-backlog.md#feature-2-1)
  - DP‑100: Explore and prepare data; leakage checks; evaluation plan; MLflow experiment init
  - Evidence: EDA notebook; prevalence table; split artifacts; MLflow run link

- Feature 2.2 Feature Engineering — DP‑100
  - Backlog: [Feature 2.2](./eurostyle-contonso-ma-project-backlog.md#feature-2-2)
  - DP‑100: Feature design with versioned Delta; train‑only transforms; data quality checks
  - Evidence: `silver.features_*_v1` tables; schema JSON; data dictionary; GE/Evidently report

- Feature 2.3 Model Training — DP‑100
  - Backlog: [Feature 2.3](./eurostyle-contonso-ma-project-backlog.md#feature-2-3)
  - DP‑100: Baseline models, calibration, CIs; segment metrics; model card
  - Evidence: ROC/PR charts; metrics CSV; model card with run IDs and seed

- Feature 2.4 Batch Scoring & Integration — DP‑100, DP‑203
  - Backlog: [Feature 2.4](./eurostyle-contonso-ma-project-backlog.md#feature-2-4)
  - DP‑100: Deploy/manage models for batch scoring; skew checks
  - DP‑203: Orchestrate data writes, contracts, idempotent MERGE/overwrite
  - Evidence: `customer_scores_gold` table; skew/QA report; runbook snippet

### Epic 3 — Analytics & Business Intelligence
- Feature 3.1 First Look – Contoso — PL‑300
  - Backlog: [Feature 3.1](./eurostyle-contonso-ma-project-backlog.md#feature-3-1)
  - PL‑300: Visualize/analyze (cards, trends, top products); model basics; perf quick wins
  - Evidence: PBIX/Fabric report link; named measures; Performance Analyzer screenshot

- Feature 3.2 Raw vs Silver – Comparison — PL‑300
  - Backlog: [Feature 3.2](./eurostyle-contonso-ma-project-backlog.md#feature-3-2)
  - PL‑300: Modeling (paired measures, deltas), RLS draft, bookmarks/toggles
  - Evidence: delta measures list; "View as role" screenshot; DevOps DQ tickets link

- Feature 3.3 Executive Post‑Merger Dashboard — PL‑300
  - Backlog: [Feature 3.3](./eurostyle-contonso-ma-project-backlog.md#feature-3-3)
  - PL‑300: Visualize/analyze; RLS; performance tuning; methods banner
  - Evidence: executive page screenshots; RLS roles; performance before/after

- Feature 3.4 Customer Segmentation — PL‑300, DP‑100
  - Backlog: [Feature 3.4](./eurostyle-contonso-ma-project-backlog.md#feature-3-4)
  - PL‑300: Field parameters, what‑if, drill‑through; Direct Lake/DirectQuery considerations
  - DP‑100: Consumption of churn/CLV outputs in BI
  - Evidence: segmentation page; parameter tables; RLS validation; logic README

### Epic 4 — Platform Integration (Databricks ↔ Fabric)
- Feature 4.1 Export Gold to Fabric — DP‑203
  - Backlog: [Feature 4.1](./eurostyle-contonso-ma-project-backlog.md#feature-4-1)
  - DP‑203: Integrate/orchestrate data solutions; release manifest; ingestion validation
  - Evidence: `release_manifest.json` snippet; Fabric ingestion success; counts vs manifest

- Feature 4.2 Power BI Suite — PL‑300
  - Backlog: [Feature 4.2](./eurostyle-contonso-ma-project-backlog.md#feature-4-2)
  - PL‑300: Deploy and maintain assets (pipelines/app); RLS and sharing
  - Evidence: Fabric pipeline screenshots; app audience settings; RLS test

- Feature 4.3 Scoring Export & Validation — DP‑100, DP‑203
  - Backlog: [Feature 4.3](./eurostyle-contonso-ma-project-backlog.md#feature-4-3)
  - DP‑100: Batch scoring export, explainability summary
  - DP‑203: Validated data movement contracts and QA
  - Evidence: scoring export path; validation queries; explainability plot

### Epic 5 — Optional Extensions
- Feature 5.1 Simplified Data Vault — DP‑203
  - Backlog: [Feature 5.1](./eurostyle-contonso-ma-project-backlog.md#feature-5-1)
  - DP‑203: Advanced storage modeling; hubs/links/sats (lightweight)
  - Evidence: model sketch; load pattern; constraints

- Feature 5.2 Advanced Segmentation — PL‑300
  - Backlog: [Feature 5.2](./eurostyle-contonso-ma-project-backlog.md#feature-5-2)
  - PL‑300: Advanced modeling and UX (field params, drill‑through, performance)
  - Evidence: UX flow, field parameters tables, perf notes

- Feature 5.3 Survival/Probabilistic Models — DP‑100
  - Backlog: [Feature 5.3](./eurostyle-contonso-ma-project-backlog.md#feature-5-3)
  - DP‑100: Advanced modeling (time‑to‑churn, BG/NBD for CLV); evaluation
  - Evidence: model notebook; metrics; assumptions

- Feature 5.4 Orchestration & E2E Deployment — DP‑203, DP‑100
  - Backlog: [Feature 5.4](./eurostyle-contonso-ma-project-backlog.md#feature-5-4)
  - DP‑203: Orchestrate pipelines, manifests, QA; CI/CD concepts
  - DP‑100: Scheduled scoring reliability; drift checks
  - Evidence: DAG/runbook; manifests/_SUCCESS; QA checklist

---

## Role‑based evidence checklists

### DP‑203 (Data Engineer) — minimum evidence set
- Storage and processing
  - Bronze/Silver/Gold table screenshots and schemas (1.1–1.3)
  - Idempotent strategy (MERGE or replaceWhere) snippet (1.2/1.3)
- Security/governance/monitoring
  - Purview source + lineage screenshot (G.1)
  - DQ metrics before/after cleaning (1.2)
- Integration/orchestration
  - Release manifest + Fabric ingestion proof (4.1)
  - Contracted export/import with counts and QA (4.1/4.3)

### DP‑100 (Data Scientist) — minimum evidence set
- Data prep and experimentation
  - EDA notebook + split artifacts + MLflow experiment (2.1)
  - Versioned features with metadata (2.2)
- Modeling and evaluation
  - Churn LR + CLV RF metrics with CIs and calibration (2.3)
  - Segment‑wise metrics and model card (2.3)
- Deployment and monitoring
  - Batch scoring table + skew/QA report (2.4)
  - Explainability plot and runbook (2.4)

### PL‑300 (Data Analyst) — minimum evidence set
- Model and visuals
  - First Look report (Contoso) with named measures (3.1)
  - Raw vs Silver delta visuals + bookmarks (3.2)
- Security and performance
  - RLS roles and "View as" screenshots (3.2/3.3/3.4)
  - Performance Analyzer before/after (3.3/3.4)
- Deployment
  - Fabric app and pipeline evidence, audience/sharing (4.2)

---

## Capstone submission template (copy/paste)

Role: DP‑203 | DP‑100 | PL‑300
Name: <your name>
Dates: <start – end>

1) What you built (2–3 sentences)
2) Key artifacts (paths/links)
   - Tables/views: <names>
   - Notebooks/reports: <paths>
   - MLflow run IDs (if any): <ids>
3) Skills demonstrated (bullet list)
4) Risks/limitations and next steps (2–4 bullets)

---

## Appendix — anchor quicklinks
- Backlog file: ./eurostyle-contonso-ma-project-backlog.md
- Frequent anchors:
  - 1.1 ./eurostyle-contonso-ma-project-backlog.md#feature-1-1
  - 1.2 ./eurostyle-contonso-ma-project-backlog.md#feature-1-2
  - 1.3 ./eurostyle-contonso-ma-project-backlog.md#feature-1-3
  - G.1 ./eurostyle-contonso-ma-project-backlog.md#feature-g-1
  - 2.1 ./eurostyle-contonso-ma-project-backlog.md#feature-2-1
  - 2.2 ./eurostyle-contonso-ma-project-backlog.md#feature-2-2
  - 2.3 ./eurostyle-contonso-ma-project-backlog.md#feature-2-3
  - 2.4 ./eurostyle-contonso-ma-project-backlog.md#feature-2-4
  - 3.1 ./eurostyle-contonso-ma-project-backlog.md#feature-3-1
  - 3.2 ./eurostyle-contonso-ma-project-backlog.md#feature-3-2
  - 3.3 ./eurostyle-contonso-ma-project-backlog.md#feature-3-3
  - 3.4 ./eurostyle-contonso-ma-project-backlog.md#feature-3-4
  - 4.1 ./eurostyle-contonso-ma-project-backlog.md#feature-4-1
  - 4.2 ./eurostyle-contonso-ma-project-backlog.md#feature-4-2
  - 4.3 ./eurostyle-contonso-ma-project-backlog.md#feature-4-3
  - 5.1 ./eurostyle-contonso-ma-project-backlog.md#feature-5-1
  - 5.2 ./eurostyle-contonso-ma-project-backlog.md#feature-5-2
  - 5.3 ./eurostyle-contonso-ma-project-backlog.md#feature-5-3
  - 5.4 ./eurostyle-contonso-ma-project-backlog.md#feature-5-4
