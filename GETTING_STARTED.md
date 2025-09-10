# Getting Started — Azure Databricks and Microsoft Fabric (Free/Trial)

This guide shows how to create an Azure Databricks workspace (Premium Trial, 14 days) and enable Microsoft Fabric (Trial or Free F2), configure both for this M&A project, and understand what's possible on free/trial tiers. It also includes quick starts per role (DE/DS/DA).

Useful links: [Glossary](GLOSSARY.md), [Backlog](statement/eurostyle-contonso-ma-project-backlog.md), [Certification-compliant use case](statement/eurostyle-contonso-ma-certification-compliant.md).

---

## 1) Create Azure Databricks — Premium Trial

### Prerequisites (before you start)
- Azure subscription; role Owner/Contributor on the subscription or target resource group.
- Microsoft Entra ID account in the tenant.
- Optional admin tasks (for Unity Catalog later): ability to create a storage account and grant roles.
- Docs hub: https://learn.microsoft.com/azure/databricks/

### Steps (Azure Portal) 
1) Resource group
- Azure Portal → Resource groups → Create
- Name: `rg-es-contoso-ma` (M&A emphasis)
- Region: same region you plan to use for Databricks (e.g., France Central)

2) Databricks workspace
- Create a resource → search "Azure Databricks" → Create
- Basics:
  - Subscription: select yours
  - Resource group: `rg-es-contoso-ma`
  - Workspace name: `ws-es-contoso-ma`
  - Region: same as the resource group (keep data locality)
  - Pricing Tier: Trial (Premium — 14 days Free DBUs)
- Review + create → after deployment, Open and Launch Workspace
- Reference: Getting started → Create workspace: https://learn.microsoft.com/azure/databricks/getting-started/

![picture 30](images/54caa146857cd8b33175cbbce62ef2bc55214777f093cc0c9bd147a159de80ab.png)  

![picture 32](images/33cacddf9c34d1d8f2632334f99e22b2af4fa364325b01442d51fb1935b7de84.png)  

![picture 33](images/7ee2e1b4b1ba336a5c0a9b2e7c69552370c8eff93ffc4e757d7b3d720f09a2f9.png)  



### Minimal workspace configuration

- Connect to GitHub repository : [runbook/databricks-github-folder-repo-commit-push.md](./docs/runbooks/databricks-github-folder-repo-commit-push.md)
- Notebooks


- Compute (cluster)
  - Create → Compute → New cluster
  - Runtime: a recent LTS (stable)
  - Size: small (1 driver + 1 worker)
  - Auto-termination: 15–30 minutes
  - Docs: https://learn.microsoft.com/azure/databricks/compute/create-cluster

![picture 74](images/ea0ac168bcc292587865389318bb9870d50e0c4abb6913740b2604c1c49bc899.png)  

![picture 75](images/598380477caca2bb61d3a8b0049e173242ff017a7368d56672fa1d184b18221d.png)  

![picture 76](images/31ad58ca7767deefdd08211239f139fd4800e2703a327ad751ef696a710d1d45.png)  

Verify your quota in your subscription if cluster creation fails (default limits are low on trials). Increase your vCPU quota (e.g., to 8 or 16) in the region of your workspace.

![picture 78](images/790f3bb1057ccb976d1d4c350c8839e42fc880ce54b8549f6e282b67e189e36b.png)  



![picture 77](images/7bd7a60a5b1fe8c4a87430809d3ae1071f17ecf6200a7eb0d48150755708ba6a.png)  



#### SQL Warehouse (for Databricks SQL dashboards)

Create this once early (Sprint 1, detailed in Feature 1.1) and reuse it across:
- Feature 1.1 (DirectQuery smoke test on Bronze)
- Feature 3.1 (First Look dashboard)
- Features 3.2 / 3.3 (Raw vs Silver, Executive dashboard)
- Governance G.1 (Purview / Unity Catalog scans if UC enabled)

