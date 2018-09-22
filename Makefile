BACKUP_DIR = ~/backup

APP_SERVICE_NAME = dsp
APP_SOURCE_DIR = ~/adtech-compe-2018-e/server/

NGINX_ACCESS_LOG = /var/log/nginx/access.log
NGINX_ERROR_LOG = /var/log/nginx/error.log

.DEFAULT_GOAL := help

restart: ## Restart Services of Nginx, MySQL, and App
	@make -s nginx-restart db-restart app-restart

app-log: ## Show Log App Service
	@sudo journalctl -u ${arg} ${APP_SERVICE_NAME}

app-rebuild: ## Rebuild and Restart App
	@echo -n "Rebuilding ${APP_SERVICE_NAME}... "
	@(cd ${APP_SOURCE_DIR}; make) \
        	&& echo 'done!'
	@make -s app-restart

app-restart: ## Restart App Service
	@echo -n "Restarting ${APP_SERVICE_NAME}... "
	@(sudo systemctl daemon-reload \
	       && sudo systemctl restart ${APP_SERVICE_NAME}) \
	   && echo 'done!'

sync: ## Sync Application
	@echo -n "Sync ${APP_SERVICE_NAME}... "
	@cd ${APP_SOURCE_DIR} \
	@git pull \
	    && git checkout feature/server \
	    && echo 'done!' \
	    && cd /home/ozilikepop/config/ \
	    && make -s app-rebuild nginx-reload

nginx-reload: ## Reload Nginx
	@echo -n 'Checking Nginx conf... '
	@sudo nginx -t \
	    && echo 'done!' \
	    && echo -n 'Reload Nginx conf... ' \
	    && sudo nginx -s reload \
	    && echo 'done!'

nginx-restart: ## Restart Nginx
	@echo -n 'Restarting Nginx... '
	@sudo systemctl restart nginx \
	    && echo 'done!'

nginx-log: ## tail Nginx access.log [arg=<tail option>]
	@sudo tail ${arg} ${NGINX_ACCESS_LOG}

nginx-error-log: ## tail Nginx error.log [arg=<tail option>]
	@sudo tail ${arg} ${NGINX_ERROR_LOG}

nginx-backup: ## Make nginx.conf Backup to ~/backup/
	@echo -n "Saving nginx.conf to ${BACKUP_DIR}/nginx_`date "+%Y%m%d_%H%M%S".conf` ... "
	@cp /etc/nginx/nginx.conf ${BACKUP_DIR}/nginx_`date "+%Y%m%d_%H%M%S".conf` \
	    && echo 'done!'

service-status: ## Show Status of Service
	@sudo systemctl list-unit-files -t service

backup-all: ## Make Nginx and Mysql Bakup
	@make -s nginx-backup db-backup

clean-log: ## Clean Log Files
	@sudo rm -f ${NGINX_ACCESS_LOG} ${NGINX_ERROR_LOG} ${MYSQL_LOG} ${MYSQL_SLOW_LOG} \
		&& echo "${NGINX_ACCESS_LOG}, ${NGINX_ERROR_LOG}, ${MYSQL_LOG}, and ${MYSQL_SLOW_LOG} have been removed!"

.PHONY: help

help:
	@echo 'Usage: make <command> [arg=<arguments>]'
	@grep -E '^[a-z0-9A-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
