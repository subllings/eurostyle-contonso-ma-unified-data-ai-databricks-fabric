# Getting Started with Azure Databricks

This short guide explains what Azure Databricks is, how to set it up, and how to take your first steps in a secure, cost‑aware way.

## What is Azure Databricks?

Azure Databricks is a managed Apache Spark platform tightly integrated with Azure. It offers collaborative notebooks, Delta Lake storage format, MLflow tracking, and integrations with Azure services (ADLS Gen2, Key Vault, Synapse/Fabric). It’s designed for data engineering (ETL/ELT), analytics, and machine learning at scale.

Key concepts:
- Workspace: The Azure resource hosting your Databricks environment
- Cluster (or Compute): The Spark runtime environment to execute notebooks/jobs
- DBFS/Lakehouse: Storage and managed tables (Delta) used by notebooks and workflows
- Repos/Versioning: Git-integrated development inside the workspace
- Jobs/Workflows: Scheduled or triggered executions of notebooks or pipelines

## Prerequisites
- Azure subscription with Owner/Contributor rights to a resource group
- Region availability for Azure Databricks
- Permissions to create networking resources (if using VNet injection/private endpoints)
- Budget guardrails (spend alerts) and a plan for cost controls

## Create a Workspace (Azure Portal)
1. In the Azure Portal, search for “Azure Databricks” → Create
2. Select Subscription and Resource Group
3. Choose Workspace name and Region (co-locate with your data)
4. Pricing tier: Start with “Premium” for Unity Catalog and governance; “Trial” if available for learning
5. Networking: 
   - Basic: Microsoft-managed VNet (quick start)
   - Advanced: Your VNet (VNet injection) for enterprise control
6. Review + Create → Wait for deployment to complete

## Create a Workspace (Azure CLI)
Optionally, use Azure CLI for automation. Ensure you’re logged in (az login) and on the right subscription (az account set -s <SUB_ID>).

- Create resource group
- Create databricks workspace (basic example)

Note: For production, template deployments (Bicep/Terraform) are preferred.

## First Compute (Cluster) and Notebooks
1. Launch Workspace → Compute → Create Cluster
   - Choose a small node size for learning (e.g., Standard_DS3_v2)
   - Autopilot/Auto Termination: 10–15 min
   - Photon: On (if supported)
2. Create a Notebook: Workspace → New → Notebook
   - Language: Python (or SQL)
   - Run a simple command: spark.range(10).show()
3. Install libraries as needed (cluster Libraries or %pip in notebooks)

## Delta Lake Basics
- Create a managed table
- Upsert with MERGE
- Time Travel and VACUUM basics

## Cost Controls
- Enable auto-termination on clusters (10–15 min)
- Prefer Jobs (serverless or job clusters) for scheduled runs over long-lived interactive clusters
- Use cluster policies to restrict sizes and runtimes
- Set Azure budgets and alerts; tag resources by project/env

## Security & Governance
- Unity Catalog for data governance and fine-grained access
- Managed identities/Service principals for automation
- Secret scopes (Key Vault-backed) for credentials
- Private endpoints/VNet injection for network isolation (enterprise)

## Integrations
- ADLS Gen2 (recommended for data lake)
- Fabric Shortcuts or Pipelines for zero/low-copy analytics
- Power BI: Direct Lake/DirectQuery
- MLflow model registry for DS handoffs

## Next Steps
- Import this repository into Databricks Repos
- Configure a small medallion pipeline (Bronze→Silver→Gold)
- Track jobs with MLflow; export to Fabric Lakehouse
- Consider IaC (Bicep/Terraform) and CI/CD when moving beyond classroom trials
