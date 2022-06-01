.PHONY: all

TF_VERSION=1.2.1
NODE_VERSION=14.x

all: install-dependencies test/all

install-dependencies: install/terraform install/nodejs install/checkov

# -----------------------------------------------------------------------------------
# Dependencies install targets
# -----------------------------------------------------------------------------------
install/terraform:
	@echo "INSTALLING TERRAFORM version ${TF_VERSION}..."
	@curl https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip --output /opt/terraform.zip
	@unzip -o /opt/terraform.zip -d /usr/local/bin/
	@rm -f /opt/terraform.zip
	@terraform -version
	@echo ""

install/nodejs:
	@echo "INSTALLING NODE.js version ${NODE_VERSION}..."
	@curl -sL https://rpm.nodesource.com/setup_${NODE_VERSION} | bash -
	@yum install -y nodejs
	@node -v
	@npm -v
	@echo ""

install/checkov:
	@echo "INSTALLING CHECKOV..."
	@/usr/local/bin/pip3.8 install dataclasses && /usr/local/bin/pip3.8 install checkov --upgrade
	@checkov --version
	@echo ""

# -----------------------------------------------------------------------------------
# Test Targets
# -----------------------------------------------------------------------------------
test/checkov:
	@echo "Running Checkov for Terrafrom in ${ENV}"
	@cd terraform/${ENV} && \
		checkov -d . --quiet --framework terraform --download-external-modules true

# -----------------------------------------------------------------------------------
# Terraform Targets
# -----------------------------------------------------------------------------------
ENV?=
terraform/init:
	@echo "Terraform Init in ${ENV}"
	@cd terraform/${ENV} && \
		rm -rf tfplan-${ENV} .terraform/ && \
		terraform init

terraform/plan:
	@echo "Terraform Plan in ${ENV}"
	@cd terraform/${ENV} && \
		terraform plan \
			-out=tfplan-${ENV}

terraform/apply:
	@echo "Terraform Apply in ${ENV}"
	@cd terraform/${ENV} && \
		terraform apply tfplan-${ENV}

terraform/plan-destroy:
	@echo "Terraform **** Destroy **** Plan in ${ENV}"
	@cd terraform/${ENV} && \
		terraform plan -destroy \
			-out=tfplan-destroy-${ENV}

terraform/apply-destroy:
	@echo "Terraform **** Destroy **** Apply in ${ENV}"
	@cd terraform/${ENV} && \
		terraform apply tfplan-destroy-${ENV}