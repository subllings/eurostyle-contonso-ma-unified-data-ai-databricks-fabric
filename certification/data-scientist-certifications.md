# Data Scientist — Certifications Study Guides

This file consolidates study guides for the Data Scientist profile.

## Databricks Certified Machine Learning Associate — Study Guide (English)

Purpose: concise prep for Databricks ML fundamentals; paraphrases the live exam outline (verify the official page before booking).

See also: refer to `GLOSSARY.md` for cross-cert acronyms and shared terms.

### 1) Audience and goals
- Goal: perform core ML tasks on Databricks: explore data, engineer features, train/tune/evaluate, and deploy.
- Audience: practitioners with ~6+ months Databricks ML exposure (AutoML, MLflow basics, UC).

### 2) Assessment details
- Questions: 48 multiple choice
- Time: 90 minutes
- Fee: USD 200 (plus taxes)
- Delivery: online proctored; no aides
- Languages: English, Japanese, Portuguese BR, Korean
- Prereqs: none; 6+ months experience recommended
- Validity: 2 years; recertify by retaking the current exam
- Unscored items may appear; time already accounts for them
- Code focus: ML code in Python; non‑ML workflow snippets may use SQL
- Official page: https://www.databricks.com/learn/certification/machine-learning-associate
- Exam guide PDF: https://www.databricks.com/sites/default/files/2025-02/databricks-certified-machine-learning-associate-exam-guide-1-mar-2025.pdf

### 3) Exam outline and weights

Section 1 — Databricks Machine Learning (38%)
- [DBX-ML-Assoc][AutoML] Use AutoML to baseline models and generate candidate notebooks.
- [DBX-ML-Assoc][MLflow] Use MLflow tracking/registry basics to log runs and manage versions.
- [DBX-ML-Assoc][UC] Integrate Unity Catalog for governed access to models/artifacts.
- Environments: manage libraries/runtimes for reproducibility.

Section 2 — ML Workflows (19%)
- Structure notebooks/jobs, manage data access, and set up reproducible runs.

Section 3 — Model Development (31%)
- [DBX-ML-Assoc][EDA] Perform EDA and avoid target leakage.
- [DBX-ML-Assoc][Feature-Engineering] Engineer features; train, tune, evaluate, and select models.

Section 4 — Model Deployment (12%)
- [DBX-ML-Assoc][Batch-Scoring] Package and deploy models for batch scoring (job/serving options); manage versions/rollbacks.

### Tag Reference Table — Databricks ML Associate

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-ML-Assoc][EDA] | Exploratory Data Analysis (EDA) | Systematic profiling of data to find patterns, anomalies, and data quality issues; helps form hypotheses before modeling. |
| [DBX-ML-Assoc][Feature-Engineering] | Feature Engineering | Create, transform, and select inputs (features) that improve model signal while avoiding leakage; document logic clearly. |
| [DBX-ML-Assoc][AutoML] | Automated Machine Learning (AutoML) | Tooling that trains/tunes multiple models automatically to give a fast baseline and candidate leaderboard. |
| [DBX-ML-Assoc][MLflow] | MLflow Tracking/Registry (MLflow) | Track runs (params/metrics/artifacts) and register best models for promotion/versioning in one place. |
| [DBX-ML-Assoc][UC] | Unity Catalog (UC) for ML assets | Govern access/ownership for models, feature tables, and notebooks; enables lineage and consistent permissions. |
| [DBX-ML-Assoc][Batch-Scoring] | Batch Scoring | Run model inference on data in batches via Jobs; schedule, log outputs, and verify results are reproducible. |

### 4) Recommended training
- Instructor-led: Machine Learning with Databricks — https://www.databricks.com/training/catalog/machine-learning-with-databricks-2422
- Self-paced (Academy): Data Preparation for ML; Model Development; Model Deployment; ML Ops

### 5) Hands‑on mapping to this repository
- **End-to-end ML workflow**
  - [DBX-ML-Assoc][EDA] [DBX-ML-Assoc][Feature-Engineering] [DBX-ML-Assoc][MLflow] [DBX-ML-Assoc][Batch-Scoring] See `statement/2-eurostyle-contonso-ma-project-backlog.md` (Epic 2: 2.1–2.4): EDA → feature engineering → model training → batch scoring.
  - [DBX-ML-Assoc][MLflow] Track experiments and register the best model; document metrics and decisions.

#### Repo mapping (quick links)
- feature_2_1_eda.ipynb — EDA and leakage checks [DBX-ML-Assoc][EDA]
- feature_2_2_feature_engineering.ipynb — Feature engineering and splits [DBX-ML-Assoc][Feature-Engineering]
- feature_2_3_model_training.ipynb — Training, tuning, evaluation, registry [DBX-ML-Assoc][MLflow]
- feature_2_4_batch_scoring.ipynb — Batch scoring and simple deployment [DBX-ML-Assoc][Batch-Scoring]

