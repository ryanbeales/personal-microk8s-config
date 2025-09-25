# Renovate
Renovate is used to keep services up to date (where possible, when I've spend time to configure it).

Configuration is in `.github/renovate.json5`

## Pre-requisites

1. Create an access token here https://github.com/settings/personal-access-tokens With these permissions https://docs.renovatebot.com/modules/platform/github/
1. Create a secret with:
```
sudo k3s kubectl create namespace renovate
sudo k3s kubectl create secret generic renovate-token --from-literal=token={secret} -n renovate
```

## Testing
Dry run with:
```
docker run --rm -e RENOVATE_REPOSITORIES=ryanbeales/personal-microk8s-config -e RENOVATE_PLATFORM=github -e RENOVATE_REPORT_TYPE=logging -e LOG_LEVEL=DEBUG -e RENOVATE_TOKEN={TOKEN GOES HERE} renovate/renovate --dry-run=full
```

Or to trigger PR creation and run locally:
```
docker run --rm -e RENOVATE_REPOSITORIES=ryanbeales/personal-microk8s-config -e RENOVATE_PLATFORM=github -e RENOVATE_REPORT_TYPE=logging -e RENOVATE_TOKEN={TOKEN GOES HERE} -e RENOVATE_PR_HOURLY_LIMIT=10 renovate/renovate --dry-run=full
```

To test extration config locally on this repo:
```
docker run --rm -v $(pwd):/usr/src/app:ro -e RENOVATE_REPORT_TYPE=logging -e RENOVATE_PLATFORM=local -e LOG_LEVEL=DEBUG renovate/renovate --dry-run=extract
```

To validate the config:
```
docker run --rm -v $(pwd):/usr/src/app:ro --entrypoint /usr/local/sbin/renovate-config-validator renovate/renovate --strict
```