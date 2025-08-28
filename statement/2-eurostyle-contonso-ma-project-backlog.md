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
| 0 | [Epic 1 – Data Foundation Platform](#epic-1) (setup) | [Epic 3 – ML & Predictive](#epic-3) (hypotheses/scope) | [Epic 2 – Analytics & BI](#epic-2) (KPI Catalog v0.1) |
| 1 | [Epic 1 – Data Foundation Platform](#epic-1) | [Epic 3 – ML & Predictive](#epic-3) (EDA) | [Epic 2 – Analytics & BI](#epic-2) (First Look – Contoso) |
| 2 | [Epic 1 – Data Foundation Platform](#epic-1) (Silver) | [Epic 3 – ML & Predictive](#epic-3) (Features) | [Epic 2 – Analytics & BI](#epic-2) (Raw vs Silver – Contoso + EuroStyle) |
| 3 | [Epic 1 – Data Foundation Platform](#epic-1) (Gold marts) | [Epic 3 – ML & Predictive](#epic-3) (Model training) | [Epic 2 – Analytics & BI](#epic-2) (Executive) |
| 4 | [Epic 4 – Platform Integration](#epic-4) (Fabric) | [Epic 3 – ML](#epic-3) (Batch scoring) + [Epic 4](#epic-4) (Export/Validation) | [Epic 2 – Analytics](#epic-2) (Segmentation) + [Epic 4](#epic-4) (Power BI Suite) |
| 5 (optional) | [Epic 5 – Optional Extensions](#epic-5) (DE: Data Vault light; All: E2E deployment) | [Epic 5 – Optional Extensions](#epic-5) (DS: advanced models; All: export/validation) | [Epic 5 – Optional Extensions](#epic-5) (DA: dynamic dashboards; All: deployment pipeline) |

Notes
- Optional extensions (Epic 5.x) are scheduled under Sprint 5 (optional) based on team capacity.
- For detailed deliverables, see the Features map below and the User Stories within each epic.


## Feature-to-Sprint and Role Mapping

This table lists all features, distributed by sprint and by profile (DE, DS, DA). Ownership is ultimately at the user story level; this is the primary owner per feature.

| Sprint | DE (Data Engineer) | DS (Data Scientist) | DA (Data Analyst) |
|---|---|---|---|
| 0 | — | — | — |
| 1 | [1.1 Raw Data Ingestion](#feature-1-1) | [3.1 EDA, baselines & MLflow setup](#feature-3-1) | [2.1 First Look – Contoso](#feature-2-1) (semantic model, measures, v1 report) |
| 2 | [1.2 Silver Cleaning & Harmonization](#feature-1-2) | [3.1 EDA summary & risk log](#feature-3-1); [3.2 Feature Engineering](#feature-3-2) | [2.2 Raw vs Silver – Contoso + EuroStyle](#feature-2-2) |
| 3 | [1.3 Gold Business Marts](#feature-1-3) | [3.3 Model Training](#feature-3-3) | [2.3 Executive Post‑Merger Dashboard](#feature-2-3) |
| 4 | [4.1 Export Gold to Fabric](#feature-4-1) | [3.4 Batch Scoring & Integration](#feature-3-4), [4.3 Scoring Export & Validation](#feature-4-3) | [2.4 Customer Segmentation](#feature-2-4), [4.2 Power BI Suite](#feature-4-2) |
| 5 (optional) | [5.1 Simplified Data Vault](#feature-5-1); [5.4 E2E Deployment](#feature-5-4) (cross‑role) | [5.3 Survival/Probabilistic Models](#feature-5-3); [5.4 E2E Deployment](#feature-5-4) (cross‑role) | [5.2 Advanced Segmentation](#feature-5-2); [5.4 E2E Deployment](#feature-5-4) (cross‑role) |

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

<a id="feature-1-2"></a>
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
 - FX (Foreign Exchange) = converting source currency amounts into a single reporting currency (e.g., EUR) using documented reference rates and a fixed valuation date for reproducibility. Example sources: European Central Bank (ECB) reference rates (https://www.ecb.europa.eu/stats/eurofxref/), XE.com or OANDA APIs, Yahoo Finance API (historical).

**Acceptance Criteria**:  
- Duplicates removed with correct logic.  
- All currencies expressed in EUR.  
- Product hierarchy aligned across both datasets.  
- Customer IDs unified and cross-brand duplicates resolved.  
- Documentation of cleaning steps added in notebook.  
   - Note: Currency conversion reproducibility — store a reference FX table (e.g., European Central Bank (ECB) daily rates) and use a fixed valuation snapshot/date for the sprint; persist it in Silver (e.g., `silver.fx_rates_eur`).

**Tasks**:  
- Deduplicate data using business keys.  
- Standardize currencies (conversion → EUR).  
- Align product hierarchies using mapping table.  
- Normalize customer IDs across EuroStyle & Contoso.  
 - Create and persist an `fx_rates_eur` reference table with the chosen valuation date and FX source (e.g., European Central Bank (ECB)).

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

---

<a id="feature-2-2"></a>
### Feature 2.2: Raw vs Silver – Contoso + EuroStyle (Sprint 2)
**User Story**:  
As a Data Analyst, I want to compare KPIs Raw vs Silver to highlight data cleaning impact.  

**Learning Resources**:  
- [Data Quality Management](https://www.databricks.com/discover/pages/data-quality-management)  
- [Power BI Comparison Techniques](https://learn.microsoft.com/en-us/power-bi/visuals/power-bi-visualization-combo-chart)  

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

**Tasks**:  
- Perform **EDA** on Bronze (distributions, missing values, overlaps).  
- Define churn = inactivity > 90 days.  
- Draft **CLV** definition (12 months net margin).  
 - Publish an EDA summary with visuals and a prioritized data-quality issue list.  
 - Create and fill a leakage checklist; exclude leaky fields from labels/features.  
 - Implement simple baselines (rule-based churn risk, RFM segments) and record baseline performance.  
 - Initialize MLflow experiment; define train/validation/test split strategy and log runs with metrics/params.  

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

**Tasks**:  
- Compute **RFM (Recency, Frequency, Monetary value)** metrics.  
- Add basket diversity & cross-brand shopping signals.  
- Track feature sets in MLflow.  
 - Persist feature tables as versioned Delta (e.g., `silver.features_rfm_v1`) including schema/version metadata.  
 - Define and document the scoring schema and join keys with DE/DA for integration into `customer_360`/Gold; propose refresh cadence.  
 - Train first simple baselines on sample data and log to MLflow; compare against rule-based/RFM yardsticks.  
 - Document leakage assessment and run a quick feature-importance sanity check.  

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

**Tasks**:  
- **Train Logistic Regression** for churn.  
- Train **Random Forest for CLV**.  
- Log all experiments in **MLflow**.  

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

**Tasks**:  
- Batch scoring → `customer_scores_gold`.  
- Publish scored tables to Gold marts.  
- Document performance (Accuracy, AUC, RMSE) and explainability.  

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



