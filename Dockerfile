# Version 1.0.1

FROM jeromeklam/u18
MAINTAINER Jérôme KLAM, "jeromeklam@free.fr"

# Add files.
ADD docker/rabbitmq_start.sh /usr/local/bin/

# Install RabbitMQ.
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list
RUN wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -
RUN apt-get update && apt-get install -y rabbitmq-server
RUN rm -rf /var/lib/apt/lists/*
RUN rabbitmq-plugins enable rabbitmq_management
RUN echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config
RUN chmod 775 /usr/local/bin/rabbitmq_start.sh

# Define environment variables.
ENV RABBITMQ_LOG_BASE /data/log
ENV RABBITMQ_MNESIA_BASE /data/mnesia

# Define mount points.
VOLUME ["/data/log", "/data/mnesia"]

# Define working directory.
WORKDIR /data

# Expose ports.
EXPOSE 5672
EXPOSE 15672

CMD ["/usr/local/bin/rabbitmq_start.sh"]