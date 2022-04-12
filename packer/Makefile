.PHONY: terraform build v0.1.0 v0.2.0

default: terraform build

terraform:
	@echo "========================================"
	@echo "Provisioning TF Resources"
	@echo "========================================"
	cd ./terraform && terraform apply

build: v0.1.0 v0.2.0

v0.1.0:
	@echo "========================================"
	@echo "Building v0.1.0 (Prod)"
	@echo "========================================"
	cd v0.1.0 && ./build.sh

v0.2.0:
	@echo "========================================"
	@echo "Building v0.2.0 (Dev)"
	@echo "========================================"
	cd v0.2.0 && ./build.sh
