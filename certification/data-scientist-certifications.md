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

**Section 1 — Databricks Machine Learning (38%)**
- [DBX-ML-Assoc][AutoML] Baseline quickly with AutoML; choose primary metric (e.g., `roc_auc`) and set time/compute limits; review the generated notebook for correctness and leakage.
  Tip: exclude IDs/targets from features; cap runtime to avoid overfitting to a small search space.
- [DBX-ML-Assoc][MLflow] Track runs (params/metrics/artifacts) and register best models for versioning.
  Example: `mlflow.start_run(); mlflow.log_params(params); mlflow.sklearn.log_model(model,'model')`.
  Warning: pin environments (conda/requirements) to ensure reproducible scoring.
- [DBX-ML-Assoc][UC] Enforce governed access to features/models; prefer `catalog.schema.table` names and roles.
  Example (SQL): `GRANT SELECT ON TABLE cat.sch.features TO ROLE analysts`.
- [DBX-ML-Assoc][Splits] Manage environments and randomness for reproducibility; fix seeds and use stratified/time‑aware splits where appropriate.
  Example: `X_tr, X_te, y_tr, y_te = train_test_split(X, y, stratify=y, random_state=42)`.

**Section 2 — ML Workflows (19%)**
- [DBX-ML-Assoc][MLflow] Structure notebooks and Jobs with parameters; log inputs/outputs and dataset versions (e.g., Delta `versionAsOf`) for traceability.
  Tip: use MLflow run tags (`mlflow.set_tags`) with commit SHA and data snapshot.
- [DBX-ML-Assoc][UC] Manage secure data access with UC grants/roles; avoid embedding secrets in code (use secret scopes/Key Vault refs).
- [DBX-ML-Assoc][Metrics] Define evaluation metrics aligned to the business objective (e.g., PR‑AUC on imbalanced datasets) and compute them consistently.
  Example: `from sklearn.metrics import average_precision_score`.

**Section 3 — Model Development (31%)**
- [DBX-ML-Assoc][EDA] Profile distributions/missingness/outliers; verify label balance; prevent target leakage.
  Example: `df.isna().mean()`, `y.value_counts(normalize=True)`.
- [DBX-ML-Assoc][Feature-Engineering] Fit transformers on train only, then transform val/test; compose with `Pipeline`.
  Example: `Pipeline([('ohe', OneHotEncoder()), ('clf', LogisticRegression())])`.
- [DBX-ML-Assoc][Splits] Use stratified or time‑based validation; GroupKFold when entities repeat; keep test set untouched until the end.
- [DBX-ML-Assoc][Metrics] Pick metrics by task/imbalance (AUC/PR‑AUC/F1 for classification; RMSE/MAE for regression); calibrate thresholds for recall/precision trade‑offs.

**Section 4 — Model Deployment (12%)**
- [DBX-ML-Assoc][Batch-Scoring] [DBX-ML-Assoc][MLflow] Package models with signatures; score against deterministic snapshots (Delta time travel) and write idempotently (partition overwrite).
  Example: `spark.read.format('delta').option('versionAsOf', 123).load(path)`; `replaceWhere` on partition column to avoid duplicates.
  Warning: schema drift and non‑deterministic UDFs reduce reproducibility.

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

### 6) 10‑day study plan (example)
- Day 1: EDA and target definition; leakage checklist; label balance and stratification.
- Day 2: Feature engineering (categorical encodings, scaling); build a `Pipeline`.
- Day 3: Splits (stratified/time‑based/GroupKFold) and baseline models; set random seeds.
- Day 4: AutoML baseline and manual grid/bayesian search; compare results using consistent folds.
- Day 5: Metrics selection (AUC vs PR‑AUC vs F1 vs RMSE); threshold calibration.
- Day 6: MLflow tracking/registry; log datasets (path + Delta version) and artifacts; pin envs.
- Day 7: UC governance for models/features; permissions and lineage.
- Day 8: Batch scoring patterns; idempotent outputs; partition overwrite.
- Day 9: Feature Store basics and point‑in‑time joins; reuse across projects.
- Day 10: End‑to‑end dry run and retrospective notes.

### 7) Skills checklist
- [ ] Run AutoML with appropriate metric/time limits and interpret the leaderboard.
- [ ] Create robust train/val/test splits (stratified/time‑based/GroupKFold) without leakage.
- [ ] Build scikit‑learn Pipelines to avoid fitting transformers on non‑train data.
- [ ] Select and compute suitable metrics (classification/regression); calibrate thresholds.
- [ ] Track experiments with MLflow; log params/metrics/artifacts and dataset versions.
- [ ] Register a model with signature and environment; manage versions and stages.
- [ ] Use UC to secure features/models; apply grants and follow naming conventions.
- [ ] Implement batch scoring with deterministic inputs and idempotent outputs.
- [ ] Read/write Delta with partition overwrite and basic schema management.
- [ ] Document decisions and pitfalls; prepare a simple runbook.

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
**Section 1 — Experimentation (30%)**
- [DBX-ML-Prof][Experimentation] Design experiments (names/tags/seeds), fix randomness, and ensure comparable folds across candidates.
  Example: `np.random.seed(42); mlflow.set_tags({'git_commit': sha})`.
  Warning: peeking at the test set biases results; keep it sealed until the end.
