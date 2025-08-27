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

This backlog defines the learning and delivery path of the EuroStyle–Contoso M&A case,  
structured into five sprints (0 → 4).  
It begins with a high-level Sprint Planning Matrix (overview of DE, DA, DS roles),  
followed by detailed Epics, Features, and User Stories with tasks and learning resources.

---


## Sprint Planning Matrix (4.5 days per sprint)

This matrix summarizes the focus and concrete deliverables of each role  
— **Data Engineer (DE)**, **Data Analyst (DA)**, and **Data Scientist (DS)** — across all sprints.  
It provides a clear mapping of **who delivers what, and when**, ensuring no role is idle.

| Sprint | Data Engineer (DE) | Data Analyst (DA) | Data Scientist (DS) |
|--------|---------------------|-------------------|----------------------|
| **0 (0.5d)** | Set up Databricks workspace and folder structure; define ingestion paths for EuroStyle & Contoso | Define initial KPI catalog (GMV, AOV, margin, churn rate); map differences EuroStyle vs Contoso | Define hypotheses for churn (inactivity >90 days) and Customer Lifetime Value (CLV); identify required features |
| **1 (4.5d)** | Ingest EuroStyle & Contoso raw CSVs into Bronze Delta tables; add metadata (`ingest_ts`, `source_system`) | Build "First Look Dashboard" with Bronze KPIs: **GMV (Gross Merchandise Value)**, **AOV (Average Order Value)**, order counts | Perform **Exploratory Data Analysis (EDA)** on Bronze: distributions, missing values, brand overlap; draft churn & CLV definitions |
| **2 (4.5d)** | Transform Bronze → Silver: deduplication, schema harmonization, standardize currencies, align product hierarchies | Redesign dashboards on Silver; compare Raw vs Silver KPIs; implement first **Row-Level Security (RLS)** rules | Engineer features: **RFM (Recency, Frequency, Monetary value)**, basket diversity, cross-brand overlap; track feature sets in MLflow |
| **3 (4.5d)** | Build Gold marts: `sales_daily` (sales, GMV, AOV, margin), `category_perf`, `customer_360` with RFM base | Deliver **Executive Dashboard**: consolidated KPIs (GMV, AOV, margin), brand comparisons, North vs South splits | Train baseline models: Logistic Regression (churn), Random Forest (CLV regression); log experiments in MLflow |
| **4 (4.5d)** | Export Gold marts to Fabric Lakehouse (Parquet + manifest, or Shortcuts); orchestrate ingestion with Fabric Data Pipelines | Build full **Power BI Post-Merger Suite**: Executive + Customer Segmentation dashboards (with churn & CLV); deploy with Fabric pipelines | Run batch scoring for churn & CLV; join scored tables into Gold `customer_360`; document model performance (accuracy, AUC, RMSE) and explainability |


---


## Backlog Structure
This backlog follows Agile methodology with hierarchical organization:
- **Epics**: Major business capabilities 
- **Features**: Functional components within epics
- **User Stories**: Specific user needs and outcomes
- **Tasks**: Technical implementation items



---


## Epic 1 – Data Foundation Platform
**Goal**: Build a robust Medallion architecture (Bronze → Silver → Gold) unifying EuroStyle & Contoso.

---

### Feature 1.1: Raw Data Ingestion (Sprint 1)
**User Story**:  
As a Data Engineer, I want to ingest EuroStyle and Contoso CSVs into Bronze so the teams can start analyzing real data.  

