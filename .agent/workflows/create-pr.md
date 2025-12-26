---
description: create a new branch and PR for changes
---
// turbo-all
1. Sync the local `main` branch with `origin/main`:
   ```powershell
   git checkout main
   git pull origin main
   ```
2. Create a new branch for the changes:
   ```powershell
   git checkout -b <branch-name>
   ```
3. Stage and commit the changes:
   ```powershell
   git add .
   git commit -m "<commit-message>"
   ```
4. Push the new branch to GitHub:
   ```powershell
   git push -u origin <branch-name>
   ```
5. Create a new pull request using the GitHub CLI:
   ```powershell
   gh pr create --fill
   ```
6. Switch back to the default branch:
   ```powershell
   git checkout main
   ```
7. **Wait for PR Merge**: Ensure the Pull Request is merged before pulling `main` again. You can verify the status with:
   ```powershell
   gh pr view --json state -q .state
   ```
   Once confirmed as `MERGED`, you may safely return to step 1 for new work.
