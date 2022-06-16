# Terraform Vault Dr

## NOTE

**Terraform repo containing Live Environments for the Presentation and DEMO at HASHICONF EUROPE 2022**

SLIDES: {TO BE INSERTED}

PRESENTATION: {TO BE INSERTED}

## Description

This repo contains the Live environments: `dev`, `stage` and `prod` of the module https://github.com/KevinDeNotariis/terraform-vault-dr with a _GitOps_ approach for Jenkins integration:

- Push on a branch not _master_: Run tests;
- On Pull Request against _master_: Run Tests and make a Terraform Plan;
- On Merge to _master_ make a Terraform Apply

## Pre-requisites

- 2 Vault clusters PER environment (`dev`, `stage`, `prod`) deployed in AWS with 2 `Route53` records for your hosted zone:

  **HIGH LEVEL ARCHITECTURE:**

  [Vault Clusters High level architecture](https://github.com/KevinDeNotariis/terraform-vault-dr/blob/master/img/high_level_architecture.png)

  Two Vault clusters under autoscaling groups and behind Network Load Balancers with 2 Route53 records, one for the primary cluster and one for the secondary cluster (in DR Replication). Then a higher level endpoint, pointing to both the other two endpoints with a weighted policy; max weight for the primary cluster and minimum weight for the secondary cluster.

- Docker Container Tagged `centos:my-centos` in you Jenkins instance (`Jenkinsfile` line 4). This container can be built from the `jenkins-container` folder (simple `centos` rendition with `python3.8` & `git` installed plus other basic tools).

- Jenkins plugins:

  - CloudBees AWS Credentials https://plugins.jenkins.io/aws-credentials/

    - And AWS credentials in jenkins with id `my-aws-credentials`

  - Pipeline: AWS Steps https://plugins.jenkins.io/pipeline-aws/#documentation

  - Pipeline https://plugins.jenkins.io/workflow-aggregator/

  - Docker Pipeline https://plugins.jenkins.io/docker-workflow/

- In each `terraform/{env}/locals.tf` change the `hosted_zone` and various endpoint variables with your ones.

## Structure

In `terraform` folder there can be found 3 environments: `dev`, `stage` and `prod`. Inside these, we can find the terraform files to deploy the module https://github.com/KevinDeNotariis/terraform-vault-dr.

The dev environment will take the repo from the master branch, while the `stage` and `prod` will take the module from a specific version.

The Jenkinsfile will process the environments in parallel and will, upon a commit on a branch not _master_, make some tests using `checkov`.

Then, on a pull-request, it will also make a terraform plan in each environment, which can be checked to see whether everything is ok.

Finally, on a merge against _master_, it will make a terraform apply to deploy eveything.

The first stage will always be to furnish the vault token for each environment and the installation of the dependencies.
