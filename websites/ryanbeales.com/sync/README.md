# S3 Sync Service Setup

This directory contains the configuration for syncing the private GitHub repository `ryanbeales/wwwryanbealescom` to the S3 bucket `www.ryanbeales.com`.

## Prerequisites

### GitHub Deploy Key

Since the repository is private, you need to provide an SSH key for authentication.

1.  **Generate a new SSH key:**
    ```bash
    ssh-keygen -t rsa -b 4096 -C "s3-sync@ryanbeales.com" -f ./github_deploy_key -N ""
    ```

2.  **Add the Public Key to GitHub:**
    - Go to the repository settings: `https://github.com/ryanbeales/wwwryanbealescom/settings/keys`
    - Click **Add deploy key**.
    - **Title**: `S3 Sync Cluster`
    - **Key**: Paste the contents of `github_deploy_key.pub`.
    - **Allow write access**: No (Read-only is sufficient).

3.  **Create the Kubernetes Secret:**
    Ensure you are targeting the `websites` namespace.
    Run the following command using the *private* key file:

    ```bash
    kubectl create secret generic github-deploy-key --from-file=ssh-privatekey=./github_deploy_key -n websites
    ```
    
    > **Important**: The key in the secret data must be named `ssh-privatekey` because the CronJob expects this specific filename when mounting the secret.

4.  **Clean up:**
    Delete the local key files securely.
    ```bash
    rm github_deploy_key github_deploy_key.pub
    ```

## Resources

- **CronJob**: Runs `aws s3 sync` to push changes from the git repo to the bucket.
- **IAM User & Policy**: Managed via Crossplane to provide specifically scoped write access to the S3 bucket.
