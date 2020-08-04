
FROM redis:alpine

COPY redis.conf /usr/local/etc/redis/redis.conf

RUN chown redis:redis /usr/local/etc/redis/redis.conf

CMD [ "redis-server" ]