**Learning Resources**:  
- [Medallion Architecture](https://docs.databricks.com/lakehouse/medallion.html)  
- [Delta Lake Basics](https://docs.databricks.com/delta/index.html)  
- [PySpark DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)  

**Key Concepts**:  
- Bronze = raw data "as delivered" (no cleaning yet).  
- Add metadata columns (`ingest_ts`, `source_system`) for lineage.  
- Use Delta format instead of CSV for reliability and performance.  

**Acceptance Criteria**:  
- EuroStyle & Contoso CSVs uploaded and stored in `/FileStore/retail/raw/...`.  
- Bronze Delta tables created with correct schema.  
- Metadata fields (`ingest_ts`, `source_system`) added.  
- Row counts match raw source files.  

**Tasks**:  
- Upload EuroStyle dataset (Online Retail II) into `/FileStore/retail/raw/eurostyle/`  
- Upload Contoso dataset (European Fashion Store Multitable) into `/FileStore/retail/raw/contoso/`  
- Create Bronze Delta tables with schema inference.  
- Add metadata columns (`ingest_ts`, `source_system`).  

---

### Feature 1.2: Silver Cleaning & Harmonization (Sprint 2)
**User Story**:  
As a Data Engineer, I want Silver tables with clean, harmonized schemas so Analysts and Scientists can trust the data.  

**Learning Resources**:  
- [Schema Evolution in Delta](https://docs.databricks.com/delta/delta-batch.html#table-schema-evolution)  
- [Data Quality Framework](https://docs.databricks.com/lakehouse/data-quality.html)  
- [PySpark DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)  

**Key Concepts**:  
- Silver = cleaned and standardized layer.  
- Deduplication using business keys (e.g., `order_id + sku + customer_id`).  
- Standardize currencies (convert all to EUR).  
- Use mapping tables for product hierarchy alignment.  
- Normalize customer IDs across EuroStyle & Contoso.  

**Acceptance Criteria**:  
- Duplicates removed with correct logic.  
- All currencies expressed in EUR.  
- Product hierarchy aligned across both datasets.  
- Customer IDs unified and cross-brand duplicates resolved.  
- Documentation of cleaning steps added in notebook.  

**Tasks**:  
- Deduplicate data using business keys.  
- Standardize currencies (conversion → EUR).  
- Align product hierarchies using mapping table.  
- Normalize customer IDs across EuroStyle & Contoso.  

---

### Feature 1.3: Gold Business Marts (Sprint 3)
**User Story**:  
As a Data Engineer, I want Gold marts for sales and customers so the business gets reliable KPIs.  

**Learning Resources**:  
- [Star Schema Design](https://docs.databricks.com/lakehouse/data-modeling.html)  
- [Performance Optimization in Delta](https://docs.databricks.com/optimizations/index.html)  
- [RFM Analysis Basics](https://clevertap.com/blog/rfm-analysis/)  

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

**Tasks**:  
- Build `sales_daily` (GMV, AOV, margin).  
- Build `category_perf` (sales by product/category).  
- Build `customer_360` (RFM analysis + source_system flag).  
- Validate marts and document schema.  

---

## Epic 2 – Analytics & Business Intelligence
**Goal**: Provide dashboards for executives and marketing with unified KPIs.

---

### Feature 2.1: First Look Dashboard (Sprint 1)
**User Story**:  
As a Data Analyst, I want KPIs from Bronze so I can deliver a "First Look" dashboard.  

**Learning Resources**:  
- [Power BI Fundamentals](https://learn.microsoft.com/en-us/power-bi/fundamentals/)  
- [DirectQuery to Databricks](https://learn.microsoft.com/en-us/azure/databricks/partners/bi/power-bi)  
- [Data Visualization Best Practices](https://www.tableau.com/learn/articles/data-visualization)  

**Key Concepts**:  
- Bronze = raw, uncleaned but complete data.  
- GMV (Gross Merchandise Value) = total sales value.  
- AOV (Average Order Value) = GMV / number of orders.  
- Dashboards at this stage focus on **"quick wins"** with limited transformations.  

**Acceptance Criteria**:  
- Dashboard created in Power BI with GMV, AOV, and order counts.  
- Data source connected directly to Databricks Bronze (DirectQuery).  
- First insights available even before cleaning.  

**Tasks**:  
- Compute **GMV (Gross Merchandise Value)**.  
- Compute **AOV (Average Order Value)**.  
- Build dashboard with Raw/Bronze metrics.  

---

### Feature 2.2: Raw vs Silver Dashboard (Sprint 2)
**User Story**:  
As a Data Analyst, I want to compare KPIs Raw vs Silver to highlight data cleaning impact.  

**Learning Resources**:  
- [Data Quality Framework](https://docs.databricks.com/lakehouse/data-quality.html)  
- [Power BI Comparison Techniques](https://learn.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-combo-chart)  

**Key Concepts**:  
- Silver = cleaned, harmonized data.  
- Comparing Raw vs Silver highlights impact of deduplication, standardization, and harmonization.  
- Useful to **build trust** in the cleaning process.  

**Acceptance Criteria**:  
- Dashboard compares Raw vs Silver KPIs: GMV, AOV, return rates.  
- Documentation highlights the differences (e.g., reduced duplicates).  
- Stakeholders understand the value of Silver over Raw.  

**Tasks**:  
- Create dashboard with GMV, AOV, return rates (before/after cleaning).  
- Document and present differences.  

---

### Feature 2.3: Executive Post-Merger Dashboard (Sprint 3)
**User Story**:  
As an Executive, I want consolidated GMV, AOV, and margin so I can track EuroStyle + Contoso performance.  

**Learning Resources**:  
- [Row-Level Security in Power BI](https://learn.microsoft.com/en-us/power-bi/admin/service-security-rls)  
- [Performance Optimization in Power BI](https://learn.microsoft.com/en-us/power-bi/guidance/power-bi-performance-best-practices)  

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

---

### Feature 2.4: Customer Segmentation Dashboard (Sprint 4)
**User Story**:  
As a Marketing Manager, I want to see customer segments & churn risk so I can design campaigns.  

**Learning Resources**:  
- [RFM Analysis](https://clevertap.com/blog/rfm-analysis/) – segmentation by Recency, Frequency, Monetary value  
- [Customer Churn Basics](https://towardsdatascience.com/churn-prediction-in-telecom-industry-2f2c7d7e9388)  
- [Power BI in Fabric](https://learn.microsoft.com/en-us/fabric/get-started/microsoft-fabric-overview)  

**Key Concepts**:  
- Customer segmentation = group customers by behavior (RFM).  
- Churn prediction = probability a customer will stop purchasing.  
- CLV (Customer Lifetime Value) = expected revenue/margin over a defined horizon.  
- Integration of DS outputs (scores) into dashboards closes the loop between **data science and business action**.  

**Acceptance Criteria**:  
- Customer 360 dashboard shows segments (RFM).  
- Churn risk and CLV tiers integrated from DS outputs.  
- Dashboard published in Fabric and shared with marketing.  

**Tasks**:  
- Integrate churn & CLV scores (from Data Science team).  
- Build Customer Segmentation dashboard.  
- Publish dashboards in Fabric (Power BI).  


---

## Epic 3 – Machine Learning & Predictive Analytics
**Goal**: Develop churn and Customer Lifetime Value (CLV) models using merged Customer 360.

---

### Feature 3.1: Exploratory Analysis (Sprint 1–2)
**User Story**:  
As a Data Scientist, I want to perform **Exploratory Data Analysis (EDA)** to understand customer behavior and overlaps.  

**Learning Resources**:  
- [EDA in Databricks](https://docs.databricks.com/exploratory-data-analysis/index.html)  
- [MLflow Tracking](https://mlflow.org/docs/latest/tracking.html)  
- [Churn Prediction Basics](https://towardsdatascience.com/churn-prediction-in-telecom-industry-2f2c7d7e9388)  

**Key Concepts**:  
- **EDA (Exploratory Data Analysis)** = profiling data to find patterns, missing values, distributions.  
- Churn definition = customers inactive for more than 90 days.  
- CLV (Customer Lifetime Value) = net margin expected per customer over a defined horizon (e.g., 12 months).  

**Acceptance Criteria**:  
- Missing values, outliers, and overlaps documented.  
- Clear churn definition (>90 days inactivity).  
- Draft CLV formula validated with business stakeholders.  

**Tasks**:  
- Perform EDA on Bronze (distributions, missing values, overlaps).  
- Define churn = inactivity > 90 days.  
- Draft CLV definition (12 months net margin).  

---

### Feature 3.2: Feature Engineering (Sprint 2)
**User Story**:  
As a Data Scientist, I want RFM and behavioral features to build churn & CLV models.  

**Learning Resources**:  
- [RFM Analysis](https://clevertap.com/blog/rfm-analysis/)  
- [Feature Engineering Guide](https://docs.databricks.com/machine-learning/feature-engineering/index.html)  
- [MLflow Tracking Features](https://mlflow.org/docs/latest/feature-store.html)  

**Key Concepts**:  
- RFM = Recency, Frequency, Monetary value (classic segmentation method).  
- Basket diversity = how many unique categories a customer buys from.  
- Cross-brand shopping = customers who purchased both EuroStyle & Contoso.  
- Features must be logged and versioned for reproducibility.  

**Acceptance Criteria**:  
- RFM metrics computed for all customers.  
- Basket diversity & cross-brand features available in Silver/Gold.  
- Feature sets tracked in MLflow or Delta tables.  

**Tasks**:  
- Compute **RFM (Recency, Frequency, Monetary value)** metrics.  
- Add basket diversity & cross-brand shopping signals.  
- Track feature sets in MLflow.  

---

### Feature 3.3: Model Training (Sprint 3)
**User Story**:  
As a Data Scientist, I want baseline models for churn and CLV so I can evaluate predictive power.  

**Learning Resources**:  
- [MLlib Classification](https://spark.apache.org/docs/latest/ml-classification-regression.html)  
- [MLflow Experiment Tracking](https://mlflow.org/docs/latest/tracking.html)  
- [Model Evaluation Metrics](https://scikit-learn.org/stable/modules/model_evaluation.html)  

**Key Concepts**:  
- Logistic Regression = baseline classification model for churn (yes/no).  
- Random Forest = regression model for CLV (predicting value).  
- Model evaluation uses **Accuracy, AUC (Area Under Curve)** for churn, **RMSE (Root Mean Squared Error)** for CLV.  

**Acceptance Criteria**:  
- Logistic Regression churn model trained and logged.  
- Random Forest CLV regression trained and logged.  
- Experiments tracked in MLflow with metrics and parameters.  

**Tasks**:  
- Train Logistic Regression for churn.  
- Train Random Forest for CLV.  
- Log all experiments in MLflow.  

---

### Feature 3.4: Batch Scoring & Integration (Sprint 4)
**User Story**:  
As a Data Scientist, I want to score churn/CLV and join them into Customer 360 so Analysts can use them.  

**Learning Resources**:  
- [MLflow Model Registry](https://mlflow.org/docs/latest/model-registry.html)  
- [Databricks Batch Scoring](https://docs.databricks.com/machine-learning/model-inference/index.html)  
- [Explainability Methods](https://christophm.github.io/interpretable-ml-book/)  

**Key Concepts**:  
- Batch scoring = apply trained models to full customer base.  
- Scores stored in Gold (`customer_scores_gold`).  
- Document model performance with **Accuracy, AUC, RMSE**.  
- Explainability = feature importance to justify predictions.  

**Acceptance Criteria**:  
- Churn probabilities and CLV values scored for all customers.  
- Scored datasets joined into `customer_360_gold`.  
- Model performance documented (Accuracy, AUC, RMSE).  
- Feature importance/explainability shared with analysts.  

**Tasks**:  
- Batch scoring → `customer_scores_gold`.  
- Publish scored tables to Gold marts.  
- Document performance (Accuracy, AUC, RMSE) and explainability.  

---

## Epic 4 – Platform Integration (Databricks ↔ Fabric)
**Goal**: Demonstrate end-to-end integration between Databricks and Microsoft Fabric, even on Free Editions.

---

### Feature 4.1: Export Gold to Fabric (Sprint 4)
**User Story**:  
As a Data Engineer, I want Gold marts exported to Fabric so dashboards can consume them via Direct Lake.  

**Learning Resources**:  
- [Fabric Lakehouse Overview](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)  
- [Fabric Data Pipelines](https://learn.microsoft.com/en-us/fabric/data-factory/)  
- [Databricks Parquet & Delta Export](https://docs.databricks.com/delta/delta-batch.html)  

**Key Concepts**:  
- **Gold marts** = final curated tables for analytics (sales_daily, customer_360, etc.).  
- **Parquet + manifest + _SUCCESS** = ensures consistent export contract.  
- **Fabric Lakehouse Files** (Free path) = manual upload from Databricks to Fabric.  
- **Delta in Fabric** = ingestion into tables ready for Direct Lake mode.  

**Acceptance Criteria**:  
- Gold marts exported as Parquet with manifest and success marker.  
- Files uploaded into Fabric Lakehouse `/Files/dropzone/...`.  
- Fabric Data Pipeline ingests and creates Delta tables.  
- Datasets are queryable in Power BI.  

**Tasks**:  
- Export Gold marts as Parquet + manifest.  
- Upload to Fabric Lakehouse Files (Free path).  
- Ingest with Fabric Data Pipeline → Delta tables.  

---

### Feature 4.2: Power BI Suite (Sprint 4)
**User Story**:  
As a Data Analyst, I want Power BI dashboards published through Fabric so executives can access the post-merger suite.  

**Learning Resources**:  
- [Power BI Service](https://learn.microsoft.com/en-us/power-bi/fundamentals/)  
- [Direct Lake in Fabric](https://learn.microsoft.com/en-us/fabric/data-warehouse/direct-lake-overview)  
- [Row-Level Security (RLS)](https://learn.microsoft.com/en-us/power-bi/admin/service-security-row-level-security)  

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







---

## Optional Extensions
- Advanced ML: Neural Nets, Gradient Boosted Trees  
- MLOps: CI/CD pipelines, model drift detection  
- Portfolio polish: publish repo + blog posts