- [DBX-ML-Prof][Hyperparameter-Tuning] Use CV/Bayesian/Hyperopt with parallelism; log search spaces and best params.
  Example: Hyperopt + MLflow callback; ensure identical CV splits when comparing models.
- [DBX-ML-Prof][Explainability] Produce feature importances/SHAP for key candidates; validate stability of explanations across folds.
  Example: `shap.TreeExplainer(model).shap_values(X_sample)`.
- [DBX-ML-Prof][Distributed-Training] Scale training with SparkML or distributed frameworks (e.g., TorchDistributor/Horovod); avoid collecting large data to driver.

**Section 2 — Model Lifecycle Management (30%)**
- [DBX-ML-Prof][Registry] Operate registry workflows (Staging→Production), approvals, and rollback; attach descriptions, aliases, and run links.
- [DBX-ML-Prof][CI-CD] Automate evaluation and promotion via pipelines; gate on metrics and tests (data schema, smoke scoring).
  Tip: pin library versions; fail fast on schema changes.
- [DBX-ML-Prof][Governance] Enforce UC permissions for models/feature tables; capture lineage; use `catalog.schema` naming.
- [DBX-ML-Prof][Responsible-AI] Document model cards, data/feature provenance, ethical considerations, and intended use.

**Section 3 — Model Deployment (25%)**
- [DBX-ML-Prof][Deployment] Choose batch vs online; implement Blue/Green or Canary with measurable rollback criteria.
  Example (SQL canary): `SELECT * FROM data WHERE MOD(hash(id), 20)=0`.
- [DBX-ML-Prof][Distributed-Training] Package artifacts and dependencies; ensure inference environment matches training.
- [DBX-ML-Prof][CI-CD] Use bundles/pipelines to deploy endpoints/jobs; parameterize environments and configs.

**Section 4 — Solution and Data Monitoring (15%)**
- [DBX-ML-Prof][Monitoring] Track serving/batch metrics, latency, and failure rates; set alerts and incident procedures.
- [DBX-ML-Prof][Drift-Metrics] Detect covariate/label drift (PSI/KS) and population share changes; compare to baselines and recent windows.
- [DBX-ML-Prof][Explainability] Monitor explanation stability and feature contribution shifts over time; investigate upstream pipeline changes first.
- [DBX-ML-Prof][Responsible-AI] Assess fairness/impact metrics where applicable; document mitigations.

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

### 6) 12‑day study plan (example)
- Days 1–2: Experiment management at scale (seeds/tags/folds); artifact logging and fair comparisons.
- Days 3–4: Hyperparameter tuning (CV/Bayesian/Hyperopt); parallelism and budget control.
- Days 5–6: Explainability (feature importance/SHAP) and checks for stability/robustness.
- Day 7: Registry workflows; approvals, stage transitions, rollback; model aliases.
- Day 8: CI/CD for models; automated evaluation gates and schema tests.
- Day 9: Deployment patterns (batch/online, blue/green/canary); dependency isolation and packaging.
- Day 10: Monitoring and drift metrics (PSI/KS); triage playbooks and alerting.
- Day 11: Governance/UC and Responsible AI documentation (model cards, provenance).
- Day 12: Capstone — staged rollout with drift monitoring and rollback plan.

### 7) Skills checklist
- [ ] Structure experiments with seeds/tags; ensure identical folds for fair comparisons.
- [ ] Run hyperparameter searches (CV/Bayesian/Hyperopt) and log search spaces/results.
- [ ] Produce and interpret explainability artifacts (feature importance/SHAP) and assess stability.
- [ ] Package models with signatures/environments; ensure parity between train and inference.
- [ ] Operate the Model Registry (promote, demote, rollback, approve) with aliases and descriptions.
- [ ] Build model CI/CD gates (metrics thresholds, schema checks, smoke scoring) and approvals.
- [ ] Execute safe deployments (batch/online) with blue/green or canary rollouts.
- [ ] Monitor performance, latency, and data drift; set alerts and respond with a runbook.
- [ ] Apply UC governance and document Responsible AI considerations.
- [ ] Use distributed training/inference appropriately to scale workloads safely.

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
