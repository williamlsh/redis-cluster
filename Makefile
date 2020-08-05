.PHONY: up
up:
	@docker-compose up -d --scale node=6

.PHONY: down
down:
	@docker-compose down

.PHONY: logs
logs:
	@docker-compose logs --tail="all" -f

.PHONY: cluster
cluster:
	@./cluster.sh

.PHONY: redis-cli
redis-cli:
	@docker-compose exec node redis-cli -c -p 7000