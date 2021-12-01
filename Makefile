#
# Modern Python
#

PKG_NAME    := modern_python
PKG_VERSION := $(shell poetry version | awk '{print $$2}')
IMAGE_NAME  := edaniszewski/modern-python

.DEFAULT_GOAL := help
.PHONY: clean docker fmt help lint tag test update version


clean:  ## Clean up build and test artifacts.
	rm -rf build/ dist/ *.egg-info src/*.egg-info htmlcov/ .coverage* .pytest_cache/ \
		.mypy_cache/ src/${PKG_NAME}/__pycache__ tests/__pycache__

docker: ## Build the docker image locally.
	docker build \
		-t ${IMAGE_NAME}:latest .

fmt: ## Automatic source code formatting.
	poetry run pre-commit run --all-files

lint:  ## Run linting checks on project source code.
	poetry run flake8
	poetry run mypy src
	poetry check

tag:  ## Create and push a git tag with the current version.
	git tag -a ${PKG_VERSION} -m "${PKG_NAME} version ${PKG_VERSION}"
	git push -u origin ${PKG_VERSION}

test: ## Run project tests.
	poetry run pytest

update: ## Update project and tooling dependencies.
	poetry update
	poetry run pre-commit autoupdate

version: ## Print the project version.
	@echo "${PKG_VERSION}"

help: ## Print Makefile usage information.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort
