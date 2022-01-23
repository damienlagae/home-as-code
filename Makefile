# Setup 🔧 ————————————————————————————————————————————————————————————————————————
SHELL         = bash
PROJECT       = home-as-code
USER          = $(shell id -u)
GROUP         = $(shell id -g)
DOCKER        = USER_ID=$(USER) GROUP_ID=$(GROUP) docker
DC_ARGS       = --env-file .env
DC            = USER_ID=$(USER) GROUP_ID=$(GROUP) docker-compose $(DC_ARGS)
.DEFAULT_GOAL = help

## —— The Home server network as code Makefile 🧰 ——————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Project 🛠 ———————————————————————————————————————————————————————————————
run: network proxy services ## Create network, start rev-proxy & services

abort: services-down proxy-down network-rm ## Stop services, rev-proxy, remove network

clean: proxy-clean nextcloud-clean ## Remove all volumes

## —— Network 📡 ———————————————————————————————————————————————————————————————
network: ## Create the network
	$(DOCKER) network create --subnet=10.18.0.0/24 caddy
network-rm: ## Remove the network
	$(DOCKER) network rm caddy

## —— Proxy 🛡 ————————————————————————————————————————————————————————————————
proxy: ## Start the reverse proxy
	$(DC) -f ./caddy/docker-compose.yml up -d
proxy-down: ## Stop the reverse proxy
	$(DC) -f ./caddy/docker-compose.yml down
proxy-clean: ## Remove the reverse proxy volume
	$(DOCKER) volume rm caddy_data

## —— Services 🏗 ——————————————————————————————————————————————————————————————
services: nextcloud-up ## Start the services
services-down: nextcloud-down ## Stop the services

nextcloud-up: ## Start the nextcloud service
	$(DC) -f ./services/nextcloud/docker-compose.yml up -d
nextcloud-down: ## Stop the nextcloud service
	$(DC) -f ./services/nextcloud/docker-compose.yml down
nextcloud-logs: ## Show the nextcloud service logs
	$(DC) -f ./services/nextcloud/docker-compose.yml logs
nextcloud-clean: ## Remove the nextcloud volumes
	$(DOCKER) volume rm nextcloud_db
	$(DOCKER) volume rm nextcloud_config
	$(DOCKER) volume rm nextcloud_files
	$(DOCKER) volume rm nextcloud_apps
