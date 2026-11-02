# ALLEval — Enterprise On-Prem Readiness Assessment

**As of:** 2026-11-02 · **Method:** primary-source checks against GitHub (API + raw LICENSE files) and local environment probing. Numbers below are live, not from the README's static table, which predates several material changes.

This memo corrects and updates the `README.md` comparison matrix against the workspace's stated purpose: selecting an open-source LLM eval suite for **enterprise, self-hosted / air-gapped** deployment.

---

## 1. Live metadata (verified 2026-11-02)

| Suite | License | Stars | Latest release (date) | Last default-branch commit | Maintenance |
|---|---|---:|---|---|---|
| promptfoo | MIT | 26,745 | `0.125.1` (2026-10-25) | 2026-11-02 (same day) | **Active** |
| deepeval | Apache-2.0 | 19,249 | `python-v4.2.4` (2026-09-22) | 2026-11-02 | **Active** |
| phoenix | **Elastic License 2.0 (ELv2)** | 12,103 | `arize-phoenix-client-v3.6.0` (2026-10-30) | 2026-11-01 | **Active** |
| helm | Apache-2.0 | 2,962 | `v0.5.16` (2026-04-30) | 2026-06-05 | **Slowing** |
| ragas | Apache-2.0 | 16,216 | `v0.4.3` (2026-01-13) | 2026-02-24 | **Dormant** |

Sources: GitHub REST `/repos/{owner}/{repo}`, `/releases/latest`, `/commits?per_page=3`, and raw `LICENSE` files.

---

## 1b. Submodule pin freshness (verified locally against the recorded pins, 2026-11-02)

| Suite | Pinned commit | Pin date | vs upstream tip |
|---|---|---|---|
| promptfoo | `9cd19241` | 2026-08-30 | **~2 mo behind** (tip 2026-11-02) |
| phoenix | `37916d73` | 2026-08-29 | **~2 mo behind** (tip 2026-11-01) |
| deepeval | `9404fb2d` | 2026-08-28 | **~2 mo behind** (tip 2026-11-02) |
| helm | `63754d05` | 2026-06-05 | **at tip** (upstream itself stalled) |
| ragas | `298b6827` | 2026-02-24 | **at tip** (upstream itself dormant) |

- Pin licenses verified in-checkout: promptfoo MIT, **phoenix ELv2 (confirmed in the pinned tree, not just upstream)**, deepeval / helm / ragas Apache-2.0.
- `Dockerfile` present at pin: **promptfoo, phoenix**. Absent at pin: deepeval, helm, ragas — so the two source-`build:` compose templates (promptfoo, phoenix) are the only ones that can build as written; the other three are Python libs meant to be `pip install`-ed, not container-built.
- **Action:** the three active suites (promptfoo/phoenix/deepeval) are pinned ~2 months stale — advance them with `git submodule update --remote` before benchmarking so results reflect current code. helm/ragas are already at tip (their dormancy is upstream, not a pin issue).

---

## 2. Material findings that contradict the README

### 2.1 Phoenix is ELv2, not permissively open source
- The `LICENSE` on Arize-ai/phoenix `main` is **Elastic License 2.0**; the GitHub API returns `license.spdx_id = NOASSERTION` precisely because ELv2 is not an OSI-approved license.
- **Impact on the workspace:** the README lists Phoenix under "open source" and rates its on-prem fit "Excellent." ELv2 **does permit internal / on-prem enterprise use**, but it **forbids** (a) offering the software to third parties as a managed service and (b) circumventing its license features. For a strictly internal evaluation stack this is workable; for anything redistributed or offered externally it needs legal review. Correct the "open source" framing.
- This also weakens the "project is open source" checklist item (§4) as written for Phoenix.

### 2.2 ragas has changed ownership and gone quiet
- The submodule URL is `github.com/explodinggradients/ragas.git`, but that repo now **redirects** (`301 Moved Permanently`) to `github.com/vibrantlabsai/ragas`.
- Last default-branch commit: **2026-02-24** (~8 months stale); last release `v0.4.3` (2026-01-13).
- **Impact:** the README recommends ragas as a top-3 RAG/agent eval choice and calls it "Good" for on-prem. Its maintenance status is now a real risk. The submodule pointer should be updated to the current org, and ragas demoted from "recommended" to "watch" until release cadence resumes.

