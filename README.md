<!--
 Copyright (c) 2020 William

 This software is released under the MIT License.
 https://opensource.org/licenses/MIT
-->

# Deploy containerized Redis Cluster with Docker Compose

The most simple way to create a Redis Cluster with Docker compose. For a general guide, please refer to [How to Deploy Containerized Redis Cluster](https://williamlsh.github.io/posts/how-to-deploy-containerized-redis-cluster/).

## Steps to deployment

Creating Redis Cluster with 3 masters and 3 slaves.

```bash
sudo make up && sudo make cluster
```

Testing failover.

```bash
sudo make failover
```

Adding a new master.

```bash
sudo make new-master
```

Adding a new slave.

```bash
sudo make new-slave
```

Checking cluster status.

```bash
sudo make check-cluster
```

Viewing all logs.

```bash
sudo make logs
```

More commands, please refer to Makefile.

## Author

William

## License

MIT License
