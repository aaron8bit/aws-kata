#
DATE=$(shell date +%Y%m%d-%H%M)
FILE=plan-$(DATE)
LASTPLAN=$(shell cat .lastplan)
LASTPLAN_LOG=$(LASTPLAN).apply.log

.PHONY: default
default:
	@echo "Usage: make [target]"
	@echo
	@echo "These are the targets:"
	@echo
	@echo "default:       prints this help"
	@echo "init:          initialize terraform"
	@echo "validate:      validate the current configuration"
	@echo "environment:   check that environment variables are set"
	@echo "refresh:       refresh tfstate from AWS"
	@echo "plan:          create a new planfile and save name in .lastplan"
	@echo "apply:         apply the plan listed in .lastplan"
	@echo "detroy:        DANGER! refresh and then destroy the environment"
	@echo
	@echo "These environment variables must be set for refresh, plan, and apply"
	@echo
	@echo "AWS_ACCESS_KEY_ID:       <your aws access key id>"
	@echo "AWS_SECRET_ACCESS_KEY:   <your aws access key>"
	@echo "AWS_DEFAULT_REGION:      <your default region>"

.PHONY: init
init:
	terraform init

.PHONY: validate
validate:
	terraform validate

.PHONY: environment
environment:
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID is undefined)
else
	$(info AWS_ACCESS_KEY_ID is set)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY is undefined)
else
	$(info AWS_SECRET_ACCESS_KEY is set)
endif
ifndef AWS_DEFAULT_REGION
	$(error AWS_DEFAULT_REGION is undefined)
else
	$(info AWS_DEFAULT_REGION is set)
endif
	@echo > /dev/null

.PHONY: refresh
refresh:
	terraform refresh

.PHONY: plan
plan: validate environment
	terraform plan -out=$(FILE)
	@echo; echo Wrote plan file, $(FILE)
	@echo $(FILE) > .lastplan

.PHONY: apply
apply: environment
	terraform apply $(LASTPLAN) 2>&1 | tee $(LASTPLAN_LOG)
	@echo; echo "Terraform apply output was logged to $(LASTPLAN_LOG)"
	@terraform state list > terraform.state.list
	@echo "Terraform state list was logged to terraform.state.list"

.PHONY: destroy
destroy: environment refresh
	terraform destroy
	@terraform state list > terraform.state.list
	@echo "Terraform state list was logged to terraform.state.list"
