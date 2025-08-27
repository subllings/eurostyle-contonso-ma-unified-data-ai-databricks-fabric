# EuroStyle–Contoso M&A – Unified Data & AI Platform with Databricks & Microsoft Fabric

## Business Context

In 2025, EuroStyle (Northern Europe) acquired Contoso Retail (Southern Europe).  
Together they serve **350k+ customers** and manage **80k+ SKUs** across apparel, footwear, and accessories.  

The merger created both opportunities and challenges:  
- **Data fragmentation**: two separate systems (files, ERPs, CRMs) must be consolidated.  
- **Inconsistent KPIs**: Gross Merchandise Value (GMV), Average Order Value (AOV), margin, and return rates are defined differently, creating confusion at board level.  
- **Post-merger visibility gap**: leaders need both **comparative views** (EuroStyle vs Contoso) and a **unified Customer 360°**.  
- **Churn risk & cannibalization**: overlapping customers and product lines increase churn risk.  

To address this, the CMO and CDAO requested a **prototype platform** combining **Databricks** and **Microsoft Fabric**:

- **Databricks**: ingestion pipelines, Medallion architecture (Bronze/Silver/Gold), schema harmonization, feature engineering, MLflow for model tracking.  
- **Fabric**: Lakehouse, semantic models, Power BI dashboards with Direct Lake for executives and marketing.  
- **Integration Path**:  
  - **Free / Trial Setup (classroom prototype)**: Databricks Free Edition exports Gold marts as Parquet files + JSON manifest. These are uploaded manually into the Fabric Lakehouse `/Files` area, then ingested with Fabric Data Pipelines.  
  - **Paid / Enterprise Setup (production-ready)**: Databricks Premium/Enterprise writes versioned **Delta tables** into ADLS Gen2 (with Unity Catalog and Delta Live Tables). Fabric connects via **Shortcuts** (zero-copy) or Pipelines, enabling **Direct Lake** dashboards at scale with full automation, governance, and CI/CD.
 

---

## Project Objectives

- **Data Engineering (Databricks)**: Build reproducible Medallion pipelines, harmonize schemas, create unified Gold marts, export to Fabric Lakehouse.  
- **Data Analytics (Fabric/Power BI)**: Deliver comparative dashboards (EuroStyle vs Contoso) and unified post-merger dashboards with RLS.  
- **Data Science (Databricks MLflow)**: Train churn and Customer Lifetime Value (CLV) models, publish scored datasets into Customer 360°.  

---

## Sprint Structure

| Sprint | Focus | Key Deliverables | Platforms |
|--------|-------|------------------|-----------|
| **0** | Setup | Workspace, backlog, KPI catalog | Databricks + Fabric |
| **1** | Bronze | Ingest EuroStyle + Contoso, Raw KPIs dashboard | Databricks (Bronze), Power BI (DirectQuery) |
| **2** | Silver | Clean & harmonize schemas, Raw vs Silver dashboard | Databricks (Silver), Power BI |
| **3** | Gold | Gold marts + executive dashboard | Databricks (Gold), Fabric + Power BI |
| **4** | ML + Export | Churn & CLV scoring, export Gold to Fabric, Post-Merger Suite | Databricks (MLflow), Fabric Lakehouse, Power BI |

---

## Platform Context

This project is delivered with **Databricks Free Edition** and **Fabric Trial**.  
Free tiers impose limitations (manual exports, no ADLS Gen2, limited governance),  
but they still allow us to demonstrate the **end-to-end integration** between Databricks (pipelines, MLflow) and Fabric (Lakehouse, Direct Lake, Power BI).  

In a production environment, this would be automated and governed using:  
- **Databricks Premium/Enterprise**: Delta Live Tables, Unity Catalog, Workflows, Jobs.  
- **Azure Data Lake Gen2 + Fabric Shortcuts**: zero-copy integration for Direct Lake.  
- **Fabric Deployment Pipelines**: Dev/Test/Prod environments.  
- **Enterprise Security**: Managed Identity, Key Vault, Private Endpoints, RBAC.  

---

## Deliverables Journey

| Level | Data Engineer | Data Scientist | Data Analyst | Objective |
|-------|---------------|----------------|--------------|-----------|
| Essentials | Bronze ingestion | Churn & CLV hypotheses | Raw KPIs dashboard | First insights |
| Robustness | Silver harmonization, Gold marts | Feature engineering (RFM, overlap) | Silver dashboards + RLS | Reliable reporting |
| Advanced | Gold marts enriched with scores | Baseline churn & CLV models | Predictive KPIs dashboards | Predictive insights |
| Mastery | Reusable pipelines & exports | Finalized models + metrics (Accuracy, AUC, RMSE) | Executive storytelling dashboards | Portfolio-ready prototype |


---

## References
- [Business Case](../statement/1-eurostyle-contonso-ma-business-case.md)  
- [Product Backlog](../statement/2-eurostyle-contonso-ma-project-backlog.md)  