### 6) 7‑day study plan (example)
- Day 1: EDA and target definition; leakage checklist.
- Day 2: Feature engineering, train/validation split, baseline model.
- Day 3: Tuning (grid/AutoML), evaluation metrics; model selection.
- Day 4: MLflow (tracking/registry) and artifacts.
- Day 5: Batch scoring job; simple serving options.
- Day 6: UC governance basics for ML assets; permissions and lineage.
- Day 7: End‑to‑end dry run and notes.

### 7) Skills checklist
- [ ] Run AutoML and interpret results; compare to a manual baseline.
- [ ] Track experiments with MLflow; log params/metrics/artifacts.
- [ ] Register/promote a model; manage versions and stages.
- [ ] Engineer features safely; validate with proper splits and metrics.
- [ ] Implement batch scoring and basic deployment options.

### 8) Quick reference
- Train/test split and MLflow autolog (Python):
  - `from sklearn.model_selection import train_test_split`
  - `X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)`
  - `import mlflow; import mlflow.sklearn; mlflow.sklearn.autolog()`
- Create a feature table in Unity Catalog (Python skeleton):
  - `from databricks.feature_engineering import FeatureEngineeringClient`
  - `fe = FeatureEngineeringClient()`
  - `fe.create_table(name="main.catalog.schema.customer_features", primary_keys=["id"], schema=df.schema, description="customer features")`
- Batch scoring job (pandas on Spark or pandas):
  - `preds = model.predict(batch_df)`

---

## Databricks Certified Machine Learning Professional — Study Guide (English)

Purpose: actionable prep for production ML on Databricks; paraphrases the live exam outline (verify the official page before booking).

### 1) Audience and goals
- Goal: manage experiments at scale, govern model lifecycle, deploy safely, and monitor for drift/incidents.
- Audience: Data Scientists / ML Engineers with 1+ year Databricks ML experience and MLOps exposure.

### 2) Assessment details
- Questions: 60 multiple choice
- Time: 120 minutes
- Fee: USD 200 (plus taxes)
- Delivery: online proctored; no aides
- Languages: English
- Prereqs: none; 1+ year experience recommended
- Validity: 2 years; recertify by retaking the current exam
- Unscored items may appear; time already accounts for them
- SQL may be assessed; ANSI SQL conventions apply
- Official page: https://www.databricks.com/learn/certification/machine-learning-professional
- Exam guide PDF: https://www.databricks.com/sites/default/files/2025-08/databricks-certified-machine-learning-professional-exam-guide-interrim-sept-2025.pdf

### 3) Exam outline and weights
Section 1 — Experimentation (30%)
- Design experiment structures, manage runs/artifacts, compare and select candidates; ensure reproducibility.

Section 2 — Model Lifecycle Management (30%)
- Registry workflows (staging/production), approvals, rollback; feature/mode/version governance.

Section 3 — Model Deployment (25%)
- Batch and online serving strategies, blue/green or canary ideas, dependency isolation, and safe rollouts.

Section 4 — Solution and Data Monitoring (15%)
- Monitor performance and data quality/drift; alerting and incident handling; feedback loops.

### Tag Reference Table — Databricks ML Professional

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-ML-Prof][Experimentation] | Experiment Management | Design experiments with clear naming, parameters, and seeds so results are comparable and reproducible. |
| [DBX-ML-Prof][Registry] | Model Registry (MLflow) | Govern versions/stages (Staging/Production), approvals, and rollback; central location to track deployments. |
| [DBX-ML-Prof][Deployment] | Deployment Patterns | Batch vs Online serving; Blue/Green Deployment (two parallel environments with traffic switching to reduce risk) and Canary Deployment (release to a small subset first, then expand); isolate dependencies for reliability. |
| [DBX-ML-Prof][Monitoring] | Monitoring & Drift | Track model quality and data drift (e.g., Population Stability Index (PSI), Kolmogorov-Smirnov (KS)); alert and act. |
| [DBX-ML-Prof][Governance] | Governance (Unity Catalog) | Control access/ownership to models, features, and data; capture lineage for audits and collaboration. |

### 4) Recommended training
- Instructor-led: Machine Learning at Scale — https://www.databricks.com/training/catalog/machine-learning-at-scale-3409; Advanced Machine Learning Operations — https://www.databricks.com/training/catalog/advanced-machine-learning-operations-3481
- Self-paced (Academy): ML at Scale; Advanced ML Ops

### 5) Hands‑on mapping to this repository
- **Lifecycle and rollout**
  - [DBX-ML-Prof][Registry] [DBX-ML-Prof][Deployment] Extend Epic 2 (2.1–2.4) with: model registry promotion/rollback, shadow/canary batch rollouts.
- **Monitoring**
  - [DBX-ML-Prof][Monitoring] Add a small telemetry notebook: log prediction/feature stats and compare against training baselines.

#### Repo mapping (quick links)
- feature_2_1_eda.ipynb — experiment baselining and metrics
- feature_2_2_feature_engineering.ipynb — feature pipelines with UC assets
- feature_2_3_model_training.ipynb — registry integration and stage transitions
- feature_2_4_batch_scoring.ipynb — staged rollout, shadow/canary batches

