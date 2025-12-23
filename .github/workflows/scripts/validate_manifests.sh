#!/bin/bash
set -eo pipefail

# This script builds and validates Kustomize manifests for changed directories.
# It expects a list of space-separated directory paths as the first argument.

CHANGED_DIRS=$1
REPORT_FILE="pr-validation-report.md"

echo "## PR Validation Report" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

HAS_ERRORS=false

for dir in $CHANGED_DIRS; do
  # Skip hidden directories like .github, .github/workflows, etc.
  if [[ "$dir" == .* ]]; then
    continue
  fi

  if [ -f "$dir/kustomization.yaml" ] || [ -f "$dir/Kustomization" ]; then
    echo "### Service: \`$dir\`" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    # Build PR manifest
    if ! kustomize build "$dir" --enable-helm > pr-manifest.yaml 2> build-error.log; then
      echo "❌ **Build Failed**" >> "$REPORT_FILE"
      echo '```' >> "$REPORT_FILE"
      cat build-error.log >> "$REPORT_FILE"
      echo '```' >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"
      HAS_ERRORS=true
      continue
    fi

    # Validate with kubeconform
    echo "#### Kubeconform Validation" >> "$REPORT_FILE"
    if kubeconform -strict -summary -ignore-filename-pattern '.*\.sh' pr-manifest.yaml > kubeconform-output.log 2>&1; then
      echo "✅ Success" >> "$REPORT_FILE"
    else
      echo "❌ Issues Found" >> "$REPORT_FILE"
      echo '```' >> "$REPORT_FILE"
      cat kubeconform-output.log >> "$REPORT_FILE"
      echo '```' >> "$REPORT_FILE"
      HAS_ERRORS=true
    fi
    echo "" >> "$REPORT_FILE"

    # Compare with main branch
    echo "#### Manifest Diffs" >> "$REPORT_FILE"
    # We use a temporary branch to check out the base files to avoid local conflicts
    git checkout main -- "$dir" 2>/dev/null || true
    if [ -f "$dir/kustomization.yaml" ] || [ -f "$dir/Kustomization" ]; then
      if kustomize build "$dir" --enable-helm > base-manifest.yaml 2>/dev/null; then
        DIFF_OUTPUT=$(dyff between --color off base-manifest.yaml pr-manifest.yaml)
        if [ -z "$DIFF_OUTPUT" ]; then
          echo "No changes in generated manifests." >> "$REPORT_FILE"
        else
          echo '<details><summary>Click to view diff</summary>' >> "$REPORT_FILE"
          echo "" >> "$REPORT_FILE"
          echo '```' >> "$REPORT_FILE"
          echo "$DIFF_OUTPUT" >> "$REPORT_FILE"
          echo '```' >> "$REPORT_FILE"
          echo '</details>' >> "$REPORT_FILE"
        fi
      else
        echo "Unable to build base manifest for comparison." >> "$REPORT_FILE"
      fi
    else
      echo "New service detected. Full manifest in diff." >> "$REPORT_FILE"
      echo '<details><summary>Click to view full manifest</summary>' >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"
      echo '```yaml' >> "$REPORT_FILE"
      cat pr-manifest.yaml >> "$REPORT_FILE"
      echo '```' >> "$REPORT_FILE"
      echo '</details>' >> "$REPORT_FILE"
    fi
    echo "" >> "$REPORT_FILE"

    # Revert changes to workspace to avoid polluting next iterations
    git checkout HEAD -- "$dir" 2>/dev/null || true
  fi
done

if [ "$HAS_ERRORS" = true ]; then
  echo "Validation failed for one or more services."
  exit 1
fi
