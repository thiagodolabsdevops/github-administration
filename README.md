# github-administration

If you want to run a similar approach to manage your GitHub repos you need to have the following in place before start:

## Generate a GitHub Personal Access Token

Generate a PAT:
    1. Go to GitHub and navigate to "Settings."
    2. Click on "Developer settings" in the left sidebar.
    3. Select "Personal access tokens" and click "Generate new token."
    4. Set a name for the token and select the scopes needed for your Terraform configuration. At a minimum, you'll need repo scope for access to repository data.

Add the PAT to Repository Secrets:
    1. Go to your repository on GitHub.
    2. Click on "Settings" and then "Secrets and variables" in the left sidebar.
    3. Click on "Actions" and then "New repository secret."
    4. Name the secret `GH_TOKEN` (or any name you prefer) and paste the PAT you created.

## TODO

- Write secrets to Secrets Manager
- Secure secrets using SOPS
