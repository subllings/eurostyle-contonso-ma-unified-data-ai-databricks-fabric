# EuroStyle–Contoso M&A – Unified Data & AI Platform with Databricks and Microsoft Fabric

## Business Case

EuroStyle is a European online fashion retailer operating in the UK, France, Germany, and the Benelux.  
In early 2025, EuroStyle acquired **Contoso Retail**, a Spanish and Italian fashion chain with a strong customer base in Southern Europe.

Together, the two brands now serve **over 350 000 customers** and manage a combined portfolio of more than **80 000 SKUs** across apparel, footwear, and accessories.

The merger brings opportunities but also challenges:
- **Data fragmentation**: EuroStyle and Contoso rely on separate systems (files, ERPs, CRMs). Consolidating them into a single analytical view is essential.  
- **Inconsistent KPIs**: **GMV (Gross Merchandise Value)**, **AOV (Average Order Value)**, **margin**, and **return rates** are calculated differently across the two companies, creating confusion at the board level.
- **Post-merger visibility gap**: Executives need to compare EuroStyle vs. Contoso performance but also see a **unified sales and customer view**.  
- **Churn risk & cannibalization**: Overlapping product lines and customer bases may increase churn.  
- **Slow integration process**: Without a modern data platform, analysts spend days manually stitching EuroStyle and Contoso datasets.

The **Chief Marketing Officer (CMO)** and **Chief Data & Analytics Officer (CDAO)** have tasked three specialized teams to deliver a **prototype of a unified post-merger data platform** leveraging Databricks and Microsoft Fabric:
- **Data Engineering Team**: Build robust pipelines to integrate EuroStyle and Contoso sources into a harmonized Medallion architecture.  
- **Data Analytics Team**: Provide executives with comparative and consolidated dashboards.  
- **Data Science Team**: Develop predictive models to assess churn and customer lifetime value across the merged customer base.

---

## Key Business Metrics Definitions

