# EuroStyle–Contoso M&A – Unified Data & AI Platform with Databricks and Microsoft Fabric

## Business Case

**EuroStyle** is a European online fashion retailer operating in the UK, France, Germany, and the Benelux.  
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
- **Data Business Analyst Team**: Provide executives with comparative and consolidated dashboards.  
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

### Data Engineer 
- Build a reproducible **Medallion pipeline** (Bronze → Silver → Gold).  
  - **Bronze**: ingest EuroStyle and Contoso raw files exactly as delivered.  
  - **Silver**: clean and harmonize schemas (products, customers, orders).  
  - **Gold**: integrate into unified marts ready for analytics and data science.  
- Maintain mapping tables to align product hierarchies and customer identifiers across brands.  
- Ensure reproducibility so the same process can be re-run as new data arrives.  

### Data Business Analyst
- Deliver dashboards that serve two complementary views:
  - **Comparative view**: EuroStyle vs. Contoso performance side-by-side.
  - **Unified view**: consolidated KPIs across both brands, including  
    - **Gross Merchandise Value (GMV)**: total value of merchandise sold,  
    - **Average Order Value (AOV)**: average spend per order,  
    - and margin.  
  - Note: If **Cost of Goods Sold** (**COGS**: direct costs to acquire/produce items, e.g., purchase cost, manufacturing, inbound freight) is not present in source datasets, margin may be deferred or computed as an estimated proxy (clearly labeled) until proper cost data is available. See the Product Backlog (Feature 1.3 – Gold Business Marts) for proxy methods and a short SQL example.
- Implement **Row-Level Security (RLS)** so managers only see their own brand, while executives access the consolidated view.
- Provide clarity on key business questions: market share by region, margin gaps, and customer behavior differences North vs. South.

### Data Scientist
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

- **Data Business Analysts (DA)**  
  - Define **key performance indicators (KPIs)** from Day 0, highlighting differences in definitions between EuroStyle and Contoso.  
  - Build side-by-side dashboards early on raw/Bronze data, then refine them progressively on Silver and Gold.  
  - Implement **Row-Level Security (RLS)** in Power BI so managers see only their own brand while executives access consolidated dashboards.  
  - Deliver the final **executive Post-Merger dashboards** in Power BI, covering consolidated **Gross Merchandise Value (GMV)**, **Average Order Value (AOV)**, margin, churn, and customer segments.  

- **Data Scientists (DS)**  
  - Define hypotheses for **churn** and **Customer Lifetime Value (CLV)** from Sprint 0.  
  - Perform **Exploratory Data Analysis (EDA)** on Silver data to identify patterns, overlaps, and customer behaviors.  
  - Engineer predictive features such as **RFM scores (Recency, Frequency, Monetary value)**, churn indicators, and cross-sell signals.  
  - Train and validate models on **Gold data**, log experiments in **MLflow**, and publish churn & CLV scores back into the **Customer 360° mart** for business use.  



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

- See the [Product Backlog](./2-eurostyle-contonso-ma-project-backlog.md) for the sprint-by-sprint plan, task lists, and acceptance criteria.  


---

In summary, Agile enables the team to **deliver incremental value each sprint**, demonstrate working outcomes to stakeholders, and adapt quickly—even on free tiers (Databricks Free, Fabric Trial).

---

## Deliverables Journey – From Essentials to Mastery

This table maps the four ambition levels of the project to the concrete contributions of each role.  
It mirrors the same structure as *Roles per Sprint*, ensuring clarity and consistency.

| Level of Ambition | Data Engineer (DE) | Data Scientist (DS) | Data Analyst (DA) | Objectives |
|-------------------|---------------------|----------------------|-------------------|------------|
| **Must-Have (Essentials)** | Load EuroStyle + Contoso raw files into **Bronze Delta** with metadata (ingest_ts, source_system), a basic DQ summary, and a mini schema dictionary/runbook | Define initial hypotheses for churn and **Customer Lifetime Value (CLV)**; set up notebooks for basic **Exploratory Data Analysis (EDA)** | Create first dashboards showing **Gross Merchandise Value (GMV)**, **Average Order Value (AOV)**, and order counts from Bronze | Prove that ingestion works end-to-end and provide first insights |
| **Stretching (Robustness)** | Build the **Silver layer**: clean data, harmonize schemas, align currencies (FX→EUR), and prepare first **Gold marts** | Conduct detailed **EDA** on Silver: detect overlaps, missing values, customer segments; start designing **RFM features** (Recency, Frequency, Monetary value) | Redesign dashboards with harmonized KPIs; implement **Row-Level Security (RLS)** and add a methods banner (returns rule, FX valuation date, margin proxy note) | Guarantee consistent and reliable reporting across both brands |
| **Excellence (Advanced Value)** | Enrich **Customer 360° Gold mart** with scored tables (e.g., churn probability, CLV segments) | Train baseline churn and CLV models (e.g., Logistic Regression, Random Forest); track runs in MLflow; refine features such as cross-sell signals | Add predictive KPIs (churn risk, CLV tiers) into Fabric/Power BI dashboards | Move from descriptive reporting to predictive decision-making |
| **Hire Me Level (Mastery)** | Document and publish reusable pipelines for ingestion, transformation, and export to Fabric Lakehouse; note the optional orchestration path (Feature 5.4: Airflow DAG + Fabric fallback) | Finalize churn and CLV models; document performance using metrics such as **accuracy**, **Area Under the Curve (AUC)**, and **Root Mean Squared Error (RMSE)**; provide explainability; publish customer-level scored datasets for reuse | Build executive-level dashboards combining financial KPIs and predictive scores; present a polished *"Post-Merger Analytics with Databricks & Fabric"* case | Demonstrate full mastery of engineering, analytics, and science in a unified portfolio-ready project |

---

## Datasets

You will work with **two European retail datasets** to simulate EuroStyle (North/West Europe) and Contoso (South Europe).

**EuroStyle – Primary Dataset (Online Retail II, UCI)**  
- Link: https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci  
- Notes: Real transactional data (invoice-level), single-table CSV. Good for Bronze ingestion and baseline KPIs.

**Contoso – Secondary Dataset (European Fashion Store – Multitable)**  
- Link: https://www.kaggle.com/datasets/joycemara/european-fashion-store-multitable-dataset  
- Notes: Synthetic but realistic, multiple related tables (orders, products, customers). Ideal for schema harmonization and joins.

---

## Detailed Deliverables

For full details of tasks, acceptance criteria, and technical specifications, see the [Product Backlog](./eurostyle-contonso-ma-project-backlog.md).

Note: For acronym definitions (GMV, AOV, RFM, CLV, RLS, etc.), see the repository [Glossary](../GLOSSARY.md).



---

## Educational note (BeCode Data Analytics & AI Bootcamp)

This Business Case is provided solely for educational purposes as part of the BeCode Data Analytics & AI Bootcamp. Names, datasets, and scenarios are illustrative for training only and are not production guidance.

---
 Additional resource: [secloudis.com](https://secloudis.com) – articles and notes on cloud, data, analytics, and artificial intelligence (optional external reference).

