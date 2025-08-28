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
- [What is Delta Lake in Azure Databricks?](https://learn.microsoft.com/en-us/azure/databricks/delta/)
- [Apache Spark&trade; Tutorial: Getting Started with Apache Spark on Databricks](https://www.databricks.com/spark/getting-started-with-apache-spark/dataframes#visualize-the-dataframe)
- [PySpark DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql/dataframe.html)  
- [Tutorial: Build an ETL pipeline with Lakeflow Declarative Pipelines](https://learn.microsoft.com/en-us/azure/databricks/getting-started/data-pipeline-get-started)

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
- [Data Quality Management](https://www.databricks.com/discover/pages/data-quality-management)  
- [PySpark DataFrame API](https://api-docs.databricks.com/python/pyspark/latest/pyspark.sql/api/pyspark.sql.DataFrame.html)  

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
- [Star Schema Design](https://www.databricks.com/glossary/star-schema)  
- [Performance Optimization in Delta](https://docs.databricks.com/aws/en/delta/best-practices)  
- [Recency, Frequency, Monetary (RFM) Segmentation](https://www.databricks.com/solutions/accelerators/rfm-segmentation)  
- [Retail Personalization with RFM Segmentation and the Composable CDP](https://www.databricks.com/blog/retail-personalization-rfm-segmentation-and-composable-cdp)
- [RFM Segmentation, Databricks Solution Accelerators](https://github.com/databricks-industry-solutions/rfm-segmentation)
- [Gross Merchandise Value (GMV): Meaning & Calculation](https://www.yieldify.com/blog/gross-merchandise-value-gmv)
- [Understanding GMV in ecommerce](https://getrecharge.com/blog/understanding-gmv-in-ecommerc)
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
- [Work with the legacy Hive metastore alongside Unity Catalog](https://docs.databricks.com/aws/en/data-governance/unity-catalog/hive-metastore)  
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
- [Data Quality Management](https://www.databricks.com/discover/pages/data-quality-management)  
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

---

### Feature 2.4: Customer Segmentation Dashboard (Sprint 4)
**User Story**:  
As a Marketing Manager, I want to see customer segments & churn risk so I can design campaigns.  

**Learning Resources**:  
- [RFM Analysis](https://clevertap.com/blog/rfm-analysis/) 
- [Databricks Solution Accelarator - Predict Customer Churn](https://www.databricks.com/solutions/accelerators/predict-customer-churn)  
- [Databricks Intelligence Platform for C360: Reducing Customer Churn](https://www.databricks.com/resources/demos/tutorials/lakehouse-platform/c360-platform-reduce-churn)
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
- [Churn Prediction Basics](https://www.databricks.com/solutions/accelerators/predict-customer-churn)  

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
- [Feature Engineering Guide](https://www.databricks.com/glossary/feature-engineering)  
- [MLflow Tracking Features](https://docs.databricks.com/aws/en/mlflow/tracking)  

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


---

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

---
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


---

## Optional Extensions

### Feature 5.1 (DE) – Simplified Data Vault in Silver  

**User Story**  
As a Data Engineer, I want a simplified Data Vault (Hubs, Links, Satellites) in the Silver layer so downstream Gold marts are consistent, modular, and easy to evolve.

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

**Minimal SQL Example (adapt for CE)**  
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

Free Edition Limitations (Databricks CE + Fabric Student)

- No Delta Live Tables (DLT) or Jobs API: transformations must be run manually; no native scheduled pipelines.
- No Unity Catalog: no centralized governance, lineage, or fine-grained policies; rely on naming conventions and workspace scopes.
- Limited compute and session lifetime: keep data volumes modest; avoid heavy SHAP or deep nets on large samples.
- Limited optimization features: if OPTIMIZE/Z-ORDER options are unavailable, compact data via write patterns (e.g., coalesce/repartition) and keep file sizes reasonable.
- No Airflow jobs in Fabric free/student and no Databricks tokens in CE: CI/CD and orchestration must be simulated (documented steps, local GitHub Actions for tests only).
- SCD2 management is manual: track changes with effective dates and handle historical data in the application logic.

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
- No Jobs API → cannot schedule or trigger pipelines automatically.  
- No Unity Catalog → no centralized governance or lineage.  
- Limited compute → must work on small datasets.  
- Manual export/import only → users must download Parquet from DBFS and upload into Fabric.  
- GitHub Actions usable for **static checks only** (no direct deployment).  









