SOURCE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
BUILD_ROOT := $(SOURCE_DIR)/build

# Warn if variables are undefined
MAKEFLAGS += --warn-undefined-variables

S3_BUCKET := ''
S3_KEY_PREFIX := $(shell date +%Y%m%d%H%M%S)-

RUNTIMES := mcp a2a

.PHONY: all $(RUNTIMES) install upload deploy

deploy: $(RUNTIMES)
	@aws cloudformation deploy \
		--template-file $(SOURCE_DIR)/template.yml \
		--stack-name AgentCore-Gateway-to-Runtime \
		--parameter-overrides \
			RuntimeCodeS3Bucket=$(S3_BUCKET) \
			RuntimeCodeS3KeyPrefix=$(S3_KEY_PREFIX) \
		--capabilities CAPABILITY_NAMED_IAM

$(RUNTIMES): BUILD_DIR = $(BUILD_ROOT)/$@
$(RUNTIMES): ZIP_FILE_NAME = $(S3_KEY_PREFIX)$@.zip
$(RUNTIMES):
	@rm -rf $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)
	@cp -r $(SOURCE_DIR)/$@_runtime/* $(BUILD_DIR)
	@$(MAKE) install name=$@ build_dir=$(BUILD_DIR)
	@cd $(BUILD_DIR) && zip -r $(ZIP_FILE_NAME) *
	@$(MAKE) upload zip_path=$(BUILD_DIR)/$(ZIP_FILE_NAME)

install:
	@uv pip install \
		--python-platform aarch64-manylinux2014 \
		--python-version 3.14 \
		--target="$(build_dir)" \
		--only-binary=:all: \
		-r "$(SOURCE_DIR)/$(name)_runtime/requirements.txt"

upload:
	@aws s3 cp $(zip_path) s3://${S3_BUCKET}/$(notdir $(zip_path))
