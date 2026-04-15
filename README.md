# NanoClaw Home Assistant Add-on

Custom Home Assistant add-on that runs [NanoClaw](https://github.com/qwibitai/nanoclaw) on HAOS.

## Install

1. Push this repo to GitHub.
2. In Home Assistant: **Settings → Add-ons → Add-on Store → ⋮ → Repositories**.
3. Paste the GitHub URL of this repo, click Add, then Close.
4. Refresh the store; the **NanoClaw** add-on appears.
5. Install it (builds on the Pi — a few minutes on aarch64).
6. Open the add-on's **Configuration** tab and set `github_repo` to your fork of NanoClaw, e.g. `https://github.com/<you>/nanoclaw.git`.
7. Start the add-on.

## First-run setup

NanoClaw's `/setup` is interactive and must be driven once via Claude Code:

```bash
# from the Advanced SSH & Web Terminal add-on (protection mode off):
docker exec -it addon_local_nanoclaw bash
cd /share/nanoclaw
claude    # then run /setup inside the Claude Code prompt
```

After `/setup` finishes, restart the add-on. It will boot straight into `npm start`.

## Iteration

Edit files under `/share/nanoclaw/**` (via the SSH or VS Code add-on). Restart the add-on to pick up changes — no image rebuild required.

## Caveats

- **Docker socket mounted.** Agent containers spawn as siblings on the host Docker daemon, sharing CPU/RAM with Home Assistant. Keep concurrency low on a Pi 5.
- **aarch64 only.** Verify any base images NanoClaw pulls for agent containers have arm64 tags.
- **Supervisor updates** can occasionally break privileged add-ons. Pin versions and expect to fix things once or twice a year.