Document the Hostname and HTTP Path (from the warehouse details) in the README under a short "Connectivity – Power BI / DirectQuery" section so analysts/scientists can connect without asking engineering. Keep it small, auto‑stop aggressively (15–30 min) to control trial costs.

  - Switch to SQL persona → Warehouses → New → choose Pro/Classic if Serverless is unavailable in your region

![picture 79](images/071eeb2f662575def07fb819a9fb683e2ec1deaaff0fba1c2449b69256b11f74.png)  
  - Size: small; Auto-stop: 15–30 minutes
  - Docs: https://learn.microsoft.com/azure/databricks/compute/sql-warehouse/create (Create & manage SQL warehouses)

![picture 80](images/79419add7583839e43fe472bfde1b34b639cb1ceb84a6045a4addf7c8422b210.png)  

![picture 81](images/07c69ea036aef35e71397343a16b4062995c40db4be25d2974f3728087a8d84f.png)  

Go to Connection Details and copy the Hostname and HTTP Path for Power BI connection.

![picture 82](images/1b1fa20de4c90520c8477e2d272a512530df9e16ac918aa3fa59f6ff4be10c81.png)  

You can also download the connection file for Power BI Desktop.

![picture 83](images/2da0fbdcb79d9af0e6e7b2808c544c57e2582708c9ca2866f63940fc51c86b3a.png)  

![picture 84](images/cd3e5eedd416f53f8a05faf0d799f17f0546d34a37059c4a01acfd2723ab4723.png)  

![picture 85](images/ec177df2776afa3d5b61a35f2afe5d13baec160e7c0ec5d3df5365267a8e166e.png)  

![picture 86](images/e788c688a169734198837c348c5111d1deeabe2d4e2fcfb3150137b794ed2493.png)  

Connection to Databricks SQL Warehouse from Power BI Desktop (DirectQuery mode) 

![picture 87](images/4651b1db2d7df1517bdb343eda6366b3dea6e133ebde44fc6d61ddb0b5a68fa6.png)  


- Optional — Unity Catalog (governed naming and RLS/CLS later)
  - If you're Account Admin: create a UC Metastore (Account Console), attach this workspace, and create an External Location (backed by ADLS Gen2 with a managed identity that has Storage Blob Data Contributor)
  - Docs (overview): https://learn.microsoft.com/azure/databricks/data-governance/unity-catalog/
  - If you can't enable UC on trial, use `hive_metastore` and simulate RLS in views or enforce RLS in Power BI

#### Unity Catalog setup — storage account & access connector (optional but recommended for a fuller governance study experience)
These steps sit outside the minimal trial path. Do them if you want realistic governance (catalogs), cleaner lineage, and fine‑grained security scenarios.

##### 1) Storage account (ADLS Gen2)
  - Azure Portal → Create resource → Storage account

  - Name: `stescontosoma` (lowercase, 3–24 chars, letters & numbers only; no dashes or underscores; globally unique)
  - Region: same as workspace (e.g., France Central)
  - Performance: Standard; Redundancy: LRS
![picture 34](images/82b7c6fd95362b214bd6585a22280f0b88f28a73b2a3f6ede20688edce012c4c.png)  

  - Advanced: Enable Hierarchical namespace

![picture 35](images/d5824a8fbf6e2f56e3fd5899f95f1d55beafed9747fe64043cebc54370ab2ba1.png) 


  - Create → then inside the storage account create containers:

![picture 36](images/30552689f27c0226a3027397d78dda3321b23946a527796a721ef2510ee5bdae.png)  

![picture 37](images/2045490318221a376e8e92c739c927221f1b8cc6fc7335e298168ce174f3e275.png)  


  - Containers (suggested logical zones):
    - `unity-catalog` – Unity Catalog managed tables / metastore-related data (if used)
    - `raw` – optional pre-bronze dump (exact source file copies before any normalization)
    - `bronze` – raw ingested landing zone (minimal transformation)
    - `silver` – cleaned & conformed data (deduped, typed, harmonized)
    - `gold` – curated marts / analytics-ready aggregates

    - `monitor` – quality & operational metrics (DQ checks, pipeline run logs, churn/model metrics exports)

  - `chk` – (optional) checkpoint/state isolation. You can keep streaming/Autoloader `_checkpoint` folders inside each zone instead of a container; we create a dedicated container here for clarity & easy lifecycle cleanup.


