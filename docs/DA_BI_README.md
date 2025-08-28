# DA/BI Handoff and Quickstart

Purpose: give Data Analysts a concise set of links and checks to validate exported data and dashboards.

## Links
- Fabric workspace: <add URL>
- Lakehouse: <add URL>
- Data Pipeline run history: <add URL>
- Dashboards (Executive, Segmentation): <add URLs>
- Datasets/semantic models: <add URLs>

## Data contracts
- Gold release manifest: docs/release_manifest.schema.json (contract) and instance: <path to manifest.json>
- Scores manifest: docs/scores_manifest.schema.json (contract) and instance: <path to scores_manifest.json>

## After-ingestion QA (Fabric)
- Run queries in docs/fabric_lakehouse_qa.sql
- Verify row counts match manifest within tolerance
- Check key uniqueness (customer_id)
- Confirm value bounds and latest as_of_date
- If buckets are used, confirm expected distribution shape

## Power BI
- Dataset connections: Lakehouse Direct Lake
- RLS roles: BrandManager, Executive (see Feature 4.2)
- Deployment pipeline: Dev → Test (verify rebind and lineage)
- Accessibility: titles/alt text, color contrast

## Troubleshooting
- Ingestion type mismatch: adjust mapping in pipeline and re-run affected table
- Broken lineage after promotion: rebind datasets, refresh
- Performance: reduce high-cardinality slicers; pre-aggregate if needed

Owners: <names>
