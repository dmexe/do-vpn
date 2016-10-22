TF_VERSION := 0.7.7
TF_PATH    := $(shell pwd)/vendor/tf/$(TF_VERSION)/terraform
TF_STATE   := $(shell pwd)/secrets/tfstate.json
TF_DIR     := $(shell pwd)/src
TF_PLAN    := $(shell pwd)/.tfplan.bin
SRC_ENV    := source ~/.secrets/do.sh ; source ~/.secrets/aws.sh ;

.PHONY: deps plan plan.gen plan.apply output

$(TF_PATH):
	mkdir -p `dirname $(TF_PATH)`
	curl -L --fail https://releases.hashicorp.com/terraform/$(TF_VERSION)/terraform_$(TF_VERSION)_darwin_amd64.zip > `dirname $(TF_PATH)`/dist.zip
	unzip -d `dirname $(TF_PATH)` `dirname $(TF_PATH)`/dist.zip
	rm `dirname $(TF_PATH)`/dist.zip
	chmod 0755 $(TF_PATH)

deps: $(TF_PATH)

plan:
	sh -c "$(SRC_ENV) exec $(TF_PATH) plan -state=$(TF_STATE) -refresh=true $(args) $(TF_DIR)"

plan.gen:
	sh -c "$(SRC_ENV) exec $(TF_PATH) plan -state=$(TF_STATE) -refresh=true -out $(TF_PLAN) $(args) $(TF_DIR)"

plan.apply:
	sh -c "$(SRC_ENV) exec $(TF_PATH) apply -state=$(TF_STATE) $(args) $(TF_PLAN)"
	$(MAKE) -f Makefile output.apply

output.apply:
	$(TF_PATH) output -state=$(TF_STATE) user_key > secrets/user.key
	bin/ovpn-client.sh $(TF_PATH) $(TF_STATE)