![picture 40](images/34149f7cc35e5021133e0f641073f9d9e678882300a9a9c8e8c00277c897e4da.png)  


**Upload data files into `raw`**

Create two folders inside `raw` (landing area for ingested files):
- `eurostyle` 
- `contoso`

Upload in 
- `eurostyle`  the files in `data/source/eurostyle` from this repo (CSV files).
- `contoso` the files   in `data/source/contoso` from this repo (csv file).  

![picture 67](images/e68ff3c6c5082debc743c221eefa6928b861d6bf3ca8fec738466fea0138d7f0.png)  
![picture 63](images/06da2599c57279bddc01c4a414794dedf5b1e86224f5fc0fc3d6bc845e1921b0.png) 

![picture 64](images/cc2d6b986f4b532c39f7a8cdaa55cec31cbd5520d63866126910d55b6290f931.png)  
![picture 65](images/5738a7785f37f162bffc3df0cf16d5c5ab3f8eb1e19a6b93d2fa3ca030d36031.png)  
![picture 66](images/b77d7930dc988015412b8382aabe21469da49049202edbb34b0eb69e072c2ffa.png)  
![picture 68](images/82a3e2b9e6abf22d449e80f93f6d773a4df41f824d70d49b0c46020efebd07fc.png)  

##### 2) Azure Databricks Access Connector
  - Create resource → "Azure Databricks access connector"

![picture 17](images/347936685f489774c62e80bc8595a5d3989728bee4190b5d6dee0e54183ab751.png) 

![picture 41](images/d851ccadc2228ed58bdd0e2a25f14073ed8bc3be6c6fa2c2aa1381b4cd4650fe.png)  

  - Name: `ac-es-contonso-ma` (same RG & region)
  - Identity: System assigned
  - Create an Access Connector for Azure Databricks

 ![picture 42](images/5eea384c7d52c9e40d519f47133270e7abc1e016e7ca5470f4c2495195e80f07.png)  

##### 3) Grant connector access to storage
  - Storage account → Access control (IAM) → Add role assignment

![picture 43](images/d199d0149ecee4477ed3bd0111b6d7b011ca629360fad0ccb3362f75e388a32b.png)  
  - Role: Storage Blob Data Owner (simplest) — or Storage Blob Data Contributor for least privilege

![picture 44](images/b30bf83340020eea5125919067c88f4773b7a091f4ecc9f2787c0672e0c9b32d.png) 

  - Assign access to: Managed identity → select `ac-es-contonso-ma` → Save

![picture 45](images/3e88846fe6372a4be08e3ad74f471415252a8e2f56fcdd0f2caab8c108ec86a6.png)  
![picture 46](images/68c49bc12ea4bbc365c10e9c6dd74f5c66f9c9e58d3025a2f6f4b4c23bd872d3.png)  
#### Assigning a Catalog to Workspaces in Databricks

In Unity Catalog, a catalog is a top-level container that organizes schemas and tables. By default, a catalog is created at the account level, but workspaces cannot access it until it is explicitly assigned.

**Why this step is necessary**
- Each workspace in Databricks operates in isolation unless you grant it permissions.
- Assigning a catalog to a workspace ensures that users in that workspace can see and use the catalog's objects (schemas, tables, views).
- Without this assignment, the catalog will remain inaccessible, even if the workspace is linked to the same Unity Catalog metastore.

**What is being done in the screenshots**
1. In the Catalog Explorer, the catalog `ws_es_contoso_ma` is shown as "No access".
2. The administrator clicks Assign to workspaces.
3. The list of available workspaces is displayed. Here, the workspace ws-es-contoso-ma is selected.
4. Clicking Assign grants this workspace the ability to access the catalog.
5. The catalog now becomes available inside the workspace, and its objects can be created and queried.

