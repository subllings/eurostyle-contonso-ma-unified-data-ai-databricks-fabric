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

A2) Silver cleaning & harmonization (Backlog: Feature 1.2)
- Outcome: deduplication on BKs; FX to EUR with documented rounding; crosswalks; idempotent writes.
- Exam alignment: schema evolution, Delta constraints, performance (partitioning), governance basics.

A3) Gold marts (Backlog: Feature 1.3)
- Outcome: curated marts (sales_daily, category_perf, customer_360).
- Exam alignment: modeling for analytics, contracts, SLAs, BI connectivity.

A4) Export to Fabric (Backlog: Epic 4)
- Outcome: Parquet + manifest (prototype) or Shortcuts (enterprise); pipeline ingest.
- Exam alignment: orchestration, integration patterns; DP‑700 awareness (workspaces, pipelines, governance).

A5) Observability and CI/CD (Optional Extensions)
- Outcome: basic run logs, query history, and a minimal DAB bundle.
- Exam alignment: operations, DAB packaging, environment configs.

## Track B — Data Scientist (Databricks ML Associate/Professional)

B1) EDA and baselines (Backlog: Feature 2.1)
- Outcome: leakage checks, target logic, baseline model; MLflow init.
- Exam alignment: ML workflows, experiment tracking.

B2) Feature engineering (Backlog: Feature 2.2)
- Outcome: RFM and product overlap features; versioned feature table; schema contract.
- Exam alignment: feature engineering, reproducibility, data access controls.

B3) Model training and selection (Backlog: Feature 2.3)
- Outcome: tuned models; metrics; candidate selection; register best model.
- Exam alignment: model development, registry basics.

B4) Batch scoring and rollout (Backlog: Feature 2.4)
- Outcome: scheduled batch scoring to Gold; simple staged rollout; validation report.
- Exam alignment: deployment, monitoring setup, rollback plan.

B5) Drift monitoring (Optional)
- Outcome: small telemetry job capturing feature/score drift; alert thresholds.
- Exam alignment: solution/data monitoring.

## Track C — Data Business Analyst (Databricks Data Analyst Associate; Microsoft PL‑300; DP‑700 awareness)

C1) First Look – Contoso (Backlog: Feature 3.1)
- Outcome: DirectQuery to Bronze; GMV/AOV/Orders with named measures; performance notes.
- Exam alignment: prepare/model/visualize, workspace connections.

C2) Raw vs Silver – Contoso + EuroStyle (Backlog: Feature 3.2)
- Outcome: paired measures (raw/silver/delta); bookmarks/toggles; RLS draft.
- Exam alignment: modeling, visualization, RLS, documentation.

C3) Executive Post‑Merger (Backlog: Feature 3.3)
- Outcome: consolidated GMV/AOV/margin; brand/region splits; RLS validated; accessibility.
- Exam alignment: manage and secure, performance tuning, storytelling.

C4) Fabric Deployment (Backlog: Feature 4.2)
- Outcome: publish via Fabric pipelines; Dev→Test promotion.
- Exam alignment: deployment pipelines, governance, endorsements.

## References
- Role guides: see `../certification/data-engineer-certifications.md`, `../certification/data-scientist-certifications.md` (alias: `../certification/ml-ai-engineer-certifications.md`), `../certification/data-business-analyst-certifications.md` (alias: `../certification/analyst-bi-certifications.md`).
- Backlog: `./2-eurostyle-contonso-ma-project-backlog.md`.
- Business case: `./1-eurostyle-contonso-ma-business-case.md`.
