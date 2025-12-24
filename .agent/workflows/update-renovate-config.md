---
description: update the list of repositories that Renovate bot scans
---

1. Locate the Renovate CronJob manifest at [cronjob.yaml](file:///c:/Users/Ryan/src/personal-microk8s-config/development-services/renovate/cronjob.yaml).
2. Find the `RENOVATE_REPOSITORIES` environment variable under the `renovate-bot` container.
3. Modify the `value` field:
   - It is a comma-separated list of GitHub repositories (e.g., `user/repo1,user/repo2`).
   - Add new repositories or remove existing ones as requested.
4. Follow the `/create-pr` workflow to stage, commit, and push the changes.