**Key point**

This step links the account-level catalog to the workspace. Without this linkage, users inside the workspace cannot create or query objects in the catalog, even if they have the correct permissions.

![picture 52](images/b3b9c35c73a8b7b2ecb55802dbba19815c25c885c52e8d59ff04ffd0012388ad.png)  

![picture 53](images/4ab5c7d5a7afe21e1e1e45ec3216a6a3a0d211614a61573bcd0af6210e363152.png)  


#### Bootstrapping the Databricks Account Console (when no Account Admin exists)

##### Symptoms

In the workspace UI there is no "Manage account / Account Console" button.

Trying to open the Account Console shows: "The Microsoft Entra tenant … does not belong to any Databricks account."

Your main identity (e.g., yves.schillings@secloudis.com) appears as a Guest in the tenant that owns the subscription.

##### Why this happens

**Databricks Account Console** sits **above workspaces**. The very first time an Entra tenant is linked to a Databricks account, only a Microsoft Entra Global Administrator (or an existing Databricks Account admin) can sign in and create that account.
If your everyday user is a **Guest** in the subscription's directory, it can create a workspace but **cannot bootstrap the Account Console**.

##### One-time bootstrap

Created a temporary internal user in the subscription's directory with Global Admin, used it once to create the Databricks account, then granted Account Admin to the real user.

**Steps**

##### Create an internal admin user
Azure Portal → Microsoft Entra ID (the Default Directory that owns the subscription) → Users → New user

- UPN: adb-admin@<your_tenant>.onmicrosoft.com
- Display name: Databricks Admin

Assign role: Global Administrator (Roles and administrators → Global Administrator → Add assignment)

![picture 47](images/e97aaa351cc68ed2df1182fa49eb533c37ce2e66c54135b83a883156e1422c3d.png)  


##### Sign in to the Account Console once
Go to https://accounts.azuredatabricks.net and sign in with adb-admin@….
This creates the Databricks Account for the tenant and makes this user Account admin.

![picture 23](images/ed47b563298f4877971ff1d71f3f25d3165aa61593fcc068121184aafd9bdcc8.png)

![picture 69](images/1251af0f68a1ddc8895a3a06343f56ae9ba9d1015d49bbf9395d5b4b0cc0cdc1.png)  


##### Grant your real user Account Admin
Account Console → User management → Add user → add yves.schillings@secloudis.com → toggle Account admin.

![picture 48](images/f643ea2c891988afb44f3b2fa7ffefff18281d5863736b5588db97007af646e2.png)  

![picture 49](images/10267b0810305ae6a00f48dd1a83e95fee43ed9d971c9ec49076d614a6226415.png)  

##### Open the Databricks Account Console from a workspace

- In any Azure Databricks workspace:
- Go to the top-right header and click the workspace selector (it shows your current workspace name, e.g. ws-es-contoso-ma).
- Click Manage account (see screenshot). This opens the Databricks Account Console in a new tab.

![picture 50](images/88e74f44d23709926336bb294bf54257d1b4bb6d27e94505e2cf2f2190d18149.png)  

![picture 51](images/61139924beaec223f899f4fe62602a4ff83e9c723d9f6b54fd9b196a1cabfb88.png)  


##### (Optional) Reduce privileges / clean-up

- Remove Global Administrator from adb-admin@…, or disable the account, or keep it as a break-glass account protected with MFA/PIM and a strong, vaulted password.

- After this bootstrap, continue with Unity Catalog setup: create the Metastore (France Central), Storage credential (via Access Connector), External location (your unity-catalog container), and attach the workspace to the metastore.

##### Security notes

- Use MFA for any account with elevated rights.
- Prefer PIM (just-in-time Global Admin) if available.
- Keep the principle of least privilege—remove GA from the temporary user after setup.


