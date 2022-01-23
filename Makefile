# Setup ————————————————————————————————————————————————————————————————————————
SHELL         = bash
PROJECT       = home-as-code
USER          = $(shell id -u)
GROUP         = $(shell id -g)
DOCKER        = USER_ID=$(USER) GROUP_ID=$(GROUP) docker
DC            = USER_ID=$(USER) GROUP_ID=$(GROUP) docker-compose
.DEFAULT_GOAL = help

## —— The Home server network as code Makefile 🍺 ——————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Project 🛠  ———————————————————————————————————————————————————————————————
run: network proxy services ## Create network, start rev-proxy & services

abort: services-down proxy-down network-rm ## Stop services, rev-proxy, remove network

## —— Network 💻 ———————————————————————————————————————————————————————————————
network: ## Create the network
network-rm: ## Remove the network

## —— Proxy 🧙‍ —————————————————————————————————————————————————————————————————
proxy: ## Start the reverse proxy
proxy-down: ## Stop the reverse proxy

## —— Services 💻 ——————————————————————————————————————————————————————————————
services: ## Start the services
services-down: ## Stop the services

