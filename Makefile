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
	@docker exec -it redis-cluster_node_1 redis-cli \
    --cluster create \
    redis-cluster_node_1:7000 \
    redis-cluster_node_2:7000 \
    redis-cluster_node_3:7000 \
    redis-cluster_node_4:7000 \
    redis-cluster_node_5:7000 \
    redis-cluster_node_6:7000 \
    --cluster-replicas 1
