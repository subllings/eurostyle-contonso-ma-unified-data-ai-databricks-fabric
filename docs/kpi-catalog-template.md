# KPI Catalog Template (Project)

Purpose: Centralize KPI definitions, measure names, formats, and data lineage.

Versioning
- v0.1 (Sprint 0): Initial business definitions and target grain.
- v0.2 (Sprint 1): Named measures + formats + mini data dictionary.
- v1.0 (Sprint 3–4): Finalized, brand‑agnostic KPIs validated on Gold.

How to use
- Copy this template into your sprint folder or update inline per sprint.
- Keep changes atomic; record rationale and links to PRs/boards.

---

## Catalog

| KPI | Business Definition | Measure Name (DAX) | Grain | Format | Source Tables | Notes |
|---|---|---|---|---|---|---|
| GMV (Gross Merchandise Value) | Total value of merchandise sold (excl. taxes/shipping if applicable) | [GMV] | Day/Brand | Currency (EUR) | bronze.sales_raw → silver.sales_clean → gold.sales_daily | If FX applied, reference fx_rates snapshot/date |
| AOV (Average Order Value) | GMV / number of orders | [AOV] | Day/Brand | Currency (EUR) | same as GMV | Ensure order_count measure uses distinct orders |
| Orders | Number of unique orders | [Orders] | Day/Brand | Integer | same as GMV | Define business key for order uniqueness |
| Margin | Revenue − COGS; or proxy when COGS missing | [Margin] | Day/Brand | Currency (EUR) | gold.sales_daily (+ cogs table or proxy) | If proxy: document assumed rates clearly |

---

## Data Dictionary (mini)

| Field | Table | Type | Description | Format | Example |
|---|---|---|---|---|---|
| order_id | silver.sales_clean | string | Business order identifier | text | 489231-IT |
| order_date | silver.sales_clean | date | Date of order | yyyy-mm-dd | 2025-03-21 |
| customer_id | silver.sales_clean | string | Customer identifier | text | C093842 |
| sku | silver.sales_clean | string | Stock Keeping Unit / product code | text | SHOE-1042 |
| unit_price | silver.sales_clean | decimal | Price per item in source currency or EUR | currency | 59.90 |
| source_system | silver.sales_clean | string | Origin brand label | enum | eurostyle/contoso |

---

## Change Log

| Version | Date | Author | Summary |
|---|---|---|---|
| v0.1 | yyyy-mm-dd | name | Initial draft |
| v0.2 | yyyy-mm-dd | name | Named measures + formats |
| v1.0 | yyyy-mm-dd | name | Finalized definitions on Gold |
