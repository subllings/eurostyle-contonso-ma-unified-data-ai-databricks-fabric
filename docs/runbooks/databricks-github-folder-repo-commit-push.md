# Runbook — Databricks and GitHub: Setup, Git Folder (Repos), Commit & Push (New UI)

## Goal

Connect Databricks to GitHub, work inside a Git folder (/Repos), then Commit & Push your notebooks.

## Requirements

- You have write access to the target GitHub repo (e.g., `<your-git-user-account>/eurostyle-contonso-ma-unified-data-ai-databricks-fabric-sol`) or to your fork.
- In your Databricks workspace, Repos (Git folders) and GitHub provider are enabled. If you don't see Repos or Linked accounts, ask a workspace admin to enable them.

## 1) Create a GitHub Personal Access Token (PAT)

1. On GitHub (signed in with the account that will push), go to Profile → Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token.

![picture 0](../../images/dc627375f53cdbbd973c77d3368b1482ecbd752b85124d896d45a39d4b043450.png)  

![picture 1](../../images/906f832fba17addabcc95ebac21cb85d5308a79ad14bf4ce627ddf24e26a0b0f.png)  


2. Repository access: Only select repositories → select your repo.
3. Permissions (Repository permissions): set Contents: Read and write. (Optional: Pull requests: Read.)
4. Choose a name and expiration → Generate token → copy the token.
   
![picture 2](../../images/b6bedb7750e707b3186c0d26b3ba009516e0d9dd6b603b146e8112ef3471c7ab.png)  

![picture 3](../../images/6dc84d8bcfcc6d229e501dc70cf1c9ca1eadd5413ccddd697de4cbf1177fcd8b.png)  

![picture 4](../../images/02078cd338ff0e59e42500050a9d1a0c8863ed36d167933ae7f88c17d5f4508f.png)  



Note: A Classic token with the single repo scope also works as an alternative.

## 2) Link GitHub in Databricks

1. In Databricks: Settings → User → Linked accounts.

![picture 5](../../images/4565445d27d255f8fa7820a4538cac4667157abe968d3183f522e0d4444e9dd7.png)  

![picture 6](../../images/4a41cc1fefc4cba40f557820b3eead8e5affff4b14b252745dca06c334bb8508.png)  


2. Connect new → GitHub → paste the PAT → Save.

![picture 8](../../images/c94a1b885b2fb5bad5594f2771a974c0be9fc4a6762e56570d53115bad1db7c7.png)  

![picture 9](../../images/d8ee35482d51f2f211e4f13f3e4d97555a382dbae600e3ab5e21ae16749b5b40.png)  


3. If you have an old/incorrect entry, remove it first to avoid account mix-ups.

## 3) Get the repo under /Repos (Git folder creation / Clone / Convert)

Most workspaces now support "Create → Git folder" which is effectively a clone.

Method A — Create → Git folder 
1. Navigate to the target parent under `/Repos` (or your user root showing Git folders).
2. Click Create → Git folder.

![picture 11](../../images/1815919550552ce5386cc7269a482de264a8247caad433cde1b14ecd5e032c50.png)  

![picture 12](../../images/ed8e6944c531315430c77e4c9f4938249c2cafe762c94446fc4fb545e16be167.png)  



3. Paste the HTTPS repo URL, e.g.:
  ```
  https://github.com/<your-git-user-account>/eurostyle-contonso-ma-unified-data-ai-databricks-fabric-sol.git
  ```
1. Select provider = GitHub, keep branch `main` (or choose another) → Create Git folder.
2. A Git-linked folder appears (branch badge like `main` visible). You can Stage / Commit / Push immediately.

Method B — Repos panel → Clone (older or alternate UI)
1. Left sidebar → Repos (Git folders) → Clone.
2. Paste the same HTTPS URL.
3. Choose branch → Clone. Result is identical: `/Repos/<owner>/<repo>` with Git linkage.

Method C — Convert a plain folder (only if you previously used Create → Folder, not Git folder)
1. Plain "Folder" has no branch badge and no Git actions.
2. To fix:
  - Recommended: Delete (if empty) and use Method A or B.
  - Or create a proper Git folder elsewhere and Move notebooks into it.
  - Uploading content into a plain folder does NOT add Git features.
3. If no Stage / Commit / Push buttons: you're still in a plain folder—move work to a Git folder.

Quick visual rules
- Branch badge (e.g., `main`) = Git folder.
- No badge = plain folder (not versioned; won't push).

Only Git-linked paths under `/Repos/` are under Git control. Anything in `Workspace/` or a plain folder is not.

## 4) Move your existing notebooks into the repo

1. In Workspace, right-click your folder (e.g., `Epic 1 – Data Foundation Platform`) → Move → target `/Repos/<owner>/<repo>/` (create a `solution/` subfolder if desired).

## 5) Commit & Push from Databricks

1. Open any file from `/Repos/...`.
2. Click the branch badge (e.g., `main`) or the Git icon to open the Changes panel.

![picture 16](../../images/a8e173c3c3aea2118f8e5696ff867eb2bf0b6a5ec4155f8d2aa2c4056943bab6.png)  

3. Select files → Stage.
4. If prompted, Pull first.
5. Enter a commit message (e.g., `feat(epic1): initial notebooks`) → Commit & push.

![picture 17](../../images/7377751ea45a08f70a7c69a3c97db4262946b47096d9a44526ddfe33f0efae32.png)  


Working on protected `main`?

- Create a branch (branch menu → Create branch, e.g., `feat/epic1`) → Commit & Push → open a Pull Request on GitHub.

Error messages that may appear if Databricks git hub app is not installed
![picture 13](../../images/980f69422085a288598e70ec632c969c16d451a57cadec55b2dcc1cd82fde078.png)  

![picture 14](../../images/bf6bbccf5c634e0f859d02d9c69129ba03edb4ca88db65377242513576a3a10e.png)  

![picture 15](../../images/9ad89369be9c540db5a72196617169826e01235985ec369e39379587300ab422.png)  

---
 Additional resource: [secloudis.com](https://secloudis.com) – articles and notes on cloud, data, analytics, and artificial intelligence (optional external reference).