##### 4) Create Metastore & External Location (requires Account Admin)
> **No "Manage account" button visible?**  
> Then you are not an Account Admin (common with a personal trial). Skip the Unity Catalog steps below and use the fallback: create the `raw|bronze|silver|gold|monitor|ref` databases in `hive_metastore` (SQL block provided) and continue. You can enable Unity Catalog later without redoing earlier features.
  
  - If you do NOT see a "Manage Account" (or "Account Console") option in the top‑right user/avatar menu inside the workspace, you are not an Account Admin. Options:
    - Ask an existing Account Admin to grant you the Account Admin role (Account Console → User management → add user → assign role) so you can perform steps 4–5 or follow the steps explained above **Bootstrapping the Databricks Account Console (when no Account Admin exists)**


![picture 57](images/10bebe431a4eaade7fa752e5d25ff2403b0987aebca5868029af914ebc638c32.png)  

  - Direct URL (if you are an admin): https://accounts.azuredatabricks.net  (sign‑in failure or 403 means you lack account privileges.)

![picture 58](images/0d18acb1fa0cfc3d6a3e5a0ed9d20b29fc3a0de3f64a7509da22ac23acfdb2ea.png)  

![picture 59](images/63cf2ff7db503ac289f61523f4a329dccb24a251af54a463d95dbe548db7b815.png)  

![picture 60](images/3ec64284eb5233e02d709f2b75ce01c7e70fb29269eb4e35fed9dbac29c5e451.png)  


  - Open the Databricks Account Console (NOT the workspace UI) → left menu "Catalog" ("Unity Catalog") → Create Metastore (give it a name and region matching the workspace)


![picture 56](images/ec805b3d02d2c7e35e729f9a0b8e844ec7168bc6b403e5b9ca6829d2b3f58e5e.png)  



    - Or skip steps 4–5 and continue using `hive_metastore`. To simulate governance without UC: (1) create schemas named `raw`, `bronze`, `silver`, `gold`, `monitor`, `ref`; (2) enforce row filters via SQL views; (3) document access rules manually.


  - Create an External Location pointing to the container path, e.g.: `abfss://unity-catalog@stes-es-contonso-ma.dfs.core.windows.net/`
  - Grant privileges (USE CATALOG / CREATE / SELECT as needed) to relevant groups (e.g., `data_engineers`, `analysts`)
  - (If you used a different container name, adjust the URI accordingly)

###### Detail: Create External Location for Unity Catalog Metastore

To enable Unity Catalog to store and manage metadata in Azure Data Lake Storage Gen2 (ADLS Gen2), you must create an External Location. This binds the storage path (for example: `abfss://uc-metastore@<your-storage-account>.dfs.core.windows.net/`) to a Storage Credential (typically a Managed Identity or Service Principal) that has permission to access the underlying storage.

This step is required to ensure that Unity Catalog can securely read and write metadata files (such as schema definitions, managed tables, and permission records) in the ADLS Gen2 container.

**Instructions**

1. In the Databricks workspace, go to the left navigation pane and open **Catalog > External Locations**.
2. Click **Create**.
3. Fill in the following fields:
   - **External location name**: for example, `loc_uc_metastore`
   - **Storage type**: select `Azure Data Lake Storage`
   - **URL**: use the format `abfss://<container>@<storage-account>.dfs.core.windows.net/`
   - **Storage credential**: select the Managed Identity or Service Principal configured during the Unity Catalog setup
4. Click **Create** to save the external location.
5. Once created, click **Test connection** to verify that all required permissions (read, write, list, delete) are correctly assigned.

If the test passes with all permissions confirmed, the external location is now ready and can be used by the Unity Catalog metastore to manage metadata securely.

![picture 54](images/9107c52605a93c5fbb91269981d94e8d7d2c6ae507de87b69bd7b33f701bef0e.png)  

![picture 55](images/f97ce1c1d36fafd97c0ecd34a6a4584166b15032a7af3d51e6174fc0ba04619f.png)  



##### 5) Attach workspace to Metastore
  - Account Console → Workspaces → select workspace → Attach Metastore