### 6) 10‑day study plan (example)
- Days 1–2: Experiment management at scale; tracking, artifacts, and comparisons.
- Days 3–4: Registry workflows; approvals, stage transitions, rollback.
- Days 5–6: Deployments (batch/online patterns) and dependency management.
- Day 7: Monitoring and drift metrics; alerting.
- Day 8: Governance/UC for ML assets; access controls and lineage.
- Days 9–10: Capstone with staged rollout and incident runbook.

### 7) Skills checklist
- [ ] Structure experiments and ensure reproducible runs.
- [ ] Operate the Model Registry (promote, demote, rollback, approve).
- [ ] Execute safe deployments (batch/online) with staged rollout.
- [ ] Monitor performance and data drift; raise alerts and act.
- [ ] Govern ML assets and data access with UC.

### 8) Quick reference
- MLflow operations (Python):
  - `import mlflow; mlflow.start_run(); mlflow.log_metric("auc", 0.91)`
  - `mlflow.register_model("runs:/<run_id>/model", "models:/main.catalog.schema/model_name")`
  - `# transition stage via API/UI with comments`
- Staged rollout idea:
  - "Blue/green or canary" using Jobs parameters to target subsets, then promote.
- Drift metric sketch (pandas):
  - `# compute PSI/KS between baseline and current distributions`

### 9) Getting ready
- Review the exam guide; take related training.
- Register and verify online proctoring requirements; run a system check.
- Re-review the outline to spot gaps; study to fill them.
- Build a small production-minded pipeline with registry and staged rollout.

### 10) Registration and resources
- Machine Learning Professional page: https://www.databricks.com/learn/certification/machine-learning-professional
- Exam guide PDF (interim Sept 2025): https://www.databricks.com/sites/default/files/2025-08/databricks-certified-machine-learning-professional-exam-guide-interrim-sept-2025.pdf
- Registration (exam delivery platform): http://webassessor.com/databricks
- Credentials portal: https://credentials.databricks.com/
- Certification FAQ: https://www.databricks.com/learn/certification/faq
- Docs:
  - MLflow Tracking & Registry: https://docs.databricks.com/machine-learning/mlflow/
  - Model Serving & endpoints: https://docs.databricks.com/machine-learning/model-serving/
  - Unity Catalog (permissions/ownership): https://docs.databricks.com/data-governance/unity-catalog/
  - Jobs/Workflows: https://docs.databricks.com/workflows/
  - System tables & observability: https://docs.databricks.com/administration-guide/system-tables/index.html

Books (O'Reilly):
- Practical MLOps — Noah Gift, Alfredo Deza (2021): https://www.oreilly.com/library/view/practical-mlops/9781098103002/
- Machine Learning for High-Risk Applications — Patrick Hall, James Curtis, Parul Pandey (2023): https://www.oreilly.com/library/view/reliable-machine-learning/9781098102425/
- Building Machine Learning Pipelines — Hannes Hapke, Catherine Nelson (2020): https://www.oreilly.com/library/view/building-machine-learning/9781492053187/
- Feature Engineering for Machine Learning — Alice Zheng, Amanda Casari (2018): https://www.oreilly.com/library/view/feature-engineering-for/9781491953235/

---

## ML Tag Glossary (quick reference)

This glossary lists the tags used in this file. For broader definitions shared across roles, see `GLOSSARY.md`.

| Tag | Study Point | What to know |
|-----|-------------|--------------|
| [DBX-ML-Assoc][EDA] | Exploratory Data Analysis (EDA) | Profiling data: distributions, missing values, outliers, correlations. Avoid target leakage. |
| [DBX-ML-Assoc][Feature-Engineering] | Feature Engineering | Create/transform features, document logic, monitor for overfitting. |
| [DBX-ML-Assoc][AutoML] | Automated Machine Learning (AutoML) | Automates model training/tuning; gives fast baseline and leaderboard. Know limits of automation. |
| [DBX-ML-Assoc][MLflow] | MLflow Tracking/Registry | Track runs (params, metrics, artifacts). Register and version models for deployment. |
| [DBX-ML-Assoc][UC] | Unity Catalog (UC) | Manage permissions and ownership for ML assets; enable lineage and audits. |
| [DBX-ML-Assoc][Batch-Scoring] | Batch Scoring | Run inference at scale in scheduled jobs; ensure reproducibility. |
| [DBX-ML-Prof][Experimentation] | Experiment Management | Design reproducible experiments with seeds, parameters, and naming conventions. |
| [DBX-ML-Prof][Registry] | Model Registry (MLflow) | Govern versions/stages (Staging/Prod), approvals, rollback. Central tracking point. |
| [DBX-ML-Prof][Deployment] | Deployment Patterns | Batch vs online, blue/green, canary rollout, dependency isolation. |
| [DBX-ML-Prof][Monitoring] | Monitoring & Drift | Detect model/data drift with PSI, KS, metrics; set alerts and incident workflows. |
| [DBX-ML-Prof][Governance] | Governance (Unity Catalog) | Permissions, ownership, lineage of models and features for compliance. |
