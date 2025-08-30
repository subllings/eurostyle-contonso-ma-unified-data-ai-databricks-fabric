# EuroStyle–Contoso M&A – Unified Data & AI Platform with Databricks & Microsoft Fabric

This case shows how Databricks and Microsoft Fabric can unify two retailers' fragmented systems into a single, governed, and AI-driven platform, giving executives consistent KPIs, real-time dashboards, and predictive insights after a complex M&A.



## Business Context

In 2025, EuroStyle (Northern Europe) acquired Contoso Retail (Southern Europe).  
Together they serve **350k+ customers** and manage **80k+ SKUs** across apparel, footwear, and accessories.  

The merger created both opportunities and challenges:  
- **Data fragmentation**: two separate systems (files, ERPs, CRMs) must be consolidated.  
- **Inconsistent KPIs**: Gross Merchandise Value (GMV), Average Order Value (AOV), margin, and return rates are defined differently, creating confusion at board level.  
- **Post-merger visibility gap**: leaders need both **comparative views** (EuroStyle vs Contoso) and a **unified Customer 360°**.  
- **Churn risk & cannibalization**: overlapping customers and product lines increase churn risk.  

To address this, the CMO and CDAO asked the **Data Engineer**, **Data Scientist**, and **Data Business Analyst** teams to deliver a **prototype platform** combining **Databricks** and **Microsoft Fabric**:

- **Databricks**: ingestion pipelines, Medallion architecture (Bronze/Silver/Gold), schema harmonization, feature engineering, MLflow for model tracking.  
- **Fabric**: Lakehouse, semantic models, Power BI dashboards with Direct Lake for executives and marketing.  
 - **Integration**: Shortcut-first; otherwise export + pipeline. Supports Direct Lake and CI/CD.
 - **Profiles**: DE (Medallion + handover), DS (EDA→churn/CLV + scoring), Data Business Analyst (Fabric/Power BI, RLS, dashboards).
 

---

## Project Objectives

- **Data Engineering (Databricks)**: Build reproducible Medallion pipelines, harmonize schemas, create unified Gold marts, export to Fabric Lakehouse.  
- **Data Analytics (Fabric/Power BI)**: Deliver comparative dashboards (EuroStyle vs Contoso) and unified post-merger dashboards with RLS.  
- **Data Science (Databricks MLflow)**: Train churn and Customer Lifetime Value (CLV) models, publish scored datasets into Customer 360°.  

---

![picture 8](images/daa5adb827d2fc7487dc37c035199c3f628e68fac93ce5aefcec854f1cca42bd.png)  


---

## Platform Context

This project targets **Azure Databricks Premium Trial** (14 days of DBUs) and **Microsoft Fabric Trial**.  
If trials aren't available, you can still follow along using Databricks Free Edition and Fabric Free (F2) with some constraints.  
Either path demonstrates the **end-to-end integration** between Databricks (pipelines, MLflow) and Fabric (Lakehouse, Direct Lake, Power BI).  

In a production environment, this would be automated and governed using:  
- **Databricks Premium/Enterprise**: Delta Live Tables, Unity Catalog, Workflows, Jobs.  
- **Azure Data Lake Gen2 + Fabric Shortcuts**: zero-copy integration for Direct Lake.  
- **Fabric Deployment Pipelines**: Dev/Test/Prod environments.  
- **Enterprise Security**: Managed Identity, Key Vault, Private Endpoints, RBAC.  

---

## Deliverables Journey

| Level | Data Engineer | Data Scientist | Data Business Analyst | Objective |
|-------|---------------|----------------|--------------|-----------|
| Essentials | 🟥 Bronze ingestion | 🟥 Churn & CLV* hypotheses | 🟨 Raw KPI* dashboard | First insights |
| Robustness | 🟥 Silver harmonization, Gold marts | 🟥 Feature engineering (RFM*, overlap) | 🟩 🟨 Silver dashboards + RLS* | Reliable reporting |
| Advanced | 🟥 Gold marts enriched with scores | 🟥 Baseline churn & CLV* models | 🟩 🟨 Predictive KPI* dashboards | Predictive insights |
| Mastery | 🟥→🟩 Reusable pipelines & exports | 🟥 Finalized models + metrics (Accuracy, AUC*, RMSE*) | 🟩 🟨 Executive storytelling dashboards | Portfolio-ready prototype |

Acronyms (used above)
- KPI: Key Performance Indicator
- CLV: Customer Lifetime Value
- RFM: Recency, Frequency, Monetary
- RLS: Row-Level Security
- AUC: Area Under the ROC Curve
- RMSE: Root Mean Square Error

Icon legend: 🟥 Databricks, 🟥→🟩 Databricks & Fabric integration, 🟩 Fabric, 🟨 Power BI.

---

![picture 5](images/7af569d43b6533c9745fe0f1e39cd23dfe1139d482a5924b550c92d3e489d88b.png)  


---

## References

- [Business Case](./statement/eurostyle-contonso-ma-business-case.md)
- [Product Backlog](./statement/eurostyle-contonso-ma-project-backlog.md)
- [Getting Started (free/trial setup)](./GETTING_STARTED.md)
- [Certification-compliant mapping](./statement/eurostyle-contonso-ma-certification-compliant.md)
- [Certification guides (DE/DS/DA)](./certification/)
- [Glossary](./GLOSSARY.md)





---

## Educational note (BeCode Data Analytics & AI Bootcamp)

This repository is provided solely for educational purposes as part of the BeCode Data Analytics & AI Bootcamp. Names, datasets, and scenarios are illustrative for training only and are not production guidance.