![picture 61](images/b6f7a20336f84ea57e11228e894e62f20b193f8fa68e04b40b9d57bf3c263140.png)  


Notes
  - If blocked (trial restrictions) fallback to `hive_metastore` and continue.
  - UC improves lineage & privilege granularity; cost hygiene still relies on auto-stop.
  - Consistent naming (`es-contonso-ma`) simplifies future automation scripts.

Collect connection info (for Power BI or external SQL clients)
- In SQL persona → Warehouses → your warehouse → Copy "Server hostname" and "HTTP Path"
- You'll use these in the Power BI Databricks connector
- Docs (Power BI ↔ Databricks): https://learn.microsoft.com/azure/databricks/partners/bi/power-bi (overview & connector setup)

Trial hygiene and cost control
- Enable auto-stop on clusters and warehouses; shut them down when idle
- Prefer a single small cluster for notebooks and a small SQL warehouse for dashboards
- Keep your workspace files under `/Workspace/Users/<you>/es-contoso/`

Quotas and common issues
- If you hit regional quota when creating compute: try a smaller VM family or another nearby region
- Serverless SQL not offered: select Pro/Classic
- Model Serving not available on trial: use scheduled batch scoring instead

##### 6) Add the git repository to Databricks
![picture 70](images/967c70964a42fe953d22eedd7989ea13df4c08baf2a86a6329f1dec979034b8c.png)  

![picture 72](images/168f869da3717db3d38d7020f90391d8d80aa37a7f3f2a0662ea55b47b4a5a4d.png)  

![picture 73](images/bc627634db9a2a728b240cf20c9454e94de7f8ddf7a9c60bd6e37508b1443675.png)  


---

## 2) Enable Microsoft Fabric — Trial or Free (F2)