- **GMV (Gross Merchandise Value)**: Unified definition across EuroStyle & Contoso to ensure consistent reporting.  
- **AOV (Average Order Value)**: Harmonized calculation based on a unified order table.  
- **SKU (Stock Keeping Unit)**: Alignment of product hierarchies between EuroStyle and Contoso (mapping tables).  
- **RFM Analysis**: Post-merger segmentation showing differences in behavior between Northern and Southern European customers.  
- **Customer 360°**: Unified customer entity across both companies, with deduplication and cross-brand identifiers.  
- **Churn**: Customers inactive for >90 days, measured consistently across both brands.
 - **FX (Foreign Exchange)**: Currency conversion from source currencies to a common reporting currency (e.g., EUR). Use documented reference rates (e.g., European Central Bank (ECB)) and a fixed valuation date for reproducibility. Examples of FX sources: European Central Bank (ECB) reference rates (https://www.ecb.europa.eu/stats/eurofxref/), XE.com or OANDA APIs, Yahoo Finance API (historical rates).

---

## Project Objectives

### Data Engineering
- Build a reproducible **Medallion pipeline** (Bronze → Silver → Gold).  
  - **Bronze**: ingest EuroStyle and Contoso raw files exactly as delivered.  
  - **Silver**: clean and harmonize schemas (products, customers, orders).  
  - **Gold**: integrate into unified marts ready for analytics and data science.  
- Maintain mapping tables to align product hierarchies and customer identifiers across brands.  
- Ensure reproducibility so the same process can be re-run as new data arrives.  

### Data Analytics
- Deliver dashboards that serve two complementary views:
  - **Comparative view**: EuroStyle vs. Contoso performance side-by-side.
  - **Unified view**: consolidated KPIs across both brands, including  
    - **Gross Merchandise Value (GMV)**: total value of merchandise sold,  
    - **Average Order Value (AOV)**: average spend per order,  
    - and margin.  
  - Note: If Cost of Goods Sold (COGS: direct costs to acquire/produce items, e.g., purchase cost, manufacturing, inbound freight) is not present in source datasets, margin may be deferred or computed as an estimated proxy (clearly labeled) until proper cost data is available. See the Product Backlog (Feature 1.3 – Gold Business Marts) for proxy methods and a short SQL example.
- Implement **Role-Based Access Control (RLS)** so managers only see their own brand, while executives access the consolidated view.
- Provide clarity on key business questions: market share by region, margin gaps, and customer behavior differences North vs. South.

### Data Science
- Develop predictive models for **churn** and **Customer Lifetime Value (CLV)** across both brands.
- Conduct **Exploratory Data Analysis (EDA)** on the Silver layer to detect overlaps and purchase patterns.
- Engineer features such as **RFM scores (Recency, Frequency, Monetary value)**, churn indicators, and cross-sell signals.
- Train and validate models on the Gold layer to assess churn risk and predict cross-selling opportunities (e.g., EuroStyle customers likely to buy Contoso products).
- Publish model outputs back into the **Customer 360° mart** for use in analytics and dashboards.


---

## Profiles and Responsibilities

- **Data Engineers (DE)**  
  - Own ingestion pipelines for EuroStyle and Contoso datasets.  
  - Harmonize schemas, clean data, and integrate into unified **Gold marts** (sales, customers, products).  
  - Maintain mapping tables for cross-brand consistency (e.g., product hierarchies, customer IDs).  
  - Export unified Gold datasets into the **Fabric Lakehouse** under a reproducible release contract.  

- **Data Analysts (DA)**  
  - Define **key performance indicators (KPIs)** from Day 0, highlighting differences in definitions between EuroStyle and Contoso.  
  - Build side-by-side dashboards early on raw/Bronze data, then refine them progressively on Silver and Gold.  
  - Implement **Role-Based Access Control (RLS)** in Power BI so managers see only their own brand while executives access consolidated dashboards.  
  - Deliver the final **executive Post-Merger dashboards** in Power BI, covering consolidated **Gross Merchandise Value (GMV)**, **Average Order Value (AOV)**, margin, churn, and customer segments.  

- **Data Scientists (DS)**  
  - Define hypotheses for **churn** and **Customer Lifetime Value (CLV)** from Sprint 0.  
  - Perform **Exploratory Data Analysis (EDA)** on Silver data to identify patterns, overlaps, and customer behaviors.  
  - Engineer predictive features such as **RFM scores (Recency, Frequency, Monetary value)**, churn indicators, and cross-sell signals.  
  - Train and validate models on Gold data, log experiments in MLflow, and publish churn & CLV scores back into the **Customer 360° mart** for business use.  



---


## Sprint Structure (High-Level)

The project is organized into five sprints, each delivering specific outcomes across Databricks, Fabric, and Power BI.  


| Sprint | Duration | Focus (M&A Context) | Key Deliverables | Platforms |
|--------|----------|----------------------|------------------|-----------|
| **0** | 0.5 day | Setup & Planning | Workspace setup, schema documentation, backlog refinement, KPI catalog | Databricks (workspace) · Fabric (semantic model draft) |
| **1** | 4.5 days | Bronze & First Insights | Bronze ingestion (EuroStyle + Contoso), Raw KPIs dashboard | Databricks (Bronze tables) · Power BI (DirectQuery dashboard) |
| **2** | 4.5 days | Silver & Harmonization | Cleaned Silver, schema alignment, Raw vs Silver dashboard | Databricks (Silver tables) · Power BI (Silver dashboard) |
| **3** | 4.5 days | Gold & Post-Merger Views | Unified Gold marts, executive consolidated dashboard | Databricks (Gold marts) · Fabric/Power BI (exec dashboards) |
| **4** | 4.5 days | MLflow & Fabric Integration | Churn/CLV scoring, export to Fabric, Power BI Post-Merger Suite | Databricks (MLflow models, scored tables) · Fabric (Lakehouse, Direct Lake) · Power BI (Post-Merger Suite) |

**Note – Sprint 1 (Bronze in Databricks):**  
You expose your Bronze tables via the `hive_metastore` (or SQL views).  
In Power BI Desktop: *Get Data → Databricks* → provide **Server Hostname** and **HTTP Path** (found in cluster JDBC/ODBC settings). Authenticate using a Databricks Personal Access Token (Authentication method = Token).

---


## Roles per Sprint (EuroStyle–Contoso M&A)

It shows what **Data Engineers (DE)**, **Data Scientists (DS)**, and **Data Analysts (DA)** contribute at every stage of the project,  
and specifies the **platforms** (Databricks, Fabric, Power BI) where their work is implemented.

| Sprint | Data Engineer (DE) | Data Scientist (DS) | Data Analyst (DA) | Platforms |
|---|---|---|---|---|
| **0** | Set up Databricks workspace & folders; define ingestion paths for EuroStyle + Contoso | Define churn/CLV hypotheses, identify data requirements, prepare MLflow experiments | Document KPI catalog (EuroStyle vs Contoso), map differences, design draft semantic model | DE: Databricks · DS: Databricks (MLflow) · DA: Fabric/Power BI |
| **1** | Ingest EuroStyle + Contoso raw CSVs into **Bronze Delta**; add metadata & data quality checks | EDA on Bronze (distributions, missing values, overlap) | Build "First Look Dashboard" with Raw/Bronze KPIs (GMV, AOV, order counts) | DE: Databricks (Bronze) · DS: Databricks · DA: Power BI (DirectQuery to Databricks SQL) |
| **2** | Transform Bronze → Silver (deduplication, schema harmonization, currency alignment) | Feature engineering (RFM, overlap, basket diversity) with MLflow tracking | Redesign dashboard with Silver data; show Raw vs Silver KPIs; define RLS/governance | DE: Databricks (Silver) · DS: Feature store/MLflow · DA: Power BI |
| **3** | Create Gold marts (`sales_daily`, `category_perf`, unified `customer_360`) | Train baseline churn/CLV models (LR, RF); log runs in MLflow | Executive Post-Merger Dashboard (consolidated view, brand/geography splits) | DE: Databricks (Gold) · DS: MLflow · DA: Fabric/Power BI (Gold marts) |
| **4** | Export Gold marts → Fabric Lakehouse (Shortcuts/Parquet); orchestrate | Batch scoring of churn/CLV; publish scores into Gold; register models | Unified Power BI dashboards with RLS, Customer Segmentation + Churn, deployment pipelines | DE: Databricks + Fabric · DS: Databricks + Fabric · DA: Power BI/Fabric |



---

### Platform Context

This prototype is built using **Databricks Free Edition** together with **Microsoft Fabric Free/Trial**.  
While both free tiers impose limitations, they are sufficient to demonstrate the full integration of Databricks (for Medallion architecture and MLflow) and Fabric (for Lakehouse, Direct Lake, and Power BI dashboards).



#### Constraints vs. Viability

| Aspect              | Free Tier Constraints                                        | How the Solution Still Works |
|---------------------|--------------------------------------------------------------|-------------------------------|
| **Databricks cluster** | Auto-stops after ~2h, limited performance                 | Acceptable for Bronze/Silver exploration; clusters can be restarted when needed |
| **Storage**         | No ADLS Gen2 integration in Free Edition                     | Data exported as Parquet + manifest; uploaded manually to Fabric Lakehouse |
| **Fabric capacity** | Limited to trial capacity; not production-scale              | Enough to validate Direct Lake, semantic models, and Power BI dashboards |
| **Orchestration**   | Manual triggers, limited scheduling                          | Pipelines in Fabric ensure ingestion and refresh; manual Databricks export is acceptable for demo |
| **Security & RBAC** | No enterprise-level governance in free tiers                 | Role-based access simulated at dashboard level (Power BI RLS) |
| **BI mode**         | DirectQuery on Databricks cluster in Sprint 1–Sprint 2; Direct Lake only later | Demonstrates end-to-end journey from raw Bronze (DirectQuery) to governed Fabric (Direct Lake) |



In other words, although the free editions lack enterprise features (ADLS integration, automation, large-scale performance), they allow us to deliver a **working prototype** of a unified EuroStyle–Contoso post-merger platform, showcasing ingestion, harmonization, analytics, and predictive modeling across Databricks and Fabric.




---

## Agile Way of Working

The project is managed following Agile principles, with short sprints and continuous feedback loops.  
Agility ensures that data engineers, data scientists, and data analysts can iterate together, validate assumptions quickly, and deliver visible value at the end of each sprint.

- **Sprint Planning**  
  The team collectively defines the objectives for the sprint, distinguishing between **must-have deliverables** (essential to move forward) and **stretch goals** (value-adding if time permits).  
  For example, a must-have may be ingesting EuroStyle and Contoso raw files into Bronze, while a stretch goal could be automating quality checks.

- **Daily Stand-up**  
  A short meeting where each role shares:  
  1. What they accomplished yesterday.  
  2. What they plan to do today.  
  3. Any blockers requiring help from others.  
  >This ensures transparency across DE, DS, and DA tasks (e.g., if data cleaning is delayed, the analyst knows not to build a Silver dashboard yet).

- **Sprint Review**  
  At the end of each sprint, the team demonstrates concrete deliverables to stakeholders:  
  - Dashboards in Power BI.  
  - Delta tables in Databricks (Bronze/Silver/Gold).  
  - Initial churn and **Customer Lifetime Value (CLV)** models logged in MLflow.  
  >The focus is on showing **working software/data** rather than slides or theory.

- **Sprint Retrospective**  
  A dedicated session to reflect on how the sprint went:  
  - What worked well (e.g., quick schema alignment).  
  - What did not (e.g., manual upload to Fabric too slow).  
  - What to improve next sprint (e.g., automate checks, refine backlog).  
  >Retrospectives help the team adapt continuously, improving both collaboration and delivery.

- **Cross-Role Collaboration**  
  Agile practices in this project are not just about ceremonies, but about **tight integration between roles**:  
  - Data Engineers prepare and document data so Data Analysts and Scientists can use it without rework.  
  - Data Analysts provide early feedback on Silver tables by visualizing them in Power BI.  
  - Data Scientists share exploratory findings from Exploratory Data Analysis (EDA) and feature importance with analysts to guide dashboard metrics.  
  >This ensures that Databricks and Fabric are used in a complementary way, not in silos.

---

In summary, the Agile way of working ensures that even with limited free-tier platforms (Databricks Free, Fabric Trial), the team can **deliver incremental business value each sprint**, demonstrate progress to stakeholders, and continuously adapt as new challenges or opportunities arise.

---

## Deliverables Journey – From Essentials to Mastery

This table maps the four ambition levels of the project to the concrete contributions of each role.  
It mirrors the same structure as *Roles per Sprint*, ensuring clarity and consistency.

| Level of Ambition | Data Engineer (DE) | Data Scientist (DS) | Data Analyst (DA) | Objectives |
|-------------------|---------------------|----------------------|-------------------|------------|
| **Must-Have (Essentials)** | Load EuroStyle + Contoso raw files into **Bronze Delta** with metadata and quality checks | Define initial hypotheses for churn and **Customer Lifetime Value (CLV)**; set up notebooks for basic **Exploratory Data Analysis (EDA)** | Create first dashboards showing **Gross Merchandise Value (GMV)**, **Average Order Value (AOV)**, and order counts from Bronze | Prove that ingestion works end-to-end and provide first insights |
| **Stretching (Robustness)** | Build the **Silver layer**: clean data, harmonize schemas, align currencies, and prepare first **Gold marts** | Conduct detailed **EDA** on Silver: detect overlaps, missing values, customer segments; start designing **RFM features** (Recency, Frequency, Monetary value) | Redesign dashboards with harmonized KPIs; implement **Role-Based Access Control (RLS)** to separate manager vs. executive views | Guarantee consistent and reliable reporting across both brands |
| **Excellence (Advanced Value)** | Enrich **Customer 360° Gold mart** with scored tables (e.g., churn probability, CLV segments) | Train baseline churn and CLV models (e.g., Logistic Regression, Random Forest); track runs in MLflow; refine features such as cross-sell signals | Add predictive KPIs (churn risk, CLV tiers) into Fabric/Power BI dashboards | Move from descriptive reporting to predictive decision-making |
| **Hire Me Level (Mastery)** | Document and publish reusable pipelines for ingestion, transformation, and export to Fabric Lakehouse | Finalize churn and CLV models; document performance using metrics such as **accuracy**, **Area Under the Curve (AUC)**, and **Root Mean Squared Error (RMSE)**; provide explainability; publish customer-level scored datasets for reuse | Build executive-level dashboards combining financial KPIs and predictive scores; present a polished *"Post-Merger Analytics with Databricks & Fabric"* case | Demonstrate full mastery of engineering, analytics, and science in a unified portfolio-ready project |

---

## Dataset

You will work with **two European retail datasets** to simulate EuroStyle (North/West Europe) and Contoso (South Europe).

**EuroStyle – Primary Dataset (Online Retail II, UCI)**  
- Link: https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci  
- Notes: Real transactional data (invoice-level), single-table CSV. Good for Bronze ingestion and baseline KPIs.

**Contoso – Secondary Dataset (European Fashion Store – Multitable)**  
- Link: https://www.kaggle.com/datasets/joycemara/european-fashion-store-multitable-dataset  
- Notes: Synthetic but realistic, multiple related tables (orders, products, customers). Ideal for schema harmonization and joins.

**Upload instructions (Databricks Free Edition)**  
- Download CSVs locally, then upload to:  
  - EuroStyle: `/FileStore/retail/raw/eurostyle/...`  
  - Contoso: `/FileStore/retail/raw/contoso/...`

**Example column mapping (to harmonize schemas)**

| Unified field        | EuroStyle (Online Retail II) | Contoso (European Fashion Store) |
|---|---|---|
| `order_id`           | `InvoiceNo`                   | `order_id` |
| `order_date`         | `InvoiceDate`                 | `order_date` |
| `customer_id`        | `CustomerID`                  | `customer_id` |
| `sku`                | `StockCode`                   | `sku` or `product_id` |
| `product_name`       | `Description`                 | `product_name` |
| `quantity`           | `Quantity`                    | `quantity` |
| `unit_price`         | `UnitPrice`                   | `unit_price` |
| `country`            | `Country`                     | `country` |
| `currency`           | inferred/assumed              | `currency` (if present) |

Recommendations  
- Normalize currencies to a common target (e.g., EUR) before Silver.  
- Build mapping tables for `sku` and product hierarchy.  
- Deduplicate by `(order_id, sku, customer_id, order_date)` where needed.  
- Add `source_system` column: `eurostyle` or `contoso`.

---

## Detailed Deliverables

For full details of tasks, acceptance criteria, and technical specifications, see the [Product Backlog](https://github.com/subllings/eurostyle-contonso-ma-unified-data-ai-databricks-fabric/blob/main/statement/2-eurostyle-contonso-ma-project-backlog.md).

---
