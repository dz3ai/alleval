# ALLEval

A local evaluation workspace for benchmarking and assessing open-source LLM evaluation suites for enterprise on-premise deployments.

This repository is organized as a parent repo with selected OSS evaluation projects added as Git submodules for comparison, experimentation, and private deployment evaluation.

## Included submodules

- [promptfoo](./promptfoo) — evals, red teaming, and model comparison
- [phoenix](./phoenix) — observability and evaluation for LLM applications
- [ragas](./ragas) — RAG and agent evaluation framework
- [deepeval](./deepeval) — Python-native LLM evaluation framework
- [helm](./helm) — benchmark and model evaluation framework

## Purpose

This workspace is intended to help evaluate which open-source suite best fits enterprise, self-hosted, or air-gapped LLM deployments based on criteria such as:

- local/private execution
- on-prem deployment support
- integration with internal model gateways
- RAG/agent evaluation support
- security and red-team capabilities
- benchmarking and regression tracking
- CI/CD suitability

## Getting started

Initialize and update submodules:

```bash
cd /home/dannyz/src/llmbenchmark/alleval
git submodule update --init --recursive
```

Then explore each project individually:

```bash
ls -1
```

## Recommended initial focus

For enterprise on-prem use, the most relevant starting points are:

1. [promptfoo](./promptfoo) — broad eval and red-team workflows
2. [phoenix](./phoenix) — production observability and tracing
3. [ragas](./ragas) — retrieval and agent quality evaluation
4. [deepeval](./deepeval) — Python-centered eval automation
5. [helm](./helm) — benchmark-oriented evaluation and comparison

## Evaluation readiness checklist

Use this checklist before adopting a solution in a secure, private environment.

- [ ] Model access is isolated to approved internal gateways or vetted providers.
- [ ] Evaluations can run fully inside a private network or air-gapped environment.
- [ ] Prompts, traces, and outputs are not sent to external SaaS services by default.
- [ ] RAG and agent workflows can be measured with task-specific scorecards.
- [ ] Security and jailbreak/red-team checks are available as part of the pipeline.
- [ ] The stack supports local or CI-based regression tracking and drift detection.
- [ ] Observability includes latency, token usage, errors, and failure traces.
- [ ] Deployment options include Docker, Kubernetes, or self-hosting patterns.
- [ ] Data retention and export controls meet enterprise compliance requirements.
- [ ] The project is open source and actively maintained.

## Docker Compose templates

Sample local templates are stored in the [templates](./templates) directory.

- [templates/docker-compose.promptfoo.yml](./templates/docker-compose.promptfoo.yml) — local Promptfoo eval and red-team environment
- [templates/docker-compose.phoenix.yml](./templates/docker-compose.phoenix.yml) — Phoenix self-hosted observability stack

A convenience startup script is provided at [scripts/start-all.sh](./scripts/start-all.sh):

```bash
cd /home/dannyz/src/llmbenchmark/alleval
./scripts/start-all.sh
```

Copy a template file to a working location and adjust environment variables and mounts for your environment.

```bash
cd /home/dannyz/src/llmbenchmark/alleval
docker compose -f templates/docker-compose.promptfoo.yml up --build
```

```bash
cd /home/dannyz/src/llmbenchmark/alleval
docker compose -f templates/docker-compose.phoenix.yml up --build
```

## Comparison matrix

| Project | Best for | On-prem fit | Deployment model | Strengths | Trade-offs |
| --- | --- | --- | --- | --- | --- |
| [promptfoo](./promptfoo) | evals, red teaming, model comparisons | Excellent | Local CLI, Docker, self-hosted app | Strong eval workflow, red-team scanning, CI-friendly | More operational focus than deep tracing |
| [phoenix](./phoenix) | LLM observability, tracing, debugging | Excellent | Docker, Helm, Kubernetes, self-hosted | Production-grade observability, trace analysis, strong self-hosting story | Less focused on benchmark suites |
| [ragas](./ragas) | RAG and agent evaluation | Good | Python library, local or private compute | Excellent quality metrics for retrieval and answer evaluation | More library-oriented than full dashboarding |
| [deepeval](./deepeval) | Python-native model testing | Good | Local Python tests, CI pipelines | Very developer-friendly, fast iteration, custom metrics | Less enterprise dashboarding than Phoenix |
| [helm](./helm) | benchmark suites and model comparison | Good | Local benchmark runs, reproducible suite management | Research-grade comparison, broad benchmark coverage | Broader benchmarking than application eval pipeline |

## Recommended path

For a private enterprise deployment, the most practical starting stack is:

1. [promptfoo](./promptfoo) for evals and red teaming
2. [phoenix](./phoenix) for observability and debugging
3. [ragas](./ragas) for RAG/agent quality metric checks
4. [deepeval](./deepeval) if Python-native CI tests are preferred
5. [helm](./helm) for formal benchmark or model comparison work

## Notes

- This repository is designed for research and evaluation rather than production deployment.
- Each submodule may have its own dependencies, setup steps, and license terms.
- Review each project’s upstream README before adopting it in a secure environment.

## Repository status

This is a comparison workspace for selecting an open-source evaluation pipeline suite for on-prem enterprise LLM deployments.