Prereqs
- A Power BI account in your tenant (https://app.powerbi.com) with permission to create workspaces.
- For capacity assignment: Fabric/Power BI admin or a user with rights to create Trial workspaces.

### Option A — Fabric Trial (recommended)
#### 1) Start the trial
- Go to Power BI Service: https://app.powerbi.com
- Click Try Fabric (top banner or settings) and follow the prompts.
- Docs: https://learn.microsoft.com/fabric/get-started/fabric-trial

#### 2) Create a Fabric workspace on Trial capacity
- Workspaces → New workspace → Name: `es-contoso-ma` (M&A emphasis)
- Advanced → Capacity: select your Fabric Trial capacity
- Save
- Docs: https://learn.microsoft.com/fabric/enterprise/capacity#workspaces-and-capacities

#### 3) Create the core items
- Lakehouse: New → Lakehouse → name `lh-es-contoso-ma`
  - Docs: https://learn.microsoft.com/fabric/lakehouse/
- Data Warehouse (optional for T‑SQL): New → Warehouse → `wh-es-contoso-ma`
  - Docs: https://learn.microsoft.com/fabric/data-warehouse/
- Semantic model + Report (Power BI): build a model and report from Lakehouse/Warehouse tables
  - RLS guidance: https://learn.microsoft.com/power-bi/enterprise/row-level-security
- Deployment Pipeline (Dev→Test): Create pipeline → assign your workspace as Dev → clone to Test
  - Docs: https://learn.microsoft.com/fabric/cicd/deployment-pipelines/overview

### Option B — Fabric Free (F2)
- If you skip the trial, you operate on shared Free (F2) capacity with lower limits and feature restrictions.
- Create a new workspace (as above). If capacity cannot be assigned, it runs on shared capacity automatically.
- Many learning tasks still work; some features like Direct Lake and Deployment Pipelines may be unavailable or constrained.

Typical items to create (with docs)
- Lakehouse (files + tables): https://learn.microsoft.com/fabric/lakehouse/
- Warehouse (T‑SQL): https://learn.microsoft.com/fabric/data-warehouse/
- Semantic model (dataset) + Report (Power BI): https://learn.microsoft.com/power-bi/create-reports/
- Data Pipelines (ingestion/orchestration): https://learn.microsoft.com/fabric/data-factory/pipelines-overview
- OneLake Shortcuts (zero‑copy to ADLS): https://learn.microsoft.com/fabric/onelake/onelake-shortcuts

Notes and tips
- Direct Lake prerequisites/caveats: https://learn.microsoft.com/power-bi/enterprise/directlake-overview
- If you can't use Direct Lake, use Import or DirectQuery connectors.
- For M&A clarity, keep item names consistent (lh‑/wh‑/model‑/report‑es‑contoso‑ma).

---

## 3) What you can and can't do on Free/Trial

Azure Databricks (Trial) — works
- Delta Lake: Bronze→Silver→Gold, MERGE, OPTIMIZE, VACUUM, time travel
- Databricks SQL: queries, Lakeview dashboards, alerts (with a running warehouse)
- Jobs/Workflows: schedule notebooks/SQL tasks
- MLflow: experiments/runs; basic registry

Azure Databricks — caveats/fallbacks
- Unity Catalog: works if you can create the Metastore + External Location; otherwise use `hive_metastore`.
- Delta Live Tables (DLT): may be restricted → fallback to Jobs + notebooks.
- Model Serving: may be unavailable → fallback to scheduled batch scoring.
- Serverless SQL Warehouse: region-dependent → use Pro/Classic.

Microsoft Fabric (Trial) — works
- Lakehouse, Warehouse, Direct Lake (capacity-dependent), Data Pipelines, Deployment Pipelines
- Sensitivity labels, RLS in the semantic model

Microsoft Fabric (Free/F2) — limits
- Small capacity; some features reduced or unavailable (e.g., Direct Lake, Pipelines)
- Alternatives: Power BI Desktop Import, or DirectQuery to Databricks

Out of scope for free/trial
- Private networking (VNET/Private Link), advanced SSO, enterprise governance/SLA

---

## 4) Databricks → Fabric handover (minimal flow)
1. Prepare Gold tables (Delta/Parquet) in Databricks.
2. Prefer Shortcut (zero-copy) from Fabric Lakehouse to the ADLS folder.
3. If Shortcut is blocked by RBAC/network/tenant/region, export Parquet (+ manifest) and ingest with a Fabric Data Pipeline.
4. Build a semantic model (star schema, named DAX measures, RLS) and a Power BI report.
5. On Trial, promote via a Deployment Pipeline (Dev→Test).

Shortcut vs Export — decision box
- Use Shortcut when: same tenant, RBAC in place (Storage Blob Data Reader), networking allows access, near-real-time read-only is fine.
- Use Export when: you need an immutable snapshot, tenant/region boundaries or networking constraints exist, or you want fully-managed performance under Fabric capacity.

---

## 5) Role quick starts (Epics + Features)

Epics overview (what each epic delivers)
- [Epic 1 — Data Foundation Platform](statement/eurostyle-contonso-ma-project-backlog.md#epic-1): ingest, clean, and curate data in the Medallion architecture (Bronze → Silver → Gold).
- [Epic 2 — ML & Predictive](statement/eurostyle-contonso-ma-project-backlog.md#epic-2): exploratory analysis, feature engineering, model training, and batch scoring.
- [Epic 3 — Analytics & BI](statement/eurostyle-contonso-ma-project-backlog.md#epic-3): business KPIs, semantic modeling, reports, and security (RLS).
- [Epic 4 — Platform Integration](statement/eurostyle-contonso-ma-project-backlog.md#epic-4): handoff to Microsoft Fabric (Lakehouse/Warehouse), pipelines, and promotion.

### Data Engineer (DE)
- Sprint 1 — [Epic 1](statement/eurostyle-contonso-ma-project-backlog.md#epic-1) ([Feature 1.1](statement/eurostyle-contonso-ma-project-backlog.md#feature-1-1)): Bronze ingestion → Delta tables with lineage
- Sprint 2 — [Epic 1](statement/eurostyle-contonso-ma-project-backlog.md#epic-1) ([Feature 1.2](statement/eurostyle-contonso-ma-project-backlog.md#feature-1-2)): Silver cleaning → dedup, FX→EUR, idempotent writes
- Sprint 3 — [Epic 1](statement/eurostyle-contonso-ma-project-backlog.md#epic-1) ([Feature 1.3](statement/eurostyle-contonso-ma-project-backlog.md#feature-1-3)): Gold marts → `sales_daily`, `category_perf`, `customer_360`
- Sprint 4 — [Epic 4](statement/eurostyle-contonso-ma-project-backlog.md#epic-4) (Integration): Export to Fabric via Shortcut or Parquet + manifest

Implementation details for the initial ingestion, SQL warehouse setup, DirectQuery connectivity, and documentation steps are explained in [Feature 1.1](statement/eurostyle-contonso-ma-project-backlog.md#feature-1-1).

### Data Scientist (DS)
- Sprint 1 — [Epic 2](statement/eurostyle-contonso-ma-project-backlog.md#epic-2) ([Feature 2.1](statement/eurostyle-contonso-ma-project-backlog.md#feature-2-1)): EDA, baselines, MLflow setup
- Sprint 2 — [Epic 2](statement/eurostyle-contonso-ma-project-backlog.md#epic-2) ([Feature 2.2](statement/eurostyle-contonso-ma-project-backlog.md#feature-2-2)): Feature engineering (RFM, overlap), versioned tables/contracts
- Sprint 3 — [Epic 2](statement/eurostyle-contonso-ma-project-backlog.md#epic-2) ([Feature 2.3](statement/eurostyle-contonso-ma-project-backlog.md#feature-2-3)): Train and register models (churn, CLV)
- Sprint 4 — [Epic 2](statement/eurostyle-contonso-ma-project-backlog.md#epic-2) + [Epic 4](statement/eurostyle-contonso-ma-project-backlog.md#epic-4) ([Feature 2.4](statement/eurostyle-contonso-ma-project-backlog.md#feature-2-4)): Batch scoring and join into Gold `customer_360`, then export with DE

### Data Business Analyst (DA)
- Sprint 1 — [Epic 3](statement/eurostyle-contonso-ma-project-backlog.md#epic-3) ([Feature 3.1](statement/eurostyle-contonso-ma-project-backlog.md#feature-3-1)): First Look via Databricks SQL (DirectQuery) or Power BI
- Sprint 2 — [Epic 3](statement/eurostyle-contonso-ma-project-backlog.md#epic-3) ([Feature 3.2](statement/eurostyle-contonso-ma-project-backlog.md#feature-3-2)): Raw vs Silver comparison; draft RLS
- Sprint 3 — [Epic 3](statement/eurostyle-contonso-ma-project-backlog.md#epic-3) ([Feature 3.3](statement/eurostyle-contonso-ma-project-backlog.md#feature-3-3)): Executive Post‑Merger dashboard
- Sprint 4 — [Epic 3](statement/eurostyle-contonso-ma-project-backlog.md#epic-3) + [Epic 4](statement/eurostyle-contonso-ma-project-backlog.md#epic-4) ([Feature 4.2](statement/eurostyle-contonso-ma-project-backlog.md#feature-4-2)): Power BI Suite and Deployment Pipeline (Dev→Test)
## 6) References
- Backlog: [statement/eurostyle-contonso-ma-project-backlog.md](statement/eurostyle-contonso-ma-project-backlog.md)
- Solutions: https://github.com/yves-schillings/eurostyle-contonso-ma-unified-data-ai-databricks-fabric-sol/tree/main/solution
- Certification-compliant use case: [statement/eurostyle-contonso-ma-certification-compliant.md](statement/eurostyle-contonso-ma-certification-compliant.md)
- Certification guides: [certification/](certification/)
- Glossary: [GLOSSARY.md](GLOSSARY.md)

---
 Additional resource: [secloudis.com](https://secloudis.com) – articles and notes on cloud, data, analytics, and artificial intelligence (optional external reference).

