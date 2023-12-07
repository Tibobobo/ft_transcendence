SOURCES = 	docker-compose.yml

CACHE_FILE = "/mnt/nfs/homes/$(USER)/.cache/yarn"

all: 	$(SOURCES) env_front env_back
		docker-compose -f ./docker-compose.yml up

down:	$(SOURCES) env_front env_back
		docker-compose -f ./docker-compose.yml down

clean:	$(SOURCES)
		docker-compose -f ./docker-compose.yml down -v

fclean:	clean
		docker system prune -af

re:		fclean all

env_back: /mnt/nfs/homes/$(USER)/env_ft_transcendence/env_back
		@( \
			if [ ! -e "backend/.env" ]; then \
				cp /mnt/nfs/homes/$(USER)/env_ft_transcendence/env_back backend/.env; \
				echo "Env file backend added !"; \
			fi; \
		)

env_front:
		@( \
			if [ ! -e "frontend/.env" ]; then \
				echo -n "REACT_APP_URL_MACHINE=" > frontend/.env;\
				env | grep cluster | cut -d ":" -f 1 | cut -d "/" -f 2 >> frontend/.env; \
				echo "Env file frontend added !"; \
			fi; \
		)

cache: 	fclean
		rm -rf $(CACHE_FILE)

.PHONY: all re down clean
