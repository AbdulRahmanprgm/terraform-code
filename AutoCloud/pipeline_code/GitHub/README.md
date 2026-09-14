# GitHub OIDC → AWS → Terraform Deployment

## Step 1: Create GitHub Repository

1. Login to GitHub
2. Create a new repository
3. Example name:

   ```
   terraform-iac
   ```

4. Initialize with a README file

---

## Step 2: Create OIDC Provider in AWS

1. Login to AWS Console
2. Go to:

   ```
   IAM → Identity Providers
   ```

3. Click:

   ```
   Add Provider
   ```

4. Select:

   * Provider Type:

     ```
     OpenID Connect
     ```

   * Provider URL:

     ```
     https://token.actions.githubusercontent.com
     ```

   * Audience:

     ```
     sts.amazonaws.com
     ```

5. Click:

   ```
   Add Provider
   ```

---

## Step 3: Create IAM Role

1. Go to:

   ```
   IAM → Roles → Create Role
   ```

2. Select:

   ```
   Web Identity
   ```

3. Choose:

   * Identity Provider

     ```
     token.actions.githubusercontent.com
     ```

   * Audience

     ```
     sts.amazonaws.com
     ```

4. Attach Policy

   For learning:

   ```
   AdministratorAccess
   ```

5. Role Name

   Example:

   ```
   github-oidc-role
   ```

6. Create Role

7. Copy Role ARN

Example:

```text
arn:aws:iam::348737449144:role/github-oidc-role
```

---

## Step 4: Configure Trust Policy

Open:

```text
IAM → Roles → github-oidc-role → Trust Relationships → Check If Trust Policy Wrong Edit It
```

Replace with:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::<ACCOUNT-ID>:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:<GITHUB-USERNAME>/<REPOSITORY-NAME>:*"
        }
      }
    }
  ]
}
```

Example:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::348737449144:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:cloudgarage/terraform-iac:*"
        }
      }
    }
  ]
}
```

> Repository name and owner must match exactly.

---

## Step 5: Store Role ARN in GitHub Secrets

1. Open Repository
2. Go to:

   ```
   Settings → Secrets and variables → Actions
   ```

3. Click:

   ```
   New repository secret
   ```

4. Create:

   **Name**

   ```
   AWS_ROLE_ARN
   ```

   **Value**

   ```
   arn:aws:iam::348737449144:role/github-oidc-role
   ```

5. Click:

   ```
   Add Secret
   ```

---

## Step 6: Create GitHub Actions Workflow

Create file:

```text
.github/workflows/terraform.yml
```

Paste:

```yaml
name: Terraform Deploy

on:
  push:
    branches:
      - main

permissions:
  contents: read

jobs:
  terraform:
    runs-on: ubuntu-latest

    permissions:
      id-token: write
      contents: read

    steps:
      - uses: actions/checkout@v4

      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1

      - uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.14.0

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan

      # Uncomment to deploy resources
      # - name: Terraform Apply
      #   run: terraform apply -auto-approve
```

Replace:

```yaml
aws-region: us-east-1
```

with your AWS region if needed.

---

## Step 7: Verify Workflow

Open:

```text
GitHub → Actions
```

Select the latest workflow run.

Expected output:

```text
Terraform Init
Terraform Validate
Terraform Plan
```

Example:

```text
Plan: 5 to add, 0 to change, 0 to destroy.
```

---

## Step 8: Deploy Resources (Optional)

Currently the workflow only performs:

```text
Terraform Init
Terraform Validate
Terraform Plan
```

To deploy resources automatically, uncomment:

```yaml
- name: Terraform Apply
  run: terraform apply -auto-approve
```

Then commit and push again.

---

## Successful Output

```text
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

Success:

* GitHub connected to AWS using OIDC
* No AWS Access Keys used
* Terraform authentication successful
* Infrastructure deployed to AWS

---

## Common Mistakes

### Error

```text
Not authorized to perform sts:AssumeRoleWithWebIdentity
```

Check:

1. OIDC Provider exists
2. Trust Policy repository name is correct
3. Correct AWS_ROLE_ARN secret
4. `id-token: write` permission exists

---

### Error

```text
Could not load credentials
```

Check:

1. AWS_ROLE_ARN secret exists
2. Secret value contains correct Role ARN

---

### Error

```text
terraform: command not found
```

Check:

```yaml
uses: hashicorp/setup-terraform@v3
```

exists in workflow.

---

## Workflow Flow

```text
Developer Pushes Code
        │
        ▼
GitHub Actions Starts
        │
        ▼
Configure AWS OIDC
        │
        ▼
Terraform Init
        │
        ▼
Terraform Validate
        │
        ▼
Terraform Plan
        │
        ▼
Pipeline Complete
```