### 2.3 helm is benchmark-only and moving slowly
- Latest release `v0.5.16` (2026-04-30); last default-branch commit 2026-06-05. Stanford CRFM's HELM is research-grade benchmark infrastructure, not an application-eval pipeline.
- **Impact:** keep helm, but scope it correctly — it is for **formal model benchmark comparison**, not CI regression / red-teaming. The README already notes this ("broader benchmarking than application eval pipeline"); add the staleness caveat.

### 2.4 What IS actively maintained and permissively licensed
- **promptfoo (MIT)** and **deepeval (Apache-2.0)** are the two suites with both a permissive license and same-day commit activity plus recent releases (Oct 25 / Sep 22 2026). For a private enterprise eval stack that must be open source *and* actively maintained, these two are the strongest foundation.

---

## 3. Local environment probe (this host)

- **Container runtime:** Docker CLI is emulated by **podman 5.7.0** (crun). `docker compose` maps to **Docker Compose 2.40.3** (external provider shim). Both compose templates validate (`docker compose -f … config` → exit 0).
- **Only nit:** both templates set the now-obsolete top-level `version:` key (compose warns it is ignored). Harmless; removable.
- **Toolchains:** Python 3.14.9, Node v26.12.1. No NVIDIA GPU detected (`nvidia-smi` not found) — on-prem eval here would run against API gateways, not local GPU inference.
- **Caveat:** the compose templates `build:` from the submodule source (`context: ../promptfoo`, `../phoenix`). Building Phoenix from source is a heavy frontend+backend monorepo. For evaluation it is faster and more faithful to run the **published images** (`promptfoo/promptfoo`, `arizephoenix/phoenix`) than to build submodules. Consider adding image-based template variants.

---

## 4. Checklist verdict (from README "Evaluation readiness checklist")

Legend: ✅ = verified fit · ⚠️ = caveats · ❌ = does not meet as written

| Criterion | promptfoo | deepeval | phoenix | ragas | helm |
|---|:--:|:--:|:--:|:--:|:--:|
| Runs fully in private network / air-gap | ✅ | ✅ | ⚠️ needs self-host | ✅ | ✅ |
| No external SaaS by default | ✅ | ⚠️ Confident Cloud optional | ⚠️ Arize Cloud optional | ✅ | ✅ |
| RAG / agent eval | ⚠️ | ✅ | ✅ | ✅ (dormant) | ❌ |
| Security / red-team checks | ✅ | ⚠️ | ❌ | ❌ | ❌ |
| Local/CI regression tracking | ✅ | ✅ | ✅ | ⚠️ | ⚠️ |
| Observability (latency/tokens/trace) | ⚠️ | ⚠️ | ✅ | ❌ | ❌ |
| Docker / K8s / self-host | ✅ | ⚠️ CI | ✅ Helm/K8s | ⚠️ lib | ⚠️ |
| Open source (OSI) | ✅ MIT | ✅ Apache-2.0 | ❌ **ELv2** | ✅ Apache-2.0 | ✅ Apache-2.0 |
| Actively maintained | ✅ | ✅ | ✅ | ⚠️ dormant | ⚠️ slowing |

**Bottom line:** For an enterprise, air-gapped, permissively-licensed eval stack the defensible core is **promptfoo + deepeval**, with **phoenix** added for observability *if* the ELv2 internal-use terms are acceptable. **ragas** and **helm** should be demoted pending maintenance, and **ragas**' submodule URL repointed to the current org.

---

## 5. Recommended actions for the repo
1. Update README comparison matrix + recommended-path with the live license/activity facts above (esp. Phoenix ELv2, ragas ownership/staleness).
2. Repoint the `ragas` submodule to `vibrantlabsai/ragas` (or note the redirect).
3. Remove the obsolete `version:` key from both compose templates; add image-based (`image:`) variants alongside the source-`build:` ones.
4. Add a "License" column to the comparison matrix — it is the biggest omission for an enterprise/on-prem decision.
