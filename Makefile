SHELL := bash
PORT := 6379

.PHONY: all
all: up cluster

.PHONY: up
up:
	@docker compose up -d --scale node=6

.PHONY: down
down:
	@docker compose down -v

.PHONY: logs
logs:
	@docker compose logs --tail="all" -f

.PHONY: cluster
cluster:
	@./scripts/cluster.sh

.PHONY: redis-cli
redis-cli:
	@docker compose exec node redis-cli -c

.PHONY: reshard
reshard:
	@docker compose exec node redis-cli --cluster reshard redis-cluster-node-1:$(PORT)

.PHONY: nodes-status
nodes-status:
	@docker compose exec node redis-cli cluster nodes

.PHONY: check-cluster
check-cluster:
	@docker compose exec node redis-cli --cluster check redis-cluster-node-1:$(PORT)

.PHONY: auto-reshard
auto-reshard:
	@./scripts/reshard.sh

.PHONY: failover
failover:
	@./scripts/failover.sh

.PHONY: new-master
new-master:
	@./scripts/add-node.sh master

.PHONY: new-slave
new-slave:
	@./scripts/add-node.sh slave
