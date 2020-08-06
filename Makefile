SHELL := bash

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
	@./scripts/cluster.sh

.PHONY: redis-cli
redis-cli:
	@docker-compose exec node redis-cli -c -p 7000

.PHONY: reshard
reshard:
	@docker-compose exec node redis-cli --cluster reshard redis-cluster_node_1:7000

.PHONY: nodes-status
nodes-status:
	@docker-compose exec node redis-cli -p 7000 cluster nodes

.PHONY: check-cluster
check-cluster:
	@docker-compose exec node redis-cli --cluster check redis-cluster_node_1:7000

.PHONY: auto-reshard
auto-reshard:
	@./scripts/reshard.sh

.PHONY: failover
failover:
	@./scripts/failover.sh

.PHONY: new-node
new-node:
	@./scripts/add-node.sh