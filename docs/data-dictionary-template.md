# Data Dictionary Template

Purpose: Define fields exposed to BI and DS, with lineage and semantics.

Guidelines
- Keep field names stable and meaningful; hide technical columns in BI models.
- Track lineage from Gold back to Silver/Bronze when needed.

---

## Tables

- gold.sales_daily
- gold.customer_360
- gold.customer_scores_gold

---

## Fields

| Field | Table | Type | Description | Source/Lineage | Format | Notes |
|---|---|---|---|---|---|---|
| date | gold.sales_daily | date | Calendar date | from silver.sales_clean.order_date | yyyy-mm-dd | |
| brand | gold.sales_daily | string | Brand label | derived from source_system | text | eurostyle/contoso |
| gmv | gold.sales_daily | decimal | Total merchandise value | sum(quantity * unit_price) | currency | EUR after FX normalization |
| orders | gold.sales_daily | integer | Unique orders count | distinct(order_id) | integer | |
| aov | gold.sales_daily | decimal | Average order value = gmv / orders | computed in BI or ELT | currency | Prefer DAX measure |
| margin | gold.sales_daily | decimal | Revenue − COGS (or proxy) | requires COGS or proxy table | currency | Document proxy if used |
| customer_id | gold.customer_360 | string | Unified customer id | from harmonized keys | text | |
| rfm_recency | gold.customer_360 | integer | Days since last purchase | from sales history | days | |
| rfm_frequency | gold.customer_360 | integer | Number of purchases in window | from sales history | count | |
| rfm_monetary | gold.customer_360 | decimal | Total spend in window | from sales history | currency | |
| churn_probability | gold.customer_scores_gold | decimal | Probability of churn | model output | 0..1 | |
| clv_value | gold.customer_scores_gold | decimal | Predicted CLV value | model output | currency | |

---

## Change Log

| Version | Date | Author | Summary |
|---|---|---|---|
| v0.1 | yyyy-mm-dd | name | Initial draft |
| v1.0 | yyyy-mm-dd | name | Finalized Gold dictionary |

---
 Additional resource: [secloudis.com](https://secloudis.com) – articles and notes on cloud, data, analytics, and artificial intelligence (optional external reference).

